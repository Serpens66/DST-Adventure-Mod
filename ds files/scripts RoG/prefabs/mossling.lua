require("brains/mosslingbrain")
require "stategraphs/SGmossling"

local assets =
{
	Asset("ANIM", "anim/mossling_build.zip"),
    Asset("ANIM", "anim/mossling_basic.zip"),
    Asset("ANIM", "anim/mossling_actions.zip"),
    Asset("ANIM", "anim/mossling_angry_build.zip")
   -- Asset("SOUND", "sound/mossling.fsb"),
}

local prefabs =
{
    "mossling_spin_fx",
    "goose_feather",
    "drumstick",
}

SetSharedLootTable( 'mossling',
{
    {'meat',             1.00},
    {'drumstick',        1.00},
    {'goose_feather',    1.00},
    {'goose_feather',    1.00},
    {'goose_feather',    0.33},
})

local BASE_TAGS = {"structure"}
local SEE_STRUCTURE_DIST = 20

local TARGET_DIST = 7
local LOSE_TARGET_DIST = 13
local TARGET_DIST = 6

local function HasGuardian(inst)
    local gs = inst.components.herdmember.herd
    return gs and gs.components.guardian:HasGuardian()
end

local function RetargetFn(inst)
    if inst:HasGuardian() or inst.mother_dead then
        return FindEntity(inst, TARGET_DIST, function(guy) 
            return inst.components.combat:CanTarget(guy)
               and not guy:HasTag("prey")
               and not guy:HasTag("smallcreature")
               and not guy:HasTag("mossling")
               and not guy:HasTag("moose")
               and (guy:HasTag("monster") or guy:HasTag("player"))
        end)
    end
end

local function IsInDanger(inst)
    --[[
    If the mosling doesn't have a guardian and 
    does have a combat target then the mosling is in danger.

    If the mosling does have a guardian and does have a combat target but the 
    combat target is a certain distance away then the mosling is safe.

    If the mosling doesn't have a combat target then the mosling is safe.
    --]]

    if not inst.components.combat.target then
        return false
    end

    if (not inst:HasGuardian() or inst.mother_dead) then
        return true
    elseif inst:HasGuardian() then
        if inst:GetDistanceSqToInst(inst.components.combat.target) <= LOSE_TARGET_DIST*LOSE_TARGET_DIST then
            return false
        else
            return true
        end
    end
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target) and IsInDanger(inst)
end

local function OnSave(inst, data)
    data.mother_dead = inst.mother_dead
end
        
local function OnLoad(inst, data)
    if data and data.mother_dead then
        inst.mother_dead = data.mother_dead
    end
end

local function OnEntitySleep(inst)
    if inst.shouldGoAway then
        inst:Remove()
    end
end

local function OnSeasonChange(inst, data)
    inst.shouldGoAway = (GetSeasonManager():GetSeason() ~= SEASONS.SPRING)
    if inst:IsAsleep() then
        OnEntitySleep(inst)
    end
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
end

local function OnCollide(inst, other)
    --Destroy?
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 60, function(guy) return guy.prefab == inst.prefab end, 60)
end


local function fn(Sim)
    local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()

    local s = 1
    trans:SetScale(s,s,s)

	shadow:SetSize(1.5, 1.25)
    
    inst.Transform:SetFourFaced()
    
	MakeCharacterPhysics(inst, 50, .5)
    inst.Physics:SetCollisionCallback(OnCollide)

    anim:SetBank("mossling")
    anim:SetBuild("mossling_build")
    anim:PlayAnimation("idle", true)
    
    ------------------------------------------

    inst:AddTag("mossling")
    inst:AddTag("animal")

    ------------------
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.MOSSLING_HEALTH)
    inst.components.health.destroytime = 5
    
    ------------------

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.MOSSLING_DAMAGE)
    inst.components.combat.playerdamagepercent = .5
    inst.components.combat:SetRange(TUNING.MOSSLING_ATTACK_RANGE)
    inst.components.combat.hiteffectsymbol = "mossling_body"
    inst.components.combat:SetAttackPeriod(TUNING.MOSSLING_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1.5, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/mossling/hurt")
    
    ------------------------------------------
 
    inst:AddComponent("sizetweener")

    ------------------------------------------
 
    inst:AddComponent("sleeper")
    --inst.components.sleeper:SetResistance(4)
    
    ------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('mossling')    
    
    ------------------------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    ------------------------------------------

    inst:AddComponent("knownlocations")
    inst:AddComponent("inventory")
    inst:AddComponent("herdmember")
    inst.components.herdmember.herdprefab = "mooseegg"

    ------------------------------------------

    inst:AddComponent("eater")
    inst.components.eater.foodprefs = {"MEAT", "VEGGIE", "SEEDS"}
    inst.components.eater.eatwholestack = true

    ------------------------------------------

    inst:ListenForEvent("seasonChange", function() OnSeasonChange(inst) end, GetWorld() )
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("entitysleep", OnEntitySleep)

    ------------------------------------------

    MakeMediumBurnableCharacter(inst, "swap_fire")
    inst.components.burnable.lightningimmune = true
    MakeHugeFreezableCharacter(inst, "mossling_body")

    inst.SeenBase = false
    inst.HasGuardian = HasGuardian

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:ListenForEvent("attacked", OnAttacked)

    ------------------------------------------

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.MOOSE_WALK_SPEED


    inst:SetStateGraph("SGmossling")
    local brain = require("brains/mosslingbrain")
    inst:SetBrain(brain)

    return inst
end

return Prefab( "common/monsters/mossling", fn, assets, prefabs) 
