

-- TODO:


-- animation on throne
-- -> als minor bug eintragen


-- TheWorld.components.adventurejump:DoJump()

-- vllt noch eine modsetting mit der man die startitems (die mein mod gibt) "für jeden spieler" abschalten kann, könnte sonst bei servern wo neue spieler ein und ausgehen zuviel werden?
--> nur machen wenns nachfrage da nach gibt



-- advenced worldgeneration von dejavu hat aera-aware. evtl könnte man damit two worlds
-- untersch. wetter usw machen?





-- maxwell phonograph, mod by DoktorHolmes
-- maxwell light, mod by Leonardo Coxington
-- and my own work..

PrefabFiles = { 
    "maxwellphonograph",
    "maxwelllight_p",
    "maxwelllight_flame",
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
    -- "puppet",
}
Assets = {
    Asset("ANIM", "anim/phonograph.zip"),
    Asset("SOUND", "sound/phonograph.fsb"),
    Asset("SOUNDPACKAGE", "sound/phonograph.fev"),
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
local TheNet = _G.TheNet
local SERVER_SIDE, DEDICATED_SIDE, CLIENT_SIDE, ONLY_CLIENT_SIDE
if TheNet:GetIsServer() then
    SERVER_SIDE = true
    if TheNet:IsDedicated() then
        DEDICATED_SIDE = true -- ==ONLY_SERVER_SIDE
    else
        CLIENT_SIDE = true
    end
elseif TheNet:GetIsClient() then
    SERVER_SIDE = false
    CLIENT_SIDE = true
    ONLY_CLIENT_SIDE = true
end
if not _G.TUNING.TELEPORTATOMOD then
    _G.TUNING.TELEPORTATOMOD = {}
end

-- _G.TUNING.TELEPORTATOMOD.experimentalcode = GetModConfigData("experimentalcode") -- currently no purpose, since there is no experimental code
_G.TUNING.TELEPORTATOMOD.repickcharacter = GetModConfigData("repickcharacter") -- this setting is currently only set-able for adventure mod (because its easier and still in testing)
_G.TUNING.TELEPORTATOMOD.getstartingitems = GetModConfigData("repickcharacter") -- this setting is currently only set-able for adventure mod (because its easier and still in testing)
_G.TUNING.TELEPORTATOMOD.Thulecite = 0 -- overwrite this teleportato settings, cause these really dont fit the adventure theme and are overpowered when worldjunping that often
_G.TUNING.TELEPORTATOMOD.Ancient = 0 -- overwrite this teleportato settings
_G.TUNING.TELEPORTATOMOD.statssave = true -- overwrite this teleportato settings
_G.TUNING.TELEPORTATOMOD.TELENEWWORLD = true -- overwrite this teleportato settings
_G.TUNING.TELEPORTATOMOD.RegenerateHealth = 0 -- overwrite this teleportato settings
_G.TUNING.TELEPORTATOMOD.RegenerateSanity = 0 -- overwrite this teleportato settings
_G.TUNING.TELEPORTATOMOD.RegenerateHunger = 0 -- overwrite this teleportato settings
_G.TUNING.TELEPORTATOMOD.sandboxpreconfigured = GetModConfigData("sandboxpreconfigured") -- to also let teleportato now and use the variate world setting if enabled

--#################################################################
-- #################################################
--## force same character code...

_G.TUNING.TELEPORTATOMOD.adv_forcechar_prefabs = nil

local ex_fns = require "prefabs/player_common_extensions"
local UserCommands = _G.require("usercommands")
AddUserCommand("adv_forcechar",{
    permission = _G.COMMAND_PERMISSION.USER,
    vote = false,
    params = {},
    serverfn = function(params, caller)
        -- print("adv_playerinlobby")
        local userid = caller.userid
        if _G.TUNING.TELEPORTATOMOD.CHAPTER~=1 and _G.TheWorld and _G.TheWorld.components and _G.TheWorld.components.worldjump and _G.TheWorld.components.worldjump.player_data and _G.TheWorld.components.worldjump.player_data[userid] then
            if not table.contains(_G.TheWorld.components.worldjump.player_ids,userid) then -- only the first time in lobbyscreen (eg dont do it when we change char in new portal)
                local prefab = _G.TheWorld.components.worldjump.player_data[userid].prefab
                _G.TUNING.TELEPORTATOMOD.adv_forcechar_prefabs:set(tostring(userid).."###"..tostring(prefab))
            end
        end
    end,
})

local function IsScreenInStackAndReturnScreen(screenname)
    for _,screen_in_stack in pairs(_G.TheFrontEnd.screenstack) do
        if screen_in_stack.name == screenname then
            return screen_in_stack
        end
    end
    return false
end

AddPrefabPostInit("forest_network",function(worldnet)
    -- print("forest_network")
    _G.TUNING.TELEPORTATOMOD.adv_forcechar_prefabs = _G.net_string(worldnet.GUID, "adv_forcechar.player", "adv_forcechar_dirty")
    _G.TUNING.TELEPORTATOMOD.adv_forcechar_prefabs:set("")
    
    if CLIENT_SIDE then
        worldnet:ListenForEvent("adv_forcechar_dirty", function(worldnet) 
            local adv_forcechar = _G.TUNING.TELEPORTATOMOD.adv_forcechar_prefabs:value()
            -- print(adv_forcechar)
            local adv_forcechar_split = string.split(adv_forcechar, "###") -- we send userid+###+prefab within netvar
            local userid,prefab = adv_forcechar_split[1],adv_forcechar_split[2]
            if TheNet:GetUserID()==userid then
                local lobbyscreen = IsScreenInStackAndReturnScreen("LobbyScreen")
                if lobbyscreen then
                    lobbyscreen:Hide()
                    -- print(prefab)
                    lobbyscreen.character_for_game = prefab
                    lobbyscreen.cb(lobbyscreen.character_for_game) -- currentskin is nil, but we will use the normal worldjump load to add the skin back
                -- else
                    -- print("no lobbyscreen")
                end
            -- else
                -- print("userid unequal")
                -- print(TheNet:GetUserID())
                -- print(userid)
            end
        end)
    end
end)

local function LobbyHook(self) -- force same player
    -- _G.scheduler:ExecuteInTime(0,function()
        -- print("LobbyHook")
        UserCommands.RunUserCommand("adv_forcechar", {}, _G.TheNet:GetClientTableForUser(_G.TheNet:GetUserID()))
    -- end, "get_data_about_self")
end
if _G.TUNING.TELEPORTATOMOD.repickcharacter==false then
    AddClassPostConstruct("screens/redux/lobbyscreen", LobbyHook)
end
--#################################################################
--#################################################################

-- local function tesst()
    -- print(client_obj)
    -- if type(client_obj)=="table" then
        -- for k,v in pairs(client_obj) do
            -- print(tostring(k).." ... "..tostring(v))
        -- end
    -- end
-- end
-- _G.TUNING.TTEESSTT = tesst -- TUNING.TTEESSTT(TheNet:GetSessionIdentifier(),ThePlayer.userid)


-- print("HIER modmain adv")





_G.TUNING.ADV_DIFFICULTY = GetModConfigData("difficulty") -- also used within chest scenarios
local adv_helpers = _G.require("adv_helpers")  --load it from teleportato mod
-- we can use _G.TUNING.TELEPORTATOMOD.LEVEL and _G.TUNING.TELEPORTATOMOD.CHAPTER as soon as the game started
-- _G.TUNING.TELEPORTATOMOD.LEVELINFOLOADED will be true after everythong was loaded.

modimport("scripts/ADVENTURE_STRINGS") -- load DS STRINGS if the devs removed them...

--world:DoTaskInTime(1,function() world.components.adventurejump:DoJump() end) end) -- endless jump for testing

