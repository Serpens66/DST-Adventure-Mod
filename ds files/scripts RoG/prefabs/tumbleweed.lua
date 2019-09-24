local easing = require("easing")

local AVERAGE_WALK_SPEED = 4
local WALK_SPEED_VARIATION = 2
local SPEED_VAR_INTERVAL = .5
local ANGLE_VARIANCE = 10

local assets =
{
	Asset("ANIM", "anim/tumbleweed.zip"),
}

local prefabs = 
{
	"cutgrass",
	"twigs",
    "petals",
    "foliage",
    "silk",
    "rope",
    "seeds",
    "purplegem",
    "bluegem",
    "redgem",
    "orangegem",
    "yellowgem",
    "greengem",
    "seeds",
    "trinket_6",
    "cutreeds",
    "feather_crow",
    "feather_robin",
    "feather_robin_winter",
	"trinket_3",
    "beefalowool",
    "rabbit",
    "mole",
    "butterflywings",
    "fireflies",
    "beardhair",
    "berries",
    "blueprint",
    "petals_evil",
    "trinket_8",
    "houndstooth",
    "stinger",
    "gears",
    "spider",
    "frog",
    "bee",
    "mosquito",
    "boneshard",
}

local SFX_COOLDOWN = 5

local function onplayerprox(inst)
    if not inst.last_prox_sfx_time or (GetTime() - inst.last_prox_sfx_time > SFX_COOLDOWN) then
	   inst.last_prox_sfx_time = GetTime()
       inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tumbleweed_choir")
    end
end

local function CheckGround(inst)
    if not inst:IsOnValidGround() then
        local fx = SpawnPrefab("splash_ocean")
        local pos = inst:GetPosition()
        fx.Transform:SetPosition(pos.x, pos.y, pos.z)
        -- Shut down all the possible tasks
        if inst.bouncepretask then
            inst.bouncepretask:Cancel()
            inst.bouncepretask = nil
        end
        if inst.bouncetask then
            inst.bouncetask:Cancel()
            inst.bouncetask = nil
        end
        if inst.restartmovementtask then
            inst.restartmovementtask:Cancel()
            inst.restartmovementtask = nil
        end
        if inst.bouncepst1 then
            inst.bouncepst1:Cancel()
            inst.bouncepst1 = nil
        end
        if inst.bouncepst2 then
            inst.bouncepst2:Cancel()
            inst.bouncepst2 = nil
        end
        -- And remove the tumbleweed
        inst:Remove()
    end
end

local function startmoving(inst)
    inst.AnimState:PushAnimation("move_loop", true)
    inst.bouncepretask = inst:DoTaskInTime(10*FRAMES, function(inst)
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tumbleweed_bounce")
        inst.bouncetask = inst:DoPeriodicTask(24*FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tumbleweed_bounce")
            CheckGround(inst)
        end)
    end)
    inst.components.blowinwind:Start()
    inst:RemoveEventCallback("animover", startmoving, inst)
end

local function onpickup(inst, owner)
	if owner and owner.components.inventory then
		if inst.owner and inst.owner.components.childspawner then 
			inst:PushEvent("pickedup")
		end

		local item = nil
		for i, v in ipairs(inst.loot) do
			item = SpawnPrefab(v)
            item.Transform:SetPosition(inst.Transform:GetWorldPosition())
            if item.components.inventoryitem and item.components.inventoryitem.ondropfn then
                item.components.inventoryitem.ondropfn(item)
            end
            if inst.lootaggro[i] and item.components.combat and GetPlayer() then
                if not (GetPlayer():HasTag("spiderwhisperer") and item:HasTag("spider")) and not (GetPlayer():HasTag("monster") and item:HasTag("spider")) then
                    item.components.combat:SuggestTarget(GetPlayer())
                end
            end
    	end
    end
    inst:RemoveEventCallback("animover", startmoving, inst)
    inst.AnimState:PlayAnimation("break")
    inst.DynamicShadow:Enable(false)
    inst:ListenForEvent("animover", function(inst) inst:Remove() end)
    return true --This makes the inventoryitem component not actually give the tumbleweed to the player
end

