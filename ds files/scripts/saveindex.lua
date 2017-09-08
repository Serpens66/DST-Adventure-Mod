require "os"

SaveIndex = Class(function(self)
	self:Init()
end)

function SaveIndex:Init()
	self.data =
	{
		slots=
		{
		}
	}
	for k = 1, NUM_SAVE_SLOTS do

		local filename = "latest_" .. tostring(k)

		if BRANCH ~= "release" then
			filename = filename .. "_" .. BRANCH
		end

		self.data.slots[k] = 
		{
			current_mode = nil,
			modes = {survival= {file = filename}},
			resurrectors = {},
			dlc = {},
			mods = {},
		}
	end
	self.current_slot = 1
end

function SaveIndex:GuaranteeMinNumSlots(numslots)
	if #self.data.slots < numslots then
		local filename = nil
		for i = 1, numslots do
			if self.data.slots[i] == nil then
				filename = "latest_" .. tostring(i)
				if BRANCH ~= "release" then
					filename = filename .. "_" .. BRANCH
				end
				self.data.slots[i] = 
				{
					current_mode = nil,
					modes = {survival= {file = filename}},
					resurrectors = {},
					dlc = {},
					mods = {},
				}
			end
		end
	end
end

function SaveIndex:GetSaveGameName(type, slot)

	local savename = nil
	type = type or "unknown"

	if type == "cave" then
		local cavenum = self:GetCurrentCaveNum(slot)
		local levelnum = self:GetCurrentCaveLevel(slot, cavenum)
		savename = type .. "_" .. tostring(cavenum) .. "_" .. tostring(levelnum) .. "_" .. tostring(slot)
	else
		savename = type.."_"..tostring(slot)
	end

	
	if BRANCH ~= "release" then
		savename = savename .. "_" .. BRANCH
	end
	return savename
end

function SaveIndex:GetSaveIndexName()
	local name = "saveindex" 
	if BRANCH ~= "release" then
		name = name .. "_"..BRANCH
	end
	return name
end

function SaveIndex:GetSaveBackupName()
	local name = self:GetSaveIndexName()
	name = name .. "_backup_"
	return name
end

function SaveIndex:SaveBackup(callback, timestamp)
	self:Save(callback, self:GetSaveBackupName() .. timestamp, true)
end

function SaveIndex:Save(callback, indexname, isbackup)
	-- Will happen most of the time
	if not indexname then
		indexname = self:GetSaveIndexName()
	end

	local data = DataDumper(self.data, nil, false)
	if isbackup then
    	local insz, outsz = TheSim:SetPersistentString(indexname, data, ENCODE_SAVES, callback, true)
    else
    	local insz, outsz = TheSim:SetPersistentString(indexname, data, ENCODE_SAVES, callback)
    end
end

function SaveIndex:Load(callback)
	--This happens on game start.
	local filename = self:GetSaveIndexName()
    TheSim:GetPersistentString(filename,
        function(load_success, str) 
			local success, savedata = RunInSandbox(str)

			-- If we are on steam cloud this will stop a currupt saveindex file from 
			-- ruining everyones day.. 
			if success and string.len(str) > 0 and savedata ~= nil then
				self.data = savedata
				print ("loaded "..filename)
			else
				print ("Could not load "..filename)
			end
			
	        if PLATFORM == "PS4" then 
                -- PS4 doesn't need to verify files. If they're missing then the save was damaged and wouldn't have been loaded.
                -- Just fire the callback and keep going.
                callback()  
            else
			    self:VerifyFiles(callback)                
			end
        end)    
end

--this also does recovery of pre-existing save files (sort of)
function SaveIndex:VerifyFiles(completion_callback)

	local pending_slots = {}
	for k,v in ipairs(self.data.slots) do
		pending_slots[k] = true
	end
	
	for k,v in ipairs(self.data.slots) do
		local dirty = false
		local files = {}
		if v.current_mode == "empty" then
			v.current_mode = nil
		end
		if v.modes then
			v.modes.empty = nil
			for k, v in pairs(v.modes) do
				table.insert(files, v.file)
			end
		end
		if not v.save_id then
			v.save_id = self:GenerateSaveID(k)
		end

		CheckFiles(function(status) 

			if v.modes then
				for kk,vv in pairs (v.modes) do
					if vv.file and not status[vv.file] then
						vv.file = nil
					end
				end

			 	if v.current_mode == nil then
			 		if v.modes.survival and v.modes.survival.file then
			 			v.current_mode = "survival"
			 		end
			 	end
			 end

		 	pending_slots[k] = nil

		 	if not next(pending_slots) then
		 		self:Save(completion_callback)
		 	end

		 end, files)
	end
end

function SaveIndex:GetModeData(slot, mode)
	if slot and mode and self.data.slots[slot] then
		if not self.data.slots[slot].modes then
			self.data.slots[slot].modes = {}
		end
		if not self.data.slots[slot].modes[mode] then
			self.data.slots[slot].modes[mode] = {}
		end
		return self.data.slots[slot].modes[mode]
	end

	return {}
end

function SaveIndex:OwnsMode(mode, slotnum)
	if not slotnum then
		slotnum = self.current_slot
	end

	local mode_data = self:GetModeData(slotnum, mode)

	if next(mode_data) ~= nil and mode_data.file ~= nil then
		return true
	end
	return false
end

function SaveIndex:ROGEnabledOnSWSlot(slotnum)
	if slotnum == nil or self.data.slots[slotnum] == nil or
	   self.data.slots[slotnum].modes.survival == nil or
	   self.data.slots[slotnum].modes.survival.options == nil or
	   self.data.slots[slotnum].modes.survival.options.ROGEnabled == nil then
	   return false
	end

	return self.data.slots[slotnum].modes.survival.options.ROGEnabled
end

function SaveIndex:SetSaveHoundedData()
	local hounded_data = {}
	local hounded = GetWorld().components.hounded

	if hounded then
		hounded_data = hounded:OnSave()
	end

	if self.data~= nil and self.data.slots ~= nil and 
		self.data.slots[self.current_slot] ~= nil and hounded_data ~= nil then
	 	
	 	self.data.slots[self.current_slot].hounded_data = hounded_data
	end
end

function SaveIndex:LoadSavedHoundedData()
	local hounded = GetWorld().components.hounded
	local hounded_data = self.data.slots[self.current_slot].hounded_data

	if hounded and hounded_data then
		hounded:OnLoad(hounded_data)
	end

	self.data.slots[self.current_slot].hounded_data = nil
	self:Save(function () print("LoadSavedHoundedData CB") end)
end

function SaveIndex:SetSaveClockData()
	
	local clock_data = {}
	local clock = GetWorld().components.clock

	if clock then
		clock_data = clock:OnSave()
	end

	if self.data~= nil and self.data.slots ~= nil and 
		self.data.slots[self.current_slot] ~= nil and clock_data ~= nil then
	 	
	 	self.data.slots[self.current_slot].clock_data = clock_data
	end
end

function SaveIndex:LoadSavedClockData()
	--local clock = GetWorld().components.clock
	local clock_data = self.data.slots[self.current_slot].clock_data

	if clock_data then
		self.data.slots[self.current_slot].clock_data = nil
		return clock_data
	end

	return nil
end

function SaveIndex:SetSaveSeasonData()
	local seasondata = {}

	local seasonmgr = GetSeasonManager()
	if seasonmgr then
		--only use season data for the level's season mode
		if seasonmgr.IsTropical and seasonmgr:IsTropical() then
			print("SeasonManager save tropical")
			seasondata["targettropicalseason"] = seasonmgr.current_season
			seasondata["targettropicalpercent"] = seasonmgr.percent_season
			seasondata["mildlen"] = seasonmgr.mildlength
			seasondata["wetlen"] = seasonmgr.wetlength
			seasondata["greenlen"] = seasonmgr.greenlength
			seasondata["drylen"] = seasonmgr.drylength
			seasondata["mildenabled"] = seasonmgr.mildenabled
			seasondata["wetenabled"] = seasonmgr.wetenabled
			seasondata["greenenabled"] = seasonmgr.greenenabled
			seasondata["dryenabled"] = seasonmgr.dryenabled
		else
			print("SeasonManager save cycle")
			seasondata["targetseason"] = seasonmgr.current_season
			seasondata["targetpercent"] = seasonmgr.percent_season
			seasondata["autumnlen"] = seasonmgr.autumnlength
			seasondata["winterlen"] = seasonmgr.winterlength
			seasondata["springlen"] = seasonmgr.springlength
			seasondata["summerlen"] = seasonmgr.summerlength
			seasondata["autumnenabled"] = seasonmgr.autumnenabled
			seasondata["winterenabled"] = seasonmgr.winterenabled
			seasondata["springenabled"] = seasonmgr.springenabled
			seasondata["summerenabled"] = seasonmgr.summerenabled
		end
		seasondata["initialevent"] = seasonmgr.initialevent
		dumptable(seasondata, 1, 2)
	end

	if self.data~= nil and self.data.slots ~= nil and self.data.slots[self.current_slot] ~= nil then
	 	self.data.slots[self.current_slot].seasondata = seasondata
	end	
