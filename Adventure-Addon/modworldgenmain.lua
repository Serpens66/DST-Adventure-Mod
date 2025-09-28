
local _G = GLOBAL


if GLOBAL.rawget(GLOBAL, "TheFrontEnd") and GLOBAL.rawget(GLOBAL, "IsInFrontEnd") and GLOBAL.IsInFrontEnd() then return end -- only load to generate the world
-- print("HIER WORLDGEN adv")

-- GLOBAL values are seperated for forest and cave, so make sure that they are always set up equally or keep in mind that they might be different.
-- LEVEL and CHAPTER should be the same in cave like in overworld, but not tested yet.


--##########################################

-- Explanations:

-- Level is the number of chosen map. There can be unlimited maps. starts at 1
-- Chapter: starts at 1. max number is 7. ->Only 7 maps are chosen from the level list.
-- for testing you can do TheWorld.components.adventurejump:DoJump() within console
-- to see what overrides you can choose for your world, see scripts\map\customise.lua

-- mods can add their worlds to the WORLDS list, so players could also use several such mods and the teleoprtato mod will choose randomly between those levels to fill the chapters.
-- those mods must load before the teleportato mod, so priority must be higher than 8888 (no clue why I chose this value)

-- if you want a teleportato (add_teleportato in taskdata), but don't want to create setpieces for it and want the teleportato mod to simply spawn them, you can either
-- make _G.TUNING.TELEPORTATOMOD.teleportato_layouts["forest"]=nil, then the setpieces from teleportato mod are used. OR you can set it {}, then no setpieces are used, 
-- but they are randomly placed after world generation. But also set _G.TUNING.TELEPORTATOMOD.set_behaviour within your modworldgenmain to between 0 and 3 (not 4 or 5!), otherwise world generation will be endless.

-- add_teleportato at caves will only add the parts here. the base will always be at mastershard (forest)

-- you can define the tasks where to palce the teleportato parts tasksetdata.set_pieces[layout] = { count = 1, tasks=allTasks} within your taskdatafunction.
-- only forest will have the worldjump component, so only forest should have a teleportato_base.
-- if it is nil for a layout from teleportato_layouts, a random task will be chosen. You can find all existing tasks in scripts\map\tasks folder or create your own.
-- do not use tasksetdata.ordered_story_setpieces, since this is only made to work with original DS adventure worlds. Only use it if you know what you are doing.
-- use taskdata.set_pieces instead for normal set_pieces and add_teleportato for the teleportato stuff (to place them randomly)

-- currently it only supports two worlds: forest and cave, but you can change them to your liking. If you want to add more worlds with different names, 
-- the teleportato mod code has to be adjusted, although I already made sure to use "forest" and "cave" as less as possible.



-- do not use "_G.TUNING.TELEPORTATOMOD.LEVEL == x" within your code, use instead _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="mylevel"

------------------------------------------------------------------

local require = _G.require


if not _G.TUNING.TELEPORTATOMOD then
    _G.TUNING.TELEPORTATOMOD = {}
end
if not _G.TUNING.TELEPORTATOMOD.WORLDS then
    _G.TUNING.TELEPORTATOMOD.WORLDS = {}
end
local WORLDS = _G.TUNING.TELEPORTATOMOD.WORLDS

_G.TUNING.ADV_DIFFICULTY = GetModConfigData("difficulty") -- also used within chest scenarios

modimport("scripts/tasksroomslayouts") -- load some custom map stuff

if _G.TUNING.ADV_DIFFICULTY==0 then
    adventureportal = "AdventurePortalLayout"
else
    adventureportal = "AdventurePortalLayoutNew" --  has some clockworks, skeletons and a maxwelllight
end
local adventure1_setpieces_tasks = {"Easy Blocked Dig that rock","Great Plains","Guarded Speak to the king","Waspy Beeeees!","Guarded Squeltch","Guarded Forest hunters","Befriend the pigs","Guarded For a nice walk","Walled Kill the spiders","Killer bees!","Make a Beehat","Waspy The hunters","Hounded Magic meadow","Wasps and Frogs and bugs","Guarded Walrus Desolate"}
local required_prefabs = {"chester_eyebone", "spawnpoint_master",}




-- we can use GLOBAL.LEVEL and _G.TUNING.TELEPORTATOMOD.CHAPTER as soon as the game started
-- so do not use it directly in AddPrefabPostInit, but make DoTaskInTime with at least 0.1 within

-- in case the positions choosen by usr and also defaultpositions chosen by level creator fail to assign one unique level to every chapter, use this fallback level list:
_G.TUNING.TELEPORTATOMOD.LEVEL_LIST_FALLBACK = {"Maxwells Door","King of Winter","A Cold Reception","Archipelago","Two Worlds","Darkness","Checkmate"}

-- testing
-- _G.TUNING.TELEPORTATOMOD.LEVEL_GEN = 8 -- force loading this level, starts at 1 anjd goes up to unlimited (max 63 due to netvars)
-- _G.TUNING.TELEPORTATOMOD.CHAPTER_GEN = 7 -- force loading this chapter, starts at 1 and goes up to 7
-- Sandbox (adventureportal) = 1
-- A Cold Reception = 2
-- King of Winter = 3
-- The Game is Afoot = 4
-- Archipelago = 5
-- Two Worlds = 6
-- Darkness = 7
-- MaxwellHome = 8




-- following is optional, teleportato and adventure_portal setpieces are also added within the teleportato mod
if _G.TUNING.TELEPORTATOMOD.teleportato_layouts==nil then
    _G.TUNING.TELEPORTATOMOD.teleportato_layouts = {}
end

if _G.TUNING.TELEPORTATOMOD.teleportato_layouts["forest"]==nil then -- may also be changed by another mod
    if _G.TUNING.ADV_DIFFICULTY==0 then
        _G.TUNING.TELEPORTATOMOD.teleportato_layouts["forest"] = {
            teleportato_box="TeleportatoBoxLayout",
            teleportato_ring="TeleportatoRingLayout",
            teleportato_potato="TeleportatoPotatoLayout",
            teleportato_crank="TeleportatoCrankLayout",
            teleportato_base="TeleportatoBaseAdventureLayout",
        }
    else
        _G.TUNING.TELEPORTATOMOD.teleportato_layouts["forest"] = {
            teleportato_box="TeleportatoBoxLayout",
            teleportato_ring="TeleportatoRingLayoutSanityRocks",
            teleportato_potato="TeleportatoPotatoLayout",
            teleportato_crank="TeleportatoCrankLayout",
            teleportato_base="TeleportatoBaseAdventureLayout",
        }
    end
end

if _G.TUNING.TELEPORTATOMOD.teleportato_layouts["cave"]==nil then -- may also be changed by another mod
    if _G.TUNING.ADV_DIFFICULTY==0 then
        _G.TUNING.TELEPORTATOMOD.teleportato_layouts["cave"] = { -- without base ! base is only in forest (mastershard)
            teleportato_box="TeleportatoBoxLayout",
            teleportato_ring="TeleportatoRingLayout",
            teleportato_potato="TeleportatoPotatoLayout",
            teleportato_crank="TeleportatoCrankLayout",
        }
    else
        _G.TUNING.TELEPORTATOMOD.teleportato_layouts["cave"] = {
            teleportato_box="TeleportatoBoxLayout",
            teleportato_ring="TeleportatoRingLayoutSanityRocks",
            teleportato_potato="TeleportatoPotatoLayout",
            teleportato_crank="TeleportatoCrankLayout",
        }
    end
end

