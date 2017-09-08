-- print("HIER WORLDGEN")


-- # Anstatt Inseln zu machen, könnte man evtl auch verbundene inseln machen, die aber zb. mit basalt blokciert sind (vgl übergang mit sanityrocks), sodass man letzlich doch wormholes benutzen muss

-----------spawn mode------------------------------------------------
-- local SpawnMode = GetModConfigData("spawn_mode")

-- GLOBAL.GAME_MODES["custom_game"].spawn_mode = SpawnMode


----------ghost sanity drain--------------------------------------------
-- local GhostSanityDrain = GetModConfigData("ghost_sanity_drain")

-- GLOBAL.GAME_MODES["custom_game"].ghost_sanity_drain = GhostSanityDrain

-----------ghost enabled------------------------------------------------
-- local GhostEnabled = GetModConfigData("ghost_enable")

-- GLOBAL.GAME_MODES["custom_game"].ghost_enabled = GhostEnabled

----------------reset timer-----------------------------
-- local ResetTime = GetModConfigData("reset_time")

-- if ResetTime then
	-- GLOBAL.GAME_MODES["custom_game"].reset_time = { time = 120, loadingtime = 180 }
-- end

-------------------------poratl revival------------------------------

-- local PortalRez = GetModConfigData("portal_rez")

-- GLOBAL.GAME_MODES["custom_game"].portal_rez = PortalRez

-----------------banned items-----------------------------------------
-- local BanResItems = GetModConfigData("ban_rez")

-- if BanResItems then
	-- GLOBAL.GAME_MODES["custom_game"].invalid_recipes = { "reviver", "lifeinjector", "amulet", "resurrections" }
-- end








-- TODO :
-- [00:02:24]: Missing reference:	101481 - maxwelllock	->	103609	103609 - diviningrod(LIMBO)

-- alle GetPlayer bzw ThePlayer durch eine for schleife mit AllPlayers ersetzen, wenn es mit allen Spielern passieren soll

-- bei throne noch machen, dass maxwell da ist und dass player dann auf thron gesetzt wird... oder brauch ich dafür puppets? sonst mal puppest mod runterladen
-- aktuell sitze maxwell auf den thron, nachdem das spiel beendet ist , aber vorher nicht ?!

-- bei worldjump evlt auch den gewählten char speichern und übernehmen -> keine ahnung wie

-- wenn alles läuft könnte man evlt auch ein caves level zufuegen, wobei dann tintybyte duch smallbyte -> 63 level geändert werden muss

-- maxwell+betäubt am level anfang kann direkt in PlayerPostInit rein und startstuff component merkt es sich dann pro spieler und es wird als client ausgeführt... braucht man dann vermutlich netvars für


--can't find grass_umbrella_blueprint -> vermutlich weil es noch None baubar ist

-- die blueprints müssen hingegen schon in einer sinnvollen Reihenfolge vreteilt werden... dabei muss auch berücksichtigt werden, in welchem level wir sind...
-- eine möglichkeit wäre sie in setpieces zu integrieren. bleibt aber noch das problem der welten.. -> vorher genau überlegen in welchem level welche blueprints werden könnten
-- optionale blueprints können zufällig verteilt bzw beim shop angeboten werden (wenn beides passiert, dann nach aufpicken im shop preis auf 1 reduzieren? geht das? Ja mit GLOBAL.AllRecipes)


-- COOP aufgaben:
-- dinge können mit playerprox prüfen ob iein player in der nähe ist, und wenn ja bei ieinem anderen objekt etwas auslösen, damit spieler durch kann oderso
-- um das anzahl problem zu lösen, könnte man immer mit aLLPlayers die Zahl checken. wenn nur ein spieler da sind, ist die Sperre nur normale sanity obelisken.
-- sind aber zwei oder mehr spieler aktiv, dann muss die abgerundete hälfte aller spieler sich auf eine bestimmte position stellen, damit obelisekn runtergehen (shopkeeper kann hint geben)
-- mind. einer muss dann durch und auf der anderen seite eine stelle betreten, damit obeliksen dauerhaft verschwinden (auch wenn dann nur noch 1 player da)

