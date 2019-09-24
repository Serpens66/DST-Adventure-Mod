local assets =
{
	Asset("IMAGE", "images/colour_cubes/day05_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/dusk03_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/night03_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/snow_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/snowdusk_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/night04_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/insane_day_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/insane_dusk_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/insane_night_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/summer_day_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/summer_dusk_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/summer_night_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/spring_day_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/spring_dusk_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/spring_night_cc.tex"),
	Asset("IMAGE", "images/colour_cubes/purple_moon_cc.tex"),

    Asset("ANIM", "anim/snow.zip"),
    Asset("ANIM", "anim/lightning.zip"),
    Asset("ANIM", "anim/splash_ocean.zip"),
    Asset("ANIM", "anim/frozen.zip"),

    Asset("SOUND", "sound/forest_stream.fsb"),
    Asset("SOUND", "sound/amb_stream.fsb"),

	Asset("IMAGE", "levels/textures/snow.tex"),
	Asset("IMAGE", "levels/textures/mud.tex"),
	Asset("IMAGE", "images/wave.tex"),

	-- Dependency stuff
	Asset("SCRIPT", "scripts/prefabs/devtool.lua"),
	Asset("SCRIPT", "scripts/prefabs/DLC0001.lua"),
	Asset("SCRIPT", "scripts/prefabs/brokenwalls.lua"),
	Asset("SCRIPT", "scripts/prefabs/player_common.lua"),

	-- Those are mostly Base game items. They need to be referenced here for the build process to work properly
	Asset("INV_IMAGE", "abigail_flower"),
    Asset("INV_IMAGE", "abigail_flower2"),
    Asset("INV_IMAGE", "abigail_flower_haunted"),
    Asset("INV_IMAGE", "accomplishment_shrine"),
    Asset("INV_IMAGE", "armormarble"),
    Asset("INV_IMAGE", "armorsnurtleshell"),
    Asset("INV_IMAGE", "axe"),
    Asset("INV_IMAGE", "bag"),
    Asset("INV_IMAGE", "bandage"),
   	Asset("INV_IMAGE", "bat"),
   	Asset("INV_IMAGE", "batbat"),
   	Asset("INV_IMAGE", "beemine"),
    Asset("INV_IMAGE", "sunken_boat_trinket_1"),
    Asset("INV_IMAGE", "sunken_boat_trinket_2"),
    Asset("INV_IMAGE", "sunken_boat_trinket_3"),
    Asset("INV_IMAGE", "sunken_boat_trinket_4"),
    Asset("INV_IMAGE", "sunken_boat_trinket_5"),
    Asset("INV_IMAGE", "teleportato_base"),
	Asset("INV_IMAGE", "teleportato_box"),
	Asset("INV_IMAGE", "teleportato_box_adv"),
	Asset("INV_IMAGE", "teleportato_crank"),
	Asset("INV_IMAGE", "teleportato_crank_adv"),
	Asset("INV_IMAGE", "teleportato_potato"),
	Asset("INV_IMAGE", "teleportato_potato_adv"),
	Asset("INV_IMAGE", "teleportato_ring"),
	Asset("INV_IMAGE", "teleportato_ring_adv"),
	Asset("INV_IMAGE", "chester_eyebone"),
    Asset("INV_IMAGE", "chester_eyebone_closed"),
    Asset("INV_IMAGE", "chester_eyebone_closed_shadow"),
    Asset("INV_IMAGE", "chester_eyebone_closed_snow"),
    Asset("INV_IMAGE", "chester_eyebone_shadow"),
    Asset("INV_IMAGE", "chester_eyebone_snow"),
    Asset("INV_IMAGE", "book_birds"),
    Asset("INV_IMAGE", "book_brimstone"),
    Asset("INV_IMAGE", "book_gardening"),
    Asset("INV_IMAGE", "book_sleep"),
    Asset("INV_IMAGE", "book_tentacles"),
    Asset("INV_IMAGE", "skull_wallace"),
	Asset("INV_IMAGE", "skull_waverly"),
	Asset("INV_IMAGE", "skull_webber"),
	Asset("INV_IMAGE", "skull_wilbur"),
	Asset("INV_IMAGE", "skull_wilton"),
	Asset("INV_IMAGE", "skull_winnie"),
	Asset("INV_IMAGE", "skull_wortox"),
	Asset("INV_IMAGE", "phonograph"),
	Asset("INV_IMAGE", "record_01"),
	Asset("INV_IMAGE", "record_02"),
	Asset("INV_IMAGE", "record_03"),
	Asset("INV_IMAGE", "nightmare_timepiece"),
    Asset("INV_IMAGE", "nightmare_timepiece_nightmare"),
    Asset("INV_IMAGE", "nightmare_timepiece_warn"),
    Asset("INV_IMAGE", "trunk_cooked"),
    Asset("INV_IMAGE", "trunk_summer"),
    Asset("INV_IMAGE", "trunk_winter"),
    Asset("INV_IMAGE", "beardhair"),
    Asset("INV_IMAGE", "beard_monster"),
    Asset("INV_IMAGE", "birdtrap"),
    Asset("INV_IMAGE", "bucket"),
    Asset("INV_IMAGE", "walrushat"),
    Asset("INV_IMAGE", "walrus_tusk"),
    Asset("INV_IMAGE", "lucy"),
    Asset("INV_IMAGE", "slurper"),
    Asset("INV_IMAGE", "slurper_pelt"),
    Asset("INV_IMAGE", "slurtle_shellpieces"),
    Asset("INV_IMAGE", "goldenaxe"),
    Asset("INV_IMAGE", "goldenpickaxe"),
    Asset("INV_IMAGE", "goldenshovel"),
    Asset("INV_IMAGE", "stopwatch"),
    Asset("INV_IMAGE", "compass"),
    Asset("INV_IMAGE", "eyeturret_item"),
    Asset("INV_IMAGE", "seeds"),
    Asset("INV_IMAGE", "seeds_cooked"),
    Asset("INV_IMAGE", "boomerang"),
    Asset("INV_IMAGE", "bugnet"),
    Asset("INV_IMAGE", "truffle"),
    Asset("INV_IMAGE", "ruins_bat"),
    Asset("INV_IMAGE", "campfire"),
    Asset("INV_IMAGE", "clothes"),
    Asset("INV_IMAGE", "mandrake"),
    Asset("INV_IMAGE", "cookedmandrake"),
    Asset("INV_IMAGE", "sewing_kit"),
    Asset("INV_IMAGE", "cane"),
    Asset("INV_IMAGE", "diviningrod"),
    Asset("INV_IMAGE", "fishingrod"),
    Asset("INV_IMAGE", "healingsalve"),
    Asset("INV_IMAGE", "honey"),
    Asset("INV_IMAGE", "honeycomb"),
    Asset("INV_IMAGE", "horn"),
    Asset("INV_IMAGE", "houndstooth"),
    Asset("INV_IMAGE", "spear"),
    Asset("INV_IMAGE", "stinger"),
    Asset("INV_IMAGE", "tentaclespike"),
    Asset("INV_IMAGE", "pickaxe"),
    Asset("INV_IMAGE", "pigskin"),
    Asset("INV_IMAGE", "pitchfork"),
    Asset("INV_IMAGE", "shovel"),
    Asset("INV_IMAGE", "razor"),
    Asset("INV_IMAGE", "snowball"),
    Asset("INV_IMAGE", "trap"),
    Asset("INV_IMAGE", "trap_teeth"),
    Asset("INV_IMAGE", "scarecrow"),
    Asset("INV_IMAGE", "lantern_lit"),
    Asset("INV_IMAGE", "lantern"),
    Asset("INV_IMAGE", "lightbulb"),
    Asset("INV_IMAGE", "minotaurhorn"),
    Asset("INV_IMAGE", "mosquitosack"),
    Asset("INV_IMAGE", "multitool_axe_pickaxe"),
    Asset("INV_IMAGE", "nightmarefuel"),
    Asset("INV_IMAGE", "pumpkin_lantern"),
    Asset("INV_IMAGE", "eyebrella"),
    Asset("INV_IMAGE", "slurtlehat"),

	Asset("INV_IMAGE", "saddle_basic"),
    Asset("INV_IMAGE", "saddle_war"),
	Asset("INV_IMAGE", "saddle_race"),
	Asset("INV_IMAGE", "brush"),
	Asset("INV_IMAGE", "saddlehorn"),
	Asset("INV_IMAGE", "phlegm"),
	Asset("INV_IMAGE", "steelwool"),

	Asset("INV_IMAGE", "waxpaper"),
	Asset("INV_IMAGE", "beeswax"),
	Asset("INV_IMAGE", "bundle_large"),	
	Asset("INV_IMAGE", "bundle_medium"),
	Asset("INV_IMAGE", "bundle_small"),		
	Asset("INV_IMAGE", "bundlewrap"),

	Asset("INV_IMAGE", "fence_item"),		
	Asset("INV_IMAGE", "fence_gate_item"),

    Asset("MINIMAP_IMAGE", "portal"),
    Asset("MINIMAP_IMAGE", "Willow"),
	Asset("MINIMAP_IMAGE", "Wilton"),
	Asset("MINIMAP_IMAGE", "parrot_pirate"),
	Asset("MINIMAP_IMAGE", "wheat"),
	Asset("MINIMAP_IMAGE", "winnie"),
	Asset("MINIMAP_IMAGE", "wortox"),
	Asset("MINIMAP_IMAGE", "phonograph"),
	Asset("MINIMAP_IMAGE", "pond"),
	Asset("MINIMAP_IMAGE", "pond_cave"),
	Asset("MINIMAP_IMAGE", "pond_mos"),
	Asset("MINIMAP_IMAGE", "abigail_flower"),
	Asset("MINIMAP_IMAGE", "accomplishment_shrine"),
	Asset("MINIMAP_IMAGE", "mushroom_tree"),
	Asset("MINIMAP_IMAGE", "mushroom_tree_med"),
	Asset("MINIMAP_IMAGE", "mushroom_tree_small"),
	Asset("MINIMAP_IMAGE", "basalt"),
	Asset("MINIMAP_IMAGE", "batcave"),
	Asset("MINIMAP_IMAGE", "beemine"),
	Asset("MINIMAP_IMAGE", "birdtrap"),
	Asset("MINIMAP_IMAGE", "bulb_plant"),
	Asset("MINIMAP_IMAGE", "cave_banana_tree"),
	Asset("MINIMAP_IMAGE", "chester"),
	Asset("MINIMAP_IMAGE", "chestershadow"),
	Asset("MINIMAP_IMAGE", "chestersnow"),
	Asset("MINIMAP_IMAGE", "gravestones"),
	Asset("MINIMAP_IMAGE", "statue"),
	Asset("MINIMAP_IMAGE", "statue_small"),
	Asset("MINIMAP_IMAGE", "marbletree"),
	Asset("MINIMAP_IMAGE", "pigking"),
	Asset("MINIMAP_IMAGE", "rabbittrap"),
	Asset("MINIMAP_IMAGE", "wormhole"),
	Asset("MINIMAP_IMAGE", "wormhole_sick"),
	Asset("MINIMAP_IMAGE", "whitespider_den"),
	Asset("MINIMAP_IMAGE", "stalagmite"),
	Asset("MINIMAP_IMAGE", "stalagmite_tall"),
	Asset("MINIMAP_IMAGE", "rock"),
	Asset("MINIMAP_IMAGE", "rock_flintless"),
	Asset("MINIMAP_IMAGE", "tentapillar"),
	Asset("MINIMAP_IMAGE", "slurtle_den"),
	Asset("MINIMAP_IMAGE", "diviningrod"),
	Asset("MINIMAP_IMAGE", "eyeball_turret"),
	Asset("MINIMAP_IMAGE", "eyeplant"),
	Asset("MINIMAP_IMAGE", "livingtree"),
	Asset("MINIMAP_IMAGE", "lucy_axe"),
	Asset("MINIMAP_IMAGE", "marblepillar"),
	Asset("MINIMAP_IMAGE", "maxwelltorch"),
	Asset("MINIMAP_IMAGE", "nightmarelight"),
	Asset("MINIMAP_IMAGE", "obelisk"),
	Asset("MINIMAP_IMAGE", "teleportato"),
	Asset("MINIMAP_IMAGE", "toothtrap"),
	Asset("MINIMAP_IMAGE", "wasphive"),
	Asset("MINIMAP_IMAGE", "cave_closed"),	
	Asset("MINIMAP_IMAGE", "cave_open"),	
	Asset("MINIMAP_IMAGE", "cave_open2"),	
}

