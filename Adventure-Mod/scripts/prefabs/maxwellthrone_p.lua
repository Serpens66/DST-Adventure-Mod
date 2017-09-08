--local EndGameDialog = require("screens/endgamedialog")
local assets =
{
	Asset("ANIM", "anim/maxwell_throne.zip"),
    Asset("SOUND", "sound/sanity.fsb"),
    Asset("SOUND", "sound/common.fsb"),
    Asset("SOUND", "sound/wilson.fsb")

}

local prefabs =
{
   
}

local function ZoomAndFade(inst)
    if not inst.isMaxwell then
        TheCamera:SetOffset(Vector3(0, 1.45, 0))
    end
    TheCamera:SetDistance(7)
    Sleep(2)
    if inst.phonograph then
        inst.phonograph.songToPlay = "dontstarve/maxwell/ragtime_2d"
        if not inst.phonograph.components.machine:IsOn() then
            inst.phonograph.components.machine:TurnOn()
        end
    end
    Sleep(5)
    TheFrontEnd:Fade(false, 3)

    Sleep(4)
    --endgame screen
    TheFrontEnd:DoFadeIn(0)

end

local function onbuilt(inst)
inst.SoundEmitter:PlaySound("dontstarve/common/throne/playerappear")
inst.AnimState:PlayAnimation("appear")
inst.AnimState:PushAnimation("idle", false)
end

local function startthread(inst)
    inst.task =  inst:StartThread(function() SetUpCutscene(inst) end)
end

local function fn()

    local inst = CreateEntity()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	
	--TheCamera:SetOffset(Vector3(0, 1.45, 0))
	--TheCamera:SetDistance(7)
	
	inst.DynamicShadow:SetSize( 3, 2 )    

    inst.AnimState:SetBank("throne")--pigtorch
    inst.AnimState:SetBuild("maxwell_throne")--pig_torch
    inst.AnimState:PlayAnimation("idle", false)

    inst:AddTag("maxwellthrone")

	inst.entity:SetPristine()
	
	 if not TheWorld.ismastersim then
        return inst
    end
	
	inst:ListenForEvent("onbuilt", onbuilt)
    inst:AddComponent("inspectable")    

    --local characterinthrone = GetPlayer().profile:GetValue("characterinthrone") or "waxwell"
    local characterinthrone = "waxwell"
    --inst.lock = nil
    --inst.startthread = startthread

    return inst
end

return Prefab( "maxwellthrone", fn, assets, prefabs), 
MakePlacer("maxwellthrone_placer", "throne", "maxwell_throne", "idle")