-- in summer leveln muss man iwie an eis und gears rankommen...

-- testen ob adventure und worldjump funzt, wenn einer der spieler ein Geist ist 


-- statue/wes_enemywave einbauen, evlt in maxwellhome als endkampf ? 

-- mod muss iwie noch zu adventure geforced werden, damit aufjedenfall kein wilderness mit mehreren spawnpoints wählbar ist.


-- anim inactive trap_teeth_maxwell ... hmm die anim datei gibts eigentlich... also woher kommt der fehler? 

--  sound von phonograph funzt nicht mehr


-- two worlds welt. world generation hat lang gedauert, weil er wie bei archipel zuviele unconnected tiles hatte. Aber iwann war welt fertig, obwohl in logfile wormholes weiterhin unconnected steht?!
-- -> alles ist connected, gibt also keine inseln. Deswegen ists wohl erfolgreich.

-- den teleoprtato in maxwellhome evlt nutzbar machen, um adventure von vorn zu beginnen? dann muss char aber wieder erscheinen, damit man sich wieder bewegen kann

-- einige blueprints können auch etwas teurer direkt im shop kaufbar sein.


-- versuchen diviningrod aus game zu zerstören, ob es irreplacable ist.

-- automatic health adjustment einbauen und in diesem dann adventure check einbauen. Von den einstellungen nur die Quicksettings mit "aus" übernehmen.
-- evtl auch increased animals mit einbauen, sodass es je nach schwierigkeitsgrad mehr feindliche Wesen gibt

-- mit caves testen -> cave klein gemacht und gibt auch keine eingänge.
-- mit cave enabled kann nun clientversion getestet werden. 
-- Wenn maxwell redet wird camera noch nicht als client rangezoomt... liegt daran, dass maxwell und seine maxwelltalker componente natürlich nur fur den server erstellt wird...
-- man müsste also die camera befehle dort rausholen und in modmain packen, sodass sie auch von client ausgeführt werden... gilt dann natürlich auch für den maxwellthrone kram -.-
-- man könnte sonst auch noch eine netvar verwenden, zb die TitleStuff variable, und bei bestimmten werten in der listener funktion dann die camera verändern und den wert in der maxwellcomponente ändern...
-- -> ja funktioniert mit netvar ! :)

-- two-worlds: berrybush_juicy cant find prefab


-- die ganzen netvars evtl besser in world speichern anstatt in player inst ? 


-- neues clockwork bastel setpiece ist in chapter 0 ?! drin lassen, oder nicht?


-- stuff from DarkXero to make adventure progress:
local io = GLOBAL.io
local json = GLOBAL.json
local modfoldername = "adventuremod"
local tmp_filepath = "../mods/"..modfoldername.."/adventure"

GLOBAL.MakeTemporalAdventureFile = function(json_string)
	local advfile = io.open(tmp_filepath, "w")

	if advfile then
		advfile:write(json_string)
		advfile:close()
	end
end

GLOBAL.CleanTemporalAdventureFile = function()
	GLOBAL.MakeTemporalAdventureFile("")
end

GLOBAL.GetTemporalAdventureContent = function()
	local advfile = io.open(tmp_filepath, "r")

	if advfile == nil then
		print(modfoldername..": no adventure override found...")
		return nil
	end

	local adventure_stuff = nil

	local advstr = advfile:read("*all")

	if advstr ~= "" then
		adventure_stuff = json.decode(advstr)
	end

	advfile:close()

	return adventure_stuff
end




-- hack from DarkXero to prevent the world from stop-loading when generating unconnected islands (cause island generation is broken in DST, since the connection with wormholes does not work)
-- unfortunately this makes the world to load incomplete.. stops after creating one island...
local function GetUpvalue(func, name)
	local debug = GLOBAL.debug
	local i = 1
	while true do
		local n, v = debug.getupvalue(func, i)
		if not n then
			return nil, nil
		end
		if n == name then
			return v, i
		end
		i = i + 1
	end
