
local _G = GLOBAL
print("HIER WORLDGEN adv")
-- other mods, loaded previously, should add their worldgeneration stuff in this GLOBAL variable. And this API mod then will be able to choose and start worlds from other mods
-- make it compatible with caves/ more then host player

-- maxwellshome is suddenly the other way round? The whole world as to be rotated bei 180°


-- TODO :
-- [00:02:24]: Missing reference:	101481 - maxwelllock	->	103609	103609 - diviningrod(LIMBO)

-- alle GetPlayer bzw ThePlayer durch eine for schleife mit AllPlayers ersetzen, wenn es mit allen Spielern passieren soll

-- bei throne noch machen, dass maxwell da ist und dass player dann auf thron gesetzt wird... oder brauch ich dafür puppets? sonst mal puppest mod runterladen
-- aktuell sitze maxwell auf den thron, nachdem das spiel beendet ist , aber vorher nicht ?!

-- bei worldjump evlt auch den gewählten char speichern und übernehmen -> keine ahnung wie

-- wenn alles läuft könnte man evlt auch ein caves level zufuegen, wobei dann tintybyte duch smallbyte -> 63 level geändert werden muss

-- maxwell+betäubt am level anfang kann direkt in PlayerPostInit rein und startstuff component merkt es sich dann pro spieler und es wird als client ausgeführt... braucht man dann vermutlich netvars für


--can't find grass_umbrella_blueprint -> vermutlich weil es noch None baubar ist


-- in summer leveln muss man iwie an eis und gears rankommen...


-- statue/wes_enemywave einbauen, evlt in maxwellhome als endkampf ? 


-- anim inactive trap_teeth_maxwell ... hmm die anim datei gibts eigentlich... also woher kommt der fehler? 

--  sound von phonograph funzt nicht mehr



-- den teleoprtato in maxwellhome evlt nutzbar machen, um adventure von vorn zu beginnen? dann muss char aber wieder erscheinen, damit man sich wieder bewegen kann



-- Wenn maxwell redet wird camera noch nicht als client rangezoomt... liegt daran, dass maxwell und seine maxwelltalker componente natürlich nur fur den server erstellt wird...
-- man müsste also die camera befehle dort rausholen und in modmain packen, sodass sie auch von client ausgeführt werden... gilt dann natürlich auch für den maxwellthrone kram -.-
-- man könnte sonst auch noch eine netvar verwenden, zb die TitleStuff variable, und bei bestimmten werten in der listener funktion dann die camera verändern und den wert in der maxwellcomponente ändern...
-- -> ja funktioniert mit netvar ! :)  .. wobei es berichte gab, dass es doch nicht funzt?

-- two-worlds: berrybush_juicy cant find prefab



-- GLOBALs sind in forest/cave unterschiedlich, also darauf achten, dass ich alle globals immer für alle welten setze!

-- wollten wir nur einen welt mod aufeinmal aktiv haben, bräuchte es diese WORLDS Liste vermutlich nicht.
-- doch wir wollen, dass mehrere mods ihre welten zu der liste zufügen können und dann zufällig zwischen ihnen ausgewählt werden kann. dafür ist die liste nötig.


-- als client testen, auch _G.TheWorld.mynetvarAdvChapter:value() in konstole printen um zu sehen obs funzt
-- -> mynetvarAdvChapter ist als client nil
-- es wird kein titelscreen gezeigt nicht rangezoomed inst.Camera und maxwell hat keinen Text 
-- UI ein/ausblenden klappt aber
-- test/reden von maxwell we have to find the door, kommt auch nicht
-- karte wird in maxhome auch nicht gedreht.
-- nach divingingrod um maxwell zu befreien: [string "../mods/Adventure-Addon/scripts/prefabs/max..."]:214: attempt to index field 'HUD' (a nil value)

-- Say() zb find maxwells door, wird doch fuer client angezeigt, obowhl nur server es ausführt, ist vermutlich richtig so, aber talker muss halt für beide zugefügt worden sein
-- was bei maxwell evlt nicht so ist?

-- player:SetCameraDistance() innerhalb des server modmain teil wo ich auch "search door" saye, funcktioniert, aber innerhalb vom maxwelltaler nicht, obwohl AllPlayer[x] defintiv inst des players ist.