local forest_prefabs = 
{
	"world",
	"adventure_portal",
	"resurrectionstone",
    "deerclops",
    "gravestone",
    "flower",
    "animal_track",
    "dirtpile",
    "beefaloherd",
    "beefalo",
    "penguinherd",
    "penguin_ice",
    "penguin",
    "koalefant_summer",
    "koalefant_winter",
    "beehive",
	"wasphive",
    "walrus_camp",
    "pighead",
    "mermhead",
    "rabbithole",
    "molehill",
    "carrot_planted",
    "tentacle",
	"wormhole",
    "cave_entrance",
	"teleportato_base",
	"teleportato_ring",
	"teleportato_box",
	"teleportato_crank",
	"teleportato_potato",
	"pond", 
	"marsh_tree", 
	"marsh_bush", 
	"reeds", 
	"mist",
	"snow",
	"rain",
	"maxwellthrone",
	"maxwellendgame",
	"maxwelllight",
	"horizontal_maxwelllight",	
	"vertical_maxwelllight",	
	"quad_maxwelllight",	
	"area_maxwelllight",
	"maxwelllock",
	"maxwellphonograph",
	"puppet_wilson",
	"puppet_willow",
	"puppet_wendy",
	"puppet_wickerbottom",
	"puppet_wolfgang",
	"puppet_wx78",
	"puppet_wes",
	"marblepillar",
	"marbletree",
	"statueharp",
	"statuemaxwell",
	"eyeplant",
	"lureplant",
	"purpleamulet",
	"monkey",
	"livingtree",
	"tumbleweed",
	"rock_ice",
	"catcoonden",
	"bigfoot",
    "sunken_boat",
    "flotsam",

    -- Here for dependency issues
    "guano",
	"krampus_sack",
	"lavalight",
	"nitre",
	"pollen",
	"rubble",
	"shock_fx",
	"slurtleslime",
	"wormlight",
	"tumbleweedspawner",
	"lightninggoatherd",
	"mosslingherd",

	"spat",
}

