local _G = GLOBAL
local require = _G.require
local StaticLayout = require("map/static_layout")

local function GetStaticLayout(name)
    return StaticLayout.Get("map/static_layouts/"..name, {
            start_mask = _G.PLACE_MASK.IGNORE_IMPASSABLE_BARREN,
            fill_mask = _G.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,})
end

-- load some custom layouts
local LLayouts = _G.require("map/layouts").Layouts
LLayouts["WesUnlock"] = GetStaticLayout("wes_unlock")
LLayouts["TeleportatoRingLayoutSanityRocks"] = _G.require("map/layouts/TeleportatoRingLayoutSanityRocks")
LLayouts["DefaultStartMaxwellHome"] = GetStaticLayout("default_startmaxwellhome")
LLayouts["AdventurePortalLayoutNew"] = GetStaticLayout("adventure_portal_layoutnew")
LLayouts["NightmareStart_new"] = GetStaticLayout("nightmare_new") -- added spawnpoint_master and removed items, since items are now contributed for each player in modmain
LLayouts["PreSummerStart_new"] = GetStaticLayout("presummer_start_new") -- also the not "new" files got a spawnpoint_master, but kept items, to allow DS like mode.
LLayouts["WinterStartEasy_new"] = GetStaticLayout("winter_start_easy_new")
LLayouts["BargainStart_new"] = GetStaticLayout("bargain_start_new")
LLayouts["WinterStartMedium_new"] = GetStaticLayout("winter_start_medium_new")
LLayouts["Wormhole_Mod"] = GetStaticLayout("wormhole_mod") -- just a single wormhole
LLayouts["Wormhole_Mod2"] = GetStaticLayout("wormhole_mod") -- just a single wormhole
LLayouts["Wormhole_Mod3"] = GetStaticLayout("wormhole_mod") -- just a single wormhole

LLayouts["NightmareStartFixed"] = GetStaticLayout("nightmare_fixed") -- original except necessary adjustments

LLayouts["PreSummerStartFixed"] = GetStaticLayout("presummer_start_fixed") 
LLayouts["WinterStartEasyFixed"] = GetStaticLayout("winter_start_easy_fixed")
LLayouts["BargainStartFixed"] = GetStaticLayout("bargain_start_fixed")
LLayouts["WinterStartMediumFixed"] = GetStaticLayout("winter_start_medium_fixed")
LLayouts["ThisMeansWarStartFixed"] = GetStaticLayout("thismeanswar_start_fixed")
LLayouts["MaxwellHomeFixed"] = StaticLayout.Get("map/static_layouts/maxwellhome_fixed", {
                            areas = 
                            {                               
                                barren_area = function(area) return _G.PickSomeWithDups( 0.5 * area
                                    , {"marsh_tree", "marsh_bush", "rock1", "rock2", "evergreen_burnt", "evergreen_stump"}) end,
                                gold_area = function() return _G.PickSomeWithDups(math.random(15,20), {"goldnugget"}) end,
                                livinglog_area = function() return _G.PickSomeWithDups(math.random(5, 10), {"livinglog"}) end,
                                nightmarefuel_area = function() return _G.PickSomeWithDups(math.random(5, 10), {"nightmarefuel"}) end,
                                deadlyfeast_area = function() return _G.PickSomeWithDups(math.random(25,30), {"monstermeat", "green_cap", "red_cap", "spoiled_food", "meat"}) end,
                                marblegarden_area = function(area) return _G.PickSomeWithDups(1.5*area, {"marbletree", "flower_evil"}) end,
                            },
                            start_mask = _G.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
                            fill_mask = _G.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
                            layout_position = _G.LAYOUT_POSITION.CENTER,
                            disable_transform = true
                        })

AddRoomPreInit("MaxHome", function(room) room.contents.countstaticlayouts = {["MaxwellHomeFixed"] = 1} end)

local start1 = "WinterStartEasy_new"
local start2 = "WinterStartMedium_new"
local start3 = "PreSummerStart_new"
local start4 = "ThisMeansWarStartFixed"--"DefaultStart" --"ThisMeansWarStart" gibts kein new
local start5 = "BargainStart_new"
local start6 = "NightmareStart_new"
local start7 = "DefaultStartMaxwellHome" -- ist new, gibts kein alt
if GetModConfigData("difficulty")==0 then -- DS
    start1 = "WinterStartEasyFixed"
    start2 = "WinterStartMediumFixed"
    start3 = "PreSummerStartFixed"
    start4 = "ThisMeansWarStartFixed"--"DefaultStart" 
    start5 = "BargainStartFixed"
    start6 = "NightmareStartFixed"
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
    start_setpeice  =  start7,  -- for some reason a portal has to exist... but I removed spawnpoint, so the start position is right
    start_node  =  "MaxHome",  
})