end

function SaveIndex:LoadSavedSeasonData()
	local seasonmgr = GetSeasonManager()
	local seasondata = self.data.slots[self.current_slot].seasondata
	if seasonmgr and seasondata then
		--only use season data for the level's season mode
		if seasonmgr.IsTropical and seasonmgr:IsTropical() then
			print("SeasonManager load tropical")
			if seasondata["targettropicalseason"] then
				seasonmgr.target_season = seasondata["targettropicalseason"]
			end
			seasonmgr.target_percent = seasondata["targettropicalpercent"] or seasonmgr.percent_season
			seasonmgr.mildlength = seasondata["mildlen"] or seasonmgr.mildlength
			seasonmgr.wetlength = seasondata["wetlen"] or seasonmgr.wetlength
			seasonmgr.greenlength = seasondata["greenlen"] or seasonmgr.greenlength
			seasonmgr.drylength = seasondata["drylen"] or seasonmgr.drylength
			seasonmgr.mildenabled = seasondata["mildenabled"] or seasonmgr.mildenabled
			seasonmgr.wetenabled = seasondata["wetenabled"] or seasonmgr.wetenabled
			seasonmgr.greenenabled = seasondata["greenenabled"] or seasonmgr.greenenabled
			seasonmgr.dryenabled = seasondata["dryenabled"] or seasonmgr.dryenabled
		else
			print("SeasonManager load cycle")
			if seasondata["targetseason"] then
				seasonmgr.target_season = seasondata["targetseason"]
			end
			seasonmgr.target_percent = seasondata["targetpercent"] or seasonmgr.percent_season
			seasonmgr.autumnlength = seasondata["autumnlen"] or seasonmgr.autumnlength
			seasonmgr.winterlength = seasondata["winterlen"] or seasonmgr.winterlength
			seasonmgr.springlength = seasondata["springlen"] or seasonmgr.springlength
			seasonmgr.summerlength = seasondata["summerlen"] or seasonmgr.summerlength
			seasonmgr.autumnenabled = seasondata["autumnenabled"] or seasonmgr.autumnenabled
			seasonmgr.winterenabled = seasondata["winterenabled"] or seasonmgr.winterenabled
			seasonmgr.springenabled = seasondata["springenabled"] or seasonmgr.springenabled
			seasonmgr.summerenabled = seasondata["summerenabled"] or seasonmgr.summerenabled
		end
		seasonmgr.initialevent = seasondata["initialevent"]
	end
	self.data.slots[self.current_slot].seasondata = nil
	self:Save(function () print("LoadSavedSeasonData CB") end)
end

function SaveIndex:SetSaveVolcanoData()
	local vmdata = nil
	local vm = GetWorld().components.volcanomanager
	if vm then
		vmdata = vm:OnSave()
	end

	if vmdata ~= nil and self.data ~= nil and self.data.slots ~= nil and self.data.slots[self.current_slot] ~= nil then
	 	self.data.slots[self.current_slot].volcanodata = vmdata
	end	
end

function SaveIndex:LoadSavedVolcanoData()
	local vmdata = self.data.slots[self.current_slot].volcanodata
	local vm = GetWorld().components.volcanomanager
	if vm and vmdata then
		vm:OnLoad(vmdata)
	end
	self.data.slots[self.current_slot].volcanodata = nil
	self:Save(function () print("LoadSavedVolcanoData CB") end)
end

function SaveIndex:GetSaveFollowers(doer)
	local followers = {}

	if doer.components.leader then
		for follower,v in pairs(doer.components.leader.followers) do
			-- Make sure the follower is alive
			if follower and (not follower.components.health or (follower.components.health and not follower.components.health:IsDead())) then
				local ent_data = follower:GetPersistData()
				table.insert(followers, {prefab = follower.prefab, data = follower:GetPersistData()})
				follower:Remove()
			elseif follower then -- Otherwise remove it from the list and world
				doer.components.leader:RemoveFollower(follower)
				follower:Remove()
			end
		end
	end

	local eyebone = nil
	local queued_remove = {}

	--special case for the chester_eyebone: look for inventory items with followers
	if doer.components.inventory then
		for k,item in pairs(doer.components.inventory.itemslots) do
			if item.components.leader then
				if item:HasTag("chester_eyebone") then
					eyebone = item
				end
				for follower,v in pairs(item.components.leader.followers) do
					if follower and (not follower.components.health or (follower.components.health and not follower.components.health:IsDead())) then
						local ent_data = follower:GetPersistData()
						table.insert(followers, {prefab = follower.prefab, data = follower:GetPersistData()})
						if follower.components.container then
							table.insert(queued_remove, follower)
						else
							follower:Remove()
						end
					elseif follower then
						item.components.leader:RemoveFollower(follower)
						follower:Remove()
					end
				end
			end
		end

		-- special special case, look inside equipped containers
		for k,equipped in pairs(doer.components.inventory.equipslots) do
			if equipped and equipped.components.container then
				local container = equipped.components.container
				for j,item in pairs(container.slots) do
					if item.components.leader then
						if item:HasTag("chester_eyebone") then
							eyebone = item
						end
						for follower,v in pairs(item.components.leader.followers) do
							if follower and (not follower.components.health or (follower.components.health and not follower.components.health:IsDead())) then
								local ent_data = follower:GetPersistData()
								table.insert(followers, {prefab = follower.prefab, data = follower:GetPersistData()})
								if follower.components.container then
									table.insert(queued_remove, follower)
								else
									follower:Remove()
								end
							elseif follower then
								item.components.leader:RemoveFollower(follower)
								follower:Remove()
							end
						end
					end
				end
			end
		end

		-- special special special case: if we have an eyebone, then we have a container follower not actually in the inventory. Look for inventory items with followers there.
		if eyebone and eyebone.components.leader then
			for follower,v in pairs(eyebone.components.leader.followers) do
				if follower and (not follower.components.health or (follower.components.health and not follower.components.health:IsDead())) and follower.components.container then
					for j,item in pairs(follower.components.container.slots) do
						if item.components.leader then
							for follower,v in pairs(item.components.leader.followers) do
								if follower and (not follower.components.health or (follower.components.health and not follower.components.health:IsDead())) then
									local ent_data = follower:GetPersistData()
									table.insert(followers, {prefab = follower.prefab, data = follower:GetPersistData()})
									follower:Remove()
								elseif follower then
									item.components.leader:RemoveFollower(follower)
									follower:Remove()
								end
							end
						end
					end
				end
			end
		end
	end

	for i,v in pairs(queued_remove) do
		v:Remove()
	end

	if self.data~= nil and self.data.slots ~= nil and self.data.slots[self.current_slot] ~= nil then
	 	self.data.slots[self.current_slot].followers = followers
	end	
end

function SaveIndex:LoadSavedFollowers(doer)
    local x,y,z = doer.Transform:GetWorldPosition()

	if doer.components.leader and self.data.slots[self.current_slot].followers then
		for idx,follower in pairs(self.data.slots[self.current_slot].followers) do
			local ent  = SpawnPrefab(follower.prefab)
			if ent ~= nil then
				ent:SetPersistData(follower.data)

		        local angle = TheCamera.headingtarget + math.random()*10*DEGREES-5*DEGREES
		        x = x + .5*math.cos(angle)
		        z = z + .5*math.sin(angle)
		 		ent.Transform:SetPosition(x,y,z)
		 		if ent.MakeFollowerFn then
		 			ent.MakeFollowerFn(ent, doer)
		 		end
		 		ent.components.follower:SetLeader(doer)
			end
		end
	end
