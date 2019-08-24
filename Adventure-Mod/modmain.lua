-- maxwell phonograph, mod by DoktorHolmes
-- maxwell light and throne, mod by Leonardo Coxington
-- and my own work..

print("HIER modmain adv")

PrefabFiles = { 
	"maxwellphonograph",
    "maxwelllight_p",
	"maxwelllight_flame",
	-- "maxwellthrone_p",
    "maxwellthrone",	
    "paired_maxwelllight",
    "maxwell",
    "maxwellendgame",
    "maxwellhead",
    "maxwellhead_trigger",
    "maxwellintro",
    "maxwellkey",
    "maxwelllock",
    "diviningrodstart",
    "teleportato_checkmate",
    "teleportlocation",
    "puppet",     -- causes crash, because warly and new characters can not be loaded.
}
Assets = {
	Asset("ANIM", "anim/phonograph.zip"),
	-- Asset("SOUND", "sound/phonograph.fsb"),
	-- Asset("SOUNDPACKAGE", "sound/phonograph.fev"),
	Asset("ATLAS", "images/inventoryimages/Gramophone.xml"),
    Asset("IMAGE", "images/inventoryimages/Gramophone.tex"),
    ----------------------------------------------------
    Asset( "IMAGE", "images/map_icons/evilthrone.tex" ),
	Asset( "ATLAS", "images/map_icons/evilthrone.xml" ),
	Asset( "IMAGE", "images/map_icons/evillight.tex" ),
	Asset( "ATLAS", "images/map_icons/evillight.xml" ),
	----------------------------------------------------
	Asset( "IMAGE", "images/inventoryimages/evilthrone.tex" ),
	Asset( "ATLAS", "images/inventoryimages/evilthrone.xml" ),
	Asset( "IMAGE", "images/inventoryimages/evillight.tex" ),
	Asset( "ATLAS", "images/inventoryimages/evillight.xml" ),
    -------------------------------------------------------
    Asset("ANIM", "anim/maxwell_build.zip"),
    Asset("ANIM", "anim/max_fx.zip"),
    Asset("ANIM", "anim/maxwell_basic.zip"),
	Asset("ANIM", "anim/maxwell_adventure.zip"),
	-- Asset("SOUND", "sound/maxwell.fsb"),
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
    Asset("ANIM", "anim/maxwell_endgame.zip"),
    Asset("ANIM", "anim/maxwell_floatinghead.zip"),
    Asset("ANIM", "anim/diviningrod_maxwell.zip"),
    Asset("ANIM", "anim/purple_gem.zip"),
    Asset("ANIM", "anim/player_throne.zip"),
}
RemapSoundEvent( "phonograph/play", "phonograph/sound/gramaphoneplay" )
RemapSoundEvent( "phonograph/end", "phonograph/sound/gramaphoneend" )

local _G = GLOBAL
if not _G.TUNING.TELEPORTATOMOD then
    _G.TUNING.TELEPORTATOMOD = {}
end
-- if not _G.TUNING.TELEPORTATOMOD.WORLDS then
    -- _G.TUNING.TELEPORTATOMOD.WORLDS = {}
-- end
-- local WORLDS = _G.TUNING.TELEPORTATOMOD.WORLDS

_G.TUNING.ADV_DIFFICULTY = GetModConfigData("difficulty") -- also used within chest scenarios
local adv_helpers = _G.require("adv_helpers") 
-- we can use _G.TUNING.TELEPORTATOMOD.LEVEL and _G.TUNING.TELEPORTATOMOD.CHAPTER as soon as the game started
-- so do not use it directly in AddPrefabPostInit, but make DoTaskInTime with at least 0.1 within


-- AddPrefabPostInit("world",function(world) world:DoTaskInTime(1,function() world.components.adventurejump:DoJump() end) end)

