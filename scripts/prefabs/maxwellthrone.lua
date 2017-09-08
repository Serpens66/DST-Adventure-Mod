local EndGameDialog = require("screens/endgamedialog")
local assets =
{
	Asset("ANIM", "anim/maxwell_throne.zip"),
    Asset("SOUND", "sound/sanity.fsb"),
    Asset("SOUND", "sound/common.fsb"),
    Asset("SOUND", "sound/wilson.fsb")

}

local prefabs =
{
    "maxwellendgame",
    -- "puppet_wilson",
    -- "puppet_willow",
    -- "puppet_wendy",
    -- "puppet_wickerbottom",
    -- "puppet_wolfgang",
    -- "puppet_wx78",
    -- "puppet_wes",
}

local function SpawnPuppet(inst, name)

    if name ~= "maxwellendgame" then
        name = "puppet_"..name
    end 
    local pt = Vector3(inst.Transform:GetWorldPosition())
    local puppet = SpawnPrefab(name)
    if puppet then
        puppet.Transform:SetPosition(pt.x, pt.y + 0.1, pt.z)
        puppet.persists = false
    end
    return puppet
end

local function DoCharacterUnlock(inst, whendone)
    -- GetPlayer().profile:UnlockCharacter("waxwell")  --unlock waxwell    
    -- GetPlayer().profile:SetValue("characterinthrone", SaveGameIndex:GetSlotCharacter() or "wilson") --The character that will be locked next time.    
    -- GetPlayer().profile.dirty = true
    -- GetPlayer().profile:Save(whendone)
end

local function ZoomAndFade4(inst)
    TheFrontEnd:DoFadeIn(0)
    for _,player in pairs(AllPlayers) do
        player.components.playercontroller:Enable(true)
        TheNet:Announce("Congratulation! You won the adventure!")
        player.HUD:Show()
    end
    TheCamera:SetDefault()
end

local function ZoomAndFade3(inst)
    TheFrontEnd:Fade(false, 3)

    inst:DoTaskInTime(4, ZoomAndFade4)
end

local function ZoomAndFade2(inst)
    if inst.phonograph then
        inst.phonograph.songToPlay = "dontstarve/maxwell/ragtime_2d"
        if not inst.phonograph.components.machine:IsOn() then
            inst.phonograph.components.machine:TurnOn()
        end
    end
    inst:DoTaskInTime(5, ZoomAndFade3)
end

local function ZoomAndFade(inst)
    if not inst.isMaxwell then
        TheCamera:SetOffset(Vector3(0, 1.45, 0))
    end
    TheCamera:SetDistance(7)
    inst:DoTaskInTime(2, ZoomAndFade2)
end

local function DecomposePuppet(inst)
    local tick_time = TheSim:GetTickTime()
    local time_to_erode = 4
    inst.puppet:StartThread( function()
        local ticks = 0
        while ticks * tick_time < time_to_erode do
            local erode_amount = ticks * tick_time / time_to_erode
            inst.puppet.AnimState:SetErosionParams( erode_amount, 0.1, 1.0 )
            ticks = ticks + 1
            Yield()
        end
        inst.puppet:Remove()
    end)
end

