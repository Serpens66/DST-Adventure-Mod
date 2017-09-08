--- ############# Worldjump code by DarkXero! 

local function PlayerExitOverworld(player)
    if not TheWorld:HasTag("cave") then
        TheWorld.components.worldjump:OnPlayerExitOverworld(player)
    end
end

-- Load the decoded data from the persistent string on new spawn
local function OnPlayerSpawn(world, player)
    if not world:HasTag("cave") then
        player:ListenForEvent("onremove", PlayerExitOverworld) -- add listener to notice overwolrd leaving (entering cave)
        world:DoTaskInTime(0, function(world)
            local worldjump = world.components.worldjump
            local userid = player.userid
            local t = worldjump.player_ids
            local found = false
            
            for i, v in ipairs(t) do
                if v == userid then
                    found = true
                    break
                end
            end
            if not found then
                local jumpdata = worldjump.player_data[userid]
                if jumpdata then
                    if worldjump.saveage then
                        player.components.age:OnLoad(jumpdata.age_data)
                        if player.components.beard and jumpdata.beard_data and GetTableSize(player.components.beard.callbacks) > 0 then -- added by serp
                            player.components.beard:OnLoad(jumpdata.beard_data)
                        end
                        if player.prefab=="wx78" then -- level
                            player:OnPreLoad(jumpdata.level_data)
                        end
                    end
                    if worldjump.saveinventory then
                        if TUNING.ITEMNUMBERTRANS~="all" then -- defined in modmain, only transfer a number of items
                            local transitems = {}
                            for i=1,TUNING.ITEMNUMBERTRANS do
                                table.insert(transitems,jumpdata.inventory_data.items[i])
                            end
                            jumpdata.inventory_data.items = transitems
                            jumpdata.inventory_data.equip = {} -- delete quipped items
                        end
                        player.components.inventory:OnLoad(jumpdata.inventory_data, jumpdata.inventory_references)
                        -- print("HIER inventory_data and reference: "..tostring(jumpdata.inventory_data).." , "..tostring(jumpdata.inventory_references))
                    -- else
                        -- print("HIER, saveinventory: "..tostring(saveinventory))
                    end
                    if worldjump.savebuilder then
                        player.components.builder:OnLoad(jumpdata.builder_data) -- added by serp
                    end
                    table.insert(t, userid)
                end
            end
        end)
    end
end

local function OnPlayerDespawn(world, player)
    if TheWorld.components.worldjump then
        TheWorld.components.worldjump:SavePlayerData(player) -- save player data when leaving overworld (leaving game or entering caves)
    end
end

local function LoadRememberStuff(inst,self)
    print("Hier loadrememberstuff worldjump "..tostring(self.inst))
    if TheWorld.components.adv_rememberstuff then
        if self.player_data.worldrememberstuff1 and next(self.player_data.worldrememberstuff1) then -- change world component entry only, if the saved thing is not empty
            TheWorld.components.adv_rememberstuff.stuff1 = self.player_data.worldrememberstuff1  -- load stuff1, this contains the unlocked blueprints from previous worlds
        end
        if self.player_data.worldrememberstuff3 and next(self.player_data.worldrememberstuff3) then
            TheWorld.components.adv_rememberstuff.stuff3 = self.player_data.worldrememberstuff3 -- 3 contains the blueprints that were already distributed to players in blueprintsonly mode
        end
    end
end

local WorldJump = Class(function(self, inst)
	self.inst = inst
	-- I don't know the previous session, it is deleted
	-- I don't know the new session identifier that the regenerated world will have
	-- The save slot is a constant, I guess
	local saveslot = SaveGameIndex:GetCurrentSaveSlot() or 0
	self.info_dir = "mod_config_data/mod_worldjump_adventure_data_"..tostring(saveslot)

	-- jumping data
	-- saves before jumping, loads when the world loads
	self.player_data = {}
	self:LoadPlayerData()
	-- player ids get saved so game can determine if guy is a new spawn or not
	-- if he is, then he gets looked up on the jumping data saved
	self.player_ids = {}

    self.player_data_save = {} -- is the playerdata that is saved during game wehn player leaves game. is not used when player spawns and is saved in persistent string when worldjump is done
	self.inst:ListenForEvent("ms_playerspawn", OnPlayerSpawn)
    self.inst:ListenForEvent("ms_playerdespawn", OnPlayerDespawn) -- leaving game.. 
    self.saveinventory = self.player_data.saveinventory
    self.savebuilder = self.player_data.savebuilder
    self.saveage = self.player_data.saveage 
    self.inst:DoTaskInTime(1,function(inst,self) if TheWorld.components.adv_startstuff then TheWorld.components.adv_startstuff:GiveStartStuffIn(0,LoadRememberStuff,"LoadRememberStuff",self) end;end,self)
end)

function WorldJump:OnPlayerExitOverworld(player) 
    if TheWorld.components.worldjump and player and player.migration then
        TheWorld.components.worldjump:SavePlayerData(player) -- save player data when leaving overworld (leaving game or entering caves)
    end
end