-- maxwelltalker am besten durch die talker component ersetzen ... leider macht dieser nicht nur das talken, sondern auch viel mehr bzl animation und camrea..
-- den text ekommt man aber, wenn man die Say() fkt mit { {message="hallo"},{message="ich"},{message="bin"},{message="doof"} } aufruft.



--##########################################

-- Explanations:

-- Level is the number of chosen map. There can be unlimited maps. starts at 1
-- Chapter: starts at 0. max number is 6. ->Only 7 maps are chosen from the level list.
-- for testing you can do TheWorld.components.adventurejump:DoJump(true,true,true) within console
-- to see what overrides you can choose for your world, see scripts\map\customise.lua

-- if you want a teleportato (add_teleportato in taskdata), but don't want to create setpieces for it and want the teleportato mod to simply spawn them, you can either
-- make _G.TUNING.TELEPORTATOMOD.teleportato_layouts["forest"]=nil, then the setpieces from teleportato mod are used. OR you can set it {}, then no setpieces are used, 
-- but they are randomly placed after world generation. But also set _G.TUNING.TELEPORTATOMOD.set_behaviour within your modworldgenmain to between 0 and 3 (not 4 or 5!), otherwise world generation will be endless.

-- add_teleportato at caves will only add the parts here. the base will always be at mastershard (forest)

-- you can define the tasks where to palce the teleportato parts tasksetdata.set_pieces[layout] = { count = 1, tasks=allTasks} within your taskdatafunction.
-- only forest will have the worldjump component, so only forest should have a teleportato_base.
-- if it is nil for a layout from teleportato_layouts, a random task will be chosen. You can find all existing tasks in scripts\map\tasks folder or create your own.

-- currently it only supports two worlds: forest and cave, but you can change them to your liking. If you want to add more worlds with different names, 
-- the teleportato mod code has to be adjusted, although I already made sure to use "forest" and "cave" as less as possible.

-- do not use tasksetdata.ordered_story_setpieces, since this is only made to work with original DS adventure worlds. Only use it if you know what you are doing.
-- use taskdata.set_pieces instead for normal set_pieces and add_teleportato for the tele stuff.

------------------------------------------------------------------



local require = _G.require

-- load some custom layouts
local LLayouts = _G.require("map/layouts").Layouts
LLayouts["WesUnlock"] = _G.require("map/layouts/WesUnlock")
LLayouts["TeleportatoRingLayoutSanityRocks"] = require("map/layouts/TeleportatoRingLayoutSanityRocks")
LLayouts["DefaultStartMaxwellHome"] = require("map/layouts/defaultstartmaxwellhome")
LLayouts["AdventurePortalLayoutNew"] = require("map/layouts/AdventurePortalLayoutNew")
LLayouts["NightmareStart_new"] = require("map/layouts/NightmareStart_new") -- added spawnpoint_master and removed items, since items are now contributed for each player in modmain
LLayouts["PreSummerStart_new"] = require("map/layouts/PreSummerStart_new") -- also the not "new" files got a spawnpoint_master, but kept items, to allow DS like mode.
LLayouts["WinterStartEasy_new"] = require("map/layouts/WinterStartEasy_new")
LLayouts["BargainStart_new"] = require("map/layouts/BargainStart_new")
LLayouts["WinterStartMedium_new"] = require("map/layouts/WinterStartMedium_new")
LLayouts["ImpassableBlock"] = require("map/layouts/ImpassableBlock")



if GetModConfigData("difficulty")==0 then
    adventureportal = "AdventurePortalLayout"
else
    adventureportal = "AdventurePortalLayoutNew" --  has some clockworks, skeletons and a maxwelllight
end


local adventure1_setpieces_tasks = {
            "Easy Blocked Dig that rock",
            "Great Plains",
            "Guarded Speak to the king",
            "Waspy Beeeees!",
            "Guarded Squeltch",
            "Guarded Forest hunters",
            "Befriend the pigs",
            "Guarded For a nice walk",
            "Walled Kill the spiders",
            "Killer bees!",
            "Make a Beehat",
            "Waspy The hunters",
            "Hounded Magic meadow",
            "Wasps and Frogs and bugs",
            "Guarded Walrus Desolate"
        }