end
local function SetUpvalue(func, ind, value)
	local debug = GLOBAL.debug
	debug.setupvalue(func, ind, value)
end

local function HackGenChecksForIslands() -- a try to solve the broken island generation... but this only results in Stop of world generation after 1 island is generated
	local generate_fn = GLOBAL.require("map/forest_map").Generate

	local SKIP_GEN_CHECKS, SKIP_GEN_CHECKS_index = GetUpvalue(generate_fn, "SKIP_GEN_CHECKS")

	SetUpvalue(generate_fn, SKIP_GEN_CHECKS_index, true)
end







local require = GLOBAL.require

local LLayouts = GLOBAL.require("map/layouts").Layouts
LLayouts["WesUnlock"] = GLOBAL.require("map/layouts/WesUnlock")
LLayouts["TeleportatoRingLayoutSanityRocks"] = require("map/layouts/TeleportatoRingLayoutSanityRocks")
LLayouts["DefaultStartMaxwellHome"] = require("map/layouts/defaultstartmaxwellhome")
LLayouts["AdventurePortalLayoutNew"] = require("map/layouts/AdventurePortalLayoutNew")
LLayouts["NightmareStart_new"] = require("map/layouts/NightmareStart_new") -- added spawnpoint_master and removed items, since items are now contributed for each player in modmain
LLayouts["PreSummerStart_new"] = require("map/layouts/PreSummerStart_new") -- also the not "new" files got a spawnpoint_master, but kept items, to allow DS like mode.
LLayouts["WinterStartEasy_new"] = require("map/layouts/WinterStartEasy_new")
LLayouts["BargainStart_new"] = require("map/layouts/BargainStart_new")
LLayouts["WinterStartMedium_new"] = require("map/layouts/WinterStartMedium_new")
LLayouts["Wormhole_Mod"] = require("map/layouts/Wormhole_Mod")


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

local SUBS_1= { -- substitute spiderden with spiderden 2 or 3
			["evergreen"] = 		{perstory=0.5, 	pertask=1, 		weight=1},
			["evergreen_short"] = 	{perstory=1, 	pertask=1, 		weight=1},
			["evergreen_normal"] = 	{perstory=1, 	pertask=1, 		weight=1},
			["evergreen_tall"] = 	{perstory=1, 	pertask=1, 		weight=1},
			["sapling"] = 			{perstory=0.6, 	pertask=0.95,	weight=1},
			["beefalo"] = 			{perstory=1, 	pertask=1, 		weight=1},
			["rabbithole"] = 		{perstory=1, 	pertask=1, 		weight=1},
			-- ["rock1"] = 			{perstory=0.3, 	pertask=1, 		weight=1},
			-- ["rock2"] = 			{perstory=0.5, 	pertask=0.8, 	weight=1},
			["grass"] = 			{perstory=0.5, 	pertask=0.9, 	weight=1},
			["flint"] = 			{perstory=0.5, 	pertask=1,		weight=1},
			["spiderden"] =			{perstory=1, 	pertask=1, 		weight=1},
}


local teleportato_layouts = {}
if GetModConfigData("difficulty")==0 then
    teleportato_layouts = {
		"TeleportatoBoxLayout",
        "TeleportatoRingLayout",
		"TeleportatoPotatoLayout",
		"TeleportatoCrankLayout",
		"TeleportatoBaseAdventureLayout",
	}
else
    teleportato_layouts = {
        "TeleportatoRingLayoutSanityRocks",
        "TeleportatoBoxLayout",
        "TeleportatoCrankLayout",
        "TeleportatoPotatoLayout",
        "TeleportatoBaseAdventureLayout",
    }
end