-- maxwell spawn for every single player only on their client side, so other players should not be able to see him
local function SpawnMaxwell(inst)
    -- print("SpawnMaxwell")
    if _G.TUNING.TELEPORTATOMOD.CHAPTER then
        if SERVER_SIDE and inst.components~=nil and inst.components.health~=nil then
            inst.components.health:SetInvincible(true) -- make player invincible, is removed within maxwelltalker file
        end
        if _G.TUNING.TELEPORTATOMOD.WORLDS~=nil and _G.TUNING.TELEPORTATOMOD.LEVEL~=nil and _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name~=nil then
            inst:DoTaskInTime(0.5,function(inst)
                -- print("SpawnMaxwell1")
                
                local maxw = _G.SpawnPrefab("maxwellintro")
                if maxw~=nil then
                    local speechName = "ADVENTURE_1"
                    if _G.TUNING.ADV_DIFFICULTY==0 then -- DS. so no new dialog
                        inst.dolevelspeech = false
                    end
                    -- inst.dolevelspeech = true -- test
                    if inst.dolevelspeech then -- 66% chance, different for every single player
                        speechName = "ADVENTURE "..tostring(_G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name) -- alternative strings matching the chosen level
                    end
                    if (not inst.dolevelspeech or maxw.components.maxwelltalker.speeches[speechName]==nil) then
                        speechName = "ADVENTURE_".._G.TUNING.TELEPORTATOMOD.CHAPTER -- strings matching the actual chapter
                    end
                    if maxw.components.maxwelltalker.speeches[speechName]~=nil then
                        maxw:Hide() -- invisible
                        if _G.ThePlayer==inst or SERVER_SIDE then
                            if _G.ThePlayer==inst then
                                maxw:Show() -- make it visible only for the player who "called" him
                            end
                            maxw.components.maxwelltalker:SetSpeech(speechName)
                            maxw.components.maxwelltalker:Initialize(inst,CLIENT_SIDE)
                            maxw:StartThread(function() maxw.components.maxwelltalker:DoTalk(CLIENT_SIDE,inst.dolevelspeech) end)
                        end
                    else
                        print("AdventureMod: no speech found within maxwellintro for "..tostring(speechName))
                        if SERVER_SIDE and inst.components~=nil and inst.components.health~=nil then
                            inst.components.health:SetInvincible(false)
                        end
                        maxw:Remove()
                    end
                end
            end)
        end
    else
        print("AdventureMod: SpawnMaxwell CHAPTER is nil?!")
    end