--- #################
-- adding new worldgeneration settings (only selectable by scripts I guess) to restore the old behavior of Node:PopulateExtra function (map/graphnode.lua) called from forest_map.lua to spawn some more prefabs.
-- in an older game version (pre ~2021) setting eg "fireflies" in wordlsettings to "often" resulted in fireflies everywhere, even in areas where they usually don't spawn.
-- in current version they only get multiplied where they usually spawn instead.
-- but the devs introduced TRANSLATE_TO_CLUMP in forest_map.lua instead, so get close to the old behaviour and the chesspieces setting is one that uses it (although I'm not sure why the condition includes "0.25 > math.random()"... does it mean even on highest clump-settings there may be areas without new prefabs? not sure... but I think yes, but it is ok I think)
-- so we will add some more stuff there, eg fireflies and maxwell-lights for the darkness level, so they will spawn everywhere, just like they should
-- valid settings (overrides) will then be often,mostly,always,insane
-- in addition that game update added more allowed setting values for worldgerneration settings, so instead of only having 
--   never,rare,default,often,always  we now have: never,rare,uncommon,default,often,mostly,always,insane
--   you can see in map/customize.lua which settings do have these new options when searching for "worldgen_frequency_descriptions"
local forest_map = require("map/forest_map")
-- we should not use the prefab in the list directly, because Clump overwrites the translated_prefabs in TranslateWorldGenChoices in forest_map.lua. That is also why the devs used "worldgen_chesspieces" instead of a list with knight/bishop/rook, because clump can only spawn new prefabs, but can not reduce the number. And since we don't want to overwrite any other mechanics, we need to make custom prefabs and translate them with prefabswap, just like worldgen_chesspieces did
if forest_map.TRANSLATE_TO_CLUMP~=nil then -- devs need to add it to the returned values: https://forums.kleientertainment.com/klei-bug-tracker/dont-starve-together/forest_maplua-does-not-return-translate_to_clump-r36225/
    forest_map.TRANSLATE_TO_CLUMP["ADV_clump_fireflies"] = {"ADV_worldgen_fireflies"} 
    forest_map.TRANSLATE_TO_CLUMP["ADV_clump_maxwelllight_area"] = {"ADV_worldgen_maxwelllight_area"}
    forest_map.TRANSLATE_TO_CLUMP["ADV_clump_bunnymen"] = {"ADV_worldgen_rabbithouse"}
    forest_map.TRANSLATE_TO_CLUMP["ADV_clump_flower_cave"] = {"ADV_worldgen_flower_cave"}
    forest_map.TRANSLATE_TO_CLUMP["ADV_clump_pigtorch"] = {"ADV_worldgen_pigtorch"}
    forest_map.TRANSLATE_TO_CLUMP["ADV_clump_spiders"] = {"ADV_worldgen_spiderden"}
    forest_map.TRANSLATE_TO_CLUMP["ADV_clump_walrus"] = {"ADV_worldgen_walrus_camp"}
    -- the naming "often" and so on for Clump is a bit misleading. "often" here is the smallest amount of spawning new prefabs, so if you only want a very few new prefabs to spawn, you call it often, and not rare or so.
    -- but still our "ADV_allmap_often" will mean spawn 1 or 2 entities in every single node (?) (75%chance). If we want less, we should use "often" instead, which is only up to 8 nodes.
    forest_map.CLUMP["ADV_allmap_always"] = 100 -- in how many nodes(?) we spawn the prefabs. Since we want it in nearly all areas, a extra high number (every node still only has a 75% chance, because this is set in graphnode.lua from the game "if amt.clumpcount > 0 and 0.25 > math.random() then")
    forest_map.CLUMPSIZE["ADV_allmap_always"] = forest_map.CLUMPSIZE["always"] -- how many prefabs are spawned in a node(?)
    forest_map.CLUMP["ADV_allmap_often"] = 100
    forest_map.CLUMPSIZE["ADV_allmap_often"] = forest_map.CLUMPSIZE["often"]
    forest_map.CLUMP["ADV_allmap_mostly"] = 100
    forest_map.CLUMPSIZE["ADV_allmap_mostly"] = forest_map.CLUMPSIZE["mostly"]
    forest_map.CLUMP["ADV_allmap_insane"] = 100
    forest_map.CLUMPSIZE["ADV_allmap_insane"] = forest_map.CLUMPSIZE["insane"]
    forest_map.CLUMP["ADV_allmap_never"] = 0
    forest_map.CLUMPSIZE["ADV_allmap_never"] = {0,0}
    -- Now add the translation of our worldgen_ prefabs:
    local PrefabSwaps = require("prefabswaps")
    PrefabSwaps.AddCustomizationPrefab("ADV_worldgen_fireflies", "fireflies")
    PrefabSwaps.AddCustomizationPrefab("ADV_worldgen_maxwelllight_area", "maxwelllight_area")
    PrefabSwaps.AddCustomizationPrefab("ADV_worldgen_rabbithouse", "rabbithouse")
    PrefabSwaps.AddRandomizationPrefab("ADV_worldgen_flower_cave", {"flower_cave", "flower_cave_double", "flower_cave_triple"})
    PrefabSwaps.AddCustomizationPrefab("ADV_worldgen_pigtorch", "pigtorch")
    PrefabSwaps.AddCustomizationPrefab("ADV_worldgen_spiderden", "spiderden")
    PrefabSwaps.AddCustomizationPrefab("ADV_worldgen_walrus_camp", "walrus_camp")
end

--- #################


local function GetRandomSubstituteList( substitutes, num_choices )  
    local subs = {}
    local list = {}

    for k,v in pairs(substitutes) do 
        list[k] = v.weight
    end

    for i=1,num_choices do
        local choice = GLOBAL.weighted_random_choice(list)
        list[choice] = nil
        subs[choice] = substitutes[choice]
    end

    return subs
end
local SUBS_1= { -- this is replacing stuff, (see resource_sub... gamefile) I don't like it and it seems not working 100%, but at least for DS setting we should use it
            ["evergreen"] =         {perstory=0.5,  pertask=1,      weight=1}, -- weight is for GetRandomSubstituteList to choose x from that list
            ["evergreen_short"] =   {perstory=1,    pertask=1,      weight=1}, -- per story is the chance per area to actually do the substitution
            ["evergreen_normal"] =  {perstory=1,    pertask=1,      weight=1}, -- pertask is the percentage of how many of this prefab is replaced in this area
            ["evergreen_tall"] =    {perstory=1,    pertask=1,      weight=1}, -- BUT Im not able to see this working as it should. even on 1 1 1 there are or are no subistiutions. I dont trust this, so this will only be active for DS difficulty
            ["sapling"] =           {perstory=0.6,  pertask=0.95,   weight=1},
            ["beefalo"] =           {perstory=1,    pertask=1,      weight=1},
            ["rabbithole"] =        {perstory=1,    pertask=1,      weight=1},
            ["rock1"] =             {perstory=0.3,  pertask=1,      weight=1},
            ["rock2"] =             {perstory=0.5,  pertask=0.8,    weight=1},
            ["grass"] =             {perstory=0.5,  pertask=0.9,    weight=1},
            ["flint"] =             {perstory=0.5,  pertask=1,      weight=1},
            ["spiderden"] =         {perstory=1,    pertask=1,      weight=1},
        }
-- for refernce, this is by what it is replaced: (see resource_sub... gamefile)
    -- ["rock1"] =      {"basalt","rock_flintless"},--, "plainrock"},
    -- ["rock2"] =      {"basalt","rock_flintless"},--, "plainrock"},
    -- ["evergreen"] =  { "evergreen_stump", "evergreen_sparse", "marsh_tree"}, --, "leif"
    -- ["evergreen_normal"] =   {"evergreen_burnt", "evergreen_stump", "evergreen_sparse", "marsh_tree"},-- "leif"}, 
    -- ["evergreen_short"] =    {"evergreen_burnt", "evergreen_stump", "evergreen_sparse", "marsh_tree"},-- "leif"}, 
    -- ["evergreen_tall"] =     {"evergreen_burnt", "evergreen_stump", "evergreen_sparse", "marsh_tree"},-- "leif"}, 
    -- ["grass"]    =       {"depleted_grass", "flower"},
    -- ["flint"]    =       {"flower"},
    -- ["sapling"] =        {"marsh_bush"}, --  "depleted_sapling"},
    -- ["beefalo"] =        {"rabbithole"},
    -- ["rabbithole"] =     {"beefalo"},
    -- ["spiderden"] =      {"spiderden_2", "spiderden_3"},
    -- ["pighouse"] =       {"pigman"},


local function AlwaysTinyCave(tasksetdata) -- even if cave was enabled, make it always very tiny, cause we dont need it
    tasksetdata.tasks = {"CaveExitTask1"}
            tasksetdata.numoptionaltasks = 0
            tasksetdata.optionaltasks = {}
            tasksetdata.required_setpieces = {}
            tasksetdata.required_prefabs = {}
            tasksetdata.set_pieces = {}
            tasksetdata.valid_start_tasks = {"CaveExitTask1"}
            if tasksetdata.overrides==nil then
                tasksetdata.overrides = {}
            end
            tasksetdata.overrides.world_size  =  "small"
            tasksetdata.overrides.wormhole_prefab = "wormhole"
            tasksetdata.overrides.layout_mode = "LinkNodesByKeys"
    return tasksetdata