local adventureportal = "AdventurePortalLayoutNew" -- has some clockworks, skeletons and a maxwelllight
if GetModConfigData("difficulty")==0 then
    adventureportal = "AdventurePortalLayout"
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
            "teleportato_ring",  "teleportato_box",  "teleportato_crank", "teleportato_potato", "teleportato_base", "chester_eyebone", "spawnpoint_master",
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


-- hack into the island worlds, to make them no island. Then they will load at leat....
local islandtasks = {"IslandHop_Start","IslandHop_Hounds","IslandHop_Forest","IslandHop_Savanna","IslandHop_Rocky","IslandHop_Merm","Land of Plenty","The other side",}
for _,tasks in pairs(islandtasks) do
    AddTaskPreInit(tasks,function(task)
        task.entrance_room = nil -- now the world is loading but of course without islands... 
    end)
end


GLOBAL.OVERRIDELEVEL_GEN = 0
GLOBAL.CHAPTER_GEN = 0
GLOBAL.ADVENTURE_STUFF = nil
local adventure_stuff = GLOBAL.GetTemporalAdventureContent() -- eg. {"current_level":3,"level_list":[3,4,5,1,6,7]}
if adventure_stuff then -- is only true, if we just adventure_jumped 
    GLOBAL.ADVENTURE_STUFF = adventure_stuff
    GLOBAL.OVERRIDELEVEL_GEN = adventure_stuff.level_list[adventure_stuff.current_level] or 0
    GLOBAL.CHAPTER_GEN = adventure_stuff.current_level or 0
    print("Adventure: adventurestuff loaded successfully")
end

-- testing
-- GLOBAL.OVERRIDELEVEL_GEN= 5 -- force loading this level

-- if GLOBAL.OVERRIDELEVEL_GEN==4 then HackGenChecksForIslands() end -- island hack.. -- a try to solve the broken island generation... but this only results in Stop of world generation after 1 island is generated

print("Level gen1 is "..tostring(GLOBAL.OVERRIDELEVEL_GEN).." Chapter is "..tostring(GLOBAL.CHAPTER_GEN))