local required_prefabs = {
            "chester_eyebone", "spawnpoint_master",
        }


local start1 = "WinterStartEasy_new"
local start2 = "WinterStartMedium_new"
local start3 = "PreSummerStart_new"
local start4 = "ThisMeansWarStart"--"DefaultStart" --"ThisMeansWarStart" gibts kein new
local start5 = "BargainStart_new"
local start6 = "NightmareStart_new"
local start7 = "DefaultStartMaxwellHome" -- ist new, gibts kein alt
if GetModConfigData("difficulty")==0 then -- DS
    start1 = "WinterStartEasy"
    start2 = "WinterStartMedium"
    start3 = "PreSummerStart"
    start4 = "ThisMeansWarStart"--"DefaultStart" 
    start5 = "BargainStart"
    start6 = "NightmareStart"
    start7 = "DefaultStartMaxwellHome"
end        
        
AddStartLocation("adv1", {
    name = "adv1",
    location = "forest",
    start_setpeice  =  start1,	
    start_node  =  "Forest",
})        
AddStartLocation("adv2", {
    name = "adv2",
    location = "forest",
    start_setpeice  =  start2,		
    start_node  =  "Clearing",
})
AddStartLocation("adv3", {
    name = "adv3",
    location = "forest",
    start_setpeice = start3,
    start_node = "Clearing",
})
AddStartLocation("adv4", {
    name = "adv4",
    location = "forest",
    start_setpeice  =  start4,	
    start_node  =  "BGGrass",
})
AddStartLocation("adv5", {
    name = "adv5",
    location = "forest",
    start_setpeice  =  start5,	
    start_node  =  "Clearing",
})
AddStartLocation("adv6", {
    name = "adv6",
    location = "forest",
    start_setpeice  =  start6,	
    start_node  =  "BGGrass",
})
AddStartLocation("adv7", {
    name = "adv7",
    location = "forest",
    start_setpeice  =  start7,	-- for some reason a portal has to exist... but I removed spawnpoint, so the start position is right
    start_node  =  "MaxHome",  
})

local _G = GLOBAL
if not _G.TUNING.TELEPORTATOMOD then
    _G.TUNING.TELEPORTATOMOD = {}
end
if not _G.TUNING.TELEPORTATOMOD.WORLDS then
    _G.TUNING.TELEPORTATOMOD.WORLDS = {}
end
local WORLDS = _G.TUNING.TELEPORTATOMOD.WORLDS

local adv_helpers = _G.require("adv_helpers") 
-- we can use GLOBAL.LEVEL and _G.TUNING.TELEPORTATOMOD.CHAPTER as soon as the game started
-- so do not use it directly in AddPrefabPostInit, but make DoTaskInTime with at least 0.1 within


-- testing
-- _G.TUNING.TELEPORTATOMOD.LEVEL_GEN = 8 -- force loading this level
-- _G.TUNING.TELEPORTATOMOD.CHAPTER_GEN = 0
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



local function AlwaysTinyCave(tasksetdata) -- even if cave was enabled, make it always very tiny, cause we dont need it
    -- tasksetdata.tasks = {"CaveExitTask1"}
    -- tasksetdata.numoptionaltasks = 0
    -- tasksetdata.optionaltasks = {}
    -- tasksetdata.set_pieces = {}
    -- tasksetdata.required_setpieces = {}
    -- tasksetdata.numrandom_set_pieces = 0
    -- tasksetdata.random_set_pieces = {}
    -- tasksetdata.valid_start_tasks = {"CaveExitTask1"}
    -- tasksetdata.overrides={
        -- world_size  =  _G.PLATFORM == "PS4" and "default" or "tiny",
        -- wormhole_prefab = "tentacle_pillar",
        -- layout_mode = "RestrictNodesByKey",
    -- }
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
    tasksetdata.tasks = {"Tentacle-Blocked Spider Swamp"}--{"Swamp start","Tentacle-Blocked Spider Swamp"}--{"Tentacle-Blocked Spider Swamp"} -- {"Swamp start"}
    tasksetdata.numoptionaltasks = 0
    tasksetdata.optionaltasks = {}
    tasksetdata.set_pieces = {}
        -- ["ResurrectionStoneWinter"] = { count=1, tasks={"Tentacle-Blocked Spider Swamp"}},
    -- }
    tasksetdata.required_setpieces = {}
    table.insert(tasksetdata.required_setpieces,adventureportal) -- adventure portal is NOT added by teleportato mod
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
        season_start  =  "autumn",
        autumn = "veryshortseason",
        winter = "veryshortseason",
        spring = "veryshortseason",
        summer = "veryshortseason",
        keep_disconnected_tiles = true,
		no_joining_islands = true,
		has_ocean = true,
    }
    return tasksetdata