end
-- Explanation of the WORLD table:
-- name -> shown in title
-- taskdatafunctions -> this function is called in AddLevelPreInitAny in modwordgenmain of the base mod to set the taskdata of the world, so your mod is loaded.
-- location -> forest or cave
-- positions -> only 5 maps per game. maps chosen randomly or disallow certain positions. eg. {2,3} your world may only load at second or third world. {1,2,3,4,5} your world may load regardless on which position.
-- the LEVEL is determined by the order you add them to the _G.TUNING.TELEPORTATOMOD.WORLDS list



local function AdventurePortalWorld(tasksetdata)
    if tasksetdata.overrides==nil then
        tasksetdata.overrides = {}
    end
    if GetModConfigData("sandboxpreconfigured") then
        tasksetdata.tasks = {"Tentacle-Blocked Spider Swamp"}--{"Swamp start","Tentacle-Blocked Spider Swamp"}--{"Tentacle-Blocked Spider Swamp"} -- {"Swamp start"}
        tasksetdata.numoptionaltasks = 0
        tasksetdata.optionaltasks = {}
        tasksetdata.set_pieces = {}
            -- ["ResurrectionStoneWinter"] = { count=1, tasks={"Tentacle-Blocked Spider Swamp"}},
        -- }
        tasksetdata.required_setpieces = {}
        table.insert(tasksetdata.required_setpieces,adventureportal) -- adventure portal is NOT added by teleportato mod. only if it is a level with name Maxwells Door and the world has no portal
        tasksetdata.numrandom_set_pieces = 0
        tasksetdata.random_set_pieces = {}
        tasksetdata.required_prefabs = {"spawnpoint_master","adventure_portal"}
        tasksetdata.ocean_prefill_setpieces = {} -- delete any ocean stuff
        tasksetdata.ocean_population = {} -- delete any ocean stuff
        
        tasksetdata.overrides.world_size  =  "small"
        tasksetdata.overrides.wormhole_prefab = "wormhole"
        tasksetdata.overrides.layout_mode = "LinkNodesByKeys"
        tasksetdata.overrides.deerclops  =  (_G.TUNING.ADV_DIFFICULTY==0 and "never") or (_G.TUNING.ADV_DIFFICULTY==1 and "never") or (_G.TUNING.ADV_DIFFICULTY==2 and "rare") or (_G.TUNING.ADV_DIFFICULTY==3 and "default") or "never"
        tasksetdata.overrides.dragonfly  =  "never"
        tasksetdata.overrides.bearger  =  (_G.TUNING.ADV_DIFFICULTY==0 and "never") or (_G.TUNING.ADV_DIFFICULTY==1 and "never") or (_G.TUNING.ADV_DIFFICULTY==2 and "rare") or (_G.TUNING.ADV_DIFFICULTY==3 and "default") or "never"
        tasksetdata.overrides.goosemoose  =  (_G.TUNING.ADV_DIFFICULTY==0 and "never") or (_G.TUNING.ADV_DIFFICULTY==1 and "never") or (_G.TUNING.ADV_DIFFICULTY==2 and "rare") or (_G.TUNING.ADV_DIFFICULTY==3 and "default") or "never"
        tasksetdata.overrides.antliontribute = "never"
        tasksetdata.overrides.season_start  =  "autumn"
        tasksetdata.overrides.autumn = "veryshortseason"
        tasksetdata.overrides.winter = "veryshortseason"
        tasksetdata.overrides.spring = "veryshortseason"
        tasksetdata.overrides.summer = "veryshortseason"
        tasksetdata.overrides.keep_disconnected_tiles = true
        tasksetdata.overrides.no_joining_islands = true
        
        -- ALWAYS with ocean! because wormhole placement can fail. Instead we will make thinkthank unavailable when setting is set to only wormholes and placement suceeded
        tasksetdata.overrides["has_ocean"] = true
    
        -- game mode settings
        tasksetdata.overrides.portalresurection = _G.TUNING.ADV_DIFFICULTY==1 and "always" or "none"
        tasksetdata.overrides.ghostenabled = "always"
        tasksetdata.overrides.ghostsanitydrain = "always"
        tasksetdata.overrides.basicresource_regrowth = "always"
        tasksetdata.overrides.spawnmode = "fixed"
        tasksetdata.overrides.resettime = "default"
    else -- load normal worldsettings, but with portal
        if tasksetdata.required_setpieces==nil then
            tasksetdata.required_setpieces = {}
        end
        table.insert(tasksetdata.required_setpieces,adventureportal) -- adventure portal is NOT added by teleportato mod. only if it is a level with name Maxwells Door and the world has no portal
    end
    return tasksetdata
end
if GetModConfigData("sandboxpreconfigured") then
    table.insert(_G.TUNING.TELEPORTATOMOD.WORLDS, {name="Maxwells Door", taskdatafunctions={forest=AdventurePortalWorld, cave=AlwaysTinyCave}, defaultpositions={1}, positions=GetModConfigData("maxwellsdoor")})
else -- otherwise, no tiny cave
    table.insert(_G.TUNING.TELEPORTATOMOD.WORLDS, {name="Maxwells Door", taskdatafunctions={forest=AdventurePortalWorld}, defaultpositions={1}, positions=GetModConfigData("maxwellsdoor")})
end

local function AdventureColdReception(tasksetdata) -- A Cold Reception
    tasksetdata.numoptionaltasks = 4
    tasksetdata.tasks = {"Make a pick","Easy Blocked Dig that rock","Great Plains","Guarded Speak to the king",}
    tasksetdata.optionaltasks = {"Waspy Beeeees!","Guarded Squeltch","Guarded Forest hunters","Befriend the pigs","Guarded For a nice walk","Walled Kill the spiders","Killer bees!",
        "Make a Beehat","Waspy The hunters","Hounded Magic meadow","Wasps and Frogs and bugs","Guarded Walrus Desolate",}
    tasksetdata.set_pieces = {                
            ["ResurrectionStoneWinter"] = { count=1, tasks=adventure1_setpieces_tasks},
        }
    tasksetdata.required_setpieces = {}
    tasksetdata.numrandom_set_pieces = 0
    if not tasksetdata.ordered_story_setpieces then -- only use this for this mod, so for original DS adventure worlds!
        tasksetdata.ordered_story_setpieces = {}
    end
    for _,set in pairs(_G.TUNING.TELEPORTATOMOD.teleportato_layouts["forest"]) do
        table.insert(tasksetdata.ordered_story_setpieces,set)
    end
    tasksetdata.random_set_pieces = {}
    tasksetdata.ocean_prefill_setpieces = {} -- delete any ocean stuff
    tasksetdata.ocean_population = {} -- delete any ocean stuff
    tasksetdata.add_teleportato = true -- add teleportato within teleportato mod. ypu can set up _G.TUNING.TELEPORTATOMOD.teleportato_layouts to change the setpieces of them
    tasksetdata.required_prefabs = _G.ArrayUnion(required_prefabs,{"teleportato_base","teleportato_box","teleportato_crank","teleportato_ring","teleportato_potato"}) -- if ordered_story_setpieces is nil/empty, required_prefabs is set up in teleoprtato mod depending in settings there
    if _G.TUNING.ADV_DIFFICULTY==0 then
        tasksetdata.substitutes = GetRandomSubstituteList(SUBS_1, 3)
    end
    if tasksetdata.overrides==nil then
        tasksetdata.overrides = {}
    end
    tasksetdata.overrides.world_size  =  GetModConfigData("worldsizeacoldreception") or "medium"
    tasksetdata.overrides.day  =  GetModConfigData("dayacoldreception") or "longdusk" 
    tasksetdata.overrides.weather  =  "often"
    tasksetdata.overrides.frograin   =  "often"
    
    tasksetdata.overrides.season_start  =  GetModConfigData("startseasonacoldreception") or "spring"
    
    tasksetdata.overrides.deerclops  =  (_G.TUNING.ADV_DIFFICULTY==0 and "never") or (_G.TUNING.ADV_DIFFICULTY==1 and "never") or (_G.TUNING.ADV_DIFFICULTY==2 and "rare") or (_G.TUNING.ADV_DIFFICULTY==3 and "default") or "never"
    tasksetdata.overrides.dragonfly  =  "never"
    tasksetdata.overrides.bearger  =  "never"
    tasksetdata.overrides.goosemoose  =  (_G.TUNING.ADV_DIFFICULTY==0 and "never") or (_G.TUNING.ADV_DIFFICULTY==1 and "never") or (_G.TUNING.ADV_DIFFICULTY==2 and "rare") or (_G.TUNING.ADV_DIFFICULTY==3 and "default") or "never"
    tasksetdata.overrides.antliontribute = "never"
    tasksetdata.overrides.hounds  =  "never" -- no hound attacks
    
    if forest_map.TRANSLATE_TO_CLUMP~=nil then
        -- DS uses mactusk="always", but still only ~5 to 10 will spawn all over the world. seems somehow limited to one per task or so?
        -- anyway, we will reduce it for DS to Clump="often" which means 1 or 2 in up to 8 nodes (ADV_allmap_often would mean 1 or 2 in nearly every node) and also reduce it a bit in other difficulties
        tasksetdata.overrides.ADV_clump_walrus  =  (_G.TUNING.ADV_DIFFICULTY==0 and "often") or (_G.TUNING.ADV_DIFFICULTY==3 and "ADV_allmap_mostly") or (_G.TUNING.ADV_DIFFICULTY==1 and "often") or "ADV_allmap_often"
    else
        tasksetdata.overrides.walrus  =  "always"
    end
    
    tasksetdata.overrides.leifs  =  "always"
    
    tasksetdata.overrides.trees  =  "often" -- no clump_ needed, because I think trees should only spawn there where they are meant to spawn
    tasksetdata.overrides.carrot  =  "default"
    tasksetdata.overrides.berrybush  =  "never"
    
    tasksetdata.overrides.wormhole_prefab = "wormhole"
    tasksetdata.overrides.layout_mode = "LinkNodesByKeys"
    tasksetdata.overrides.start_location = "adv1"
    tasksetdata.overrides.autumn = GetModConfigData("autumnacoldreception") or "noseason"
    tasksetdata.overrides.winter = GetModConfigData("winteracoldreception") or "3__daysseason" -- 3__daysseason added by teleportato mod
    tasksetdata.overrides.spring = GetModConfigData("springacoldreception") or "5__daysseason"
    tasksetdata.overrides.summer = GetModConfigData("summeracoldreception") or "noseason"
    tasksetdata.overrides.keep_disconnected_tiles = true
    tasksetdata.overrides.no_joining_islands = true
    
    -- ALWAYS with ocean! because wormhole placement can fail. Instead we will make thinkthank unavailable when setting is set to only wormholes and placement suceeded
    tasksetdata.overrides["has_ocean"] = true
    
    -- game mode settings
    tasksetdata.overrides.portalresurection = _G.TUNING.ADV_DIFFICULTY==1 and "always" or "none"
    tasksetdata.overrides.ghostenabled = "always"
    tasksetdata.overrides.ghostsanitydrain = "always"
    tasksetdata.overrides.basicresource_regrowth = "always"
    tasksetdata.overrides.spawnmode = "fixed"
    tasksetdata.overrides.resettime = "default"
    
    return tasksetdata