local function MakeLoot(inst)
    local possible_loot =
    {
        {chance = 40,   item = "cutgrass"},
        {chance = 40,   item = "twigs"},
        {chance = 1,    item = "petals"},
        {chance = 1,    item = "foliage"},
        {chance = 1,    item = "silk"},
        {chance = 1,    item = "rope"},
        {chance = 1,    item = "seeds"},
        {chance = 0.01, item = "purplegem"},
        {chance = 0.04, item = "bluegem"},
        {chance = 0.02, item = "redgem"},
        {chance = 0.02, item = "orangegem"},
        {chance = 0.01, item = "yellowgem"},
        {chance = 0.02, item = "greengem"},
        {chance = 1,    item = "seeds"},
        {chance = 0.5,  item = "trinket_6"},
        {chance = 0.5,  item = "trinket_4"},
        {chance = 1,    item = "cutreeds"},
        {chance = 0.33, item = "feather_crow"},
        {chance = 0.33, item = "feather_robin"},
        {chance = 0.33, item = "feather_robin_winter"},
        {chance = 1,    item = "trinket_3"},
        {chance = 1,    item = "beefalowool"},
        {chance = 0.1,  item = "rabbit"},
        {chance = 0.1,  item = "mole"},
        {chance = 0.1,  item = "spider", aggro = true},
        {chance = 0.1,  item = "frog", aggro = true},
        {chance = 0.1,  item = "bee", aggro = true},
        {chance = 0.1,  item = "mosquito", aggro = true},
        {chance = 1,    item = "butterflywings"},
        {chance = .02,  item = "beardhair"},
        {chance = 1,    item = "berries"},
        {chance = 1,    item = "blueprint"},
        {chance = 1,    item = "petals_evil"},
        {chance = 1,    item = "trinket_8"},
        {chance = 1,    item = "houndstooth"},
        {chance = 1,    item = "stinger"},
        {chance = 1,    item = "gears"},
        {chance = 0.1,  item = "boneshard"},
    }
    local totalchance = 0
    for m, n in ipairs(possible_loot) do
        totalchance = totalchance + n.chance
    end

    inst.loot = {}
    inst.lootaggro = {}
    local next_loot = nil
    local next_aggro = nil
    local next_chance = nil
    local num_loots = 3
    while num_loots > 0 do
        next_chance = math.random()*totalchance
        next_loot = nil
        next_aggro = nil
        for m, n in ipairs(possible_loot) do
            next_chance = next_chance - n.chance
            if next_chance <= 0 then
                next_loot = n.item
                if n.aggro then next_aggro = true end
                break
            end
        end
        if next_loot ~= nil then
            table.insert(inst.loot, next_loot)
            if next_aggro then 
                table.insert(inst.lootaggro, true)
            else
                table.insert(inst.lootaggro, false)
            end
            num_loots = num_loots - 1
        end
    end
end

local function DoDirectionChange(inst, data)

    if not inst.entity:IsAwake() then return end

    if data and data.angle and data.velocity and inst.components.blowinwind then
        if inst.angle == nil then
            inst.angle = math.clamp(GetRandomWithVariance(data.angle, ANGLE_VARIANCE), 0, 360)
            inst.components.blowinwind:Start(inst.angle, data.velocity)
        else
            inst.angle = math.clamp(GetRandomWithVariance(data.angle, ANGLE_VARIANCE), 0, 360)
            inst.components.blowinwind:ChangeDirection(inst.angle, data.velocity)
        end
    end
end

local function onburnt(inst)
    inst.components.pickable.canbepicked = false
    inst.components.propagator:StopSpreading()

    inst.Physics:Stop()
    inst.components.blowinwind:Stop()
    inst:RemoveEventCallback("animover", startmoving, inst)

    if inst.bouncepretask then
        inst.bouncepretask:Cancel()
        inst.bouncepretask = nil
    end
    if inst.bouncetask then
        inst.bouncetask:Cancel()
        inst.bouncetask = nil
    end
    if inst.restartmovementtask then
        inst.restartmovementtask:Cancel()
        inst.restartmovementtask = nil
    end
    if inst.bouncepst1 then
        inst.bouncepst1:Cancel()
        inst.bouncepst1 = nil
    end
    if inst.bouncepst2 then
        inst.bouncepst2:Cancel()
        inst.bouncepst2 = nil
    end

    inst.AnimState:PlayAnimation("move_pst")
    inst.AnimState:PushAnimation("idle")
    inst.bouncepst1 = inst:DoTaskInTime(4*FRAMES, function(inst)
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tumbleweed_bounce")
        inst.bouncepst1 = nil
    end)
    inst.bouncepst2 = inst:DoTaskInTime(10*FRAMES, function(inst)
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tumbleweed_bounce")
        inst.bouncepst2 = nil
    end)

    inst:DoTaskInTime(1.2, function(inst)
        local ash = SpawnPrefab("ash")
        ash.Transform:SetPosition(inst.Transform:GetWorldPosition())
        
        if inst.components.stackable then
            ash.components.stackable.stacksize = inst.components.stackable.stacksize
        end

        inst:Remove()
    end)
end