end
table.insert(_G.TUNING.TELEPORTATOMOD.WORLDS, {name="Maxwells Door", taskdatafunctions={forest=AdventurePortalWorld, cave=AlwaysTinyCave}, defaultpositions={1}, positions=GetModConfigData("maxwellsdoor")})


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
		has_ocean = true,
    }
    return tasksetdata
end
table.insert(_G.TUNING.TELEPORTATOMOD.WORLDS, {name="A Cold Reception", taskdatafunctions={forest=AdventureColdReception, cave=AlwaysTinyCave}, defaultpositions={2,3,4,5}, positions=GetModConfigData("acoldreception")})


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
		has_ocean = true,
    }
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
        goosemoose  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
        wormhole_prefab = "wormhole",
        layout_mode = "LinkNodesByKeys",
        start_location = "adv3",
        autumn = (GetModConfigData("difficulty")==1 and "veryshortseason") or "noseason",
        winter = "noseason",
        spring = "verylongseason",
        summer = "noseason",
        keep_disconnected_tiles = true,
		no_joining_islands = true,
		has_ocean = true,
    }
    return tasksetdata
end
table.insert(_G.TUNING.TELEPORTATOMOD.WORLDS, {name="The Game is Afoot", taskdatafunctions={forest=AdventureGameAfoot, cave=AlwaysTinyCave}, defaultpositions={2,3,4,5}, positions=GetModConfigData("thegameisafoot")})


local function AdventureArchipelago(tasksetdata)
    tasksetdata.numoptionaltasks = 0
    tasksetdata.tasks = {"IslandHop_Start","IslandHop_Hounds","IslandHop_Forest","IslandHop_Savanna","IslandHop_Rocky","IslandHop_Merm",}
    tasksetdata.optionaltasks = {}
    -- tasksetdata.optionaltasks = {"The hunters","Trapped Forest hunters","Wasps and Frogs and bugs","Tentacle-Blocked The Deep Forest","Hounded Greater Plains","Merms ahoy",}
    tasksetdata.set_pieces = {                
            -- ["WesUnlock"] = { restrict_to="background", tasks={ "IslandHop_Start", "IslandHop_Hounds", "IslandHop_Forest", "IslandHop_Savanna", "IslandHop_Rocky", "IslandHop_Merm" } },
            -- ["Wormhole_Mod"] = { count= 5, tasks={ "IslandHop_Start"}}--, "IslandHop_Hounds", "IslandHop_Forest", "IslandHop_Savanna", "IslandHop_Rocky", "IslandHop_Merm" } },
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
    tasksetdata.overrides={
        world_size = "medium",
        roads = "never",
        weather = (GetModConfigData("difficulty")==0 and "default") or (GetModConfigData("difficulty")==1 and "rare") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "often") or "default",
        deerclops = (GetModConfigData("difficulty")==0 and "default") or (GetModConfigData("difficulty")==1 and "rare") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "often") or "default",
        dragonfly  =  "never",
        bearger  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
        goosemoose  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
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
		has_ocean = true,
    }
    return tasksetdata
end
table.insert(_G.TUNING.TELEPORTATOMOD.WORLDS, {name="Archipelago", taskdatafunctions={forest=AdventureArchipelago, cave=AlwaysTinyCave}, defaultpositions={2,3,4,5}, positions=GetModConfigData("archipelago")})