end
table.insert(_G.TUNING.TELEPORTATOMOD.WORLDS, {name="A Cold Reception", taskdatafunctions={forest=AdventureColdReception, cave=AlwaysTinyCave}, defaultpositions={2,3,4}, positions=GetModConfigData("acoldreception")})


local function AdventureKingWinter(tasksetdata)
    tasksetdata.numoptionaltasks = 2
    tasksetdata.tasks = {"Resource-rich Tier2","Sanity-Blocked Great Plains","Hounded Greater Plains","Insanity-Blocked Necronomicon",}
    tasksetdata.optionaltasks = {"Walrus Desolate","Walled Kill the spiders","The Deep Forest","Forest hunters",}
    tasksetdata.set_pieces = {                
            -- ["WesUnlock"] = { restrict_to="background", tasks={ "Hounded Greater Plains", "Walrus Desolate", "Walled Kill the spiders", "The Deep Forest", "Forest hunters" }},
            ["ResurrectionStoneWinter"] = { count=1, tasks={"Resource-rich Tier2","Sanity-Blocked Great Plains","Hounded Greater Plains","Insanity-Blocked Necronomicon", 
                                                    "Walrus Desolate","Walled Kill the spiders","The Deep Forest","Forest hunters"}},
            ["MacTuskTown"] = { tasks={"Insanity-Blocked Necronomicon", "Hounded Greater Plains", "Sanity-Blocked Great Plains"} },
        }
    tasksetdata.required_setpieces = {}
    tasksetdata.numrandom_set_pieces = 0
    if not tasksetdata.ordered_story_setpieces then -- only use this for this mod, so for original DS adventure worlds!
        tasksetdata.ordered_story_setpieces = {}
    end
    for _,set in pairs(_G.TUNING.TELEPORTATOMOD.teleportato_layouts["forest"]) do
        table.insert(tasksetdata.ordered_story_setpieces,set)
    end
    tasksetdata.random_set_pieces = {}
    tasksetdata.ocean_prefill_setpieces = {} -- delete any ocean stuff
    tasksetdata.ocean_population = {} -- delete any ocean stuff
    tasksetdata.add_teleportato = true -- add teleportato within teleportato mod. ypu can set up _G.TUNING.TELEPORTATOMOD.teleportato_layouts to change the setpieces of them
    tasksetdata.required_prefabs = _G.ArrayUnion(required_prefabs,{"teleportato_base","teleportato_box","teleportato_crank","teleportato_ring","teleportato_potato"}) -- if ordered_story_setpieces is nil/empty, required_prefabs is set up in teleoprtato mod depending in settings there
    if _G.TUNING.ADV_DIFFICULTY==0 then
        tasksetdata.substitutes = GetRandomSubstituteList(SUBS_1, 3)
    end
    if tasksetdata.overrides==nil then
        tasksetdata.overrides = {}
    end
    tasksetdata.overrides.world_size = GetModConfigData("worldsizekingofwinter") or "medium"
    tasksetdata.overrides.wormhole_prefab = "wormhole"
    tasksetdata.overrides.layout_mode = "LinkNodesByKeys"
    tasksetdata.overrides.day  =  GetModConfigData("daykingofwinter") or "longdusk" 

    tasksetdata.overrides.start_location = "adv2"

    tasksetdata.overrides.loop  =  "never"
    tasksetdata.overrides.branching  =  "least"
    
    tasksetdata.overrides.season_start  =  GetModConfigData("startseasonkingofwinter") or "winter"
    tasksetdata.overrides.weather  =  (_G.TUNING.ADV_DIFFICULTY==0 and "often") or (_G.TUNING.ADV_DIFFICULTY==1 and "often") or (_G.TUNING.ADV_DIFFICULTY==2 and "always") or (_G.TUNING.ADV_DIFFICULTY==3 and "always") or "often"      
    
    tasksetdata.overrides.deerclops  =  (_G.TUNING.ADV_DIFFICULTY==0 and "often") or (_G.TUNING.ADV_DIFFICULTY==1 and "default") or (_G.TUNING.ADV_DIFFICULTY==2 and "often") or (_G.TUNING.ADV_DIFFICULTY==3 and "always") or "often"
    tasksetdata.overrides.dragonfly  =  "never"
    tasksetdata.overrides.bearger  =  "never"
    tasksetdata.overrides.goosemoose  =  "never"
    tasksetdata.overrides.antliontribute = "never"
    tasksetdata.overrides.hounds  =  "never"
    if forest_map.TRANSLATE_TO_CLUMP~=nil then
        -- DS uses mactusk="always", but still only ~5 to 10 will spawn all over the world. seems somehow limited to one per task or so?
        -- anyway, we will reduce it for DS to Clump="often" which means 1 or 2 in up to 8 nodes (ADV_allmap_often would mean 1 or 2 in nearly every node) and also reduce it a bit in other difficulties
        tasksetdata.overrides.ADV_clump_walrus  =  (_G.TUNING.ADV_DIFFICULTY==0 and "often") or (_G.TUNING.ADV_DIFFICULTY==3 and "ADV_allmap_mostly") or (_G.TUNING.ADV_DIFFICULTY==1 and "often") or "ADV_allmap_often"
    else
        tasksetdata.overrides.walrus  =  "always"
    end
    
    tasksetdata.overrides.carrot = (_G.TUNING.ADV_DIFFICULTY==0 and "rare") or (_G.TUNING.ADV_DIFFICULTY==1 and "default") or (_G.TUNING.ADV_DIFFICULTY==2 and "rare") or (_G.TUNING.ADV_DIFFICULTY==3 and "never") or "rare"          
    tasksetdata.overrides.berrybush  =  (_G.TUNING.ADV_DIFFICULTY==0 and "rare") or (_G.TUNING.ADV_DIFFICULTY==1 and "default") or (_G.TUNING.ADV_DIFFICULTY==2 and "rare") or (_G.TUNING.ADV_DIFFICULTY==3 and "never") or "rare"
    
    tasksetdata.overrides.autumn = GetModConfigData("autumnkingofwinter") or "noseason"
    tasksetdata.overrides.winter = GetModConfigData("winterkingofwinter") or "verylongseason"
    tasksetdata.overrides.spring = GetModConfigData("springkingofwinter") or "noseason"
    tasksetdata.overrides.summer = GetModConfigData("summerkingofwinter") or "noseason"
    tasksetdata.overrides.keep_disconnected_tiles = true
    tasksetdata.overrides.no_joining_islands = true
    
    -- ALWAYS with ocean! because wormhole placement can fail. Instead we will make thinkthank unavailable when setting is set to only wormholes and placement suceeded
    tasksetdata.overrides["has_ocean"] = true
    
    -- game mode settings
    tasksetdata.overrides.portalresurection = _G.TUNING.ADV_DIFFICULTY==1 and "always" or "none"
    tasksetdata.overrides.ghostenabled = "always"
    tasksetdata.overrides.ghostsanitydrain = "always"
    tasksetdata.overrides.basicresource_regrowth = "always"
    tasksetdata.overrides.spawnmode = "fixed"
    tasksetdata.overrides.resettime = "default"
    
    return tasksetdata