end


-- some functions you can use which will be called within teleportato mod:
-- functionatplayerfirstspawn(player) -- will be executed for every players first spawn and can eg. be used to spawn some starter items or lit some fires around him and so on. 
-- functionpostloadworldONCE(world) -- will be executed at world start ONCE (only the first time directly after generating the world).  eg. you could add some stuff around startposition 
-- in addition you can use addprefabpostinit in your modmain, but LEVEL and CHAPTER will need ~0.1 seconds to be set, so do DoTaskInTime within your Addprefabpostiint! (only continue after _G.TUNING.TELEPORTATOMOD.LEVELINFOLOADED was set to true by teleportato mod)

local functionatplayerfirstspawn = _G.TUNING.TELEPORTATOMOD.functionatplayerfirstspawn
local functionpostloadworldONCE = _G.TUNING.TELEPORTATOMOD.functionpostloadworldONCE
_G.TUNING.TELEPORTATOMOD.functionatplayerfirstspawn = function(player) -- called for server and client
    -- print("functionatplayerfirstspawn")
    if functionatplayerfirstspawn~=nil then -- call a previous funtion from another mod, if there is one
        functionatplayerfirstspawn(player)
    end
    player:DoTaskInTime(0,function() -- do the following after everything is finally done
        if SERVER_SIDE then
            player.dolevelspeech = _G.GetRandomItem({true,false,true}) -- higher chance for true
            player.mynetvardolevelspeech:set(player.dolevelspeech) -- random and server may get differnt result for this, so we have to send the server result to client
        end
        SpawnMaxwell(player)
        if SERVER_SIDE then 
            if _G.TheWorld:HasTag("forest") then
                if (_G.TheWorld.components.worldjump.player_data[player.userid]==nil or (_G.TUNING.TELEPORTATOMOD.getstartingitems==false and _G.TUNING.TELEPORTATOMOD.CHAPTER~=nil and _G.TUNING.TELEPORTATOMOD.CHAPTER<=2)) and player.starting_inventory_orig~=nil then -- give the starting items only in those 2 chapters. -- if it is first spawn ever (no player_data saved), then give start items regardless of settings or chapter!
                    ex_fns.GivePlayerStartingItems(player, player.starting_inventory_orig) -- line taken from NewSpawn within player_common.lua
                end
                -- print("functionatplayerfirstspawn, level:"..tostring(_G.TUNING.TELEPORTATOMOD.LEVEL).." chapter:"..tostring(_G.TUNING.TELEPORTATOMOD.CHAPTER))
                if _G.TUNING.ADV_DIFFICULTY~=0 and _G.TUNING.ADV_DIFFICULTY~=3 then -- spawn some helpful stuff for starting players, at least on easy and default difficutly
                    adv_helpers.FuelNearFires(player) -- always fuel nerby fires to help new starting players a bit
                    if _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Maxwells Door" and _G.TUNING.TELEPORTATOMOD.sandboxpreconfigured then 
                        local chest = adv_helpers.SpawnPrefabAtLandPlotNearInst("backpack",player,15,0,15,1,3,3)
                        adv_helpers.AddScenario(chest,"chest_random_good")
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("cutgrass",player,15,0,15,6/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("twigs",player,15,0,15,4/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("flint",player,15,0,15,8/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("flint",player,80,0,80,8/_G.TUNING.ADV_DIFFICULTY,20,20)           
                    elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="A Cold Reception" then
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("axe",player,15,0,15,2/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("grass_umbrella",player,15,0,15,1,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("cutgrass",player,15,0,15,6/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("twigs",player,15,0,15,4/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("flint",player,15,0,15,8/_G.TUNING.ADV_DIFFICULTY,3,3)
                    elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="King of Winter" then
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("cutgrass",player,15,0,15,6/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("twigs",player,15,0,15,4/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("flint",player,15,0,15,6/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("log",player,15,0,15,8/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("axe",player,15,0,15,2/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("skeleton",player,15,0,15,1,3,3)
                        local blueprint = adv_helpers.SpawnPrefabAtLandPlotNearInst("earmuffshat_blueprint",player,15,0,15,1,3,3)
                        adv_helpers.MakeFireProof(blueprint,50)
                        local chest = adv_helpers.SpawnPrefabAtLandPlotNearInst("backpack",player,15,0,15,1,3,3)
                        adv_helpers.AddScenario(chest,"packloot_winter_start_medium")
                        adv_helpers.MakeFireProof(chest,50)
                    elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="The Game is Afoot" then
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("cutgrass",player,15,0,15,6/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("twigs",player,15,0,15,4/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("flint",player,15,0,15,4/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("grass_umbrella",player,15,0,15,1,3,3)
                        local chest = adv_helpers.SpawnPrefabAtLandPlotNearInst("backpack",player,15,0,15,1,3,3)
                        adv_helpers.AddScenario(chest,"chest_presummer")
                    elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Archipelago" then
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("axe",player,15,0,15,2/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("cutgrass",player,15,0,15,6/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("twigs",player,15,0,15,4/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("flint",player,15,0,15,4/_G.TUNING.ADV_DIFFICULTY,3,3)
                    elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Two Worlds" then
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("cutgrass",player,15,0,15,20/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("twigs",player,15,0,15,14/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("flint",player,15,0,15,4/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("nitre",player,15,0,15,6/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("grass_umbrella",player,15,0,15,1,3,3)
                    elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Darkness" then
                        local chest = adv_helpers.SpawnPrefabAtLandPlotNearInst("backpack",player,15,0,15,1,3,3)
                        adv_helpers.AddScenario(chest,"packloot_nightmare")
                        adv_helpers.MakeFireProof(chest,50)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("cutgrass",player,15,0,15,20/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("twigs",player,15,0,15,14/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("flint",player,15,0,15,4/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("grass_umbrella",player,15,0,15,1,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("torch",player,15,0,15,4/_G.TUNING.ADV_DIFFICULTY,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("skeleton",player,15,0,15,1,3,3)
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("nitre",player,15,0,15,6/_G.TUNING.ADV_DIFFICULTY,3,3)
                    end
                end
            end
        end
    end)
end


local function ConnectWormholes(x,y)
    if adv_savewormholes["wormhole"..tostring(x)]~=nil and adv_savewormholes["wormhole"..tostring(y)]~=nil and adv_savewormholes["wormhole"..tostring(x)]:IsValid() and adv_savewormholes["wormhole"..tostring(y)]:IsValid() then
        adv_savewormholes["wormhole"..tostring(x)].components.teleporter.targetTeleporter = adv_savewormholes["wormhole"..tostring(y)]
        adv_savewormholes["wormhole"..tostring(y)].components.teleporter.targetTeleporter = adv_savewormholes["wormhole"..tostring(x)]
        return true,true
    end
    print("AdventureMod: ERROR was not able to connect all wormholes, cause at least one (non starting and ending) island has less than 2 wormholes")
    return adv_savewormholes["wormhole"..tostring(x)]~=nil,adv_savewormholes["wormhole"..tostring(y)]~=nil
end

_G.TUNING.TELEPORTATOMOD.functionpostloadworldONCE = function(world) -- only called for server and after everything is loaded
    if functionpostloadworldONCE~=nil then -- call a previous funtion from another mod, if there is one
        functionpostloadworldONCE(world)
    end
    world:DoTaskInTime(0,function() -- do the following after everything is finally done
        if SERVER_SIDE then -- only called for server anyway
            if world:HasTag("forest") then
                -- print("functionpostloadworldONCE, level:"..tostring(_G.TUNING.TELEPORTATOMOD.LEVEL).." chapter:"..tostring(_G.TUNING.TELEPORTATOMOD.CHAPTER))
                local x,y,z = world.components.playerspawner.GetAnySpawnPoint() -- we only have one starting position (if 0,0,0, then no point is registered yet, this is why the code must be in DoTaskInTime )
                local spawnpointpos = _G.Vector3(x ,y ,z )
                if _G.TUNING.ADV_DIFFICULTY~=0 and _G.TUNING.ADV_DIFFICULTY~=3 then -- spawn some helpful stuff
                    if _G.TUNING.TELEPORTATOMOD.CHAPTER~=7 then -- everytime except in the last chosen world
                        local fire = adv_helpers.SpawnPrefabAtLandPlotNearInst("firepit",spawnpointpos,7,0,7,1,3,3)
                        if _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Maxwells Door" and _G.TUNING.TELEPORTATOMOD.sandboxpreconfigured then -- in lvl 1 add a pond to get some food
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("pond",spawnpointpos,30,0,30,1,15,15)
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("rock_ice",spawnpointpos,50,0,50,4/_G.TUNING.ADV_DIFFICULTY,20,20)
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("rabbithole",spawnpointpos,50,0,50,10/_G.TUNING.ADV_DIFFICULTY,20,20)
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("evergreen",spawnpointpos,100,0,100,30/_G.TUNING.ADV_DIFFICULTY,10,10)
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("sapling",spawnpointpos,100,0,100,80/_G.TUNING.ADV_DIFFICULTY,10,10)
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("grassgekko",spawnpointpos,100,0,100,40/_G.TUNING.ADV_DIFFICULTY,5,5)
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("grass",spawnpointpos,100,0,100,80/_G.TUNING.ADV_DIFFICULTY,5,5)
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("carrot_planted",spawnpointpos,100,0,100,20/_G.TUNING.ADV_DIFFICULTY,10,10)
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("berrybush",spawnpointpos,100,0,100,20/_G.TUNING.ADV_DIFFICULTY,15,15)
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("berrybush_juicy",spawnpointpos,100,0,100,20/_G.TUNING.ADV_DIFFICULTY,15,15)
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("flower",spawnpointpos,20,0,20,10/_G.TUNING.ADV_DIFFICULTY,5,5)
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("rock1",spawnpointpos,150,0,150,20/_G.TUNING.ADV_DIFFICULTY,15,15) -- some stone boulder, since its only swamp map
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("rock2",spawnpointpos,150,0,150,12/_G.TUNING.ADV_DIFFICULTY,15,15) -- gold boulder
                        elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Two Worlds" then -- in twoworlds some saplings would be good
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("sapling",spawnpointpos,20,0,40/_G.TUNING.ADV_DIFFICULTY,5,5,5)
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("ice",spawnpointpos,15,0,15,30/_G.TUNING.ADV_DIFFICULTY,3,3) -- some ice for flingo
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("knight",spawnpointpos,50,0,50,2/_G.TUNING.ADV_DIFFICULTY,30,30) -- knight for gears
                        elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Darkness" then
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("ice",spawnpointpos,15,0,15,36/_G.TUNING.ADV_DIFFICULTY,3,3) -- some ice for flingo
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("knight",spawnpointpos,50,0,50,2/_G.TUNING.ADV_DIFFICULTY,30,30) -- knight for gears
                        elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Archipelago" then
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("rock1",spawnpointpos,150,0,150,20/_G.TUNING.ADV_DIFFICULTY,15,15) -- some stone boulder
                            adv_helpers.SpawnPrefabAtLandPlotNearInst("rock2",spawnpointpos,150,0,150,12/_G.TUNING.ADV_DIFFICULTY,15,15) -- gold boulder
                        end
                    end
                elseif GetModConfigData("withocean")=="ocean" then -- every difficulty, otherwise it might be impossible without wormholes
                    if _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Archipelago" then
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("rock1",spawnpointpos,150,0,150,5,15,15) -- some stone boulder
                        adv_helpers.SpawnPrefabAtLandPlotNearInst("rock2",spawnpointpos,150,0,150,5,15,15) -- gold boulder
                    end
                end
                world:DoTaskInTime(1,function() -- do the following after everything is finally done
                    if (GetModConfigData("withocean")=="wormholes" or GetModConfigData("withocean")=="oceanwormholes") then
                        if _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Archipelago" then -- an odd number is leaving the island and an even number is entering the island
                            local sucess = true
                            if adv_savewormholes["wormhole1"]~=nil and adv_savewormholes["wormhole10"]~=nil then
                                -- local islandtasks = { "IslandHop_Start", "IslandHop_Hounds", "IslandHop_Forest", "IslandHop_Savanna", "IslandHop_Rocky", "IslandHop_Merm" }
                                -- print("Adventure archipelago connect wormholes..")
                                local entrances = {2,4,6,8}
                                local pick = 0
                                local a,b
                                for i = 1,4 do
                                    oldpick = pick
                                    pick = _G.PickSome(1,entrances)[1]
                                    a,b = ConnectWormholes(oldpick+1,pick)
                                    if not a or not b then
                                        sucess = false
                                    end
                                end
                                a,b = ConnectWormholes(pick+1,10)
                                if not a or not b then
                                    sucess = false
                                end
                            else
                                sucess = false
                            end
                            if sucess and GetModConfigData("withocean")=="wormholes" and GLOBAL.AllRecipes["seafaring_prototyper"] then -- we alawys spawn ocean, but if player chose to only have wormhole, we will make thinkthank unavailable if connecting wormholes suceeded
                                GLOBAL.AllRecipes["seafaring_prototyper"].level = GLOBAL.TECH.LOST
                                GLOBAL.AllRecipes["boat_grass_item"].level = GLOBAL.TECH.LOST
                            end
                            if not sucess then
                                print("AdventureMod: Spawning and linking wormholes failed, please use boats instead...")
                            end
                        elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Two Worlds" then 
                            if GetModConfigData("withocean")=="wormholes" then -- we alawys spawn ocean, but if player chose to only have wormhole, we will make thinkthank unavailable if connecting wormholes suceeded
                                if world.firsttwoworldswormhole and world.firsttwoworldswormhole.components.teleporter.targetTeleporter and GLOBAL.AllRecipes["seafaring_prototyper"] then -- we alawys spawn ocean, but if player chose to only have wormhole, we will make thinkthank unavailable if connecting wormholes suceeded
                                    GLOBAL.AllRecipes["seafaring_prototyper"].level = GLOBAL.TECH.LOST
                                    GLOBAL.AllRecipes["boat_grass_item"].level = GLOBAL.TECH.LOST
                                end
                            end
                        elseif not (_G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Maxwells Door" and not _G.TUNING.TELEPORTATOMOD.sandboxpreconfigured) then
                            if GetModConfigData("withocean")=="wormholes" and GLOBAL.AllRecipes["seafaring_prototyper"] then -- we alawys spawn ocean, but if player chose to only have wormhole, we will make thinkthank unavailable
                                GLOBAL.AllRecipes["seafaring_prototyper"].level = GLOBAL.TECH.LOST
                                GLOBAL.AllRecipes["boat_grass_item"].level = GLOBAL.TECH.LOST
                            end
                        end
                    end
                end)
            end
        end
    end)
end

local shadow_pieces = {"shadow_bishop","shadow_knight","shadow_rook"}
for _,piece in ipairs(shadow_pieces) do
    AddPrefabPostInit(piece,function(inst)
        if not _G.TheNet:GetIsServer() then 
            return
        end
        inst:DoTaskInTime(2,function()
            if _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Checkmate" and inst:IsValid() then
                inst.OnEntitySleep = nil -- no despawn for them
                inst:OnEntityWake()
            end
        end)
    end)
end

local function MCutsceneClient(player)
    local val = player.mynetvarMCutscene:value() -- is set from host within maxwelllock to also start the cutscene for clients
    if val==true and player==_G.ThePlayer then
        local throne = _G.TheSim:FindFirstEntityWithTag("maxwellthrone") -- on client this has only short range, but still better than nothing..
        -- throne = nil -- test the worst case
        if throne~=nil then -- if nil there still will be the server code, although it might look a bit odd
            throne.startthread(throne,CLIENT_SIDE)
        end
    end
end


AddPlayerPostInit(function(player)
    player.mynetvardolevelspeech = _G.net_bool(player.GUID, "dolevelspeechNetStuff", "DirtyEventdolevelspeech") -- true or false
    player.mynetvardolevelspeech:set(true) -- set a default value
    player.dolevelspeech = true
    player.mynetvarMCutscene = _G.net_bool(player.GUID, "MCutsceneNetStuff", "DirtyEventMCutscene")
    player.mynetvarMCutscene:set(false) -- set a default value
    player.dolevelspeech = true
    if CLIENT_SIDE then
        player:ListenForEvent("DirtyEventdolevelspeech", function(player) print("AdventureMod: set dolevelspeech for client to "..tostring(player.mynetvardolevelspeech:value()));player.dolevelspeech = player.mynetvardolevelspeech:value() end) -- also set up for client
        player:ListenForEvent("DirtyEventMCutscene", MCutsceneClient)
    end
    player:DoTaskInTime(0, function(player)
        if _G.TUNING.TELEPORTATOMOD.LEVEL~=nil and _G.TUNING.TELEPORTATOMOD.WORLDS~=nil and _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL]~=nil then
            if _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Checkmate" then -- has to be done everytime
                _G.TheCamera:SetHeadingTarget(225) -- rotate the camera for every player making south at the top (we removed maxwellcamera, thats why we have to do it)
            end
        end
    end)
    if _G.TUNING.TELEPORTATOMOD.getstartingitems==false then -- at this point neither chapter nor worldjump player_data is defined!
        player.starting_inventory_orig = player.starting_inventory -- save it and give it within functionatplayerfirstspawn if the chapter is 0 or 1
        player.starting_inventory = {} -- dont give starting items generally
    end
    -- print("level bei playerpostinit ist "..tostring(_G.TUNING.TELEPORTATOMOD.LEVEL).." levelload:"..tostring(_G.TUNING.TELEPORTATOMOD.LEVELINFOLOADED))
end)







local function GetRoom(entity) -- written by ptr, thanks.
    local closestdist = math.huge
    local closestid = nil
    x,_,y=entity.Transform:GetWorldPosition()
    for i,v in pairs(_G.TheWorld.topology.nodes) do
        if #v.neighbours > 0 then
            local dx = math.floor((math.abs(v.x - x)+2)/4)
            local dy = math.floor((math.abs(v.y - y)+2)/4)
            local distsq = dx*dx + dy*dy
            if distsq < closestdist then
                closestdist = distsq
                closestid = i
            end
        end
    end
    return _G.TheWorld.topology.ids[closestid]
end
-- TheWorld.components.adventurejump:DoJump()
-- _G.TUNING.TELEPORTATOMOD.ARCHIPELWORMHOLES = {} -- remember the wormholes and connect them in world post init
adv_savewormholes = {}  -- remember the wormholes and connect them in world post init
AddPrefabPostInit("wormhole",function(inst)
    if SERVER_SIDE and inst.components.teleporter then
        inst:DoTaskInTime(0.5,function(inst) -- do it after _G.TUNING.TELEPORTATOMOD.LEVEL is checked (0.001) and before adv_savewormholes are used 0.1
            if (GetModConfigData("withocean")=="wormholes" or GetModConfigData("withocean")=="oceanwormholes") then
                -- print("ADV: execute wormhole saving if world with wormholes...level "..tostring(_G.TUNING.TELEPORTATOMOD.LEVEL))
                local taskandroom = ""
                if _G.TUNING.TELEPORTATOMOD.LEVEL~=nil and _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL]~=nil then
                    if _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Archipelago" then
                        -- print("save wormholes")
                        taskandroom = GetRoom(inst) -- eg "IslandHop_Start:2:SpiderMarsh"                
                        if string.find(taskandroom,"IslandHop_Start") and (adv_savewormholes["wormhole1"]==nil or not adv_savewormholes["wormhole1"]:IsValid()) then
                            adv_savewormholes["wormhole1"] = inst
                        elseif string.find(taskandroom,"IslandHop_Hounds") and (adv_savewormholes["wormhole2"]==nil or not adv_savewormholes["wormhole2"]:IsValid()) then
                            adv_savewormholes["wormhole2"] = inst
                        elseif string.find(taskandroom,"IslandHop_Hounds") and (adv_savewormholes["wormhole3"]==nil or not adv_savewormholes["wormhole3"]:IsValid()) then
                            adv_savewormholes["wormhole3"] = inst
                        elseif string.find(taskandroom,"IslandHop_Forest") and (adv_savewormholes["wormhole4"]==nil or not adv_savewormholes["wormhole4"]:IsValid()) then
                            adv_savewormholes["wormhole4"] = inst
                        elseif string.find(taskandroom,"IslandHop_Forest") and (adv_savewormholes["wormhole5"]==nil or not adv_savewormholes["wormhole5"]:IsValid()) then
                            adv_savewormholes["wormhole5"] = inst
                        elseif string.find(taskandroom,"IslandHop_Savanna") and (adv_savewormholes["wormhole6"]==nil or not adv_savewormholes["wormhole6"]:IsValid()) then
                            adv_savewormholes["wormhole6"] = inst
                        elseif string.find(taskandroom,"IslandHop_Savanna") and (adv_savewormholes["wormhole7"]==nil or not adv_savewormholes["wormhole7"]:IsValid()) then
                            adv_savewormholes["wormhole7"] = inst
                        elseif string.find(taskandroom,"IslandHop_Rocky") and (adv_savewormholes["wormhole8"]==nil or not adv_savewormholes["wormhole8"]:IsValid()) then
                            adv_savewormholes["wormhole8"] = inst
                        elseif string.find(taskandroom,"IslandHop_Rocky") and (adv_savewormholes["wormhole9"]==nil or not adv_savewormholes["wormhole9"]:IsValid()) then
                            adv_savewormholes["wormhole9"] = inst
                        elseif string.find(taskandroom,"IslandHop_Merm") and (adv_savewormholes["wormhole10"]==nil or not adv_savewormholes["wormhole10"]:IsValid()) then
                            adv_savewormholes["wormhole10"] = inst
                        end
                    elseif _G.TUNING.TELEPORTATOMOD.WORLDS[_G.TUNING.TELEPORTATOMOD.LEVEL].name=="Two Worlds" then -- there we only have 2 wormholes
                        taskandroom = GetRoom(inst)
                        -- print("connect wormholes")
                        if _G.TheWorld.firsttwoworldswormhole==nil and string.find(taskandroom,"Land of Plenty") then
                            _G.TheWorld.firsttwoworldswormhole = inst
                        elseif _G.TheWorld.firsttwoworldswormhole~=nil and string.find(taskandroom,"The other side") and _G.TheWorld.firsttwoworldswormhole.components.teleporter.targetTeleporter==nil then
                            inst.components.teleporter.targetTeleporter = _G.TheWorld.firsttwoworldswormhole
                            _G.TheWorld.firsttwoworldswormhole.components.teleporter.targetTeleporter = inst
                        end
                    end
                end
            end
        end)
        inst:DoTaskInTime(2,function(inst)
            if inst.components.teleporter.targetTeleporter==nil then
                inst:Remove()
            else
                local pt = inst:GetPosition()
                if adv_helpers.IsNearOcean(pt.x,pt.y,pt.z, 2) then
                    local success = false
                    success = adv_helpers.MoveInstAtLandPlotNearInst(inst,inst,8,0,8,4,4,2) -- move it a bit so it is not that near the ocean (otherwise player might fall into ocean)
                    if not success then
                        success = adv_helpers.MoveInstAtLandPlotNearInst(inst,inst,15,0,15,6,6,2) -- try again with bigger moves
                    end
                end
            end
            
        end)
    end
end)


-- following code from Baku/Loki99, thanks
local sitonthrone =
    _G.State{ 
        name = "throne_sit",
        tags = { "busy", "nopredict", "nomorph" },
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:Hide("ARM_carry") 
            inst.AnimState:Show("ARM_normal")
            inst.AnimState:PlayAnimation("appear")
            inst.AnimState:PushAnimation("throne_loop", true)
        end,
    }
AddStategraphState("wilson", sitonthrone) -- instead of spawning a puppet, we simply put the real player char on the throne
AddStategraphState("wilson_client", sitonthrone)
local danceplayers =
    _G.State{ 
        name = "shadowdance",
        tags = { "busy", "nopredict", "nomorph" },
        onenter = function(inst)
            inst:ClearBufferedAction()
                        inst.components.locomotor:StopMoving()
        if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
        end
            if inst.AnimState:IsCurrentAnimation("run_pst") then
                inst.AnimState:PushAnimation("emoteXL_pre_dance0")
            else
                inst.AnimState:PlayAnimation("emoteXL_pre_dance0")
            end
            inst.AnimState:PushAnimation("emoteXL_loop_dance0", true)
        end,
    }
AddStategraphState("wilson", danceplayers) -- other players who will not sit on throne will shadowdance
AddStategraphState("wilson_client", danceplayers)






-----------------------------------------------------------------------------------------------------------------