local function CancelRunningTasks(inst)
    if inst.bouncepretask then
       inst.bouncepretask:Cancel()
        inst.bouncepretask = nil
    end
    if inst.bouncetask then
        inst.bouncetask:Cancel()
        inst.bouncetask = nil
    end
    if inst.restartmovementtask then
        inst.restartmovementtask:Cancel()
        inst.restartmovementtask = nil
    end
    if inst.bouncepst1 then
       inst.bouncepst1:Cancel()
        inst.bouncepst1 = nil
    end
    if inst.bouncepst2 then
        inst.bouncepst2:Cancel()
        inst.bouncepst2 = nil
    end
end


local function OnEntitySleep(inst)
	CancelRunningTasks(inst)
end

local function OnEntityWake(inst)
    inst.AnimState:PlayAnimation("move_loop", true)
    inst.bouncepretask = inst:DoTaskInTime(10*FRAMES, function(inst)
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tumbleweed_bounce")
        inst.bouncetask = inst:DoPeriodicTask(24*FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tumbleweed_bounce")
            CheckGround(inst)
        end)
    end)
end



local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()

    inst.Transform:SetFourFaced()
    shadow:SetSize( 1.7, .8 )

    anim:SetBuild("tumbleweed")
    anim:SetBank("tumbleweed")
    anim:PlayAnimation("move_loop", true)
    

    MakeCharacterPhysics(inst, .5, 1)
    inst:AddComponent("locomotor")
    inst.components.locomotor:SetTriggersCreep(false)

    inst:AddComponent("blowinwind")
    inst.components.blowinwind.soundPath = "dontstarve_DLC001/common/tumbleweed_roll"
    inst.components.blowinwind.soundName = "tumbleweed_roll"
    inst.components.blowinwind.soundParameter = "speed"
    inst.angle = (GetWorld() and GetWorld().components.worldwind) and GetWorld().components.worldwind:GetWindAngle() or nil
    inst:ListenForEvent("windchange", function(it, data)
        DoDirectionChange(inst, data)
    end, GetWorld())
    if inst.angle ~= nil then
        inst.angle = math.clamp(GetRandomWithVariance(inst.angle, ANGLE_VARIANCE), 0, 360)
        inst.components.blowinwind:Start(inst.angle)
    else
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tumbleweed_roll", "tumbleweed_roll")
    end

    ---local color = 0.5 + math.random() * 0.5
    ---anim:SetMultColour(color, color, color, 1)
    
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetOnPlayerNear(onplayerprox)
	inst.components.playerprox:SetDist(5,10)

	--inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
    inst.components.pickable.onpickedfn = onpickup
    inst.components.pickable.canbepicked = true
    inst.components.pickable.witherable = false

    inst:ListenForEvent("startlongaction", function(inst)
        inst.Physics:Stop()
        inst.components.blowinwind:Stop()
        inst:RemoveEventCallback("animover", startmoving, inst)

		CancelRunningTasks(inst)

        inst.AnimState:PlayAnimation("move_pst")
        inst.bouncepst1 = inst:DoTaskInTime(4*FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tumbleweed_bounce")
            inst.bouncepst1 = nil
        end)
        inst.bouncepst2 = inst:DoTaskInTime(10*FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tumbleweed_bounce")
            inst.bouncepst2 = nil
        end)
        inst.AnimState:PushAnimation("idle", true)
        inst.restartmovementtask = inst:DoTaskInTime(math.random(2,6), function(inst)
            if inst and inst.components.blowinwind then
                inst.AnimState:PlayAnimation("move_pre")
                inst.restartmovementtask = nil
                inst:ListenForEvent("animover", startmoving)
            end
        end)
    end)

    MakeLoot(inst)

    inst:AddComponent("burnable")
    inst.components.burnable:SetFXLevel(2)
    inst.components.burnable:AddBurnFX("character_fire", Vector3(.1, 0, .1), "swap_fire")
    inst.components.burnable.canlight = true
    inst.components.burnable:SetOnIgniteFn(function(inst) if inst.components.burnable then inst.components.burnable:Ignite() end end)
    inst.components.burnable:SetOnBurntFn(onburnt)
    inst.components.burnable:SetBurnTime(10)
    inst.components.burnable:MakeDragonflyBait(1)

    MakeSmallPropagator(inst)
    inst.components.propagator.flashpoint = 5 + math.random()*3
    inst.components.propagator.propagaterange = 5

   	inst.OnEntityWake = OnEntityWake
   	inst.OnEntitySleep = OnEntitySleep  

    return inst
end

return Prefab( "badlands/objects/tumbleweed", fn, assets, prefabs) 