local function SpawnNewPuppet3(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/throne/playerappear")

    inst:DoTaskInTime(3,ZoomAndFade)
    -- Sleep(3)

    -- inst:StartThread(function() ZoomAndFade(inst) end)

end

local function SpawnNewPuppet2(inst)
    inst.SoundEmitter:KillSound("deathrattle")
    for _,player in pairs(AllPlayers) do
        player:Hide()
    end
    local puppetToSpawn =  AllPlayers[1].prefab or "wilson"
    -- if puppetToSpawn == "waxwell" then 
        puppetToSpawn = "maxwellendgame" 
    -- end
    local puppet = SpawnPuppet(inst, puppetToSpawn)
    if puppet.components.maxwelltalker then puppet:RemoveComponent("maxwelltalker") end    
    local pos = Vector3( inst.Transform:GetWorldPosition() )
    
	TheWorld:PushEvent('ms_sendlightningstrike', pos)

    -- if puppetToSpawn == "maxwellendgame" then 
        inst.AnimState:PlayAnimation("appear")
        inst.AnimState:PushAnimation("idle")
        inst.isMaxwell = true
        puppet.AnimState:PlayAnimation("appear")
        puppet.AnimState:PushAnimation("idle_loop", true)
    -- else
        -- inst.AnimState:PlayAnimation("player_appear")
        -- inst.AnimState:PushAnimation("player_idle_loop")
        -- inst.isMaxwell = false
        -- puppet.AnimState:PlayAnimation("appear")
        -- puppet.AnimState:PushAnimation("throne_loop", true)
    -- end

    if inst.DynamicShadow then
        inst.DynamicShadow:Enable(true)
    end

    local soundframedelay = 2
    -- Sleep(soundframedelay * (1/30))
    inst:DoTaskInTime(soundframedelay * (1/30),SpawnNewPuppet3)
end

local function SpawnNewPuppet(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/throne/thronemagic", "deathrattle")    
    -- DecomposePuppet(inst)
    TheCamera:Shake("FULL", 4, 0.033, 0.1)
    for _,player in pairs(AllPlayers) do
        player.sg:GoToState("teleportato_teleport")
        if player.DynamicShadow then
            player.DynamicShadow:Enable(false)
        end
    end
    
    -- Sleep(4)
    inst:DoTaskInTime(4,SpawnNewPuppet2)
end


local function MaxwellDie(inst)
    inst.AnimState:PlayAnimation("death")
    -- inst.puppet.AnimState:PlayAnimation("death")
    inst.SoundEmitter:PlaySound("dontstarve/maxwell/breakchains")    
    inst:DoTaskInTime(113 * (1/30), function() inst.SoundEmitter:PlaySound("dontstarve/maxwell/blowsaway") end)
    inst:DoTaskInTime(95 * (1/30), function() inst.SoundEmitter:PlaySound("dontstarve/maxwell/throne_scream") end)    
    inst:DoTaskInTime(213 * (1/30), function() inst.SoundEmitter:KillSound("deathrattle") end)
    
    inst:DoTaskInTime(9.5,SpawnNewPuppet)
end


local function PlayerDie(inst)
    inst.AnimState:PlayAnimation("player_death")
    -- inst.puppet.AnimState:PlayAnimation("dismount")
    -- inst.puppet.AnimState:PushAnimation("death", false)
    inst:DoTaskInTime(24 * (1/30), function() inst.SoundEmitter:PlaySound("dontstarve/wilson/death") end)
    inst:DoTaskInTime(40 * (1/30), function() inst.SoundEmitter:KillSound("deathrattle") end)
    
    inst:DoTaskInTime(4,SpawnNewPuppet)
end

local function SetUpCutscene3(inst)
    if inst.DynamicShadow then
        inst.DynamicShadow:Enable(false)
    end
    inst.SoundEmitter:PlaySound("dontstarve/common/throne/thronedisappear")
    if inst.isMaxwell then
        inst:DoTaskInTime(0,MaxwellDie)
        -- inst:StartThread(function() MaxwellDie(inst) end)
    else
        -- inst:StartThread(function() PlayerDie(inst) end)
        inst:DoTaskInTime(0,PlayerDie)
    end
end

local function SetUpCutscene2(inst)
    TheCamera:SetGains(0.5, .1, .3)
    -- Sleep(2)
    inst:DoTaskInTime(2,SetUpCutscene3)
end


local function SetUpCutscene(inst)
    -- print("HIER SetUpCutscene maxwellthrone")
    --Put game into "cutscene" mode. 
    -- if inst.puppet.components.maxwelltalker then
        -- if inst.puppet.components.maxwelltalker:IsTalking() then
            -- inst.puppet.components.maxwelltalker:StopTalking()
        -- end
        -- inst.puppet:RemoveComponent("maxwelltalker")
        -- inst.puppet.AnimState:PlayAnimation("idle_loop")
    -- end
    local pt = Vector3(inst.Transform:GetWorldPosition())
    for _,player in pairs(AllPlayers) do
        player:FacePoint(Vector3(pt.x - 100, pt.y, pt.z))
        player.components.playercontroller:Enable(false)
        player.HUD:Hide()
    end
    -- GetPlayer():FacePoint(Vector3(pt.x - 100, pt.y, pt.z))

    -- GetPlayer().components.playercontroller:Enable(false)
    -- GetPlayer().HUD:Hide()

    TheCamera:CutsceneMode(true)
    TheCamera:SetCustomLocation(Vector3(pt.x, pt.y, pt.z))
    TheCamera:SetGains(0.5, .1, 2)
    TheCamera:SetMinDistance(5)

    inst.previousLock = "waxwell"
    
    TheCamera:Shake("FULL", 5, 0.033, 0.1)

    inst.phonograph = TheSim:FindFirstEntityWithTag("maxwellphonograph")
    if inst.phonograph then
        if inst.phonograph.components.machine:IsOn() then
            inst.phonograph.components.machine:TurnOff()
        end
    end
    inst.SoundEmitter:PlaySound("dontstarve/common/throne/thronemagic", "deathrattle")

    -- Sleep(3)
    inst:DoTaskInTime(3,SetUpCutscene2)
end

local function startthread(inst)
    inst.task =  inst:StartThread(function() SetUpCutscene(inst) end)
end

local function fn(Sim)

    local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 3, 2 )    
    inst.entity:AddNetwork()
    MakeObstaclePhysics(inst, .1)
    inst.AnimState:SetBank("throne")
    inst.AnimState:SetBuild("maxwell_throne")
    inst.AnimState:PlayAnimation("idle", false)

    inst:AddTag("maxwellthrone")
    
    inst.entity:SetPristine()
	
	 if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")    

    local characterinthrone = "waxwell"

    inst.lock = nil
    inst.startthread = startthread


    if characterinthrone == "waxwell" then --special case for maxwell
        inst.isMaxwell = true
        characterinthrone = "maxwellendgame"
        inst:ListenForEvent("free", function()EndGameSequence(inst) end, inst.lock) --is called when diviningrod is placed at lock
    end
    
    -- inst:DoTaskInTime(0, function() inst.puppet = SpawnPuppet(inst, characterinthrone) end)
    return inst
end


return Prefab( "maxwellthrone", fn, assets, prefabs), 
MakePlacer("maxwellthrone_placer", "throne", "maxwell_throne", "idle")

