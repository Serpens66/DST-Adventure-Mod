-- A Cold Reception = 1
-- King of Winter = 2
-- The Game is Afoot = 3
-- Archipelago = 4
-- Two Worlds = 5
-- Darkness = 6
-- MaxwellHome = 7
 
local function DelayedSaveAndClean()
    -- With this, stuff will be safe in the component
    -- SaveGame(false)
    TheWorld:PushEvent("ms_save") -- save with the save animation. this is to make sure adventure stuff is not lost when the game crashes between generation and first day.
 
    -- Clean temporal file so other servers don't load adventure levels by mistake
    CleanTemporalAdventureFile()
end
 
local function OnInit(inst, self)
    -- If we bring stuff from modworldgenmain, attach it
    -- Else, make it yourself (what happens for the sandbox worlds)
    local adventure_stuff = GetTemporalAdventureContent()
    if adventure_stuff then
        self.adventure_info = adventure_stuff
    else
        local adventure_info = self.adventure_info
 
        if adventure_info.current_level == nil then
            -- 0 is the starting sandbox world
            adventure_info.current_level = 0
        end
 
        if adventure_info.level_list == nil then
            -- 1, 2, 3, 4, 5 levels to go
            local level_list = {}
            -- Darkness goes last
            level_list[5] = 6
            level_list[6] = 7 -- last is maxwellhome
			-- Two Worlds goes on 3 or 4
			level_list[math.random(3, 4)] = 5

			-- The rest will fill the empty spaces of the level list
			local remaining = {1, 2, 3, 4}
			for i = 1, 6, 1 do
				if level_list[i] == nil then
					local pick = math.random(#remaining)
					level_list[i] = remaining[pick]
					table.remove(remaining, pick)
				end
			end
 
            adventure_info.level_list = level_list
        end
    end
 
    -- inst:DoTaskInTime(1, DelayedSaveAndClean) -- call it instead only after worldgeneration in modmain
end


local AdventureJump = Class(function(self, inst)
	self.inst = inst
	self.adventure_info = {}

	inst:DoTaskInTime(0, OnInit, self)
end)

function AdventureJump:OnSave()
	-- print("hier adventurejump save currentlevel "..tostring(self.adventure_info.current_level))
    return { code = json.encode(self.adventure_info) }
end

function AdventureJump:OnLoad(data)
	self.adventure_info = data and json.decode(data.code) or {}
    -- print("hier adventurejump load currentlevel "..tostring(self.adventure_info.current_level))
end

function AdventureJump:DoJump(keepage,keepinventory,keeprecipes)
	-- Up the level
	local current_level = self.adventure_info.current_level + 1
	self.adventure_info.current_level = current_level

	-- 0 is sandbox key
	-- 1, 2, 3, 4, 5, 6 are adventure keys
	-- 7 means we completed the level list, it's over
	if current_level < 7 then
		MakeTemporalAdventureFile(json.encode(self.adventure_info))
	end

    if TheWorld.components.worldjump then
        TheWorld.components.worldjump:DoJump(keepage,keepinventory,keeprecipes)
    else
        TheNet:SendWorldResetRequestToServer()
    end
end

function AdventureJump:MakeSave() -- save stuff in components, to prevent datalost after worldgenereation if game crashes. Should only be needed directly after world generation
	self.inst:DoTaskInTime(1, DelayedSaveAndClean)
end

return AdventureJump