local function AdventureTwoWorlds(tasksetdata)
    -- tasksetdata.override_level_string=true -- test out what this does ?
    tasksetdata.tasks = {"Land of Plenty", -- Part 1 - Easy peasy - lots of stuff
                        "The other side",}	-- Part 2 - Lets kill them off
    -- tasksetdata.numoptionaltasks = 4 -- evlt vllt doch 0, mal Beschreibung genauer lesen, was darin vorkommen sollte...
    -- tasksetdata.optionaltasks = {"Befriend the pigs","For a nice walk","Kill the spiders","Killer bees!","Make a Beehat",
            -- "The hunters","Magic meadow","Frogs and bugs",} -- in adventure.lua keine optionaltasks definiert. Aber wenn es 0 sein sollte, würde das da stehen, also vermutlich default werte? 
    tasksetdata.required_setpieces = {}
    tasksetdata.numoptionaltasks = 0
    tasksetdata.optionaltasks = {}
    tasksetdata.set_pieces = {                
            ["MaxPigShrine"] = {tasks={"Land of Plenty"}},
            ["MaxMermShrine"] = {tasks={"The other side"}},
            ["ResurrectionStone"] = { count=2, tasks={"Land of Plenty", "The other side" } },}
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
    tasksetdata.overrides={
        day  =  (GetModConfigData("difficulty")==0 and "default") or (GetModConfigData("difficulty")==1 and "longday") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "longdusk") or "default", 
        season_start  =  "autumn",
        
        weather = (GetModConfigData("difficulty")==0 and "rare") or (GetModConfigData("difficulty")==1 and "rare") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "often") or "rare", 
        
        roads  =  "never",
        dragonfly  =  "never",
        bearger  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
        goosemoose  =  "never",
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
		has_ocean = true,
    }
    return tasksetdata
end
table.insert(_G.TUNING.TELEPORTATOMOD.WORLDS, {name="Two Worlds", taskdatafunctions={forest=AdventureTwoWorlds, cave=AlwaysTinyCave}, defaultpositions={4,5}, positions=GetModConfigData("twoworlds")})


local function AdventureDarkness(tasksetdata)
    tasksetdata.tasks = {"Swamp start","Battlefield","Walled Kill the spiders","Sanity-Blocked Spider Queendom",}
    tasksetdata.numoptionaltasks = 2
    tasksetdata.optionaltasks = {"Killer bees!","Chessworld","Tentacle-Blocked The Deep Forest","Tentacle-Blocked Spider Swamp",
        "Trapped Forest hunters","Waspy The hunters","Hounded Magic meadow",}
    tasksetdata.set_pieces = {
            ["RuinedBase"] = {tasks={"Swamp start", "Battlefield", "Walled Kill the spiders", "Killer bees!"}},
            ["ResurrectionStoneLit"] = { count=4, tasks={"Swamp start", "Battlefield", "Walled Kill the spiders", "Sanity-Blocked Spider Queendom","Killer bees!",
            "Chessworld","Tentacle-Blocked The Deep Forest", "Tentacle-Blocked Spider Swamp","Trapped Forest hunters","Waspy The hunters","Hounded Magic meadow", }},}
    tasksetdata.substitutes = {["pighouse"] = {perstory=1,weight=1,pertask=1}} -- pighouses replaced by pigs (see ressource_sub... gamefile)
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
        flower_cave = (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "always") or (GetModConfigData("difficulty")==2 and "often") or (GetModConfigData("difficulty")==3 and "default") or "never",
        
        maxwelllight_area = (GetModConfigData("difficulty")==0 and "always") or (GetModConfigData("difficulty")==1 and "always") or (GetModConfigData("difficulty")==2 and "often") or (GetModConfigData("difficulty")==3 and "default") or "always", 
        pigtorch = (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "often") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "rare") or "never", 
        dragonfly  =  "never",
        bearger  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
        goosemoose  =  "never",
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
		has_ocean = true,
    }
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
        world_size = "medium",
        autumn = "verylongseason", -- only summer would be rubbish
        winter = "noseason",
        spring = "noseason",
        summer = "noseason",
        keep_disconnected_tiles = true,
		no_wormholes_to_disconnected_tiles = true,
		no_joining_islands = true,
		has_ocean = true,
    }
    return tasksetdata
end
table.insert(_G.TUNING.TELEPORTATOMOD.WORLDS, {name="MaxwellHome", taskdatafunctions={forest=AdventureMaxwellHome, cave=AlwaysTinyCave}, defaultpositions={7}, positions=GetModConfigData("maxwellhome")})