end
table.insert(_G.TUNING.TELEPORTATOMOD.WORLDS, {name="King of Winter", taskdatafunctions={forest=AdventureKingWinter, cave=AlwaysTinyCave}, defaultpositions={2,3,4,5}, positions=GetModConfigData("kingofwinter")})


local function AdventureGameAfoot(tasksetdata)
    tasksetdata.numoptionaltasks = 4
    tasksetdata.tasks = {-- Enemies: Lots of hound mounds and maxwell traps everywhere. Frequent hound invasions.
        "Resource-Rich","Lots-o-Spiders","Lots-o-Tentacles","Lots-o-Tallbirds","Lots-o-Chessmonsters",}
    tasksetdata.optionaltasks = {"The hunters","Trapped Forest hunters","Wasps and Frogs and bugs","Tentacle-Blocked The Deep Forest","Hounded Greater Plains","Merms ahoy",}
    tasksetdata.set_pieces = {                
            ["SimpleBase"] = { tasks={"Lots-o-Spiders", "Lots-o-Tentacles", "Lots-o-Tallbirds", "Lots-o-Chessmonsters"}},
            -- ["WesUnlock"] = { restrict_to="background", tasks={ "The hunters", "Trapped Forest hunters", "Wasps and Frogs and bugs", "Tentacle-Blocked The Deep Forest", "Hounded Greater Plains", "Merms ahoy" }},
            ["ResurrectionStone"] = { count=1, tasks={"Resource-Rich","Lots-o-Spiders","Lots-o-Tentacles","Lots-o-Tallbirds","Lots-o-Chessmonsters", "The hunters","Trapped Forest hunters",
                                                    "Wasps and Frogs and bugs","Tentacle-Blocked The Deep Forest","Hounded Greater Plains","Merms ahoy"} },
        }
    tasksetdata.required_setpieces = {}
    tasksetdata.numrandom_set_pieces = 0
    if not tasksetdata.ordered_story_setpieces then -- only use this for this mod, so for original DS adventure worlds!
        tasksetdata.ordered_story_setpieces = {}
    end
    for _,set in pairs(_G.TUNING.TELEPORTATOMOD.teleportato_layouts["forest"]) do
        table.insert(tasksetdata.ordered_story_setpieces,set)
    end
    tasksetdata.random_set_pieces = {}
    tasksetdata.ocean_prefill_setpieces = {} -- delete any ocean stuff
    tasksetdata.ocean_population = {} -- delete any ocean stuff
    tasksetdata.add_teleportato = true -- add teleportato within teleportato mod. ypu can set up _G.TUNING.TELEPORTATOMOD.teleportato_layouts to change the setpieces of them
    tasksetdata.required_prefabs = _G.ArrayUnion(required_prefabs,{"teleportato_base","teleportato_box","teleportato_crank","teleportato_ring","teleportato_potato"}) -- if ordered_story_setpieces is nil/empty, required_prefabs is set up in teleoprtato mod depending in settings there
    if _G.TUNING.ADV_DIFFICULTY==0 then
        tasksetdata.substitutes = GetRandomSubstituteList(SUBS_1, 3)
    end
    if tasksetdata.overrides==nil then
        tasksetdata.overrides = {}
    end
    tasksetdata.overrides.day = GetModConfigData("daythegameisafoot") or "longdusk" 

    tasksetdata.overrides.season_start = GetModConfigData("startseasonthegameisafoot") or "winter"

    if forest_map.TRANSLATE_TO_CLUMP~=nil then
        tasksetdata.overrides.ADV_clump_spiders = "ADV_allmap_often"
    else
        tasksetdata.overrides.spiders = "often"
    end
    
    tasksetdata.overrides.world_size = GetModConfigData("worldsizethegameisafoot") or "medium"
    tasksetdata.overrides.branching = "default"
    tasksetdata.overrides.loop = "never"
    
    tasksetdata.overrides.deerclops  =  (_G.TUNING.ADV_DIFFICULTY==0 and "default") or (_G.TUNING.ADV_DIFFICULTY==1 and "rare") or (_G.TUNING.ADV_DIFFICULTY==2 and "default") or (_G.TUNING.ADV_DIFFICULTY==3 and "often") or "default"
    tasksetdata.overrides.dragonfly  =  "never"
    tasksetdata.overrides.bearger  =  "never"
    tasksetdata.overrides.goosemoose  =  (_G.TUNING.ADV_DIFFICULTY==0 and "never") or (_G.TUNING.ADV_DIFFICULTY==1 and "rare") or (_G.TUNING.ADV_DIFFICULTY==2 and "default") or (_G.TUNING.ADV_DIFFICULTY==3 and "often") or "never"
    tasksetdata.overrides.antliontribute = "never"
    tasksetdata.overrides.wormhole_prefab = "wormhole"
    tasksetdata.overrides.layout_mode = "LinkNodesByKeys"
    tasksetdata.overrides.start_location = "adv3"
    tasksetdata.overrides.autumn = GetModConfigData("autumnthegameisafoot") or ((_G.TUNING.ADV_DIFFICULTY==1 and "veryshortseason") or "noseason")
    tasksetdata.overrides.winter = GetModConfigData("winterthegameisafoot") or "noseason"
    tasksetdata.overrides.spring = GetModConfigData("springthegameisafoot") or "verylongseason"
    tasksetdata.overrides.summer = GetModConfigData("summerthegameisafoot") or "noseason"
    tasksetdata.overrides.keep_disconnected_tiles = true
    tasksetdata.overrides.no_joining_islands = true
    
    -- ALWAYS with ocean! because wormhole placement can fail. Instead we will make thinkthank unavailable when setting is set to only wormholes and placement suceeded
    tasksetdata.overrides["has_ocean"] = true
    
    -- game mode settings
    tasksetdata.overrides.portalresurection = _G.TUNING.ADV_DIFFICULTY==1 and "always" or "none"
    tasksetdata.overrides.ghostenabled = "always"
    tasksetdata.overrides.ghostsanitydrain = "always"
    tasksetdata.overrides.basicresource_regrowth = "always"
    tasksetdata.overrides.spawnmode = "fixed"
    tasksetdata.overrides.resettime = "default"
    
    return tasksetdata
end
table.insert(_G.TUNING.TELEPORTATOMOD.WORLDS, {name="The Game is Afoot", taskdatafunctions={forest=AdventureGameAfoot, cave=AlwaysTinyCave}, defaultpositions={2,3,4,5}, positions=GetModConfigData("thegameisafoot")})