AddTaskSetPreInitAny(function(tasksetdata)
-- AddLevelPreInitAny(function(tasksetdata)  -- what is the differnce ?!

    if tasksetdata.location ~= "forest" then 
        if tasksetdata.location=="cave" then -- make cave super tiny in case it does exist
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
        end
        return
    end
    
    if GLOBAL.OVERRIDELEVEL_GEN==0 then-- load a normal world, but place the adventure portal somewhere
        if not tasksetdata.ordered_story_setpieces then
            tasksetdata.ordered_story_setpieces = {}
        end
        table.insert(tasksetdata.ordered_story_setpieces,adventureportal)
        tasksetdata.tasks = {"Tentacle-Blocked Spider Swamp"}
        tasksetdata.numoptionaltasks = 0
        tasksetdata.optionaltasks = {}
        tasksetdata.set_pieces = {
            ["ResurrectionStoneWinter"] = { count=1, tasks={"Tentacle-Blocked Spider Swamp"}},
            -- ["InsanePighouse"] = { count=1, tasks={"Tentacle-Blocked Spider Swamp"}},
            -- ["PigTown"] = { count=1, tasks={"Tentacle-Blocked Spider Swamp"}},
        }
        tasksetdata.required_prefabs = {"spawnpoint_master","adventure_portal"}
        tasksetdata.substitutes = GetRandomSubstituteList(SUBS_1, 1)
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
        }
    elseif GLOBAL.OVERRIDELEVEL_GEN==1 then
        tasksetdata.numoptionaltasks = 4
        tasksetdata.tasks = {"Make a pick","Easy Blocked Dig that rock","Great Plains","Guarded Speak to the king",}
        tasksetdata.optionaltasks = {"Waspy Beeeees!","Guarded Squeltch","Guarded Forest hunters","Befriend the pigs","Guarded For a nice walk","Walled Kill the spiders","Killer bees!",
            "Make a Beehat","Waspy The hunters","Hounded Magic meadow","Wasps and Frogs and bugs","Guarded Walrus Desolate",}
        tasksetdata.set_pieces = {                
                -- ["WesUnlock"] = { restrict_to="background", tasks= adventure1_setpieces_tasks},
                ["ResurrectionStoneWinter"] = { count=1, tasks=adventure1_setpieces_tasks},
            }
        tasksetdata.substitutes = GetRandomSubstituteList(SUBS_1, 1)
        tasksetdata.ordered_story_setpieces = teleportato_layouts
        tasksetdata.required_prefabs = required_prefabs
        tasksetdata.overrides={
            world_size  =  "default",
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
        }
    elseif GLOBAL.OVERRIDELEVEL_GEN==2 then
        tasksetdata.numoptionaltasks = 2
        tasksetdata.tasks = {"Resource-rich Tier2","Sanity-Blocked Great Plains","Hounded Greater Plains","Insanity-Blocked Necronomicon",}
        tasksetdata.optionaltasks = {"Walrus Desolate","Walled Kill the spiders","The Deep Forest","Forest hunters",}
        tasksetdata.set_pieces = {                
                -- ["WesUnlock"] = { restrict_to="background", tasks={ "Hounded Greater Plains", "Walrus Desolate", "Walled Kill the spiders", "The Deep Forest", "Forest hunters" }},
                ["ResurrectionStoneWinter"] = { count=1, tasks={"Resource-rich Tier2","Sanity-Blocked Great Plains","Hounded Greater Plains","Insanity-Blocked Necronomicon", 
														"Walrus Desolate","Walled Kill the spiders","The Deep Forest","Forest hunters"}},
                ["MacTuskTown"] = { tasks={"Insanity-Blocked Necronomicon", "Hounded Greater Plains", "Sanity-Blocked Great Plains"} },
            }
        tasksetdata.substitutes = GetRandomSubstituteList(SUBS_1, 1)
        tasksetdata.ordered_story_setpieces = teleportato_layouts
        tasksetdata.required_prefabs = required_prefabs
        tasksetdata.overrides={
            world_size = "default",
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
		}
    elseif GLOBAL.OVERRIDELEVEL_GEN==3 then -- The Game is Afoot
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
        tasksetdata.substitutes = GetRandomSubstituteList(SUBS_1, 3)
        tasksetdata.ordered_story_setpieces = teleportato_layouts
        tasksetdata.required_prefabs = required_prefabs
        tasksetdata.overrides={
			day = "longdusk", 

			season_start = "winter",
			spiders = "often",
            world_size = "default",
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
		}
    elseif GLOBAL.OVERRIDELEVEL_GEN==4 then -- Archipel
                
        tasksetdata.numoptionaltasks = 0
        tasksetdata.tasks = {"IslandHop_Start","IslandHop_Hounds","IslandHop_Forest","IslandHop_Savanna","IslandHop_Rocky","IslandHop_Merm",}
        tasksetdata.optionaltasks = {}
        -- tasksetdata.optionaltasks = {"The hunters","Trapped Forest hunters","Wasps and Frogs and bugs","Tentacle-Blocked The Deep Forest","Hounded Greater Plains","Merms ahoy",}
        tasksetdata.set_pieces = {                
                -- ["WesUnlock"] = { restrict_to="background", tasks={ "IslandHop_Start", "IslandHop_Hounds", "IslandHop_Forest", "IslandHop_Savanna", "IslandHop_Rocky", "IslandHop_Merm" } },
                -- ["Wormhole_Mod"] = { count= 1, tasks={ "IslandHop_Start", "IslandHop_Hounds", "IslandHop_Forest", "IslandHop_Savanna", "IslandHop_Rocky", "IslandHop_Merm" } },
            }
        tasksetdata.substitutes = GetRandomSubstituteList(SUBS_1, 3)
        tasksetdata.ordered_story_setpieces = teleportato_layouts
        tasksetdata.required_prefabs = required_prefabs
        tasksetdata.overrides={
            -- loop  =  "always",
			-- branching  =  "never",   -- hilft leider auch nicht -.-
        
        
			islands = "always",	
			roads = "never",	
			weather = (GetModConfigData("difficulty")==0 and "default") or (GetModConfigData("difficulty")==1 and "rare") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "often") or "default",
            deerclops = (GetModConfigData("difficulty")==0 and "default") or (GetModConfigData("difficulty")==1 and "rare") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "often") or "default",
            dragonfly  =  "never",
            bearger  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
            goosemoose  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
            season_start = "default",
            wormhole_prefab = "wormhole",
            -- layout_mode = "LinkNodesByKeys",
            layout_mode = "RestrictNodesByKey",
            start_location = "adv4",
            autumn = "shortseason",
            winter = "shortseason",
            spring = "shortseason",
            summer = "shortseason",
		}
    elseif GLOBAL.OVERRIDELEVEL_GEN==5 then -- Two Worlds
        tasksetdata.override_level_string=true -- test out what this does ?
        tasksetdata.tasks = {"Land of Plenty", -- Part 1 - Easy peasy - lots of stuff
                            "The other side",}	-- Part 2 - Lets kill them off
        -- tasksetdata.numoptionaltasks = 4 -- evlt vllt doch 0, mal Beschreibung genauer lesen, was darin vorkommen sollte...
        -- tasksetdata.optionaltasks = {"Befriend the pigs","For a nice walk","Kill the spiders","Killer bees!","Make a Beehat",
				-- "The hunters","Magic meadow","Frogs and bugs",} -- in adventure.lua keine optionaltasks definiert. Aber wenn es 0 sein sollte, würde das da stehen, also vermutlich default werte? 
        tasksetdata.numoptionaltasks = 0
        tasksetdata.optionaltasks = {}
        tasksetdata.set_pieces = {                
                ["MaxPigShrine"] = {tasks={"Land of Plenty"}},
                ["MaxMermShrine"] = {tasks={"The other side"}},
                ["ResurrectionStone"] = { count=2, tasks={"Land of Plenty", "The other side" } },}
        tasksetdata.substitutes = GetRandomSubstituteList(SUBS_1, 3)
        tasksetdata.ordered_story_setpieces = teleportato_layouts
        table.insert(required_prefabs,"pigking") -- this level should have a pigking
        tasksetdata.required_prefabs = required_prefabs
        tasksetdata.overrides={
			day  =  (GetModConfigData("difficulty")==0 and "default") or (GetModConfigData("difficulty")==1 and "longday") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "longdusk") or "default", 
			season_start  =  "autumn",
			
            weather = (GetModConfigData("difficulty")==0 and "rare") or (GetModConfigData("difficulty")==1 and "rare") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "often") or "rare", 
            
			islands  =  "always",	
			roads  =  "never",	
            dragonfly  =  "never",
            bearger  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
            goosemoose  =  "never",
            world_size = "default",
            wormhole_prefab = "wormhole",
            layout_mode = "LinkNodesByKeys",
            start_location = "adv5",
            autumn = (GetModConfigData("difficulty")==1 and "veryshortseason") or "noseason",
            winter = "noseason",
            spring = "noseason",
            summer = "verylongseason",
		}
		-- tasksetdata.override_triggers = {
			-- ["START"] = {	-- Quick (localised) fix for area-aware bug #677
									-- {"weather", "never"}, 
									-- {"day", "longday"},
							 	-- },
			-- ["Land of Plenty"] = {	
									-- {"weather", "never"},   -- testen ob und wie sowas funktioniert... wird wohl wetter und tag wechsel sein, der erwähnt wurde... in mehrspieler ist das natürlich schwer umsetzbar
									-- {"day", "longday"},
							 	-- },
			-- ["The other side"] = {	
									-- {"weather", "often"}, 
									-- {"day", "longdusk"},
							 	-- },
		-- }
    elseif GLOBAL.OVERRIDELEVEL_GEN==6 then -- Darkness
        tasksetdata.tasks = {"Swamp start","Battlefield","Walled Kill the spiders","Sanity-Blocked Spider Queendom",}
        tasksetdata.numoptionaltasks = 2
        tasksetdata.optionaltasks = {"Killer bees!","Chessworld","Tentacle-Blocked The Deep Forest","Tentacle-Blocked Spider Swamp",
			"Trapped Forest hunters","Waspy The hunters","Hounded Magic meadow",}
        tasksetdata.set_pieces = {
                ["RuinedBase"] = {tasks={"Swamp start", "Battlefield", "Walled Kill the spiders", "Killer bees!"}},
                ["ResurrectionStoneLit"] = { count=4, tasks={"Swamp start", "Battlefield", "Walled Kill the spiders", "Sanity-Blocked Spider Queendom","Killer bees!",
                "Chessworld","Tentacle-Blocked The Deep Forest", "Tentacle-Blocked Spider Swamp","Trapped Forest hunters","Waspy The hunters","Hounded Magic meadow", }},}
        tasksetdata.substitutes = GLOBAL.MergeMaps( {["pighouse"] = {perstory=1,weight=1,pertask=1}},GetRandomSubstituteList(SUBS_1, 3) )
        tasksetdata.ordered_story_setpieces = teleportato_layouts
        tasksetdata.required_prefabs = required_prefabs
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
            dragonfly  =  "never",
            bearger  =  (GetModConfigData("difficulty")==0 and "never") or (GetModConfigData("difficulty")==1 and "never") or (GetModConfigData("difficulty")==2 and "rare") or (GetModConfigData("difficulty")==3 and "default") or "never",
            goosemoose  =  "never",
            world_size = "default",
            wormhole_prefab = "wormhole",
            layout_mode = "LinkNodesByKeys",
            start_location = "adv6",
            autumn = (GetModConfigData("difficulty")==0 and "noseason") or (GetModConfigData("difficulty")==1 and "shortseason") or (GetModConfigData("difficulty")==2 and "veryshortseason") or (GetModConfigData("difficulty")==3 and "noseason") or "noseason",
            winter = "noseason",
            spring = "noseason",
            summer = (GetModConfigData("difficulty")==0 and "verylongseason") or (GetModConfigData("difficulty")==1 and "shortseason") or (GetModConfigData("difficulty")==2 and "default") or (GetModConfigData("difficulty")==3 and "verylongseason"),
		}
    elseif GLOBAL.OVERRIDELEVEL_GEN==7 then
        tasksetdata.nomaxwell=true
        tasksetdata.hideminimap = true
		tasksetdata.teleportaction = "restart"
        tasksetdata.teleportmaxwell = "ADVENTURE_6_TELEPORTFAIL"
        tasksetdata.tasks = {"MaxHome"}--,"Make a pick",}
        tasksetdata.valid_start_tasks = {"MaxHome",}  
        tasksetdata.numoptionaltasks = 0
        tasksetdata.optionaltasks = {}
        tasksetdata.set_pieces = {} -- vermutlich keine
        tasksetdata.required_prefabs = {}
        tasksetdata.overrides={
            start_location = "adv7",  --- wenn wir keine startlocation zufügen, wird default verwendet, welches default setpiece und clearing verwendet, welches ein multiplayer portal beinhaltet.
            wormhole_prefab = "wormhole",
            layout_mode = "LinkNodesByKeys",  
            -- layout_mode = "RestrictNodesByKey",
			day  =  "onlynight", 
			weather  =  "never",
			creepyeyes  =  "always",
			waves  =  "off",
			boons  =  "never",
            deerclops = "never",
            dragonfly  =  "never",
            bearger  =  "never",
            goosemoose  =  "never",
            world_size = "default",
            autumn = "verylongseason", -- only summer would be rubbish
            winter = "noseason",
            spring = "noseason",
            summer = "noseason",
		}
        -- tasksetdata.override_triggers = {
			-- ["MaxHome"] = {	
				-- {"areaambient", "VOID"}, 
			-- },
		-- }
    end
end)