end

function SaveIndex:GetResurrectorName( res )
	return self:GetSaveGameName(self.data.slots[self.current_slot].current_mode, self.current_slot)..":"..tostring(res.GUID)
end

function SaveIndex:GetResurrectorPenalty()
	if self.data.slots[self.current_slot].current_mode == "adventure" then
		return nil
	end

	local penalty = 0

	for k,v in pairs(self.data.slots[self.current_slot].resurrectors) do
		penalty = penalty + v
	end

	return penalty
end

function SaveIndex:ClearCavesResurrectors()
	if self.data.slots[self.current_slot].resurrectors == nil then
		self.data.slots[self.current_slot].resurrectors = {}
		return
	end

	for k,v in pairs(self.data.slots[self.current_slot].resurrectors) do
		if string.find(k, self:GetSaveGameName("cave", self.current_slot), 1, true) ~= nil then
			self.data.slots[self.current_slot].resurrectors[k] = nil
		end
	end

	if PLATFORM ~= "PS4" then 
	    self:Save(function () print("ClearCavesResurrectors CB") end)
    end	   
end

function SaveIndex:ClearCurrentResurrectors()
	if self.data.slots[self.current_slot].resurrectors == nil then
		self.data.slots[self.current_slot].resurrectors = {}
		return
	end

	for k,v in pairs(self.data.slots[self.current_slot].resurrectors) do
		if string.find(k, self:GetSaveGameName(self.data.slots[self.current_slot].current_mode, self.current_slot), 1, true) ~= nil then
			self.data.slots[self.current_slot].resurrectors[k] = nil
		end
	end

	if PLATFORM ~= "PS4" then 
	    self:Save(function () print("ClearCurrentResurrectors CB") end)
    end	   
end

function SaveIndex:RegisterResurrector(res, penalty)

	if self.data.slots[self.current_slot].resurrectors == nil then
		self.data.slots[self.current_slot].resurrectors = {}
	end
	print("RegisterResurrector", res)
	self.data.slots[self.current_slot].resurrectors[self:GetResurrectorName(res)] = penalty
	
	if PLATFORM ~= "PS4" then 
	    -- Don't need to save on each of these events as regular saveindex save will be enough to keep these consistent
	    self:Save(function () print("RegisterResurrector CB") end)
	end
end

function SaveIndex:DeregisterResurrector(res)

	if self.data.slots[self.current_slot].resurrectors == nil then
		self.data.slots[self.current_slot].resurrectors = {}
		return
	end

	print("DeregisterResurrector", res.inst)

	local name = self:GetResurrectorName(res)
	for k,v in pairs(self.data.slots[self.current_slot].resurrectors) do
		if k == name then
			print("DeregisterResurrector found", name)
			self.data.slots[self.current_slot].resurrectors[name] = nil
			
	        if PLATFORM ~= "PS4" then 
	            -- Don't need to save on each of these events as regular saveindex save will be enough to keep these consistent
			    self:Save(function () print("DeregisterResurrector CB") end)
			end
			return
		end
	end

	print("DeregisterResurrector", res.inst, "not found")
end

function SaveIndex:GetResurrector()
	if self.data.slots[self.current_slot].current_mode == "adventure" then
		return nil
	end
	if self.data.slots[self.current_slot].resurrectors == nil then
		return nil
	end
	--[[for k,v in pairs(self.data.slots[self.current_slot].resurrectors) do
		return k
	end]]
	local current_mode = self.data.slots[self.current_slot].current_mode
	local second = nil
	local ter = nil
	for k,v in pairs(self.data.slots[self.current_slot].resurrectors) do
		local file = string.split(k, ":")[1]
		local mode = string.split(file, "_")[1]
		if current_mode == mode then
			print("Resurrector in this world", k)
			return k --theres one close use it
		elseif second == nil and ((current_mode == "cave" and mode == "survival") or (current_mode == "volcano" and mode == "shipwrecked")) then
			second = k
		elseif ter == nil then
			ter = k
		end
	end

	if second then
		print("Resurrector in base world", second)
		return second
	end
	if ter then
		print("Resurrector somewhere", ter)
		return ter
	end

	return nil
end

function SaveIndex:CanUseExternalResurector()
	return self.data.slots[self.current_slot].current_mode ~= "adventure"
end
function SaveIndex:GotoResurrector(cb)
	print ("SaveIndex:GotoResurrector()")

	if self.data.slots[self.current_slot].current_mode == "adventure" then
		assert(nil, "SaveIndex:GotoResurrector() In adventure mode! why are we here!!??")
		return
	end
	
	if self.data.slots[self.current_slot].resurrectors == nil then
		self.data.slots[self.current_slot].resurrectors = {}
		return
	end

	local file = string.split(self:GetResurrector(), ":")[1]
	--print ("############# FILE " .. file)
	local mode = string.split(file, "_")[1]

	local current_mode = self.data.slots[self.current_slot].current_mode

	print ("SaveIndex:GotoResurrector() File:", file, "Mode:", mode)


	--[[save the current world, is this done already?
	if current_mode == "shipwrecked" then
		self:LeaveShipwrecked(cb)
	elseif current_mode == "volcano" then
		self:LeaveVolcano(cb)
	elseif current_mode == "cave" then
		self:LeaveCave(cb)
	end]]

	if mode == "shipwrecked" then
		self:EnterShipwrecked(cb, self.current_slot)
	elseif mode == "volcano" then
		self:EnterVolcano(cb, self.current_slot)
	elseif mode == "cave" then
		local cavenum, level = string.match(file, "cave_(%d+)_(%d+)")
		cavenum = tonumber(cavenum)
		level = tonumber(level)
		print ("SaveIndex:GotoResurrector() File:", cavenum, "Mode:", level)
		self:EnterCave(cb, self.current_slot, cavenum, level)
	else --survival
		self:EnterSurvival(cb, self.current_slot)
	end

	--[[if mode == "survival" then
		if isVolcano then 
			self:LeaveVolcano(cb)
		else 
			self:LeaveCave(cb)
		end 
	else
		local cavenum, level = string.match(file, "cave_(%d+)_(%d+)")
		cavenum = tonumber(cavenum)
		level = tonumber(level)
		print ("SaveIndex:GotoResurrector() File:", cavenum, "Mode:", level)
		self:EnterCave(cb, self.current_slot, cavenum, level)
	end]]

	print ("SaveIndex:GotoResurrector() done")
end