-- Load the persistent string
-- To prevent resetted worlds or new worlds on the same slot from loading this, we are saving the persistent string again
-- But this time we bind a session to the persistent string, if the string did not have a session stored on it
function WorldJump:LoadPlayerData()
	local callback = function(success, encoded_data)
		if success then
			local decoded_data = json.decode(encoded_data)
			local decoded_session = decoded_data.session_id
			local session_id = TheNet:GetSessionIdentifier()
			if decoded_session == nil then
				decoded_data.session_id = session_id
				local re_encoded_data = json.encode(decoded_data)
				TheSim:SetPersistentString(self.info_dir, re_encoded_data, true)
				self.player_data = decoded_data
			elseif decoded_session == session_id then
				self.player_data = decoded_data
			end
		end
	end
	TheSim:GetPersistentString(self.info_dir, callback)
end

-- Save a persistent string with all the relevant player info
function WorldJump:SavePlayerData(pl)	
    local stuff = {}
    local age_data = nil
    local inventory_data, inventory_references = nil,nil
    local builder_data = nil
    local beard_data = nil
    if pl and pl:HasTag("player") then -- only save for one specific player, eg when he leaves
        age_data = pl.components.age:OnSave()
        inventory_data, inventory_references = pl.components.inventory:OnSave()
        stuff.age_data = age_data
        stuff.inventory_data = inventory_data
        stuff.inventory_references = inventory_references
        if pl.prefab=="wx78" then
            stuff.level_data = {level=pl.level > 0 and pl.level or nil}
        end
        -- print("HIER inventory_data and reference: "..tostring(inventory_data).." , "..tostring(inventory_references).." from "..tostring(pl))
        -- for k,v in pairs(inventory_data.items) do
            -- print(tostring(k).." , "..tostring(v))
        -- end
        builder_data = pl.components.builder:OnSave()-- added by serp
        stuff.builder_data = builder_data
        beard_data = pl.components.beard and pl.components.beard:OnSave() or nil-- added by serp
        stuff.beard_data = beard_data
        self.player_data_save[pl.userid] = stuff -- save or overload the stuff of this player
    else -- in case of worldjump
        for k, v in pairs(AllPlayers) do -- all players that are online and in overworld
            if v.prefab=="wx78" then
                stuff.level_data = {level=v.level > 0 and v.level or nil}
            end
            age_data = v.components.age:OnSave()
            inventory_data, inventory_references = v.components.inventory:OnSave()
            stuff.age_data = age_data
            stuff.inventory_data = inventory_data
            stuff.inventory_references = inventory_references
            -- print("HIER worldjump inventory_data and reference: "..tostring(inventory_data).." , "..tostring(inventory_references).." from "..tostring(v))
            builder_data = v.components.builder:OnSave()-- added by serp
            stuff.builder_data = builder_data
            beard_data = v.components.beard and v.components.beard:OnSave() or nil-- added by serp
            stuff.beard_data = beard_data
            self.player_data_save[v.userid] = stuff
        end
        self.player_data_save.saveinventory = self.saveinventory
        self.player_data_save.savebuilder = self.savebuilder
        self.player_data_save.saveage = self.saveage
        self.player_data_save.worldrememberstuff1 = TheWorld.components.adv_rememberstuff and TheWorld.components.adv_rememberstuff.stuff1 or {} --so blueprint progress is saved
        self.player_data_save.worldrememberstuff3 = TheWorld.components.adv_rememberstuff and TheWorld.components.adv_rememberstuff.stuff3 or {}
        local encoded_data = json.encode(self.player_data_save)
        TheSim:SetPersistentString(self.info_dir, encoded_data, true) -- only save it in string when the worldjump is done.
    end
    -- print("hier should be saved now ,"..tostring(pl))
	
end

-- Load the saved player ids
function WorldJump:OnLoad(data)
	if data then
		local t = self.player_ids
		for i, v in ipairs(data) do
            table.insert(t, v)
		end
        self.player_data_save = data.player_data_save or {}
	end
end

-- Save player ids to help on player spawns
function WorldJump:OnSave()
	local data = {}
	local t = self.player_ids
	for i, v in ipairs(t) do
		table.insert(data, v)
	end
    data.player_data_save = self.player_data_save
	return data
end

-- Run this method and let the magic do the rest
-- Since we parse AllPlayers, all the players have to be on the jumping master shard
-- A dedicated server won't count itself for the player count
function WorldJump:DoJump(keepage,keepinventory,keeprecipes)
	
    if keepage==nil or keepage then -- by default, everything is true
        self.saveage = true
    else -- if false
        self.saveage = false
    end
    if keepinventory==nil or keepinventory then    
        self.saveinventory = true
    else
        self.saveinventory = false
    end
    if keeprecipes==nil or keeprecipes then
        self.savebuilder = true
    else
        self.savebuilder = false
    end

    
    -- if not TheNet:GetPlayerCount() == #AllPlayers then -- if not all players are on the same world, print a log entry...
        -- print("All players not in the jumping world, won't save stuff!")
    -- end
    self:SavePlayerData()
    TheNet:SendWorldResetRequestToServer()

end

return WorldJump