local function SpawnMaxwell(world)
    world:DoTaskInTime(4,function(world) -- wait after the title screen is gone
        if _G.TUNING.TELEPORTATOMOD.CHAPTER then
            if _G.TUNING.TELEPORTATOMOD.CHAPTER>0 then
                local maxw = _G.SpawnPrefab("maxwellintro")
                local speechName = "NULL_SPEECH"
                speechName = "ADVENTURE_".._G.TUNING.TELEPORTATOMOD.CHAPTER
                maxw.components.maxwelltalker:SetSpeech(speechName)
                maxw.components.maxwelltalker:Initialize()
                maxw:DoTaskInTime(1,function()	maxw.components.maxwelltalker:DoTalk() end) 
            end
        else
            print("Adventure: SpawnMaxwell CHAPTER is nil?!")
        end
    end)
end
-- some functions you can use which will be called within teleportato mod:
-- functionatplayerfirstspawn(player) -- will be executed for every players first spawn (during showing the title) and can eg. be used to spawn some starter items or lit some fires around him and so on. wait 4 seconds, to do something if you want the player to see it (eg player:DoTaskInTime(4,function))
-- functionatfirstplayerfirstspawn(world,player) -- will only be executed for the first player that first spawns, eg to spawn maxwell
-- functionpostinitworldONCE(world) -- will be executed at world start ONCE (only the first time directly after generating the world).  eg. you could add some stuff around startposition 
-- in addition you can addprefabpostinit into your modmain, but LEVEL and CHAPTER will need 0.1 seconds to be set, so do DoTaskInTime within your Addprefabpostiint!

