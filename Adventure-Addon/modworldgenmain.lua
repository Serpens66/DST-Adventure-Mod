
local _G = GLOBAL
print("HIER WORLDGEN adv")

GLOBAL.package.loaded["librarymanager"] = nil -- use this libary to force enabling the teleportato mod.
local AutoSubscribeAndEnableWorkshopMods = GLOBAL.require("librarymanager")
AutoSubscribeAndEnableWorkshopMods({"workshop-756229217"}) -- workshop-756229217

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

modimport("scripts/tasksroomslayouts") -- load some custom map stuff

if GetModConfigData("difficulty")==0 then
    adventureportal = "AdventurePortalLayout"
else
    adventureportal = "AdventurePortalLayoutNew" --  has some clockworks, skeletons and a maxwelllight
end
local adventure1_setpieces_tasks = {"Easy Blocked Dig that rock","Great Plains","Guarded Speak to the king","Waspy Beeeees!","Guarded Squeltch","Guarded Forest hunters","Befriend the pigs","Guarded For a nice walk","Walled Kill the spiders","Killer bees!","Make a Beehat","Waspy The hunters","Hounded Magic meadow","Wasps and Frogs and bugs","Guarded Walrus Desolate"}
local required_prefabs = {"chester_eyebone", "spawnpoint_master",}


if not _G.TUNING.TELEPORTATOMOD then
    _G.TUNING.TELEPORTATOMOD = {}
end
if not _G.TUNING.TELEPORTATOMOD.WORLDS then
    _G.TUNING.TELEPORTATOMOD.WORLDS = {}
end
local WORLDS = _G.TUNING.TELEPORTATOMOD.WORLDS

-- we can use GLOBAL.LEVEL and _G.TUNING.TELEPORTATOMOD.CHAPTER as soon as the game started
-- so do not use it directly in AddPrefabPostInit, but make DoTaskInTime with at least 0.1 within


-- testing
-- _G.TUNING.TELEPORTATOMOD.LEVEL_GEN = 7 -- force loading this level, starts at 1 anjd goes up to unlimited (max 63 due to netvars)
-- _G.TUNING.TELEPORTATOMOD.CHAPTER_GEN = 6 -- force loading this chapter, starts at 1 and goes up to 7
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
    if GetModConfigData("difficulty")==0 then
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
    if GetModConfigData("difficulty")==0 then
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
            tasksetdata.set_pieces = {}
            tasksetdata.valid_start_tasks = {"CaveExitTask1"}
            tasksetdata.overrides={
                world_size  =  "small",
                wormhole_prefab = "wormhole",
                layout_mode = "LinkNodesByKeys",
                }
    return tasksetdata
end
-- Explanation of the WORLD table:
-- name -> shown in title
-- taskdatafunctions -> this function is called in AddTaskSetPreInitAny in modwordgenmain of the base mod to set the taskdata of the world, so your mod is loaded.
-- location -> forest or cave
-- positions -> only 5 maps per game. maps chosen randomly or disallow certain positions. eg. {2,3} your world may only load at second or third world. {1,2,3,4,5} your world may load regardless on which position.
-- the LEVEL is determined by the order you add them to the _G.TUNING.TELEPORTATOMOD.WORLDS list