local function AdventureArchipelago(tasksetdata)
    tasksetdata.numoptionaltasks = 0
    tasksetdata.tasks = {"IslandHop_Start","IslandHop_Hounds","IslandHop_Forest","IslandHop_Savanna","IslandHop_Rocky","IslandHop_Merm",}
    -- tasksetdata.tasks = {"IslandHop_Start wormhole","IslandHop_Hounds wormhole","IslandHop_Forest wormhole","IslandHop_Savanna wormhole","IslandHop_Rocky wormhole","IslandHop_Merm wormhole",}
    tasksetdata.optionaltasks = {}
    tasksetdata.set_pieces = {                
            -- ["WesUnlock"] = { restrict_to="background", tasks={ "IslandHop_Start", "IslandHop_Hounds", "IslandHop_Forest", "IslandHop_Savanna", "IslandHop_Rocky", "IslandHop_Merm" } },
               -- INFO: wormholes alternative code in tasksroomslayouts.lua as room_choices. This should be more secure than adding it as setpiece
               ["Wormhole_Mod"] = { count= 12, tasks={ "IslandHop_Start", "IslandHop_Hounds", "IslandHop_Forest", "IslandHop_Savanna", "IslandHop_Rocky", "IslandHop_Merm" } }, -- adds the setpiece at max once per task, set count to 12, to make sure always all 6 are spawned.., but it still may be less
               ["Wormhole_Mod2"] = { count= 12, tasks={ "IslandHop_Start", "IslandHop_Hounds", "IslandHop_Forest", "IslandHop_Savanna", "IslandHop_Rocky", "IslandHop_Merm" } }, -- adds the setpiece at max once per task
               ["Wormhole_Mod3"] = { count= 12, tasks={ "IslandHop_Start", "IslandHop_Hounds", "IslandHop_Forest", "IslandHop_Savanna", "IslandHop_Rocky", "IslandHop_Merm" } }, -- adds the setpiece at max once per task
        }
    tasksetdata.required_setpieces = {}
    tasksetdata.numrandom_set_pieces = 0
    if not tasksetdata.ordered_story_setpieces then -- only use this for this mod, so for original DS adventure worlds!
        tasksetdata.ordered_story_setpieces = {}
    end
    for _,set in pairs(_G.TUNING.TELEPORTATOMOD.teleportato_layouts["forest"]) do
        table.insert(tasksetdata.ordered_story_setpieces,set)
    end
    tasksetdata.random_set_pieces = {}
    tasksetdata.ocean_prefill_setpieces = {} -- delete any ocean stuff
    tasksetdata.ocean_population = {} -- delete any ocean stuff
    tasksetdata.add_teleportato = true -- add teleportato within teleportato mod. ypu can set up _G.TUNING.TELEPORTATOMOD.teleportato_layouts to change the setpieces of them
    tasksetdata.required_prefabs = _G.ArrayUnion(required_prefabs,{"teleportato_base","teleportato_box","teleportato_crank","teleportato_ring","teleportato_potato"}) -- if ordered_story_setpieces is nil/empty, required_prefabs is set up in teleoprtato mod depending in settings there
    if _G.TUNING.ADV_DIFFICULTY==0 then
        tasksetdata.substitutes = GetRandomSubstituteList(SUBS_1, 3)
    end
    if tasksetdata.overrides==nil then
        tasksetdata.overrides = {}
    end
    tasksetdata.overrides.world_size = GetModConfigData("worldsizearchipelago") or "medium"
    tasksetdata.overrides.day  =  GetModConfigData("dayarchipelago") or "default"
    tasksetdata.overrides.roads = "never"
    tasksetdata.overrides.weather = (_G.TUNING.ADV_DIFFICULTY==0 and "default") or (_G.TUNING.ADV_DIFFICULTY==1 and "rare") or (_G.TUNING.ADV_DIFFICULTY==2 and "default") or (_G.TUNING.ADV_DIFFICULTY==3 and "often") or "default"
    tasksetdata.overrides.deerclops = (_G.TUNING.ADV_DIFFICULTY==0 and "default") or (_G.TUNING.ADV_DIFFICULTY==1 and "rare") or (_G.TUNING.ADV_DIFFICULTY==2 and "default") or (_G.TUNING.ADV_DIFFICULTY==3 and "often") or "default"
    tasksetdata.overrides.dragonfly  =  "never"
    tasksetdata.overrides.bearger  =  (_G.TUNING.ADV_DIFFICULTY==0 and "never") or (_G.TUNING.ADV_DIFFICULTY==1 and "never") or (_G.TUNING.ADV_DIFFICULTY==2 and "rare") or (_G.TUNING.ADV_DIFFICULTY==3 and "default") or "never"
    tasksetdata.overrides.goosemoose  =  (_G.TUNING.ADV_DIFFICULTY==0 and "never") or (_G.TUNING.ADV_DIFFICULTY==1 and "never") or (_G.TUNING.ADV_DIFFICULTY==2 and "rare") or (_G.TUNING.ADV_DIFFICULTY==3 and "default") or "never"
    tasksetdata.overrides.antliontribute = "never"
    tasksetdata.overrides.hounds = (_G.TUNING.ADV_DIFFICULTY==0 and "default") or (_G.TUNING.ADV_DIFFICULTY==1 and "default") or (_G.TUNING.ADV_DIFFICULTY==2 and "often") or (_G.TUNING.ADV_DIFFICULTY==3 and "always") or "default"
    tasksetdata.overrides.season_start = GetModConfigData("startseasonarchipelago") or "default"
    tasksetdata.overrides.wormhole_prefab = "wormhole"
    tasksetdata.overrides.layout_mode = "LinkNodesByKeys"
    tasksetdata.overrides.start_location = "adv4"
    tasksetdata.overrides.autumn = GetModConfigData("autumnarchipelago") or "shortseason"
    tasksetdata.overrides.winter = GetModConfigData("winterarchipelago") or "shortseason"
    tasksetdata.overrides.spring = GetModConfigData("springarchipelago") or (_G.TUNING.ADV_DIFFICULTY==0 and "noseason") or "shortseason"
    tasksetdata.overrides.summer = GetModConfigData("summerarchipelago") or (_G.TUNING.ADV_DIFFICULTY==0 and "noseason") or "shortseason"
    tasksetdata.overrides.keep_disconnected_tiles = true
    tasksetdata.overrides.no_wormholes_to_disconnected_tiles = false
    tasksetdata.overrides.no_joining_islands = true
    
    -- ALWAYS with ocean! because wormhole placement can fail. Instead we will make thinkthank unavailable when setting is set to only wormholes and placement suceeded
    tasksetdata.overrides["has_ocean"] = true

    -- game mode settings
    tasksetdata.overrides.portalresurection = _G.TUNING.ADV_DIFFICULTY==1 and "always" or "none"
    tasksetdata.overrides.ghostenabled = "always"
    tasksetdata.overrides.ghostsanitydrain = "always"
    tasksetdata.overrides.basicresource_regrowth = "always"
    tasksetdata.overrides.spawnmode = "fixed"
    tasksetdata.overrides.resettime = "default"

    return tasksetdata
end
table.insert(_G.TUNING.TELEPORTATOMOD.WORLDS, {name="Archipelago", taskdatafunctions={forest=AdventureArchipelago, cave=AlwaysTinyCave}, defaultpositions={2,3,4,5}, positions=GetModConfigData("archipelago")})