local functionatplayerfirstspawn = _G.TUNING.TELEPORTATOMOD.functionatplayerfirstspawn
local functionatfirstplayerfirstspawn = _G.TUNING.TELEPORTATOMOD.functionatfirstplayerfirstspawn
local functionpostinitworldONCE = _G.TUNING.TELEPORTATOMOD.functionpostinitworldONCE
_G.TUNING.TELEPORTATOMOD.functionatplayerfirstspawn = function(player)
    if functionatplayerfirstspawn~=nil then -- call a previous funtion from another mod, if there is one
        functionatplayerfirstspawn(player)
    end
    if _G.TheWorld.ismastersim then
        if _G.TheWorld:HasTag("forest") then
            print("functionatplayerfirstspawn, level:"..tostring(_G.TUNING.TELEPORTATOMOD.LEVEL).." chapter:"..tostring(_G.TUNING.TELEPORTATOMOD.CHAPTER))
            adv_helpers.FuelNearFires(player) -- always fuel nerby fires to help new starting players a bit
            if _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Maxwells Door" then
                -- player:SetCameraDistance(12)
                player:DoTaskInTime(4,function(player) -- do this after the title screen
                    player.components.talker:ShutUp()
                    local strings = {"We have to find maxwells door!","Somewhere in this area we will find maxwells door","Lets find maxwells door"}
                    player.components.talker:Say(_G.GetRandomItem(strings))
                    -- player:SetCameraDistance()
                end)
                local chest = adv_helpers.SpawnPrefabAtLandPlotNearInst("backpack",player,15,0,15,1,3,3)
                adv_helpers.AddScenario(chest,"chest_random_good")
                adv_helpers.SpawnPrefabAtLandPlotNearInst("cutgrass",player,15,0,15,5,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("twigs",player,15,0,15,3,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("flint",player,15,0,15,7,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("flint",player,80,0,80,7,20,20)           
            elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="A Cold Reception" then
                adv_helpers.SpawnPrefabAtLandPlotNearInst("axe",player,15,0,15,1,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("grass_umbrella",player,15,0,15,1,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("cutgrass",player,15,0,15,3,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("twigs",player,15,0,15,3,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("flint",player,15,0,15,6,3,3)
            elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="King of Winter" then
                adv_helpers.SpawnPrefabAtLandPlotNearInst("cutgrass",player,15,0,15,3,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("twigs",player,15,0,15,3,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("flint",player,15,0,15,3,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("log",player,15,0,15,3,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("axe",player,15,0,15,1,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("skeleton",player,15,0,15,1,3,3)
                local blueprint = adv_helpers.SpawnPrefabAtLandPlotNearInst("earmuffshat_blueprint",player,15,0,15,1,3,3)
                adv_helpers.MakeFireProof(blueprint,20)
                local chest = adv_helpers.SpawnPrefabAtLandPlotNearInst("backpack",player,15,0,15,1,3,3)
                adv_helpers.AddScenario(chest,"packloot_winter_start_medium")
                adv_helpers.MakeFireProof(chest,20)
            elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="The Game is Afoot" then
                adv_helpers.SpawnPrefabAtLandPlotNearInst("cutgrass",player,15,0,15,3,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("twigs",player,15,0,15,3,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("flint",player,15,0,15,3,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("grass_umbrella",player,15,0,15,1,3,3)
                local chest = adv_helpers.SpawnPrefabAtLandPlotNearInst("backpack",player,15,0,15,1,3,3)
                adv_helpers.AddScenario(chest,"chest_presummer")
            elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Archipelago" then
                adv_helpers.SpawnPrefabAtLandPlotNearInst("axe",player,15,0,15,1,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("cutgrass",player,15,0,15,3,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("twigs",player,15,0,15,3,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("flint",player,15,0,15,3,3,3)
            elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Two Worlds" then
                adv_helpers.SpawnPrefabAtLandPlotNearInst("cutgrass",player,15,0,15,3,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("twigs",player,15,0,15,3,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("flint",player,15,0,15,3,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("nitre",player,15,0,15,3,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("grass_umbrella",player,15,0,15,1,3,3)
            elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Darkness" then
                local chest = adv_helpers.SpawnPrefabAtLandPlotNearInst("backpack",player,15,0,15,1,3,3)
                adv_helpers.AddScenario(chest,"packloot_nightmare")
                adv_helpers.SpawnPrefabAtLandPlotNearInst("grass_umbrella",player,15,0,15,1,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("torch",player,15,0,15,1,3,3)
                adv_helpers.SpawnPrefabAtLandPlotNearInst("skeleton",player,15,0,15,1,3,3)
            end
        end
    end
end

_G.TUNING.TELEPORTATOMOD.functionatfirstplayerfirstspawn =  function(world,player)
    if functionatfirstplayerfirstspawn~=nil then -- call a previous funtion from another mod, if there is one
        functionatfirstplayerfirstspawn(world,player)
    end
    if world.ismastersim then
        if world:HasTag("forest") then
            print("functionatfirstplayerfirstspawn, level:"..tostring(_G.TUNING.TELEPORTATOMOD.LEVEL).." chapter:"..tostring(_G.TUNING.TELEPORTATOMOD.CHAPTER))
            SpawnMaxwell(world)
        end
    end
end

_G.TUNING.TELEPORTATOMOD.functionpostinitworldONCE = function(world)
    if functionpostinitworldONCE~=nil then -- call a previous funtion from another mod, if there is one
        functionpostinitworldONCE(world)
    end
    if world.ismastersim then
        if world:HasTag("forest") then
            print("functionpostinitworldONCE, level:"..tostring(_G.TUNING.TELEPORTATOMOD.LEVEL).." chapter:"..tostring(_G.TUNING.TELEPORTATOMOD.CHAPTER))
            if _G.TUNING.TELEPORTATOMOD.CHAPTER~=6 then -- everytime except in the last chosen world
                local x,y,z = world.components.playerspawner.GetAnySpawnPoint() -- we only have one starting position
                local spawnpointpos = _G.Vector3(x ,y ,z )
                local fire = adv_helpers.SpawnPrefabAtLandPlotNearInst("firepit",spawnpointpos,7,0,7,1,3,3)

                if _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Maxwells Door" then -- in lvl 1 add a pond to get some food
                    adv_helpers.SpawnPrefabAtLandPlotNearInst("pond",spawnpointpos,30,0,30,1,15,15)
                    adv_helpers.SpawnPrefabAtLandPlotNearInst("rock_ice",spawnpointpos,50,0,50,2,20,20)
                    adv_helpers.SpawnPrefabAtLandPlotNearInst("rabbithole",spawnpointpos,50,0,50,5,20,20)
                    adv_helpers.SpawnPrefabAtLandPlotNearInst("evergreen",spawnpointpos,100,0,100,15,10,10)
                    adv_helpers.SpawnPrefabAtLandPlotNearInst("sapling",spawnpointpos,100,0,100,40,10,10)
                    adv_helpers.SpawnPrefabAtLandPlotNearInst("grassgekko",spawnpointpos,100,0,100,20,5,5)
                    adv_helpers.SpawnPrefabAtLandPlotNearInst("grass",spawnpointpos,100,0,100,40,5,5)
                    adv_helpers.SpawnPrefabAtLandPlotNearInst("carrot_planted",spawnpointpos,100,0,100,10,10,10)
                    adv_helpers.SpawnPrefabAtLandPlotNearInst("berrybush",spawnpointpos,100,0,100,10,15,15)
                    adv_helpers.SpawnPrefabAtLandPlotNearInst("berrybush_juicy",spawnpointpos,100,0,100,10,15,15)
                    adv_helpers.SpawnPrefabAtLandPlotNearInst("flower",spawnpointpos,20,0,20,5,5,5)
                    adv_helpers.SpawnPrefabAtLandPlotNearInst("rock1",spawnpointpos,150,0,150,10,15,15) -- some stone boulder, since its only swamp map
                    adv_helpers.SpawnPrefabAtLandPlotNearInst("rock2",spawnpointpos,150,0,150,7,15,15) -- gold boulder
                elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Two Worlds" then -- in twoworlds some saplings would be good
                    adv_helpers.SpawnPrefabAtLandPlotNearInst("sapling",spawnpointpos,20,0,20,5,5,5)
                end
            end
        end
    end
end



AddPlayerPostInit(function(player)
    if not _G.TheNet:GetIsServer() then 
        return
    end
    player:DoTaskInTime(1, function(inst)
        if _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="MaxwellHome" then -- has to be done everytime
            GLOBAL.TheCamera:SetHeadingTarget(225) -- rotate the camera for every player making south at the top (world was rotated for whatever reason)
        end
    end)
end)

modes = {"survival","wilderness","endless"} -- overwriting every gamemode to the same, so regardless wich mode you choose, it is always the following
for i,mode in ipairs(modes) do
    _G.GAME_MODES[mode].spawn_mode = "fixed"
    _G.GAME_MODES[mode].ghost_sanity_drain = true
    _G.GAME_MODES[mode].ghost_enabled = true
    _G.GAME_MODES[mode].reset_time = { time = 120, loadingtime = 180 }
    _G.GAME_MODES[mode].portal_rez = true
    _G.GAME_MODES[mode].invalid_recipes = {} -- "lifeinjector", "resurrectionstatue", "reviver"
    _G.GAME_MODES[mode].resource_renewal = true
end




-- local function GetRoom(entity) -- written by ptr, thanks.
    -- local closestdist = math.huge
    -- local closestid = nil
    -- x,_,y=entity.Transform:GetWorldPosition()
    -- for i,v in pairs(_G.TheWorld.topology.nodes) do
        -- if #v.neighbours > 0 then
            -- local dx = math.floor((math.abs(v.x - x)+2)/4)
            -- local dy = math.floor((math.abs(v.y - y)+2)/4)
            -- local distsq = dx*dx + dy*dy
            -- if distsq < closestdist then
                -- closestdist = distsq
                -- closestid = i
            -- end
        -- end
    -- end
    -- return _G.TheWorld.topology.ids[closestid]
-- end