local function AdventurePortalWorld(tasksetdata)
    
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
        tasksetdata.overrides={
            world_size  =  "small",
            wormhole_prefab = "wormhole",
            layout_mode = "LinkNodesByKeys",
            deerclops  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
            dragonfly  =  "never",
            bearger  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
            goosemoose  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
            antlion = "never",
            season_start  =  "autumn",
            autumn = "veryshortseason",
            winter = "veryshortseason",
            spring = "veryshortseason",
            summer = "veryshortseason",
            keep_disconnected_tiles = true,
            no_joining_islands = true,
        }
        if (GetModConfigData("withocean")=="ocean" or GetModConfigData("withocean")=="oceanwormholes") then
            tasksetdata.overrides["has_ocean"] = true
        end
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
else -- othjerwise, no tiny cave
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
    tasksetdata.add_teleportato = true -- add teleportato within teleportato mod. ypu can set up _G.TUNING.TELEPORTATOMOD.teleportato_layouts to change the setpieces of them
    tasksetdata.required_prefabs = _G.ArrayUnion(required_prefabs,{"teleportato_base","teleportato_box","teleportato_crank","teleportato_ring","teleportato_potato"}) -- if ordered_story_setpieces is nil/empty, required_prefabs is set up in teleoprtato mod depending in settings there
    if GetModConfigData("difficulty")==0 then
        tasksetdata.substitutes = GetRandomSubstituteList(SUBS_1, 3)
    end
    tasksetdata.overrides={
        world_size  =  "medium",
        day  =  "longdusk", 
        weather  =  "often",
        frograin   =  "often",
        
        season_start  =  "spring",
        
        deerclops  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
        dragonfly  =  "never",
        bearger  =  "never",
        goosemoose  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
        antlion = "never",
        hounds  =  "never",
        mactusk  =  "always",
        leifs  =  "always",
        
        trees  =  "often",
        carrot  =  "default",
        berrybush  =  "never",
        
        wormhole_prefab = "wormhole",
        layout_mode = "LinkNodesByKeys",
        start_location = "adv1",
        autumn = "noseason",
        winter = "veryshortseason",
        spring = "shortseason",
        summer = "noseason",
        keep_disconnected_tiles = true,
        no_joining_islands = true,
    }
    if (GetModConfigData("withocean")=="ocean" or GetModConfigData("withocean")=="oceanwormholes") then
        tasksetdata.overrides["has_ocean"] = true
    end
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
    tasksetdata.add_teleportato = true -- add teleportato within teleportato mod. ypu can set up _G.TUNING.TELEPORTATOMOD.teleportato_layouts to change the setpieces of them
    tasksetdata.required_prefabs = _G.ArrayUnion(required_prefabs,{"teleportato_base","teleportato_box","teleportato_crank","teleportato_ring","teleportato_potato"}) -- if ordered_story_setpieces is nil/empty, required_prefabs is set up in teleoprtato mod depending in settings there
    if GetModConfigData("difficulty")==0 then
        tasksetdata.substitutes = GetRandomSubstituteList(SUBS_1, 3)
    end
    tasksetdata.overrides={
        world_size = "medium",
        wormhole_prefab = "wormhole",
        layout_mode = "LinkNodesByKeys",
        day  =  "longdusk", 

        start_location = "adv2",

        loop  =  "never",
        branching  =  "least",
        
        season_start  =  "winter",
        weather  =  (GetModConfigData("difficulty")==0 and "often") or (GetModConfigData("difficulty")==1 and "often") or (GetModConfigData("difficulty")==2 and "always") or (GetModConfigData("difficulty")==3 and "always") or "often",      
        
        deerclops  =  (GetModConfigData("difficulty")==0 and "often") or (GetModConfigData("difficulty")==1 and "default") or (GetModConfigData("difficulty")==2 and "often") or (GetModConfigData("difficulty")==3 and "always") or "often",
        dragonfly  =  "never",
        bearger  =  "never",
        goosemoose  =  "never",
        antlion = "never",
        hounds  =  "never",
        mactusk  =  "always",
        
        carrot = (GetModConfigData("difficulty")==0 and "rare") or (GetModConfigData("difficulty")==1 and "default") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "never") or "rare",          
        berrybush  =  (GetModConfigData("difficulty")==0 and "rare") or (GetModConfigData("difficulty")==1 and "default") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "never") or "rare",
        
        autumn = "noseason",
        winter = "verylongseason",
        spring = "noseason",
        summer = "noseason",
        keep_disconnected_tiles = true,
        no_joining_islands = true,
    }
    if (GetModConfigData("withocean")=="ocean" or GetModConfigData("withocean")=="oceanwormholes") then
        tasksetdata.overrides["has_ocean"] = true
    end
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
    tasksetdata.add_teleportato = true -- add teleportato within teleportato mod. ypu can set up _G.TUNING.TELEPORTATOMOD.teleportato_layouts to change the setpieces of them
    tasksetdata.required_prefabs = _G.ArrayUnion(required_prefabs,{"teleportato_base","teleportato_box","teleportato_crank","teleportato_ring","teleportato_potato"}) -- if ordered_story_setpieces is nil/empty, required_prefabs is set up in teleoprtato mod depending in settings there
    if GetModConfigData("difficulty")==0 then
        tasksetdata.substitutes = GetRandomSubstituteList(SUBS_1, 3)
    end
    tasksetdata.overrides={
        day = "longdusk", 

        season_start = "winter",
        spiders = "often",
        world_size = "medium",
        branching = "default",
        loop = "never",
        
        deerclops  =  (GetModConfigData("difficulty")==0 and "default") or (GetModConfigData("difficulty")==1 and "rare") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "often") or "default",
        dragonfly  =  "never",
        bearger  =  "never",
        goosemoose  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "rare") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "often") or "never",
        antlion = "never",
        wormhole_prefab = "wormhole",
        layout_mode = "LinkNodesByKeys",
        start_location = "adv3",
        autumn = (GetModConfigData("difficulty")==1 and "veryshortseason") or "noseason",
        winter = "noseason",
        spring = "verylongseason",
        summer = "noseason",
        keep_disconnected_tiles = true,
        no_joining_islands = true,
    }
    if (GetModConfigData("withocean")=="ocean" or GetModConfigData("withocean")=="oceanwormholes") then
        tasksetdata.overrides["has_ocean"] = true
    end
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
    tasksetdata.add_teleportato = true -- add teleportato within teleportato mod. ypu can set up _G.TUNING.TELEPORTATOMOD.teleportato_layouts to change the setpieces of them
    tasksetdata.required_prefabs = _G.ArrayUnion(required_prefabs,{"teleportato_base","teleportato_box","teleportato_crank","teleportato_ring","teleportato_potato"}) -- if ordered_story_setpieces is nil/empty, required_prefabs is set up in teleoprtato mod depending in settings there
    if GetModConfigData("difficulty")==0 then
        tasksetdata.substitutes = GetRandomSubstituteList(SUBS_1, 3)
    end
    tasksetdata.overrides={
        world_size = "medium",
        roads = "never",
        weather = (GetModConfigData("difficulty")==0 and "default") or (GetModConfigData("difficulty")==1 and "rare") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "often") or "default",
        deerclops = (GetModConfigData("difficulty")==0 and "default") or (GetModConfigData("difficulty")==1 and "rare") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "often") or "default",
        dragonfly  =  "never",
        bearger  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
        goosemoose  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
        antlion = "never",
        hounds = (GetModConfigData("difficulty")==0 and "default") or (GetModConfigData("difficulty")==1 and "default") or (GetModConfigData("difficulty")==2 and "often") or (GetModConfigData("difficulty")==3 and "always") or "default",
        season_start = "default",
        wormhole_prefab = "wormhole",
        layout_mode = "LinkNodesByKeys",
        start_location = "adv4",
        autumn = "shortseason",
        winter = "shortseason",
        spring = "shortseason",
        summer = "shortseason",
        keep_disconnected_tiles = true,
        no_wormholes_to_disconnected_tiles = false,
        no_joining_islands = true,
    }
    if (GetModConfigData("withocean")=="ocean" or GetModConfigData("withocean")=="oceanwormholes") then
        tasksetdata.overrides["has_ocean"] = true
    end
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
    tasksetdata.add_teleportato = true -- add teleportato within teleportato mod. ypu can set up _G.TUNING.TELEPORTATOMOD.teleportato_layouts to change the setpieces of them
    tasksetdata.required_prefabs = _G.ArrayUnion(required_prefabs,{"teleportato_base","teleportato_box","teleportato_crank","teleportato_ring","teleportato_potato"}) -- if ordered_story_setpieces is nil/empty, required_prefabs is set up in teleoprtato mod depending in settings there -- _G.ArrayUnion(required_prefabs,{"pigking"})
    if GetModConfigData("difficulty")==0 then
        tasksetdata.substitutes = GetRandomSubstituteList(SUBS_1, 3)
    end
    tasksetdata.overrides={
        day  =  (GetModConfigData("difficulty")==0 and "default") or (GetModConfigData("difficulty")==1 and "longday") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "longdusk") or "default", 
        season_start  =  "autumn",
        
        weather = (GetModConfigData("difficulty")==0 and "rare") or (GetModConfigData("difficulty")==1 and "rare") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "often") or "rare", 
        
        roads  =  "never",
        dragonfly  =  "never",
        bearger  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
        goosemoose  =  "never",
        antlion = "never",
        world_size = "medium",
        wormhole_prefab = "wormhole",
        layout_mode = "LinkNodesByKeys",
        start_location = "adv5",
        autumn = (GetModConfigData("difficulty")==1 and "veryshortseason") or "noseason",
        winter = "noseason",
        spring = "noseason",
        summer = "verylongseason",
        keep_disconnected_tiles = true,
        no_wormholes_to_disconnected_tiles = false,
        no_joining_islands = true,
    }
    if (GetModConfigData("withocean")=="ocean" or GetModConfigData("withocean")=="oceanwormholes") then
        tasksetdata.overrides["has_ocean"] = true
    end
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
    if GetModConfigData("difficulty")==0 then
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
    tasksetdata.add_teleportato = true -- add teleportato within teleportato mod. ypu can set up _G.TUNING.TELEPORTATOMOD.teleportato_layouts to change the setpieces of them
    tasksetdata.required_prefabs = _G.ArrayUnion(required_prefabs,{"teleportato_base","teleportato_box","teleportato_crank","teleportato_ring","teleportato_potato"}) -- if ordered_story_setpieces is nil/empty, required_prefabs is set up in teleoprtato mod depending in settings there
    tasksetdata.overrides={
        branching = "never",
        day = "onlynight", 
        season_start = "autumn",
        weather = "often",

        boons = "always",
        
        roads = "never",
        berrybush = "never",
        spiders = "often",

        fireflies = (GetModConfigData("difficulty")==3 and "often") or "always",
        
        bunnymen = (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "default") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "rare") or "never",
        flower_cave = (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "always") or (GetModConfigData("difficulty")==2 and "often") or (GetModConfigData("difficulty")==3 and "rare") or "never",
        
        maxwelllight_area = (GetModConfigData("difficulty")==0 and "always") or (GetModConfigData("difficulty")==1 and "always") or (GetModConfigData("difficulty")==2 and "often") or (GetModConfigData("difficulty")==3 and "rare") or "always", 
        pigtorch = (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "often") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "rare") or "never", 
        dragonfly  =  "never",
        bearger  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
        goosemoose  =  "never",
        antlion = "never",
        world_size = "medium",
        wormhole_prefab = "wormhole",
        layout_mode = "LinkNodesByKeys",
        start_location = "adv6",
        autumn = (GetModConfigData("difficulty")==0 and "noseason") or (GetModConfigData("difficulty")==1 and "shortseason") or (GetModConfigData("difficulty")==2 and "veryshortseason") or (GetModConfigData("difficulty")==3 and "noseason") or "noseason",
        winter = "noseason",
        spring = "noseason",
        summer = (GetModConfigData("difficulty")==0 and "verylongseason") or (GetModConfigData("difficulty")==1 and "shortseason") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "verylongseason"),
        keep_disconnected_tiles = true,
        no_wormholes_to_disconnected_tiles = true,
        no_joining_islands = true,
    }
    if (GetModConfigData("withocean")=="ocean" or GetModConfigData("withocean")=="oceanwormholes") then
        tasksetdata.overrides["has_ocean"] = true
    end
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
    tasksetdata.overrides={
        start_location = "adv7",  --- wenn wir keine startlocation zufügen, wird default verwendet, welches default setpiece und clearing verwendet, welches ein multiplayer portal beinhaltet.
        wormhole_prefab = "wormhole",
        layout_mode = "LinkNodesByKeys",  
        day  =  "onlynight", 
        weather  =  "never",
        creepyeyes  =  "always",
        roads  =  "never",
        boons  =  "never",
        deerclops = "never",
        dragonfly  =  "never",
        bearger  =  "never",
        goosemoose  =  "never",
        antlion = "never",
        world_size = "medium",
        autumn = "verylongseason", -- only summer would be rubbish
        winter = "noseason",
        spring = "noseason",
        summer = "noseason",
        keep_disconnected_tiles = true,
        no_wormholes_to_disconnected_tiles = true,
        no_joining_islands = true,
        has_ocean = false, -- always no ocean
    }
    return tasksetdata
end
table.insert(_G.TUNING.TELEPORTATOMOD.WORLDS, {name="Checkmate", taskdatafunctions={forest=AdventureMaxwellHome, cave=AlwaysTinyCave}, defaultpositions={7}, positions=GetModConfigData("checkmate")})