local function AdventureTwoWorlds(tasksetdata)
    -- tasksetdata.override_level_string=true -- test out what this does ?
    tasksetdata.tasks = {"Land of Plenty", -- Part 1 - Easy peasy - lots of stuff
                        "The other side",}  -- Part 2 - Lets kill them off
    tasksetdata.required_setpieces = {}
    tasksetdata.numoptionaltasks = 0
    tasksetdata.optionaltasks = {}
    tasksetdata.set_pieces = {                
            ["MaxPigShrine"] = {tasks={"Land of Plenty"}},
            ["MaxMermShrine"] = {tasks={"The other side"}},
            ["ResurrectionStone"] = { count=2, tasks={"Land of Plenty", "The other side" } },
            -- INFO: wormholes alternative code in tasksroomslayouts.lua as room_choices. This should be more secure than adding it as setpiece
            ["Wormhole_Mod"] = { count= 4, tasks={ "Land of Plenty", "The other side" } }, -- adds the setpiece at max once per task
            ["Wormhole_Mod2"] = { count= 4, tasks={ "Land of Plenty", "The other side" } }, -- adds the setpiece at max once per task
            }
    tasksetdata.numrandom_set_pieces = 0
    if not tasksetdata.ordered_story_setpieces then -- only use this for this mod, so for original DS adventure worlds!
        tasksetdata.ordered_story_setpieces = {}
    end
    for _,set in pairs(_G.TUNING.TELEPORTATOMOD.teleportato_layouts["forest"]) do
        table.insert(tasksetdata.ordered_story_setpieces,set)
    end
    tasksetdata.random_set_pieces = {}
    tasksetdata.ocean_prefill_setpieces = {} -- delete any ocean stuff
    tasksetdata.ocean_population = {} -- delete any ocean stuff
    tasksetdata.add_teleportato = true -- add teleportato within teleportato mod. ypu can set up _G.TUNING.TELEPORTATOMOD.teleportato_layouts to change the setpieces of them
    tasksetdata.required_prefabs = _G.ArrayUnion(required_prefabs,{"teleportato_base","teleportato_box","teleportato_crank","teleportato_ring","teleportato_potato"}) -- if ordered_story_setpieces is nil/empty, required_prefabs is set up in teleoprtato mod depending in settings there -- _G.ArrayUnion(required_prefabs,{"pigking"})
    if _G.TUNING.ADV_DIFFICULTY==0 then
        tasksetdata.substitutes = GetRandomSubstituteList(SUBS_1, 3)
    end
    if tasksetdata.overrides==nil then
        tasksetdata.overrides = {}
    end
    tasksetdata.overrides.day  =  GetModConfigData("daytwoworlds") or ((_G.TUNING.ADV_DIFFICULTY==0 and "default") or (_G.TUNING.ADV_DIFFICULTY==1 and "longday") or (_G.TUNING.ADV_DIFFICULTY==2 and "default") or (_G.TUNING.ADV_DIFFICULTY==3 and "longdusk") or "default") 
    tasksetdata.overrides.season_start  =  GetModConfigData("startseasontwoworlds") or "default"
    
    tasksetdata.overrides.weather = (_G.TUNING.ADV_DIFFICULTY==0 and "rare") or (_G.TUNING.ADV_DIFFICULTY==1 and "rare") or (_G.TUNING.ADV_DIFFICULTY==2 and "default") or (_G.TUNING.ADV_DIFFICULTY==3 and "often") or "rare" 
    
    tasksetdata.overrides.roads  =  "never"
    tasksetdata.overrides.dragonfly  =  "never"
    tasksetdata.overrides.bearger  =  (_G.TUNING.ADV_DIFFICULTY==0 and "never") or (_G.TUNING.ADV_DIFFICULTY==1 and "never") or (_G.TUNING.ADV_DIFFICULTY==2 and "rare") or (_G.TUNING.ADV_DIFFICULTY==3 and "default") or "never"
    tasksetdata.overrides.goosemoose  =  "never"
    tasksetdata.overrides.antliontribute = "never"
    tasksetdata.overrides.world_size = GetModConfigData("worldsizetwoworlds") or "medium"
    tasksetdata.overrides.wormhole_prefab = "wormhole"
    tasksetdata.overrides.layout_mode = "LinkNodesByKeys"
    tasksetdata.overrides.start_location = "adv5"
    tasksetdata.overrides.autumn = GetModConfigData("autumntwoworlds") or ((_G.TUNING.ADV_DIFFICULTY==1 and "veryshortseason") or (_G.TUNING.ADV_DIFFICULTY==0 and "verylongseason") or "noseason")
    tasksetdata.overrides.winter = GetModConfigData("wintertwoworlds") or "noseason"
    tasksetdata.overrides.spring = GetModConfigData("springtwoworlds") or "noseason"
    tasksetdata.overrides.summer = GetModConfigData("summertwoworlds") or (_G.TUNING.ADV_DIFFICULTY==0 and "noseason") or "verylongseason"
    tasksetdata.overrides.keep_disconnected_tiles = true
    tasksetdata.overrides.no_wormholes_to_disconnected_tiles = false
    tasksetdata.overrides.no_joining_islands = true
    
    -- ALWAYS with ocean! because wormhole placement can fail. Instead we will make thinkthank unavailable when setting is set to only wormholes and placement suceeded
    tasksetdata.overrides["has_ocean"] = true

    -- game mode settings
    tasksetdata.overrides.portalresurection = _G.TUNING.ADV_DIFFICULTY==1 and "always" or "none"
    tasksetdata.overrides.ghostenabled = "always"
    tasksetdata.overrides.ghostsanitydrain = "always"
    tasksetdata.overrides.basicresource_regrowth = "always"
    tasksetdata.overrides.spawnmode = "fixed"
    tasksetdata.overrides.resettime = "default"

    return tasksetdata
end
table.insert(_G.TUNING.TELEPORTATOMOD.WORLDS, {name="Two Worlds", taskdatafunctions={forest=AdventureTwoWorlds, cave=AlwaysTinyCave}, defaultpositions={4,5}, positions=GetModConfigData("twoworlds")})


