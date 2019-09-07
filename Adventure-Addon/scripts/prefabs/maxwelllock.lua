local PopupDialogScreen = require "screens/popupdialog"

local assets =
{
	Asset("ANIM", "anim/diviningrod.zip"),
    Asset("SOUND", "sound/common.fsb"),
    Asset("ANIM", "anim/diviningrod_maxwell.zip")
}

local prefabs = 
{
    "diviningrodstart",
}

local function OnUnlock(inst, key, doer)
    inst.AnimState:PlayAnimation("idle_full")
    inst.throne = TheSim:FindFirstEntityWithTag("maxwellthrone")
    inst.throne.lock = inst
	
    inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_add_divining")
    doer:AddTag("shadowlord")
    inst.throne.startthread(inst.throne,false)
    for _,player in pairs(AllPlayers) do
        player.mynetvarMCutscene:set(true) -- execute it also for clients
    end
    
    -- local character = AllPlayers[1]~=nil and AllPlayers[1].prefab
    -- if character~=nil then
        -- ThePlayer.components.playercontroller:Enable(false)
        -- SetPause(true)

        -- local title =  STRINGS.UI.UNLOCKMAXWELL.TITLE
        -- local body =  STRINGS.UI.UNLOCKMAXWELL.BODY1..STRINGS.CHARACTER_NAMES[character]..string.format(STRINGS.UI.UNLOCKMAXWELL.BODY2, STRINGS.UI.GENDERSTRINGS[GetGenderStrings(character)].TWO)
        -- local popup = PopupDialogScreen(title, body,
                -- {
                    -- {text=STRINGS.UI.UNLOCKMAXWELL.YES, cb = function()
                        -- TheFrontEnd:PopScreen() 
                        -- SetPause(false)
                        -- inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_add_divining")
                        -- inst.throne.startthread(inst.throne)
                    -- end},

                    -- {text=STRINGS.UI.UNLOCKMAXWELL.NO, cb = function()
                        -- TheFrontEnd:PopScreen()               
                        -- SetPause(false)
                        -- ThePlayer.components.playercontroller:Enable(true)
                        -- inst.components.lock:Lock(doer)
                        -- inst:PushEvent("notfree")  
                    -- end}
                -- }
            -- )

        -- TheFrontEnd:PushScreen(  popup  )
    -- end
end

local function OnLock(inst, doer)
    inst.AnimState:PlayAnimation("idle_empty")
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("diviningrod")
    anim:SetBuild("diviningrod_maxwell")
    anim:PlayAnimation("activate_loop", true)
    
    inst:AddTag("maxwelllock")

    
    inst.entity:SetPristine()
	
	 if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("lock")
    inst.components.lock.locktype = "maxwell"
    inst.components.lock:SetOnUnlockedFn(OnUnlock)
    inst.components.lock:SetOnLockedFn(OnLock)
    
    
    inst:AddComponent("inspectable")

    return inst
end

return Prefab( "maxwelllock", fn, assets, prefabs)  , 
MakePlacer("maxwelllock_placer", "diviningrod", "diviningrod_maxwell", "activate_loop")