local blockersets = require("map/blockersets")
AddRoom("advSpiderForest", {
					colour={r=.80,g=0.34,b=.80,a=.50},
					value = GROUND.FOREST,
					tags = {"ExitPiece", "Chester_Eyebone"},
					contents =  {
					                distributepercent = .2,
					                distributeprefabs=
					                {
					                    evergreen_sparse = 6,
					                    rock1 = 0.05,
					                    sapling = .05,
										twiggytree = 0.05,
										ground_twigs = 0.03,						                    
										spiderden = 0.05, -- instead of 1, to reduce lag
					                },
									prefabdata = {
										spiderden = function() if math.random() < 0.2 then
																	return { growable={stage=2}}
																else
																	return { growable={stage=1}}
																end
															end,
									},
					            }
					})
AddRoom("advSpiderCity", { -- custom with less spiders to reduce lags
					colour={r=.30,g=.20,b=.50,a=.50},
					value = _G.GROUND.FOREST,
					contents =  {
					                countprefabs= {
                                        goldnugget = function() return 3 + math.random(3) end,
					                },
									distributepercent = 0.3,
					                distributeprefabs = {
					                    evergreen_sparse = 3,
					                    spiderden = 0.1, -- instead of 0.3
					                },
									prefabdata = {
										spiderden = function() if math.random() < 0.5 then -- instead of 0.2 so more lvl 3
																	return { growable={stage=3}}
																else
																	return { growable={stage=2}}
																end
															end,
									},
					            }
					})
AddTask("advSanity-Blocked Spider Queendom", {
		locks={_G.LOCKS.PIGKING,_G.LOCKS.SPIDERDENS,_G.LOCKS.ADVANCED_COMBAT,_G.LOCKS.TIER5},
		keys_given={_G.KEYS.SPIDERS,_G.KEYS.HARD_SPIDERS,_G.KEYS.TIER5,_G.KEYS.TRINKETS},
		entrance_room=blockersets.all_walls,
		room_choices={
			["advSpiderCity"] = 4,
			["Graveyard"] = 1,
			["CrappyDeepForest"] = 2,
		}, 
		room_bg=_G.GROUND.FOREST,
		background_room="advSpiderForest",
		colour={r=1,g=1,b=0,a=1}
	})
    
AddRoom("advSpiderMarsh", {
					colour={r=.45,g=.75,b=.45,a=.50},
					value = _G.GROUND.MARSH,
					tags = {"ExitPiece", "Chester_Eyebone"},
					contents =  {
					                distributepercent = .1,
					                distributeprefabs=
					                {
					                    evergreen = 1.0,
					                    tentacle = 2,
					                    pond_mos = 0.1,
					                    blue_mushroom = 0.1,
					                    reeds =  4,
					                    spiderden=1.0, -- instead 3.15 to reduce lag
					                },
									prefabdata = {
										spiderden = function() if math.random() < 0.5 then -- instead 0.2, less but bigger ones
																	return { growable={stage=2}}
																else
																	return { growable={stage=1}}
																end
															end,
									},
					            }
					})
AddTask("advTentacle-Blocked Spider Swamp", {
		locks={_G.LOCKS.SPIDERDENS,_G.LOCKS.BASIC_COMBAT,_G.LOCKS.TIER3},
		keys_given={_G.KEYS.MEAT,_G.KEYS.TENTACLES,_G.KEYS.SPIDERS,_G.KEYS.TIER3,_G.KEYS.GOLD},
		entrance_room=blockersets.all_tentacles,
		room_choices={
			["SpiderVillageSwamp"] = 1,
			["advSpiderMarsh"] = function() return 2+math.random(_G.SIZE_VARIATION) end, 
			["Forest"] = 2,
		},
		room_bg=_G.GROUND.MARSH,
		background_room="BGMarsh",
		colour={r=.5,g=.05,b=.05,a=1}
	}) 