local function AdventureDarkness(tasksetdata)
    tasksetdata.tasks = {"Swamp start","Battlefield","Walled Kill the spiders","advSanity-Blocked Spider Queendom",}
    tasksetdata.numoptionaltasks = 2
    tasksetdata.optionaltasks = {"Killer bees!","Chessworld","Tentacle-Blocked The Deep Forest","advTentacle-Blocked Spider Swamp",
        "Trapped Forest hunters","Waspy The hunters","Hounded Magic meadow",}
    tasksetdata.set_pieces = {
            ["RuinedBase"] = {tasks={"Swamp start", "Battlefield", "Walled Kill the spiders", "Killer bees!"}},
            ["ResurrectionStoneLit"] = { count=4, tasks={"Swamp start", "Battlefield", "Walled Kill the spiders", "advSanity-Blocked Spider Queendom","Killer bees!",
            "Chessworld","Tentacle-Blocked The Deep Forest", "advTentacle-Blocked Spider Swamp","Trapped Forest hunters","Waspy The hunters","Hounded Magic meadow", }},}
    if _G.TUNING.ADV_DIFFICULTY==0 then
        tasksetdata.substitutes = _G.MergeMaps( {["pighouse"] = {perstory=1,weight=1,pertask=1}}, -- pighouses replaced by pigs (see resource_sub... gamefile)
                                 GetRandomSubstituteList(SUBS_1, 3) )
    else
        tasksetdata.substitutes = {["pighouse"] = {perstory=1,weight=1,pertask=1}}
    end
    tasksetdata.required_setpieces = {}
    tasksetdata.numrandom_set_pieces = 0
    if not tasksetdata.ordered_story_setpieces then -- only use this for this mod, so for original DS adventure worlds!
        tasksetdata.ordered_story_setpieces = {}
    end
    for _,set in pairs(_G.TUNING.TELEPORTATOMOD.teleportato_layouts["forest"]) do
        table.insert(tasksetdata.ordered_story_setpieces,set)
    end
    tasksetdata.random_set_pieces = {}
    tasksetdata.ocean_prefill_setpieces = {} -- delete any ocean stuff
    tasksetdata.ocean_population = {} -- delete any ocean stuff
    tasksetdata.add_teleportato = true -- add teleportato within teleportato mod. ypu can set up _G.TUNING.TELEPORTATOMOD.teleportato_layouts to change the setpieces of them
    tasksetdata.required_prefabs = _G.ArrayUnion(required_prefabs,{"teleportato_base","teleportato_box","teleportato_crank","teleportato_ring","teleportato_potato"}) -- if ordered_story_setpieces is nil/empty, required_prefabs is set up in teleoprtato mod depending in settings there
    if tasksetdata.overrides==nil then
        tasksetdata.overrides = {}
    end
    tasksetdata.overrides.branching = "never"
    tasksetdata.overrides.day = GetModConfigData("daydarkness") or "onlynight"
    tasksetdata.overrides.season_start = GetModConfigData("startseasondarkness") or "autumn"
    tasksetdata.overrides.weather = "often"

    tasksetdata.overrides.boons = "always"
    
    tasksetdata.overrides.roads = "never"
    tasksetdata.overrides.berrybush = "never"
    
    if forest_map.TRANSLATE_TO_CLUMP~=nil then
        tasksetdata.overrides.ADV_clump_spiders = "ADV_allmap_often"
        tasksetdata.overrides.ADV_clump_fireflies = (_G.TUNING.ADV_DIFFICULTY==3 and "ADV_allmap_often") or "ADV_allmap_always"
        tasksetdata.overrides.ADV_clump_bunnymen = (_G.TUNING.ADV_DIFFICULTY==0 and "ADV_allmap_never") or (_G.TUNING.ADV_DIFFICULTY==1 and "mostly") or "ADV_allmap_often"
        tasksetdata.overrides.ADV_clump_flower_cave = (_G.TUNING.ADV_DIFFICULTY==0 and "ADV_allmap_never") or (_G.TUNING.ADV_DIFFICULTY==1 and "ADV_allmap_always") or (_G.TUNING.ADV_DIFFICULTY==2 and "ADV_allmap_mostly") or (_G.TUNING.ADV_DIFFICULTY==3 and "ADV_allmap_often") or "ADV_allmap_never"
        tasksetdata.overrides.ADV_clump_maxwelllight_area = (_G.TUNING.ADV_DIFFICULTY==0 and "ADV_allmap_always") or (_G.TUNING.ADV_DIFFICULTY==1 and "ADV_allmap_always") or (_G.TUNING.ADV_DIFFICULTY==2 and "ADV_allmap_mostly") or (_G.TUNING.ADV_DIFFICULTY==3 and "ADV_allmap_often") or "ADV_allmap_always" 
        tasksetdata.overrides.ADV_clump_pigtorch = (_G.TUNING.ADV_DIFFICULTY==0 and "ADV_allmap_never") or "ADV_allmap_often"
    else
        tasksetdata.overrides.spiders = "often"
        tasksetdata.overrides.fireflies = (_G.TUNING.ADV_DIFFICULTY==3 and "often") or "always"
        tasksetdata.overrides.bunnymen = (_G.TUNING.ADV_DIFFICULTY==0 and "never") or (_G.TUNING.ADV_DIFFICULTY==1 and "default") or (_G.TUNING.ADV_DIFFICULTY==2 and "rare") or (_G.TUNING.ADV_DIFFICULTY==3 and "rare") or "never"
        tasksetdata.overrides.flower_cave = (_G.TUNING.ADV_DIFFICULTY==0 and "never") or (_G.TUNING.ADV_DIFFICULTY==1 and "always") or (_G.TUNING.ADV_DIFFICULTY==2 and "often") or (_G.TUNING.ADV_DIFFICULTY==3 and "rare") or "never"
        tasksetdata.overrides.maxwelllight_area = (_G.TUNING.ADV_DIFFICULTY==0 and "always") or (_G.TUNING.ADV_DIFFICULTY==1 and "always") or (_G.TUNING.ADV_DIFFICULTY==2 and "often") or (_G.TUNING.ADV_DIFFICULTY==3 and "rare") or "always" 
        tasksetdata.overrides.pigtorch = (_G.TUNING.ADV_DIFFICULTY==0 and "never") or (_G.TUNING.ADV_DIFFICULTY==1 and "often") or (_G.TUNING.ADV_DIFFICULTY==2 and "default") or (_G.TUNING.ADV_DIFFICULTY==3 and "rare") or "never" 
    end

    tasksetdata.overrides.dragonfly  =  "never"
    tasksetdata.overrides.bearger  =  (_G.TUNING.ADV_DIFFICULTY==0 and "never") or (_G.TUNING.ADV_DIFFICULTY==1 and "never") or (_G.TUNING.ADV_DIFFICULTY==2 and "rare") or (_G.TUNING.ADV_DIFFICULTY==3 and "default") or "never"
    tasksetdata.overrides.goosemoose  =  "never"
    tasksetdata.overrides.antliontribute = "never"
    tasksetdata.overrides.world_size = GetModConfigData("worldsizedarkness") or "medium"
    tasksetdata.overrides.wormhole_prefab = "wormhole"
    tasksetdata.overrides.layout_mode = "LinkNodesByKeys"
    tasksetdata.overrides.start_location = "adv6"
    tasksetdata.overrides.autumn = GetModConfigData("autumndarkness") or ((_G.TUNING.ADV_DIFFICULTY==0 and "verylongseason") or (_G.TUNING.ADV_DIFFICULTY==1 and "shortseason") or (_G.TUNING.ADV_DIFFICULTY==2 and "veryshortseason") or (_G.TUNING.ADV_DIFFICULTY==3 and "noseason") or "noseason")
    tasksetdata.overrides.winter = GetModConfigData("winterdarkness") or "noseason"
    tasksetdata.overrides.spring = GetModConfigData("springdarkness") or "noseason"
    tasksetdata.overrides.summer = GetModConfigData("summerdarkness") or ((_G.TUNING.ADV_DIFFICULTY==0 and "noseason") or (_G.TUNING.ADV_DIFFICULTY==1 and "shortseason") or (_G.TUNING.ADV_DIFFICULTY==2 and "default") or (_G.TUNING.ADV_DIFFICULTY==3 and "verylongseason") or "verylongseason")
    tasksetdata.overrides.keep_disconnected_tiles = true
    tasksetdata.overrides.no_wormholes_to_disconnected_tiles = true
    tasksetdata.overrides.no_joining_islands = true
    
    -- ALWAYS with ocean! because wormhole placement can fail. Instead we will make thinkthank unavailable when setting is set to only wormholes and placement suceeded
    tasksetdata.overrides["has_ocean"] = true
    
    -- game mode settings
    tasksetdata.overrides.portalresurection = _G.TUNING.ADV_DIFFICULTY==1 and "always" or "none"
    tasksetdata.overrides.ghostenabled = "always"
    tasksetdata.overrides.ghostsanitydrain = "always"
    tasksetdata.overrides.basicresource_regrowth = "always"
    tasksetdata.overrides.spawnmode = "fixed"
    tasksetdata.overrides.resettime = "default"
    
    return tasksetdata
end
table.insert(_G.TUNING.TELEPORTATOMOD.WORLDS, {name="Darkness", taskdatafunctions={forest=AdventureDarkness, cave=AlwaysTinyCave}, defaultpositions={6}, positions=GetModConfigData("darkness")})

local function AdventureMaxwellHome(tasksetdata)
    -- tasksetdata.nomaxwell=true
    tasksetdata.hideminimap = true
    -- tasksetdata.teleportaction = "restart"
    -- tasksetdata.teleportmaxwell = "ADVENTURE_6_TELEPORTFAIL"
    tasksetdata.tasks = {"MaxHome"}
    tasksetdata.required_setpieces = {}
    tasksetdata.numoptionaltasks = 0
    tasksetdata.optionaltasks = {}
    tasksetdata.set_pieces = {} -- vermutlich keine
    tasksetdata.numrandom_set_pieces = 0
    tasksetdata.random_set_pieces = {}
    tasksetdata.required_prefabs = {}
    tasksetdata.ocean_prefill_setpieces = {} -- delete any ocean stuff
    tasksetdata.ocean_population = {} -- delete any ocean stuff
    if tasksetdata.overrides==nil then
        tasksetdata.overrides = {}
    end
    tasksetdata.overrides.start_location = "adv7"  --- wenn wir keine startlocation zufügen, wird default verwendet, welches default setpiece und clearing verwendet, welches ein multiplayer portal beinhaltet.
    tasksetdata.overrides.wormhole_prefab = "wormhole"
    tasksetdata.overrides.layout_mode = "LinkNodesByKeys"  
    tasksetdata.overrides.day  =  "onlynight" 
    tasksetdata.overrides.weather  =  "never"
    tasksetdata.overrides.creepyeyes  =  "always"
    tasksetdata.overrides.roads  =  "never"
    tasksetdata.overrides.boons  =  "never"
    tasksetdata.overrides.deerclops = "never"
    tasksetdata.overrides.dragonfly  =  "never"
    tasksetdata.overrides.bearger  =  "never"
    tasksetdata.overrides.goosemoose  =  "never"
    tasksetdata.overrides.antliontribute = "never"
    tasksetdata.overrides.hounds  =  "never"
    tasksetdata.overrides.world_size = "medium"
    tasksetdata.overrides.autumn = "verylongseason"
    tasksetdata.overrides.winter = "noseason"
    tasksetdata.overrides.spring = "noseason"
    tasksetdata.overrides.summer = "noseason"
    tasksetdata.overrides.keep_disconnected_tiles = true
    tasksetdata.overrides.no_wormholes_to_disconnected_tiles = true
    tasksetdata.overrides.no_joining_islands = true
    -- ALWAYS with ocean! because wormhole placement can fail. Instead we will make thinkthank unavailable when setting is set to only wormholes and placement suceeded
    tasksetdata.overrides["has_ocean"] = true
    
    -- game mode settings
    tasksetdata.overrides.portalresurection = _G.TUNING.ADV_DIFFICULTY==1 and "always" or "none"
    tasksetdata.overrides.ghostenabled = "always"
    tasksetdata.overrides.ghostsanitydrain = "always"
    tasksetdata.overrides.basicresource_regrowth = "always"
    tasksetdata.overrides.spawnmode = "fixed"
    tasksetdata.overrides.resettime = "default"
    
    return tasksetdata
end
table.insert(_G.TUNING.TELEPORTATOMOD.WORLDS, {name="Checkmate", taskdatafunctions={forest=AdventureMaxwellHome, cave=AlwaysTinyCave}, defaultpositions={7}, positions=GetModConfigData("checkmate")})