function SaveIndex:GetSaveData(slot, mode, cb, ignoreslot)
	if not ignoreslot then -- Added for backup stuff
	 	self.current_slot = slot
	end
	local file = self:GetModeData(slot, mode).file

	TheSim:GetPersistentString(file, function(load_success, str)
		assert(load_success, "SaveIndex:GetSaveData: Load failed for file ["..file.."] please consider deleting this save slot and trying again.")

		assert(str, "SaveIndex:GetSaveData: Encoded Savedata is NIL on load ["..file.."]")
		assert(#str>0, "SaveIndex:GetSaveData: Encoded Savedata is empty on load ["..file.."]")

		local success, savedata = RunInSandbox(str)
		
		--[[
		if not success then
			local file = io.open("badfile.lua", "w")
			if file then
				str = string.gsub(str, "},", "},\n")
				file:write(str)
				
				file:close()
			end
		end--]]

		assert(success, "Corrupt Save file ["..file.."]")
		assert(savedata, "SaveIndex:GetSaveData: Savedata is NIL on load ["..file.."]")
		assert(GetTableSize(savedata)>0, "SaveIndex:GetSaveData: Savedata is empty on load ["..file.."]")

		cb(savedata)
	end)
end

function SaveIndex:GetPlayerData(slot, mode)
	local slot = slot or self.current_slot
	return self:GetModeData(slot, mode or self.data.slots[slot].current_mode).playerdata
end

function SaveIndex:DeleteSlot(slot, cb, save_options)
	local character = self.data.slots[slot].character
	local dlc = self.data.slots[slot].dlc
	local mods = self.data.slots[slot].mods
	local mode = self.data.slots[slot].current_mode
	local survivaloptions = nil
	local shipwreckedoptions = nil
	if  self.data.slots[slot] and  self.data.slots[slot].modes then
		if self.data.slots[slot].modes.survival then
			survivaloptions = self.data.slots[slot].modes.survival.options
		end
		if self.data.slots[slot].modes.shipwrecked then
			shipwreckedoptions = self.data.slots[slot].modes.shipwrecked.options
		end
	end

	local files = {}
	for k,v in pairs(self.data.slots[slot].modes) do
		local add_file = true
		if v.files then
			for kk, vv in pairs(v.files) do
				if vv == v.file then
					add_file = false
				end
				table.insert(files, vv)
			end
		end
		
		if add_file then
			table.insert(files, v.file)
		end
	end

	if next(files) then
		EraseFiles(nil, files)
	end

	local slot_exists = self.data.slots[slot] and self.data.slots[slot].current_mode
	if slot_exists then
		self.data.slots[slot] = { current_mode = nil, modes = {}}
		if save_options == true then
			local restartmode = self:GetRestartMode(mode)
			self.data.slots[slot].character = character
			self.data.slots[slot].dlc = dlc
			self.data.slots[slot].mods = mods
			self.data.slots[slot].current_mode = restartmode
			self.data.slots[slot].modes["survival"] = {options = survivaloptions}
			self.data.slots[slot].modes["shipwrecked"] = {options = shipwreckedoptions}
		end
		self:Save(cb)		
	elseif cb then
		cb()
	end
end


function SaveIndex:ResetCave(cavenum, cb)
	
	local slot = self.current_slot

	if slot and cavenum and self.data.slots[slot] and self.data.slots[slot].modes.cave then
		
		local del_files = {}
		for k,v in pairs(self.data.slots[slot].modes.cave.files) do
			
			local cave_num = string.match(v, "cave_(%d+)_")
			if cave_num and tonumber(cave_num) == cavenum then
				table.insert(del_files, v)
			end
		end
		
		EraseFiles(cb, del_files)
	else
		if cb then
			cb()
		end
	end

end

function SaveIndex:EraseVolcano(cb)

	local function onerased()
		self.data.slots[self.current_slot].modes.volcano = {}
		self:Save(cb)
	end

	local files = {}
	
	if self.data.slots[self.current_slot] and self.data.slots[self.current_slot].modes and self.data.slots[self.current_slot].modes.volcano then
		if self.data.slots[self.current_slot].modes.volcano.file then
			table.insert(files, self.data.slots[self.current_slot].modes.volcano.file)
		end
		if self.data.slots[self.current_slot].modes.volcano.files then
			for kk, vv in pairs(self.data.slots[self.current_slot].modes.volcano.files) do
				table.insert(files, vv)
			end
		end
	end
	EraseFiles(onerased, files)
end

function SaveIndex:EraseCaves(cb)
	local function onerased()
		self.data.slots[self.current_slot].modes.cave = {}
		self:Save(cb)
	end

	local files = {}
	
	if self.data.slots[self.current_slot] and self.data.slots[self.current_slot].modes and self.data.slots[self.current_slot].modes.cave then
		if self.data.slots[self.current_slot].modes.cave.file then
			table.insert(files, self.data.slots[self.current_slot].modes.cave.file)
		end
		if self.data.slots[self.current_slot].modes.cave.files then
			for kk, vv in pairs(self.data.slots[self.current_slot].modes.cave.files) do
				table.insert(files, vv)
			end
		end
	end
	EraseFiles(onerased, files)
end



function SaveIndex:EraseCurrent(cb)
	
	local current_mode = self.data.slots[self.current_slot].current_mode

	local function docaves()
		if current_mode == "survival" then
			self:EraseCaves(cb)
		else
			cb()
		end
	end

	local filename = ""
	local function onerased()	
		EraseFiles(docaves, {filename})
	end
	
	local data = self:GetModeData(self.current_slot, current_mode)
	filename = data.file
	data.file = nil
	data.playerdata = nil
	data.day = nil
	data.world = nil
	self:Save(onerased)
end

function SaveIndex:GetDirectionOfTravel()
	return self.data.slots[self.current_slot].direction,
			self.data.slots[self.current_slot].cave_num
end
function SaveIndex:GetCaveNumber()
	return  (self.data.slots[self.current_slot].modes and
			self.data.slots[self.current_slot].modes.cave and
			self.data.slots[self.current_slot].modes.cave.current_cave) or nil
end

function SaveIndex:SaveCurrent(onsavedcb, direction, cave_num)
	
	local ground = GetWorld()
	assert(ground, "missing world?")
	local level_number = ground.topology.level_number or 1
	local day_number = GetClock().numcycles + 1

	local function onsavedgame()
		self:Save(onsavedcb)
	end

	local current_mode = self.data.slots[self.current_slot].current_mode
	local data = self:GetModeData(self.current_slot, current_mode)
	local dlc = self.data.slots[self.current_slot].dlc
	local mods = ModManager:GetEnabledModNames() or self.data.slots[self.current_slot].mods

	self.data.slots[self.current_slot].character = GetPlayer().prefab
	self.data.slots[self.current_slot].direction = direction
	self.data.slots[self.current_slot].cave_num = cave_num
	self.data.slots[self.current_slot].dlc = dlc
	self.data.slots[self.current_slot].mods = mods
	if not direction then
		self.data.slots[self.current_slot].followers = nil
	end

	data.day = day_number
	data.playerdata = nil
	data.file = self:GetSaveGameName(current_mode, self.current_slot)
	SaveGame(self:GetSaveGameName(current_mode, self.current_slot), onsavedgame)
end

function SaveIndex:BackupSlot(slotnum, onbackedup, timestamp)

	local current_mode = self.data.slots[slotnum].current_mode

	local savename = self:GetSaveGameName(current_mode, slotnum) .. "_bckp_" .. timestamp

	local function OnSaveDataRetrieved(savedata)
		local data = DataDumper(savedata, nil, BRANCH ~= "dev")
	    local insz, outsz = TheSim:SetPersistentString(savename, data, ENCODE_SAVES, onbackedup, true)
	    print ("Backed up slot", savename, outsz)
	end
	
	self:GetSaveData(slotnum, current_mode, OnSaveDataRetrieved, true)
end

function SaveIndex:GetBackup(file, cb)
	TheSim:GetPersistentString(file, function(load_success, str)
		assert(load_success, "SaveIndex:GetSaveData: Load failed for file ["..file.."] please consider deleting this save slot and trying again.")
		assert(str, "SaveIndex:GetSaveData: Encoded Savedata is NIL on load ["..file.."]")
		assert(#str>0, "SaveIndex:GetSaveData: Encoded Savedata is empty on load ["..file.."]")

		local success, savedata = RunInSandbox(str)

		assert(success, "Corrupt Save file ["..file.."]")
		assert(savedata, "SaveIndex:GetSaveData: Savedata is NIL on load ["..file.."]")
		assert(GetTableSize(savedata)>0, "SaveIndex:GetSaveData: Savedata is empty on load ["..file.."]")

		cb(savedata)
	end, true)

	--return nil
end

function SaveIndex:RestoreSave(backup_index, slot1)
	local savename = ""

	local function OnSaveDataRetrieved(savedata)
		local data = DataDumper(savedata, nil, BRANCH ~= "dev")
	    local insz, outsz = TheSim:SetPersistentString(savename, data, ENCODE_SAVES, function() print ("Restored save") end)
	    print ("Restored slot", savename, outsz)
	end

	local function RestoreFile(file, mode, slotnum, slot)
		TheSim:CheckPersistentStringExists(file, function(exists) 
			if exists then
				
				--self:DeleteSlot(slotnum, function() print ("Slot " .. slotnum .. " deleted") end)
				local save_id = self.data.slots[slotnum].save_id
				self.data.slots[slotnum] = slot
				self.data.slots[slotnum].save_id = save_id

				savename = self:GetSaveGameName(mode, slotnum)
				self.data.slots[slotnum].modes[mode].file = savename

				self:GetBackup(file, OnSaveDataRetrieved)

				self:Save(function() print("Save index updated") end)

			end
		 end, true)
	end

	local slot2 = self:GetFirstEmptySlot()
	if slot2 == nil then
		print ("Something went horribly wrong. Canceling backup restoration.")
		return
	end

	local backupname = "saveindex_backup_"
	
	if BRANCH == "dev" then
		backupname = "saveindex_dev_backup_"
	end

	self:GetBackup(backupname .. backup_index, function(savedata)
		for k,v in pairs(savedata.slots) do
			if v.modes.shipwrecked ~= nil and v.modes.shipwrecked.file ~= nil then
				local backup_file = v.modes.shipwrecked.file .. "_bckp_" .. backup_index
				RestoreFile(backup_file, "shipwrecked", slot1, v)
			end

			if v.modes.survival ~= nil and v.modes.survival.file ~= nil then
				local backup_file = v.modes.survival.file .. "_bckp_" .. backup_index
				RestoreFile(backup_file, "survival", slot2, v)
			end
		end
	end)

end

function SaveIndex:GetFirstEmptySlot()
	for k,v in pairs(self.data.slots) do	
		if v.modes.shipwrecked == nil and v.modes.survival == nil then
			return k
		end
	end
	return nil
end

function SaveIndex:MergeSlotWithCurrent(slotnum)

	local current_mode = self.data.slots[slotnum].current_mode
	local new_savename = self:GetSaveGameName(current_mode, self.current_slot)
	
	-- Prepares the next world for the merge
	-- Sets the current season to autumn/mild
	-- Will also create grave with previous player's items
	local function PrepareTargetForMerge(savedata)

		-- Stores the player position for later use
		local player_x = savedata.playerinfo.x
		local player_z = savedata.playerinfo.z

		-- Sets the season after the merge to be autumn
		if current_mode == "survival" then
			savedata.map.persistdata.seasonmanager.current_season = "autumn"
		else
			savedata.map.persistdata.seasonmanager.current_season = "mild"

			-- If the player was driving a boat this removes them from the boat so it doesn't interfere
			-- with the placement near the Seaworthy
			if savedata.playerinfo.data.driver and savedata.playerinfo.data.driver.driving then
				for k,v in pairs(savedata.ents[savedata.playerinfo.data.driver.vehicle_prefab]) do
					if (v.id == savedata.playerinfo.data.driver.vehicle) then
				 		v.data.drivable = {}
					end
				 end
			end

			-- Places the player near a Seaworthy if we're merge with an already existing SW World
			savedata.playerinfo.x = savedata.ents.shipwrecked_exit[1].x
			savedata.playerinfo.z = savedata.ents.shipwrecked_exit[1].z
		end

		-- Removes spring and summer if the merged world does not have RoG mechanics
		if not self.data.slots[slotnum].dlc.REIGN_OF_GIANTS then
			savedata.map.persistdata.seasonmanager.springlength = 0
			savedata.map.persistdata.seasonmanager.summerlength = 0
			savedata.map.persistdata.seasonmanager.springenabled = false
			savedata.map.persistdata.seasonmanager.summerenabled = false
		end

		-- Syncs the player age
		savedata.playerinfo.data.age = {age = GetPlayer().components.age:GetAge()}

		-- Copies the inventory
		local player_inventory = {}
		local function AddToPlayerInventory(t)
			for k,v in pairs(t) do
				table.insert(player_inventory, v)	
			end
		end
		
		AddToPlayerInventory(savedata.playerinfo.data.inventory.items)
		AddToPlayerInventory(savedata.playerinfo.data.inventory.equip)

		-- Sets the inventorygrave marker
		local new_marker = { data = { player_inventory=player_inventory, x=player_x, z=player_z } }
		local inventorygravemarker = {}
		table.insert(inventorygravemarker, new_marker)
		savedata.ents.inventorygrave_MARKER = inventorygravemarker

		local current_inventory = GetPlayer():GetSaveRecord().data.inventory
		savedata.playerinfo.data.inventory = current_inventory
		
		-- Syncs the days (cosmetic only)
		if savedata.map.persistdata.clock.numcycles < GetClock():GetNumCycles() then
			savedata.map.persistdata.clock.numcycles = GetClock():GetNumCycles()
		end

		-- Sets the hounded parameters
		local current_hounded = GetWorld().components.hounded:OnSave()
		if current_hounded ~= nil then
			savedata.map.persistdata.hounded = current_hounded
		end

		return savedata
	end

	local function OnSaveDataRetrieved(savedata)

		savedata = PrepareTargetForMerge(savedata)

		local function onmerged()
			print ("Slot " .. slotnum .. " merged successfully. Deleting old slot.")
			self:DeleteSlot(slotnum, function() 
					print ("Slot Deleted")
				end)
		end

		local data = DataDumper(savedata, nil, BRANCH ~= "dev")
	    local insz, outsz = TheSim:SetPersistentString(new_savename, data, ENCODE_SAVES, onmerged)
	    --SavePersistentString(new_savename, data, ENCODE_SAVES, onmerged)
	    print ("Merged", new_savename, outsz)
	end
	
	self:GetSaveData(slotnum, current_mode, OnSaveDataRetrieved, true)
	return new_savename
end


function SaveIndex:GetSlotDLC(slot)
	local dlc = self.data.slots[slot or self.current_slot].dlc 
	if not dlc then dlc = NO_DLC_TABLE end
	return dlc
end

function SaveIndex:SetSlotCharacter(saveslot, character, cb)
	self.data.slots[saveslot].character = character
	self:Save(cb)
end

function SaveIndex:SetCurrentIndex(saveslot)
	self.current_slot = saveslot
end

function SaveIndex:GetCurrentSaveSlot()
	return self.current_slot
end


--called upon relaunch when a new level needs to be loaded
function SaveIndex:OnGenerateNewWorld(saveslot, savedata, cb)
	--local playerdata = nil
	self.current_slot = saveslot
	local filename = self:GetSaveGameName(self.data.slots[self.current_slot].current_mode, self.current_slot)
	
	local function onindexsaved()
		cb()
		--cb(playerdata)
	end		

	local function onsavedatasaved()
		self.data.slots[self.current_slot].continue_pending = false
		local current_mode = self.data.slots[self.current_slot].current_mode
		local data = self:GetModeData(self.current_slot, current_mode)
		data.file = filename
		data.files = data.files or {}
		data.day = 1

		local found = false
		for k,v in pairs(data.files) do
			if v == filename then
				found = true
			end
		end

		if not found then 
			table.insert(data.files, filename)
		end


		
		--playerdata = data.playerdata
		--data.playerdata = nil

		self:Save(onindexsaved)
	end

	local insz, outsz = TheSim:SetPersistentString(filename, savedata, ENCODE_SAVES, onsavedatasaved)	
end


function SaveIndex:GetOrCreateSlot(saveslot)
	if self.data.slots[saveslot] == nil then
		self.data.slots[saveslot] = {}
	end
	return self.data.slots[saveslot]
end

function SaveIndex:PickRandomCharacter()
	local characters = GetActiveCharacterList()
	if not characters then return "wilson" end
	return characters[math.random(#characters)]
end

--call after you have worldgen data to initialize a new survival save slot
function SaveIndex:StartSurvivalMode(saveslot, character, customoptions, onsavedcb, dlc, startmode)
	self.current_slot = saveslot
--	local data = self:GetModeData(saveslot, "survival")
	local slot = self:GetOrCreateSlot(saveslot)

	if character == "random" then
		character = SaveIndex:PickRandomCharacter()
	end

	slot.character = character
	slot.current_mode = startmode or "survival"
	slot.save_id = self:GenerateSaveID(self.current_slot)
	slot.dlc = dlc and dlc or NO_DLC_TABLE
	slot.mods = ModManager:GetEnabledModNames() or {}
	print("SaveIndex:StartSurvivalMode!:", tostring(slot.dlc.REIGN_OF_GIANTS), tostring(slot.dlc.CAPY_DLC))

	slot.modes = 
	{
		survival = {
			--file = self:GetSaveGameName("survival", self.current_slot),
			day = 1,
			world = 1,
			options = customoptions
		},
	}

	if slot.dlc.CAPY_DLC and slot.dlc.CAPY_DLC == true and ((customoptions and not customoptions.ROGEnabled) or customoptions == nil) then
		slot.modes.shipwrecked = {
			--file = self:GetSaveGameName("survival", self.current_slot),
			day = 1,
			world = 1,
			options = customoptions
		}
	end
 	
    local starts = Profile:GetValue("starts") or 0
    Profile:SetValue("starts", starts+1)
	Profile:Save(function() self:Save(onsavedcb) end )
end

function SaveIndex:GenerateSaveID(slot)
	local now = os.time()
	return TheSim:GetUserID() .."-".. tostring(now) .."-".. tostring(slot)
end

function SaveIndex:GetSaveID(slot)
	slot = slot or self.current_slot
	return self.data.slots[slot].save_id
end

--this is here for resurrectors
function SaveIndex:EnterSurvival(onsavedcb, saveslot)
	self.current_slot = saveslot or self.current_slot

	--get the current player, and maintain his player data
 	local playerdata = {}
    local player = GetPlayer()
    if player then
        playerdata = player:GetSaveRecord().data
        playerdata.leader = nil
        playerdata.sanitymonsterspawner = nil
   	end

	self.data.slots[self.current_slot].current_mode = "survival"
	
	if not self.data.slots[self.current_slot].modes.survival then
		self.data.slots[self.current_slot].modes.survival = {}
	end
	
	local savename = self:GetSaveGameName("survival", self.current_slot)
	self.data.slots[self.current_slot].modes.survival.playerdata = playerdata
	self.data.slots[self.current_slot].modes.survival.file = nil
	
	
	TheSim:CheckPersistentStringExists(savename, function(exists) 
		if exists then
			self.data.slots[self.current_slot].modes.survival.file = savename
		end
		self:Save(onsavedcb)
	 end)
end

function SaveIndex:OnFailCave(onsavedcb)
	self.data.slots[self.current_slot].modes.cave.playerdata = nil
	self.data.slots[self.current_slot].current_mode = "survival"
	local playerdata = {}
    local player = GetPlayer()
    if player then
    	--remember our unlocked recipes
        playerdata.builder = player:GetSaveRecord().data.builder
        
        --set our meters to the standard resurrection amounts
        playerdata.health = {health = TUNING.RESURRECT_HEALTH}
		playerdata.hunger = {hunger = player.components.hunger.max*.66}
		playerdata.sanity = {current = player.components.sanity.max*.5}
        playerdata.leader = nil
        playerdata.sanitymonsterspawner = nil
		
   	end 

	if self.data.slots[self.current_slot].modes.survival then
		self.data.slots[self.current_slot].modes.survival.playerdata = playerdata
	end
	self:Save(onsavedcb)
end

function SaveIndex:LeaveCave(onsavedcb)
	local playerdata = {}
    local player = GetPlayer()
    if player then
        playerdata = player:GetSaveRecord().data
        playerdata.leader = nil
        playerdata.sanitymonsterspawner = nil
        
    end
	self.data.slots[self.current_slot].modes.cave.playerdata = nil
	self.data.slots[self.current_slot].current_mode = "survival"
	
	if self.data.slots[self.current_slot].modes.survival then
		self.data.slots[self.current_slot].modes.survival.playerdata = playerdata
	end

	local savename = self:GetSaveGameName("survival", self.current_slot)
	TheSim:CheckPersistentStringExists(savename, function(exists) 
		if exists then
			--self:SyncTimePassage(self.current_slot, "survival", savename)
			self:SyncDataForTransition(self.current_slot, "survival", savename, true)
		end
	 end)

	self:Save(onsavedcb)
end


function SaveIndex:EnterCave(onsavedcb, saveslot, cavenum, level)
	self.current_slot = saveslot or self.current_slot

	--get the current player, and maintain his player data
 	local playerdata = {}
    local player = GetPlayer()
    if player then
        playerdata = player:GetSaveRecord().data
        playerdata.leader = nil
        playerdata.sanitymonsterspawner = nil
   	end  

	level = level or 1
	cavenum = cavenum or 1

	self.data.slots[self.current_slot].current_mode = "cave"
	
	if not self.data.slots[self.current_slot].modes.cave then
		self.data.slots[self.current_slot].modes.cave = {}
	end

	self.data.slots[self.current_slot].modes.cave.files = self.data.slots[self.current_slot].modes.cave.files or {}
	self.data.slots[self.current_slot].modes.cave.current_level = self.data.slots[self.current_slot].modes.cave.current_level or {}
	self.data.slots[self.current_slot].modes.cave.world = level or 1

	self.data.slots[self.current_slot].modes.cave.current_level[cavenum] = level
	self.data.slots[self.current_slot].modes.cave.current_cave = cavenum
	
	local savename = self:GetSaveGameName("cave", self.current_slot)
	self.data.slots[self.current_slot].modes.cave.playerdata = playerdata
	self.data.slots[self.current_slot].modes.cave.file = nil
	
	
	TheSim:CheckPersistentStringExists(savename, function(exists) 
		if exists then
			self.data.slots[self.current_slot].modes.cave.file = savename
			self:SyncDataForTransition(self.current_slot, "cave", savename, true)
		end
		self:Save(onsavedcb)
	 end)

end

function SaveIndex:OnFailShipwrecked(onsavedcb)
	self.data.slots[self.current_slot].modes.shipwrecked.playerdata = nil
	self.data.slots[self.current_slot].current_mode = "survival"
	local playerdata = {}
    local player = GetPlayer()
    if player then
    	--remember our unlocked recipes
        playerdata.builder = player:GetSaveRecord().data.builder
        
        --set our meters to the standard resurrection amounts
        playerdata.health = {health = TUNING.RESURRECT_HEALTH}
		playerdata.hunger = {hunger = player.components.hunger.max*.66}
		playerdata.sanity = {current = player.components.sanity.max*.5}
        playerdata.leader = nil
        playerdata.sanitymonsterspawner = nil
		
   	end 

	if self.data.slots[self.current_slot].modes.survival then
		self.data.slots[self.current_slot].modes.survival.playerdata = playerdata
	end
	self:Save(onsavedcb)
end

function SaveIndex:LeaveShipwrecked(onsavedcb, customoptions)
	local playerdata = {}
    local player = GetPlayer()
    if player then
        playerdata = player:GetSaveRecord().data
        playerdata.leader = nil
        playerdata.sanitymonsterspawner = nil
    end
        
	self.data.slots[self.current_slot].modes.shipwrecked.playerdata = nil
	self.data.slots[self.current_slot].current_mode = "survival"
	
	if self.data.slots[self.current_slot].modes.survival then
		self.data.slots[self.current_slot].modes.survival.playerdata = playerdata
	end

	if customoptions then
		self.data.slots[self.current_slot].modes.survival.options = customoptions
	end

	if not IsDLCInstalled(REIGN_OF_GIANTS) then
		if not self.data.slots[self.current_slot].modes.survival.options then
			self.data.slots[self.current_slot].modes.survival.options.tweak.misc.spring="noseason"
			self.data.slots[self.current_slot].modes.survival.options.tweak.misc.summer="noseason"
		end
	end

	local savename = self:GetSaveGameName("survival", self.current_slot)
	TheSim:CheckPersistentStringExists(savename, function(exists) 
		if exists then
			--self:SyncTimePassage(self.current_slot, "survival", savename)
			--self:SyncHounded(self.current_slot, "survival", savename)
			self:SyncDataForTransition(self.current_slot, "survival", savename)
		end
	 end)


	self:Save(onsavedcb)
end



function SaveIndex:MergeSaves(slotnum, target_mode, onsavedcb, dlc)
	if not slotnum then
		return
	end

	local function slotbackupdone()
		print ("Slot backup done")
	end

	local function indexbackupdone()
		print ("Index backup done")
	end

	if not self:OwnsMode(target_mode) then
		-- We backup before doing anything, don't wanna have to deal with angry players..

		local timestamp = os.time(os.date("!*t"))

		self:BackupSlot(self.current_slot, slotbackupdone, timestamp)
		self:BackupSlot(slotnum, slotbackupdone, timestamp)
		self:SaveBackup(indexbackupdone, timestamp)
		--self:AddToBackupIndex(timestamp)
		self.data.slots[self.current_slot].backup_index = timestamp

		-- Copy the target data
		self.data.slots[self.current_slot].modes[target_mode] = deepcopy(self.data.slots[slotnum].modes[target_mode])


		if (not IsDLCInstalled(REIGN_OF_GIANTS) or not self.data.slots[slotnum].dlc.REIGN_OF_GIANTS) and target_mode == "survival" then
			if not self.data.slots[self.current_slot].modes.survival.options then
				self.data.slots[self.current_slot].modes.survival.options={
		            preset="SURVIVAL_DEFAULT",
		            tweak={ misc={ season_start="autumn", spring="noseason", summer="noseason" } }
		          }
		    else
		    	self.data.slots[self.current_slot].modes.survival.options.season_start="autumn"
		    	self.data.slots[self.current_slot].modes.survival.options.spring="noseason"
		    	self.data.slots[self.current_slot].modes.survival.options.summer="noseason"
			end
		elseif (IsDLCInstalled(REIGN_OF_GIANTS) and self.data.slots[slotnum].dlc.REIGN_OF_GIANTS) and target_mode == "survival" then
			if not self.data.slots[self.current_slot].modes.survival.options then
				self.data.slots[self.current_slot].modes.survival.options={ ROGEnabled = true }
			else
				self.data.slots[self.current_slot].modes.survival.options.ROGEnabled = true
			end
		end

		local newfile = self:MergeSlotWithCurrent(slotnum)
		
		local oldfile = self.data.slots[self.current_slot].modes[target_mode].file

		self.data.slots[self.current_slot].modes[target_mode].file = newfile

		for i=1,#self.data.slots[self.current_slot].modes[target_mode].files do
			if self.data.slots[self.current_slot].modes[target_mode].files[i] == oldfile then
				self.data.slots[self.current_slot].modes[target_mode].files[i] = newfile
			end
		end

		if dlc ~= nil then
			self.data.slots[self.current_slot].dlc = dlc
		end

	end

	--self:SaveDepartureDay(self.current_slot, target_mode)
	self.data.slots[self.current_slot].current_mode = target_mode

	self:Save(onsavedcb)
end

function SaveIndex:MergeWithSurvival(slotnum, onsavedcb)
	self:MergeSaves(slotnum, "survival", onsavedcb)
end

function SaveIndex:MergeWithShipwrecked(slotnum, onsavedcb)
	local dlc = {REIGN_OF_GIANTS = false, CAPY_DLC = true}
	self:MergeSaves(slotnum, "shipwrecked", onsavedcb, dlc)
end

function SaveIndex:SyncDataForTransition(slotnum, target_mode, savename, ignore_hounded)

	print ("Syncing data for transition")

	local function SyncTimeData(savedata)
		local timepast = 0

		if savedata.map.persistdata.clock.departure_day ~= nil then

			local current_time = GetPlayer().components.age:GetAge()
			local departure_day = savedata.map.persistdata.clock.departure_day

			if current_time > departure_day then
				timepast = current_time - departure_day
				print ("Time data synced")
			else
				print ("Something went wrong with the world age and the player age. Skipping time sync.")
			end
		end

		savedata.map.persistdata.clock.timepast = timepast
		return savedata
	end

	local function SyncHoundedData(savedata)

		-- Relive fix
		if GetWorld() == nil or GetWorld().components.hounded == nil then
			return savedata
		end

		local current_hounded = GetWorld().components.hounded:OnSave()

		if current_hounded ~= nil then
			print ("Hounded data synced")
			savedata.map.persistdata.hounded = current_hounded
		else
			print ("No Hounded data found, skipping hounded sync phase.")
		end

		print ("Hounded data synced")
		return savedata
	end	


	local function OnSaveDataRetrieved(savedata)
		savedata = SyncTimeData(savedata)

		if not ignore_hounded then
			savedata = SyncHoundedData(savedata)
		end

		local data = DataDumper(savedata, nil, BRANCH ~= "dev")
	    local insz, outsz = TheSim:SetPersistentString(savename, data, ENCODE_SAVES, function () print("Syncinc") end)

	    SavePersistentString(savename, data, ENCODE_SAVES)
	    print ("Synced ", savename, outsz)
	end

	self:GetSaveData(slotnum, target_mode, OnSaveDataRetrieved, true)
end

function SaveIndex:EnterShipwrecked(onsavedcb, saveslot, customoptions)

	self.current_slot = saveslot or self.current_slot

	--get the current player, and maintain his player data
 	local playerdata = {}
    local player = GetPlayer()
    if player then
        playerdata = player:GetSaveRecord().data
        playerdata.leader = nil
        playerdata.sanitymonsterspawner = nil
   	end

	self.data.slots[self.current_slot].current_mode = "shipwrecked"
	
	if not self.data.slots[self.current_slot].modes.shipwrecked then
		self.data.slots[self.current_slot].modes.shipwrecked = {}
	end
	
	local savename = self:GetSaveGameName("shipwrecked", self.current_slot)
	self.data.slots[self.current_slot].modes.shipwrecked.playerdata = playerdata
	self.data.slots[self.current_slot].modes.shipwrecked.file = nil

	local dlc = {REIGN_OF_GIANTS = false, CAPY_DLC = true}
	self.data.slots[self.current_slot].dlc = dlc

	
	if customoptions then
		self.data.slots[self.current_slot].modes.shipwrecked.options = customoptions
	end

	TheSim:CheckPersistentStringExists(savename, function(exists) 
		if exists then
			self.data.slots[self.current_slot].modes.shipwrecked.file = savename
			--self:SyncTimePassage(self.current_slot, "shipwrecked", savename)
			self:SyncDataForTransition(self.current_slot, "shipwrecked", savename)
		end
		self:Save(onsavedcb)
	 end)
end

function SaveIndex:OnFailVolcano(onsavedcb)
	self.data.slots[self.current_slot].modes.volcano.playerdata = nil
	self.data.slots[self.current_slot].current_mode = "survival"
	local playerdata = {}
    local player = GetPlayer()
    if player then
    	--remember our unlocked recipes
        playerdata.builder = player:GetSaveRecord().data.builder
        
        --set our meters to the standard resurrection amounts
        playerdata.health = {health = TUNING.RESURRECT_HEALTH}
		playerdata.hunger = {hunger = player.components.hunger.max*.66}
		playerdata.sanity = {current = player.components.sanity.max*.5}
        playerdata.leader = nil
        playerdata.sanitymonsterspawner = nil
		
   	end 

	if self.data.slots[self.current_slot].modes.survival then
		self.data.slots[self.current_slot].modes.survival.playerdata = playerdata
	end
	self:Save(onsavedcb)
end

function SaveIndex:LeaveVolcano(onsavedcb)
	local playerdata = {}
    local player = GetPlayer()
    if player then
        playerdata = player:GetSaveRecord().data
        playerdata.leader = nil
        playerdata.sanitymonsterspawner = nil
    end
        
	self.data.slots[self.current_slot].modes.volcano.playerdata = nil
	self.data.slots[self.current_slot].current_mode = "shipwrecked"
	
	if self.data.slots[self.current_slot].modes.shipwrecked then
		self.data.slots[self.current_slot].modes.shipwrecked.playerdata = playerdata
	end

	local savename = self:GetSaveGameName("shipwrecked", self.current_slot)
	TheSim:CheckPersistentStringExists(savename, function(exists) 
		if exists then
			--self:SyncTimePassage(self.current_slot, "shipwrecked", savename)
			self:SyncDataForTransition(self.current_slot, "shipwrecked", savename, true)
		end
	 end)

	self:Save(onsavedcb)
end

function SaveIndex:EnterVolcano(onsavedcb, saveslot)
	self.current_slot = saveslot or self.current_slot

	--get the current player, and maintain his player data
 	local playerdata = {}
    local player = GetPlayer()
    if player then
        playerdata = player:GetSaveRecord().data
        playerdata.leader = nil
        playerdata.sanitymonsterspawner = nil
   	end

	self.data.slots[self.current_slot].current_mode = "volcano"
	
	if not self.data.slots[self.current_slot].modes.volcano then
		self.data.slots[self.current_slot].modes.volcano = {}
	end

	--self.data.slots[self.current_slot].modes.volcano.files = self.data.slots[self.current_slot].modes.volcano.files or {}
	--self.data.slots[self.current_slot].modes.volcano.current_level = self.data.slots[self.current_slot].modes.volcano.current_level or {}
	--self.data.slots[self.current_slot].modes.volcano.world = level or 1

	--self.data.slots[self.current_slot].modes.volcano.current_level[cavenum] = level
	--self.data.slots[self.current_slot].modes.volcano.current_cave = cavenum
	
	local savename = self:GetSaveGameName("volcano", self.current_slot)
	self.data.slots[self.current_slot].modes.volcano.playerdata = playerdata
	self.data.slots[self.current_slot].modes.volcano.file = nil
	
	
	TheSim:CheckPersistentStringExists(savename, function(exists) 
		if exists then
			self.data.slots[self.current_slot].modes.volcano.file = savename
			--self:SyncTimePassage(self.current_slot, "volcano", savename)
			self:SyncDataForTransition(self.current_slot, "volcano", savename, true)
		end
		self:Save(onsavedcb)
	 end)
end

function SaveIndex:OnFailAdventure(cb)
	local filename = self.data.slots[self.current_slot].modes.adventure.file

	local function onsavedindex()
		EraseFiles(cb, {filename})
	end
	self.data.slots[self.current_slot].current_mode = "survival"
	self.data.slots[self.current_slot].modes.adventure = {}
	self:Save(onsavedindex)
end

function SaveIndex:FakeAdventure(cb, slot, start_world)
	self.data.slots[slot].current_mode = "adventure"
	self.data.slots[slot].modes.adventure = {world = start_world, playlist = {1,2,3,4,5,6}}
 	self:Save(cb)
end

function SaveIndex:StartAdventure(cb)

	local function ongamesaved()
		local playlist = self.BuildAdventurePlaylist()
		self.data.slots[self.current_slot].current_mode = "adventure"
		self.data.slots[self.current_slot].modes.adventure = {world = 1, playlist = playlist}
	 	self:Save(cb)
	end

	self:SaveCurrent(ongamesaved)

end

function SaveIndex:BuildAdventurePlaylist()
	local levels = require("map/levels")

	local playlist = {}

	local remaining_keys = shuffledKeys(levels.story_levels)
	for i=1,levels.CAMPAIGN_LENGTH+1 do -- the end level is at position length+1
		for k_idx,k in ipairs(remaining_keys) do
			local level_candidate = levels.story_levels[k]
			if level_candidate.min_playlist_position <= i and level_candidate.max_playlist_position >= i then
				table.insert(playlist, k)
				table.remove(remaining_keys, k_idx)
				break
			end
		end
	end

	assert(#playlist == levels.CAMPAIGN_LENGTH+1)

	--debug
	print("Chosen levels:")
	for _,k in ipairs(playlist) do
		print("",levels.story_levels[k].name)
	end

	return playlist
end

--call when you have finished a survival or adventure level to increment the world number and save off the continue information
function SaveIndex:CompleteLevel(cb)
	local adventuremode = self.data.slots[self.current_slot].current_mode == "adventure"

    local playerdata = {}
    local player = GetPlayer()
    if player then
    	player:OnProgress()

		-- bottom out the player's stats so they don't start the next level and die
		local minhealth = 0.2
		if player.components.health:GetPercent() < minhealth then
			player.components.health:SetPercent(minhealth)
		end
		local minsanity = 0.3
		if  player.components.sanity:GetPercent() < minsanity then
			player.components.sanity:SetPercent(minsanity)
		end
		local minhunger = 0.4
		if  player.components.hunger:GetPercent() < minhunger then
			player.components.hunger:SetPercent(minhunger)
		end


        playerdata = player:GetSaveRecord().data
   	 end   

   	local function onerased()
   		if adventuremode then
   			self:Save(cb)
   		else
   			self:EraseCaves(cb)
   			self:EraseVolcano(cb)
   		end
   		--self:Save(cb)
   	end

	self.data.slots[self.current_slot].continue_pending = true
	self.data.slots[self.current_slot].direction = nil
	self.data.slots[self.current_slot].cave_num = nil
	self.data.slots[self.current_slot].followers = nil
	self.data.slots[self.current_slot].clock_data = nil

	local current_mode = self.data.slots[self.current_slot].current_mode
	local data = self:GetModeData(self.current_slot, current_mode)

	data.day = 1
	data.world = data.world and (data.world + 1) or 2
 	data.playerdata = playerdata
	local file = data.file 
	data.file = nil
	EraseFiles( onerased, { file } )		
end

function SaveIndex:GetSlotDay(slot)
	slot = slot or self.current_slot
	local current_mode = self.data.slots[slot].current_mode
	local data = self:GetModeData(slot, current_mode)
	return data.day or 1
end

-- The WORLD is the "depth" the player has traversed through the teleporters. 1, 2, 3, 4...
-- Contrast with the LEVEL, below.
function SaveIndex:GetSlotWorld(slot)
	slot = slot or self.current_slot
	local current_mode = self.data.slots[slot].current_mode
	local data = self:GetModeData(slot, current_mode)
	return data.world or 1
end

-- The LEVEL is the index from levels.lua to load. This gets shuffled via the playlist.
function SaveIndex:GetSlotLevelIndexFromPlaylist(slot)
	slot = slot or self.current_slot
	local current_mode = self.data.slots[slot].current_mode
	local data = self:GetModeData(slot, current_mode)
	local world = data.world or 1
	if data.playlist and world <= #data.playlist then
		local level = data.playlist[world]
		return level
	else
		return world
	end
end

function SaveIndex:GetSlotCharacter(slot)
	local character = self.data.slots[slot or self.current_slot].character
	-- In case a file was saved with a mod character that has become disabled, fall back to wilson

	local charlist = GetActiveCharacterList()
	if not table.contains(charlist, character) and not table.contains(MODCHARACTERLIST, character) then
		character = "wilson"
	end
	return character
end

function SaveIndex:GetSlotBackup(slot)
	return self.data.slots[slot or self.current_slot].backup_index
end

function SaveIndex:HasWorld(slot, mode)

	slot = slot or self.current_slot
	local current_mode = mode or self.data.slots[slot].current_mode
	local data = self:GetModeData(slot, current_mode)
	return data.file ~= nil
end

function SaveIndex:GetSlotGenOptions(slot, mode)
	slot = slot or self.current_slot
	local current_mode = self.data.slots[slot].current_mode
	local data = self:GetModeData(slot, current_mode)
	return data.options
end

function SaveIndex:GetSlotMods(slot)
	slot = slot or self.current_slot
	if slot and self.data.slots[slot] and self.data.slots[slot].mods then
		return self.data.slots[slot].mods
	else
		return {}
	end
end

function SaveIndex:IsContinuePending(slot)
	return self.data.slots[slot or self.current_slot].continue_pending
end

function SaveIndex:GetCurrentMode(slot)
	return self.data.slots[slot or self.current_slot].current_mode
end

function SaveIndex:IsModeShipwrecked(slot)
	return self:GetCurrentMode(slot) == "shipwrecked" or self:GetCurrentMode(slot) == "volcano"
end

function SaveIndex:GetNumberOfSavesForMode(mode, ignore_mode)
	if not mode then
		return 0
	end

	local count = 0

	for i=1, NUM_SAVE_SLOTS do
		if self:GetCurrentMode(i) == mode and not self:OwnsMode(ignore_mode, i) then
			count = count + 1
		end
	end

	return count
end

function SaveIndex:GetRestartMode(mode)
	if mode == "shipwrecked" or mode == "volcano" then
		return "shipwrecked"
	end
	return "survival"
end

function SaveIndex:GetCurrentCaveLevel(slot, cavenum)
	slot = slot or self.current_slot
	cavenum = cavenum or self:GetModeData(slot, "cave").current_cave or cavenum or 1
	local cave_data = self:GetModeData(slot, "cave")
	if cave_data.current_level and cave_data.current_level[cavenum] then
		return cave_data.current_level[cavenum]
	end
	return 1
end

function SaveIndex:GetCurrentCaveNum(slot)
	slot = slot or self.current_slot
	return self:GetModeData(slot, "cave").current_cave or 1
end

function SaveIndex:GetNumCaves(slot)
	slot = slot or self.current_slot
	return self:GetModeData(slot, "cave").num_caves or 0
end


function SaveIndex:AddCave(slot, cb)
	slot = slot or self.current_slot
	
	self:GetModeData(slot, "cave").num_caves = self:GetModeData(slot, "cave").num_caves and self:GetModeData(slot, "cave").num_caves + 1 or 1
	self:Save(cb)
end


-- Global for saving game on Android focus lost event
function OnFocusLost()
	--check that we are in gameplay, not main menu
	if inGamePlay then
		SetPause(true)
		SaveGameIndex:SaveCurrent()
	end
end

function OnFocusGained()
	--check that we are in gameplay, not main menu
	if inGamePlay then
		SetPause(false)
	end
end