local function OnSeasonChange(inst, data)
	if data.season == "spring" then
		inst.Map:SetOverlayTexture( "levels/textures/mud.tex" )
		inst.Map:SetOverlayColor0( 11/255,15/255,23/255,.30 )
		inst.Map:SetOverlayColor1( 11/255,15/255,23/255,.20 )
		inst.Map:SetOverlayColor2( 11/255,15/255,23/255,.12 )
	elseif data.season == "winter" then
		inst.Map:SetOverlayTexture( "levels/textures/snow.tex" )
		inst.Map:SetOverlayColor0( 1,1,1,1 )
		inst.Map:SetOverlayColor1( 1,1,1,1 )
		inst.Map:SetOverlayColor2( 1,1,1,1 )
	end
end

local function fn(Sim)

	local inst = SpawnPrefab("world")
	inst.prefab = "forest"
	inst.entity:SetCanSleep(false)	
	
	--add waves
	local waves = inst.entity:AddWaveComponent()
    inst.WaveComponent:SetRegionSize(13.5, 2.5)						-- wave texture u repeat, forward distance between waves
    inst.WaveComponent:SetWaveSize(80, 3.5)							-- wave mesh width and height
	waves:SetWaveTexture( "images/wave.tex" )

	-- See source\game\components\WaveRegion.h
	waves:SetWaveEffect( "shaders/waves.ksh" ) -- texture.ksh
	--waves:SetWaveEffect( "shaders/texture.ksh" ) -- 

    inst:AddComponent("clock")
	inst:AddComponent("seasonmanager")
	inst:DoTaskInTime(0, function(inst) inst.components.seasonmanager:SetOverworld() end)
    inst:AddComponent("flowerspawner")
    inst:AddComponent("lureplantspawner")
    inst:AddComponent("birdspawner")
    inst:AddComponent("butterflyspawner")
	inst:AddComponent("hounded")
	inst:AddComponent("hunter")
	inst:AddComponent("worlddeciduoustreeupdater")
	
	inst:AddComponent("basehassler")
	local hasslers = require("basehasslers")
	for k,v in pairs(hasslers) do
		inst.components.basehassler:AddHassler(k, v)
	end	

    inst.components.butterflyspawner:SetButterfly("butterfly")

    inst:AddComponent("worldwind")

	inst:AddComponent("frograin")
	inst:AddComponent("bigfooter")
	inst:AddComponent("penguinspawner")

	inst:AddComponent("colourcubemanager")
	inst.Map:SetOverlayTexture( "levels/textures/snow.tex" )
	inst.Map:SetOverlayColor0( 1,1,1,1 )
	inst.Map:SetOverlayColor1( 1,1,1,1 )
	inst.Map:SetOverlayColor2( 1,1,1,1 )

	inst:ListenForEvent("seasonChange", OnSeasonChange)

    return inst
end

return Prefab( "worlds/forest", fn, assets, forest_prefabs) 
