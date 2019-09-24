local assets =
{
    Asset("ANIM", "anim/tree_leaf_short.zip"),
    Asset("ANIM", "anim/tree_leaf_normal.zip"),
    Asset("ANIM", "anim/tree_leaf_tall.zip"),
    Asset("ANIM", "anim/tree_leaf_monster.zip"),
    Asset("ANIM", "anim/tree_leaf_trunk_build.zip"), --trunk build (winter leaves build)
    Asset("ANIM", "anim/tree_leaf_green_build.zip"), --spring, summer leaves build
    Asset("ANIM", "anim/tree_leaf_red_build.zip"), --autumn leaves build
    Asset("ANIM", "anim/tree_leaf_orange_build.zip"), --autumn leaves build
    Asset("ANIM", "anim/tree_leaf_yellow_build.zip"), --autumn leaves build
    Asset("ANIM", "anim/tree_leaf_poison_build.zip"), --poison leaves build
    Asset("ANIM", "anim/dust_fx.zip"),
    Asset("SOUND", "sound/forest.fsb"),
    Asset("MINIMAP_IMAGE", "tree_leaf"),
}

local prefabs =
{
    "log",
    "twigs",
    "acorn",
    "charcoal",
    "green_leaves",
    "red_leaves",    
    "orange_leaves",
    "yellow_leaves",
    "purple_leaves",
    "green_leaves_chop",
    "red_leaves_chop",
    "orange_leaves_chop",
    "yellow_leaves_chop",
    "purple_leaves_chop",
    "deciduous_root",
    "livinglog",
    "nightmarefuel",
    "spoiled_food",
    "birchnutdrake"
}

local builds = 
{
	normal = { --Green
		leavesbuild="tree_leaf_green_build",
		prefab_name="deciduoustree",
		normal_loot = {"log", "log"},
		short_loot = {"log"},
		tall_loot = {"log", "log", "log", "acorn"},
		drop_acorns=true,
        fx="green_leaves",
        chopfx="green_leaves_chop",
        shelter=true,
    },
    barren = {
        leavesbuild=nil,
        prefab_name="deciduoustree",
        normal_loot = {"log", "log"},
        short_loot = {"log"},
        tall_loot = {"log", "log", "log"},
        drop_acorns=false,
        fx=nil,
        chopfx=nil,
        shelter=false,
    },
    red = {
        leavesbuild="tree_leaf_red_build",
        prefab_name="deciduoustree",
        normal_loot = {"log", "log"},
        short_loot = {"log"},
        tall_loot = {"log", "log", "log", "acorn"},
        drop_acorns=true,
        fx="red_leaves",
        chopfx="red_leaves_chop",
        shelter=true,
    },
    orange = {
        leavesbuild="tree_leaf_orange_build",
        prefab_name="deciduoustree",
        normal_loot = {"log", "log"},
        short_loot = {"log"},
    tall_loot = {"log", "log", "log", "acorn"},
        drop_acorns=true,
        fx="orange_leaves",
        chopfx="orange_leaves_chop",
        shelter=true,
    },
    yellow = {
        leavesbuild="tree_leaf_yellow_build",
        prefab_name="deciduoustree",
        normal_loot = {"log", "log"},
        short_loot = {"log"},
        tall_loot = {"log", "log", "log", "acorn"},
        drop_acorns=true,
        fx="yellow_leaves",
        chopfx="yellow_leaves_chop",
        shelter=true,
    },
    poison = {
        leavesbuild="tree_leaf_poison_build",
        prefab_name="deciduoustree",
        normal_loot = {"livinglog", "acorn", "acorn"},
        short_loot = {"livinglog", "acorn"},
        tall_loot = {"livinglog", "acorn", "acorn", "acorn"},
        drop_acorns=true,
        fx="purple_leaves",
        chopfx="purple_leaves_chop",
        shelter=true,
    },
}

local function makeanims(stage)
    if stage == "monster" then
        return {
            idle="idle_tall",
            sway1="sway_loop_agro",
            sway2="sway_loop_agro",
            swayaggropre="sway_agro_pre",
            swayaggro="sway_loop_agro",
            swayaggropst="sway_agro_pst",
            swayaggroloop="idle_loop_agro",
            swayfx="swayfx_tall",
            chop="chop_tall_monster",
            fallleft="fallleft_tall_monster",
            fallright="fallright_tall_monster",
            stump="stump_tall_monster",
            burning="burning_loop_tall",
            burnt="burnt_tall",
            chop_burnt="chop_burnt_tall",
            idle_chop_burnt="idle_chop_burnt_tall",
            dropleaves = "drop_leaves_tall",
            growleaves = "grow_leaves_tall",
        }
    else
        return {
            idle="idle_"..stage,
            sway1="sway1_loop_"..stage,
            sway2="sway2_loop_"..stage,
            swayaggropre="sway_agro_pre",
            swayaggro="sway_loop_agro",
            swayaggropst="sway_agro_pst",
            swayaggroloop="idle_loop_agro",
            swayfx="swayfx_"..stage,
            chop="chop_"..stage,
            fallleft="fallleft_"..stage,
            fallright="fallright_"..stage,
            stump="stump_"..stage,
            burning="burning_loop_"..stage,
            burnt="burnt_"..stage,
            chop_burnt="chop_burnt_"..stage,
            idle_chop_burnt="idle_chop_burnt_"..stage,
            dropleaves = "drop_leaves_"..stage,
            growleaves = "grow_leaves_"..stage,
        }
    end
end

local short_anims = makeanims("short")
local tall_anims = makeanims("tall")
local normal_anims = makeanims("normal")
local monster_anims = makeanims("monster")

local function GetBuild(inst)
	local build = builds[inst.build]
	if build == nil then
		return builds["normal"]
	end
	return build
end

local function SpawnLeafFX(inst, waittime, chop)
    if inst:HasTag("fire") or inst:HasTag("stump") or inst:HasTag("burnt") or inst:IsAsleep() then
        return
    end
    if waittime then
        inst:DoTaskInTime(waittime, function(inst, chop) SpawnLeafFX(inst, nil, chop) end)
        return
    end

    local fx = nil
    if chop then 
        if GetBuild(inst).chopfx then fx = SpawnPrefab(GetBuild(inst).chopfx) end
    else
        if GetBuild(inst).fx then fx = SpawnPrefab(GetBuild(inst).fx) end
    end
    if fx then
        local x, y, z= inst.Transform:GetWorldPosition()
        if inst.components.growable and inst.components.growable.stage == 1 then
            y = y + 0 --Short FX height
        elseif inst.components.growable and inst.components.growable.stage == 2 then
            y = y - .3 --Normal FX height
        elseif inst.components.growable and inst.components.growable.stage == 3 then
            y = y + 0 --Tall FX height
        end
        if chop then y = y + (math.random()*2) end --Randomize height a bit for chop FX
        fx.Transform:SetPosition(x,y,z)
    end
end

local function PushSway(inst, monster, monsterpost, skippre)
    if monster then
        inst.sg:GoToState("gnash_pre", {push=true, skippre=skippre})
    else
        if monsterpost then
            if inst.sg:HasStateTag("gnash") then
                inst.sg:GoToState("gnash_pst")
            else
                inst.sg:GoToState("gnash_idle")
            end
        else   
            if inst.monster then 
                inst.sg:GoToState("gnash_idle")
            else    
                if math.random() > .5 then
                    inst.AnimState:PushAnimation(inst.anims.sway1, true)
                else
                    inst.AnimState:PushAnimation(inst.anims.sway2, true)
                end
            end
        end
    end
end

local function Sway(inst, monster, monsterpost)

    if inst.sg:HasStateTag("burning") or inst:HasTag("stump") then return end
    if monster then
        inst.sg:GoToState("gnash_pre", {push=false, skippre=false})
    else
        if monsterpost then
            if inst.sg:HasStateTag("gnash") then
                inst.sg:GoToState("gnash_pst")
            else
                inst.sg:GoToState("gnash_idle")
            end
        else
            if inst.monster then 
                inst.sg:GoToState("gnash_idle")
            else
                if math.random() > .5 then
                    inst.AnimState:PlayAnimation(inst.anims.sway1, true)
                else
                    inst.AnimState:PlayAnimation(inst.anims.sway2, true)
                end
            end
        end        
    end
end

local function GrowLeavesFn(inst, monster, monsterout)
    if inst:HasTag("stump") or inst:HasTag("burnt") or inst:HasTag("fire") then 
        inst:RemoveEventCallback("animover", GrowLeavesFn)
        return
    end

    if inst.leaf_state == "barren" or inst.target_leaf_state == "barren" then 
        inst:RemoveEventCallback("animover", GrowLeavesFn)
        if inst.target_leaf_state == "barren" then inst.build = "barren" end
    end

    if GetBuild(inst).leavesbuild then
        inst.AnimState:OverrideSymbol("swap_leaves", GetBuild(inst).leavesbuild, "swap_leaves")
    else
        inst.AnimState:ClearOverrideSymbol("swap_leaves")
    end

    if inst.components.growable then
        if inst.components.growable.stage == 1 then
            inst.components.lootdropper:SetLoot(GetBuild(inst).short_loot)
        elseif inst.components.growable.stage == 2 then
            inst.components.lootdropper:SetLoot(GetBuild(inst).normal_loot)
        else
            inst.components.lootdropper:SetLoot(GetBuild(inst).tall_loot)
        end
    end

    inst.leaf_state = inst.target_leaf_state
    if inst.leaf_state == "barren" then
        inst.AnimState:Hide("mouseover")
    else
        if inst.build == "barren" then
            inst.build = (inst.leaf_state == "normal") and "normal" or "red"
        end
        inst.AnimState:Show("mouseover")
    end

    if not monster and not monsterout then Sway(inst) end
end

local function OnChangeLeaves(inst, monster, monsterout)
    if inst:HasTag("stump") or inst:HasTag("burnt") or inst:HasTag("fire") then 
        inst.targetleaveschangetime = nil
        inst.leaveschangetask = nil
        return
    end
    if not monster and inst.components.workable and inst.components.workable.lastworktime and inst.components.workable.lastworktime < GetTime() - 10 then
        inst.targetleaveschangetime = GetTime() + 11
        inst.leaveschangetask = inst:DoTaskInTime(11, OnChangeLeaves)
        return
    else
        inst.targetleaveschangetime = nil
        inst.leaveschangetask = nil
    end

    if inst.target_leaf_state ~= "barren" then
        if inst.target_leaf_state == "colorful" then
            local rand = math.random()
            if rand < .33 then
                inst.build = "red"
            elseif rand < .67 then
                inst.build = "orange"
            else
                inst.build = "yellow"
            end
            inst.AnimState:SetMultColour(1, 1, 1, 1)
        elseif inst.target_leaf_state == "poison" then
            inst.AnimState:SetMultColour(1, 1, 1, 1)
            inst.build = "poison"
        else
            inst.AnimState:SetMultColour(inst.color, inst.color, inst.color, 1)
            inst.build = "normal"
        end

        if inst.leaf_state == "barren" then
            if GetBuild(inst).leavesbuild then
                inst.AnimState:OverrideSymbol("swap_leaves", GetBuild(inst).leavesbuild, "swap_leaves")
            else
                inst.AnimState:ClearOverrideSymbol("swap_leaves")
            end
            inst.AnimState:PlayAnimation(inst.anims.growleaves)
            inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
            inst:ListenForEvent("animover", GrowLeavesFn)
        else
            GrowLeavesFn(inst, monster, monsterout)
        end
    else
        inst.AnimState:PlayAnimation(inst.anims.dropleaves)
        SpawnLeafFX(inst, 11*FRAMES)
        inst.SoundEmitter:PlaySound("dontstarve/forest/treeWilt")
        inst:ListenForEvent("animover", GrowLeavesFn)
    end
    if GetBuild(inst).shelter then
        if not inst:HasTag("shelter") then inst:AddTag("shelter") end
    else
        while inst:HasTag("shelter") do inst:RemoveTag("shelter") end
    end
end

local function OnSeasonChange(inst, season)
    if season == SEASONS.AUTUMN then
        inst.target_leaf_state = "colorful"
    elseif season == SEASONS.WINTER then
        inst.target_leaf_state = "barren"
    else --SPRING AND SUMMER
        inst.target_leaf_state = "normal"
    end

    if inst.target_leaf_state ~= inst.leaf_state then
        local time = math.random(TUNING.MIN_LEAF_CHANGE_TIME, TUNING.MAX_LEAF_CHANGE_TIME)
        inst.targetleaveschangetime = GetTime() + time
        inst.leaveschangetask = inst:DoTaskInTime(time, OnChangeLeaves)
    end
end

local function ChangeSizeFn(inst)
    inst:RemoveEventCallback("animover", ChangeSizeFn)
    if inst.components.growable then
        if inst.components.growable.stage == 1 then
            inst.anims = short_anims
        elseif inst.components.growable.stage == 2 then
            inst.anims = normal_anims
        else
            if inst.monster then
                inst.anims = monster_anims
            else
                inst.anims = tall_anims
            end
        end
    end

    Sway(inst, nil, inst.monster)
end          

local function SetShort(inst)
    if not inst.monster then
        inst.anims = short_anims
        if inst.components.workable then
	       inst.components.workable:SetWorkLeft(TUNING.DECIDUOUS_CHOPS_SMALL)
	    end
        inst.components.lootdropper:SetLoot(GetBuild(inst).short_loot)
    end
end

local function GrowShort(inst)
    if not inst.monster then
        inst.AnimState:PlayAnimation("grow_tall_to_short")
        if inst.leaf_state == "colorful" then SpawnLeafFX(inst, 17*FRAMES) end
        inst:ListenForEvent("animover", ChangeSizeFn)
        inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
    end
end

local function SetNormal(inst)
    inst.anims = normal_anims
    if inst.components.workable then
	    inst.components.workable:SetWorkLeft(TUNING.DECIDUOUS_CHOPS_NORMAL)
	end
    inst.components.lootdropper:SetLoot(GetBuild(inst).normal_loot)
end

local function GrowNormal(inst)
    inst.AnimState:PlayAnimation("grow_short_to_normal")
    if inst.leaf_state == "colorful" then SpawnLeafFX(inst, 10*FRAMES) end
    inst:ListenForEvent("animover", ChangeSizeFn)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
end

local function SetTall(inst)
    inst.anims = tall_anims
    if inst.components.workable then
		inst.components.workable:SetWorkLeft(TUNING.DECIDUOUS_CHOPS_TALL)
	end
    inst.components.lootdropper:SetLoot(GetBuild(inst).tall_loot)
end

local function GrowTall(inst)
    inst.AnimState:PlayAnimation("grow_normal_to_tall")
    if inst.leaf_state == "colorful" then SpawnLeafFX(inst, 10*FRAMES) end
    inst:ListenForEvent("animover", ChangeSizeFn)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")   
end

local growth_stages =
{
    {name="short", time = function(inst) return GetRandomWithVariance(TUNING.DECIDUOUS_GROW_TIME[1].base, TUNING.DECIDUOUS_GROW_TIME[1].random) end, fn = function(inst) SetShort(inst) end,  growfn = function(inst) GrowShort(inst) end},
    {name="normal", time = function(inst) return GetRandomWithVariance(TUNING.DECIDUOUS_GROW_TIME[2].base, TUNING.DECIDUOUS_GROW_TIME[2].random) end, fn = function(inst) SetNormal(inst) end, growfn = function(inst) GrowNormal(inst) end},
    {name="tall", time = function(inst) return GetRandomWithVariance(TUNING.DECIDUOUS_GROW_TIME[3].base, TUNING.DECIDUOUS_GROW_TIME[3].random) end, fn = function(inst) SetTall(inst) end, growfn = function(inst) GrowTall(inst) end},
    --{name="old", time = function(inst) return GetRandomWithVariance(TUNING.DECIDUOUS_GROW_TIME[4].base, TUNING.DECIDUOUS_GROW_TIME[4].random) end, fn = function(inst) SetOld(inst) end, growfn = function(inst) GrowOld(inst) end },
}

local function chop_tree(inst, chopper, chops)
    
    if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")          
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
	end

    SpawnLeafFX(inst, nil, true)

    -- Force update anims if monster
    if inst.monster then 
        inst.anims = monster_anims
    end
    inst.AnimState:PlayAnimation(inst.anims.chop)

    if inst.monster then
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/hurt_chop")
        inst.sg:GoToState("chop_pst")
    else
        PushSway(inst)
    end
end

local function dig_up_stump(inst, chopper)
    inst:Remove()
    if inst.monster then
        inst.components.lootdropper:SpawnLootPrefab("livinglog")
    else
        inst.components.lootdropper:SpawnLootPrefab("log")
    end
end

local function chop_down_tree(inst, chopper)
    inst:RemoveComponent("burnable")
    MakeSmallBurnable(inst)
    inst:RemoveComponent("propagator")
    inst:RemoveComponent("workable")
    while inst:HasTag("shelter") do inst:RemoveTag("shelter") end
    while inst:HasTag("cattoyairborne") do inst:RemoveTag("cattoyairborne") end
    inst:AddTag("stump")

    if inst.monster_start_task then
        inst.monster_start_task:Cancel()
        inst.monster_start_task = nil
    end
    if inst.monster_stop_task then
        inst.monster_stop_task:Cancel()
        inst.monster_stop_task = nil
    end

    local days_survived = GetClock().numcycles
    if not inst.monster and inst.leaf_state ~= "barren" and inst.components.growable and inst.components.growable.stage == 3 and days_survived >= TUNING.DECID_MONSTER_MIN_DAY then
        local chance = TUNING.DECID_MONSTER_SPAWN_CHANCE_BASE
        local thresh_chance = { TUNING.DECID_MONSTER_SPAWN_CHANCE_LOW, TUNING.DECID_MONSTER_SPAWN_CHANCE_MED, TUNING.DECID_MONSTER_SPAWN_CHANCE_HIGH }
        for k,v in ipairs(TUNING.DECID_MONSTER_DAY_THRESHOLDS) do
            if days_survived >= v then
                chance = thresh_chance[k]
            else
                break
            end
        end
        if math.random() <= chance then
            local pt = inst:GetPosition()
            local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 30, {"birchnut"}, {"stump", "burnt", "monster", "FX", "NOCLICK", "DECOR", "INLIMBO"})
            local max_monsters_to_spawn = math.random(3,4)
            for k,v in pairs(ents) do
                if not v:HasTag("fire") and not v:HasTag("stump") and not v:HasTag("burnt") and v.leaf_state ~= "barren" and not v.monster and not v.monster_start_task and not v.monster_stop_task then
                    v.monster_start_task = v:DoTaskInTime(math.random(1,4), function(v) 
                        v:StartMonster() 
                        v.monster_start_task = nil
                    end) 
                    max_monsters_to_spawn = max_monsters_to_spawn - 1
                end
                if max_monsters_to_spawn <= 0 then break end
            end
        end
    end

    if inst.monster then
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/death")
        inst.sg:GoToState("empty")
        inst.components.lootdropper:AddChanceLoot("livinglog", TUNING.DECID_MONSTER_ADDITIONAL_LOOT_CHANCE)
        inst.components.lootdropper:AddChanceLoot("nightmarefuel", TUNING.DECID_MONSTER_ADDITIONAL_LOOT_CHANCE)
        if inst.components.deciduoustreeupdater then inst.components.deciduoustreeupdater:StopMonster() end
        if inst.monster_stop_task then
            inst.monster_stop_task:Cancel()
            inst.monster_stop_task = nil
        end
        inst:RemoveComponent("combat")
    end

    if inst.leaveschangetask then
        inst.leaveschangetask:Cancel()
        inst.leaveschangetask = nil
    end

    inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")

    local pt = Vector3(inst.Transform:GetWorldPosition())
    local hispos = Vector3(chopper.Transform:GetWorldPosition())

    local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0

    if he_right then
        inst.AnimState:PlayAnimation(inst.anims.fallleft)
        if inst.components.growable and inst.components.growable.stage == 3 and inst.leaf_state == "colorful" then
            inst.components.lootdropper:SpawnLootPrefab("acorn", pt - TheCamera:GetRightVec())
        end
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
    else
        inst.AnimState:PlayAnimation(inst.anims.fallright)
        if inst.components.growable and inst.components.growable.stage == 3 and inst.leaf_state == "colorful" then
            inst.components.lootdropper:SpawnLootPrefab("acorn", pt - TheCamera:GetRightVec())
        end
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
    end

    inst:DoTaskInTime(.4, function() 
		local sz = (inst.components.growable and inst.components.growable.stage > 2) and .5 or .25
		GetPlayer().components.playercontroller:ShakeCamera(inst, "FULL", 0.25, 0.03, sz, 6)
    end)
    
    RemovePhysicsColliders(inst)
    inst.AnimState:PushAnimation(inst.anims.stump)

    if inst.leaveschangetask then
        inst.leaveschangetask:Cancel()
        inst.leaveschangetask = nil
    end
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(dig_up_stump)
    inst.components.workable:SetWorkLeft(1)
    
    if inst.components.growable then
        inst.components.growable:StopGrowing()
    end
end

local function chop_down_burnt_tree(inst, chopper)
    inst:RemoveComponent("workable")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")          
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
    inst.AnimState:PlayAnimation(inst.anims.chop_burnt)
    RemovePhysicsColliders(inst)
    inst:ListenForEvent("animover", function() inst:Remove() end)
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
    inst.components.lootdropper:DropLoot()
    if inst.acorntask then
        inst.acorntask:Cancel()
        inst.acorntask = nil
    end
end

local function onburntchanges(inst)
    inst:RemoveComponent("growable")
    while inst:HasTag("shelter") do inst:RemoveTag("shelter") end
    while inst:HasTag("cattoyairborne") do inst:RemoveTag("cattoyairborne") end
    inst:RemoveTag("dragonflybait")
    inst:RemoveTag("fire")
    inst:RemoveTag("monster")
    inst.monster = false

    if inst.monster_start_task then
        inst.monster_start_task:Cancel()
        inst.monster_start_task = nil
    end
    if inst.monster_stop_task then
        inst.monster_stop_task:Cancel()
        inst.monster_stop_task = nil
    end

    inst.components.lootdropper:SetLoot({})
    if GetBuild(inst).drop_acorns then
        inst.components.lootdropper:AddChanceLoot("acorn", 0.1)
    end
    
    if inst.components.workable then
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnWorkCallback(nil)
        inst.components.workable:SetOnFinishCallback(chop_down_burnt_tree)
    end

    if inst.leaveschangetask then
        inst.leaveschangetask:Cancel()
        inst.leaveschangetask = nil
    end

    inst.AnimState:PlayAnimation(inst.anims.burnt, true)
    inst:DoTaskInTime(3*FRAMES, function(inst)
        if inst.components.burnable and inst.components.propagator then
            inst.components.burnable:Extinguish()
            inst.components.propagator:StopSpreading()
            inst:RemoveComponent("burnable")
            inst:RemoveComponent("propagator")
        end
    end)
end

local function OnBurnt(inst, imm)
    inst:AddTag("burnt")
    if imm then
        if inst.monster then
            inst.monster = false
            if inst.components.deciduoustreeupdater then 
                inst.components.deciduoustreeupdater:StopMonster() 
                inst:RemoveComponent("deciduoustreeupdater")
            end
            if inst.components.combat then inst:RemoveComponent("combat") end
            inst.sg:GoToState("empty")
            inst.AnimState:SetBank("tree_leaf")
            inst:DoTaskInTime(1*FRAMES, onburntchanges)
        else
            onburntchanges(inst)
        end
    else
        inst:DoTaskInTime( 0.5, function(inst)
            if inst.monster then
                inst.monster = false
                if inst.components.deciduoustreeupdater then 
                    inst.components.deciduoustreeupdater:StopMonster() 
                    inst:RemoveComponent("deciduoustreeupdater")
                end
                if inst.components.combat then inst:RemoveComponent("combat") end
                inst.sg:GoToState("empty")
                inst.AnimState:SetBank("tree_leaf")
                inst:DoTaskInTime(1*FRAMES, onburntchanges)
            else
                onburntchanges(inst)
            end
        end)
    end    
    inst.AnimState:SetRayTestOnBB(true);
end

local function tree_burnt(inst)
	OnBurnt(inst)
	inst.acorntask = inst:DoTaskInTime(10,
		function()
			local pt = Vector3(inst.Transform:GetWorldPosition())
			if math.random(0, 1) == 1 then
				pt = pt + TheCamera:GetRightVec()
			else
				pt = pt - TheCamera:GetRightVec()
			end
			inst.components.lootdropper:DropLoot(pt)
			inst.acorntask = nil
		end)
    if inst.leaveschangetask then
        inst.leaveschangetask:Cancel()
        inst.leaveschangetask = nil
    end
end

local function handler_growfromseed (inst)
	inst.components.growable:SetStage(1)

    local season = nil
    if GetSeasonManager() then season = GetSeasonManager():GetSeason() end
    if season then
        if season == SEASONS.AUTUMN then
            local rand = math.random()
            if rand < .33 then
                inst.build = "red"
            elseif rand < .67 then
                inst.build = "orange"
            else
                inst.build = "yellow"
            end
            inst.AnimState:SetMultColour(1, 1, 1, 1)
            inst.leaf_state = "colorful"
            inst.target_leaf_state = "colorful"
        elseif season == SEASONS.WINTER then
            inst.build = "barren"
            inst.leaf_state = "barren"
            inst.target_leaf_state = "barren"
        else
            inst.build = "normal"
            inst.leaf_state = "normal"
            inst.target_leaf_state = "normal"
        end
    end

    if GetBuild(inst).leavesbuild then
        inst.AnimState:OverrideSymbol("swap_leaves", GetBuild(inst).leavesbuild, "swap_leaves")
    else
        inst.AnimState:ClearOverrideSymbol("swap_leaves")
    end
    inst.AnimState:PlayAnimation("grow_seed_to_short")
    if inst.leaf_state == "colorful" then SpawnLeafFX(inst, 5*FRAMES) end
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
    inst.anims = short_anims

    PushSway(inst)
end

local function inspect_tree(inst)
    if inst:HasTag("burnt") then
        return "BURNT"
    elseif inst:HasTag("stump") then
        return "CHOPPED"
    elseif inst.monster then
        return "POISON"
    end
end

local function StartMonster(inst, force, starttimeoffset)
    -- Become a monster. Requires tree to have leaves and be medium size (it will grow to large size when become monster)
    if force or (inst.anims == normal_anims and inst.leaf_state ~= "barren") then
        inst.monster = true
        inst.target_leaf_state = "poison"
        inst:RemoveTag("cattoyairborne")

        if inst.leaveschangetask then
            inst.leaveschangetask:Cancel()
            inst.leaveschangetask = nil
        end

        if not force then 
            inst.components.growable:DoGrowth()
            inst:DoTaskInTime(12*FRAMES, function(inst) 
                OnChangeLeaves(inst, true)
                inst.components.growable:StopGrowing() 
            end)
        end

        inst:DoTaskInTime(26*FRAMES, function(inst)
            if inst.components.workable then
               inst.components.workable:SetWorkLeft(TUNING.DECIDUOUS_CHOPS_MONSTER)
            end
            inst.AnimState:SetBank("tree_leaf_monster")
            inst.AnimState:PlayAnimation("transform_in")
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/transform_in")
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/transform_voice")
            SpawnLeafFX(inst, 7*FRAMES)
            if GetBuild(inst).leavesbuild then
                inst.AnimState:OverrideSymbol("legs", GetBuild(inst).leavesbuild, "legs")
                inst.AnimState:OverrideSymbol("legs_mouseover", GetBuild(inst).leavesbuild, "legs_mouseover")
                inst.AnimState:OverrideSymbol("eye", GetBuild(inst).leavesbuild, "eye")
                inst.AnimState:OverrideSymbol("mouth", GetBuild(inst).leavesbuild, "mouth")
            else
                inst.AnimState:ClearOverrideSymbol("legs")
                inst.AnimState:ClearOverrideSymbol("legs_mouseover")
                inst.AnimState:ClearOverrideSymbol("eye")
                inst.AnimState:ClearOverrideSymbol("mouth")
            end
            inst:AddComponent("combat")
            inst.components.combat.canbeattackedfn = function(inst) return false end
            if not inst.components.deciduoustreeupdater then
                inst:AddComponent("deciduoustreeupdater")
            end
            inst.components.deciduoustreeupdater:StartMonster(starttimeoffset)
        end)
    end
end

local function StopMonster(inst)
    -- Return to normal tree behavior (also grow from tall to short)
    if inst.monster then
        inst.monster = false
        inst.monster_start_time = nil
        inst.monster_duration = nil
        if inst.components.deciduoustreeupdater then inst.components.deciduoustreeupdater:StopMonster() end
        inst:RemoveComponent("combat")
        inst:RemoveComponent("deciduoustreeupdater")
        if not inst:HasTag("stump") and not inst:HasTag("burnt") then 
            inst.AnimState:PlayAnimation("transform_out")
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/transform_out")
            SpawnLeafFX(inst, 8*FRAMES)
            inst.sg:GoToState("empty")
        end
        inst:DoTaskInTime(16*FRAMES, function(inst)
            inst.AnimState:ClearOverrideSymbol("eye")
            inst.AnimState:ClearOverrideSymbol("mouth")
            if not inst:HasTag("stump") then 
                inst.AnimState:ClearOverrideSymbol("legs")
                inst.AnimState:ClearOverrideSymbol("legs_mouseover") 
            end
            inst.AnimState:SetBank("tree_leaf")
            inst:AddTag("cattoyairborne")

            if GetSeasonManager() then
                if GetSeasonManager():IsAutumn() then
                    inst.target_leaf_state = "colorful"
                elseif GetSeasonManager():IsWinter() then
                    inst.target_leaf_state = "barren"
                else
                    inst.target_leaf_state = "normal"
                end
            end
            inst.components.growable:DoGrowth()
            inst:DoTaskInTime(12*FRAMES, function(inst) 
                OnChangeLeaves(inst, false, true) 
            end)
        end)
    end
end

local function OnEntitySleep(inst)
    local fire = false
    if inst:HasTag("fire") then
        fire = true
    end
    inst:RemoveComponent("burnable")
    inst:RemoveComponent("propagator")
    inst:RemoveComponent("inspectable")
    inst:RemoveComponent("deciduoustreeupdater")
    if fire then
        inst:AddTag("fire")
    end
end

local function OnEntityWake(inst)

    if not inst:HasTag("burnt") and not inst:HasTag("fire") and not inst:HasTag("stump") then
        if not inst.components.burnable then
            MakeLargeBurnable(inst)
            inst.components.burnable:SetFXLevel(5)
            inst.components.burnable:SetOnBurntFn(tree_burnt)
            inst.components.burnable.extinguishimmediately = false
            inst.components.burnable.onignite = function(inst) 
                if inst.monster and not inst:HasTag("stump") then 
                    inst.sg:GoToState("burning_pre") 
                end 
                if inst.components.deciduoustreeupdater then
                    inst.components.deciduoustreeupdater:SpawnIgniteWave()
                end
            end
            inst.components.burnable.onextinguish = function(inst) 
                if inst.monster and not inst:HasTag("stump") then
                    inst.sg:GoToState("gnash_idle")
                end
            end
        end

        if not inst.components.propagator then
            MakeLargePropagator(inst)
        end

        if not inst.components.deciduoustreeupdater then
            inst:AddComponent("deciduoustreeupdater")
        end
    end

    if inst.monster and inst.monster_start_time and inst.monster_duration and ((GetTime() - inst.monster_start_time) > inst.monster_duration) then
        if not inst:HasTag("burnt") and not inst:HasTag("fire") and not inst:HasTag("stump") then
            StopMonster(inst)
        else
            inst.monster = false
            inst.monster_start_time = nil
            inst.monster_duration = nil
            if inst.components.deciduoustreeupdater then 
                inst.components.deciduoustreeupdater:StopMonster() 
                inst:RemoveComponent("deciduoustreeupdater")
            end
            if inst.components.combat then inst:RemoveComponent("combat") end
        end
    end

    if not inst:HasTag("burnt") and inst:HasTag("fire") then
        inst.sg:GoToState("empty")
        inst.AnimState:ClearOverrideSymbol("eye")
        inst.AnimState:ClearOverrideSymbol("mouth")
        if not inst:HasTag("stump") then 
            inst.AnimState:ClearOverrideSymbol("legs")
            inst.AnimState:ClearOverrideSymbol("legs_mouseover") 
        end
        inst.AnimState:SetBank("tree_leaf")
        OnBurnt(inst, true)
    end

    if not inst.components.inspectable then
        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = inspect_tree
    end

end

local function onsave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
    
    if inst:HasTag("stump") then
        data.stump = true
    end

	if inst.build ~= "normal" then
		data.build = inst.build
	end

    data.monster = inst.monster
    if inst.monster and inst.components.deciduoustreeupdater and inst.components.deciduoustreeupdater.monster_start_time then
        data.monster_start_offset = inst.components.deciduoustreeupdater.monster_start_time - GetTime()
    end
    data.target_leaf_state = inst.target_leaf_state
    data.leaf_state = inst.leaf_state
    if inst.leaveschangetask and inst.targetleaveschangetime then
        data.leaveschangetime = inst.targetleaveschangetime - GetTime()
    end
end
        
local function onload(inst, data)
    if data then
		if not data.build or builds[data.build] == nil then
			inst.build = "normal"
		else
			inst.build = data.build            
		end

        inst.target_leaf_state = data.target_leaf_state
        inst.leaf_state = data.leaf_state

        if data.monster and not data.stump and not data.burnt then
            inst.monster = data.monster
            StartMonster(inst, true, data.monster_start_offset)
        elseif data.monster then
            if data.stump then
                inst.monster = data.monster
                inst.components.growable.stage = 3
                inst:AddTag("stump")
            elseif not data.burnt then
                inst.monster = false
                if GetSeasonManager() then
                    if GetSeasonManager():IsAutumn() then
                        inst.target_leaf_state = "colorful"
                    elseif GetSeasonManager():IsWinter() then
                        inst.target_leaf_state = "barren"
                    else
                        inst.target_leaf_state = "normal"
                    end
                end
                inst.components.growable:DoGrowth()
                inst:DoTaskInTime(12*FRAMES, function(inst) 
                    OnChangeLeaves(inst, false) 
                end)
            end
            if inst.components.deciduoustreeupdater then 
                inst.components.deciduoustreeupdater:StopMonster() 
                inst:RemoveComponent("deciduoustreeupdater")
            end
            if inst.components.combat then inst:RemoveComponent("combat") end
            inst.sg:GoToState("empty")
        end
        
        if inst.components.growable then
            if inst.components.growable.stage == 1 then
                inst.anims = short_anims
            elseif inst.components.growable.stage == 2 then
                inst.anims = normal_anims
            else
                if inst.monster then
                    inst.anims = monster_anims
                else
                    inst.anims = tall_anims
                end
            end
        else
            inst.anims = tall_anims
        end

        if data.burnt then
            inst:AddTag("fire") -- Add the fire tag here: OnEntityWake will handle it actually doing burnt logic
        elseif data.stump then
            while inst:HasTag("shelter") do inst:RemoveTag("shelter") end
            while inst:HasTag("cattoyairborne") do inst:RemoveTag("cattoyairborne") end
            inst:RemoveComponent("burnable")
            if not inst:HasTag("stump") then inst:AddTag("stump") end
            if data.monster then
                inst.AnimState:SetBank("tree_leaf_monster")
                if GetBuild(inst).leavesbuild then
                    inst.AnimState:OverrideSymbol("legs", GetBuild(inst).leavesbuild, "legs")
                    inst.AnimState:OverrideSymbol("legs_mouseover", GetBuild(inst).leavesbuild, "legs_mouseover")
                else
                    inst.AnimState:ClearOverrideSymbol("legs")
                    inst.AnimState:ClearOverrideSymbol("legs_mouseover")
                end
            end
            inst.AnimState:PlayAnimation(inst.anims.stump)

            MakeSmallBurnable(inst)
            inst:RemoveComponent("workable")
            inst:RemoveComponent("propagator")
            inst:RemoveComponent("growable")
            RemovePhysicsColliders(inst)
            
    		inst:AddComponent("workable")
    	    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    	    inst.components.workable:SetOnFinishCallback(dig_up_stump)
    	    inst.components.workable:SetWorkLeft(1)
        end
    end

    if data and data.leaveschangetime then
        inst.leaveschangetask = inst:DoTaskInTime(data.leaveschangetime, OnChangeLeaves)
    end

    if not data or (not data.burnt and not data.stump) then
        if inst.build ~= "normal" or inst.leaf_state ~= inst.target_leaf_state then
            OnChangeLeaves(inst)
        else
            if inst.build == "barren" then
                while inst:HasTag("shelter") do inst:RemoveTag("shelter") end
                inst.AnimState:Hide("mouseover")
            else
                inst.AnimState:Show("mouseover")
            end
            Sway(inst)
        end
    end
end        

local function makefn(build, stage, data)
	
    local function fn(Sim)
		local l_stage = stage
		if l_stage == 0 then
			l_stage = math.random(1,3)
		end

        local inst = CreateEntity()
        local trans = inst.entity:AddTransform()
        local anim = inst.entity:AddAnimState()
        local sound = inst.entity:AddSoundEmitter()

        inst:SetStateGraph("SGdeciduoustree")
        inst.sg:GoToState("empty")

        MakeObstaclePhysics(inst, .25)   

		local minimap = inst.entity:AddMiniMapEntity()
        minimap:SetIcon("tree_leaf.png")
		minimap:SetPriority(-1)
       
        inst:AddTag("tree")
        inst:AddTag("birchnut")
        inst:AddTag("shelter")
        inst:AddTag("workable")
        inst:AddTag("cattoyairborne")
        
        anim:SetBank("tree_leaf")
        inst.build = build
        anim:SetBuild("tree_leaf_trunk_build")

        if GetBuild(inst).leavesbuild then
            anim:OverrideSymbol("swap_leaves", GetBuild(inst).leavesbuild, "swap_leaves")
        end
        inst.color = 0.5 + math.random() * 0.5
        anim:SetMultColour(inst.color, inst.color, inst.color, 1)
            
        MakeLargeBurnable(inst)
        inst.components.burnable:SetFXLevel(5)
        inst.components.burnable:SetOnBurntFn(tree_burnt)
        inst.components.burnable.extinguishimmediately = false
        inst.components.burnable.onignite = function(inst) 
            if inst.monster and not inst:HasTag("stump") then 
                inst.sg:GoToState("burning_pre") 
            end 
            if inst.components.deciduoustreeupdater then
                inst.components.deciduoustreeupdater:SpawnIgniteWave()
            end
        end
        inst.components.burnable.onextinguish = function(inst) 
            if inst.monster and not inst:HasTag("stump") then
                inst.sg:GoToState("gnash_idle")
            end
        end
        inst.components.burnable:MakeDragonflyBait(1)
        
        MakeLargePropagator(inst)
        
        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = inspect_tree

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.CHOP)
        inst.components.workable:SetOnWorkCallback(chop_tree)
        inst.components.workable:SetOnFinishCallback(chop_down_tree)
        
        inst:AddComponent("lootdropper") 
        
        inst:AddComponent("deciduoustreeupdater")
        inst:ListenForEvent("sway", function(inst, data)
            local m = nil
            local m_pst = nil
            if data and data.monster then m = data.monster end
            if data and data.monsterpost then m_pst = data.monsterpost end
            Sway(inst, m, m_pst)
        end)

        inst.lastleaffxtime = 0
        inst.leaffxinterval = math.random(TUNING.MIN_SWAY_FX_FREQUENCY, TUNING.MAX_SWAY_FX_FREQUENCY)
        inst.SpawnLeafFX = SpawnLeafFX
        inst:ListenForEvent("deciduousleaffx", function(it)
            if inst.entity:IsAwake() then
                if inst.leaf_state == "colorful" and GetTime() - inst.lastleaffxtime > inst.leaffxinterval then
					local variance = math.random() * 2
                    SpawnLeafFX(inst, variance)
                    inst.leaffxinterval = math.random(TUNING.MIN_SWAY_FX_FREQUENCY, TUNING.MAX_SWAY_FX_FREQUENCY)
                    inst.lastleaffxtime = GetTime()
                end
            end
        end, GetWorld())

        inst:AddComponent("growable")
        inst.components.growable.stages = growth_stages
        inst.components.growable:SetStage(l_stage)
        inst.components.growable.loopstages = true
        inst.components.growable.springgrowth = true
        inst.components.growable:StartGrowing()
        
        inst.growfromseed = handler_growfromseed

        inst:ListenForEvent("daycomplete", function(it, data) 
            if inst.leaveschangetask ~= nil then return end
            local seasonmgr = GetSeasonManager()
            local targetSeason = nil
            if seasonmgr and seasonmgr:GetPercentSeason() >= .90 then
                local nextSeason = {
                    [SEASONS.AUTUMN] = SEASONS.WINTER, [SEASONS.WINTER] = SEASONS.SPRING,
                    [SEASONS.SPRING] = SEASONS.SUMMER, [SEASONS.SUMMER] = SEASONS.AUTUMN,
                }
                targetSeason = nextSeason[seasonmgr:GetSeason()]
                
                if targetSeason then
                    if seasonmgr:GetSeasonIsEnabled(targetSeason) then
                        OnSeasonChange(inst, targetSeason)
                    else
                        targetSeason = nextSeason[targetSeason]
                        local numchecks = 0
                        while not seasonmgr:GetSeasonIsEnabled(targetSeason) do
                            targetSeason = nextSeason[targetSeason]
                            numchecks = numchecks + 1
                            if numchecks > 4 then break end
                        end
                        if seasonmgr:GetSeasonIsEnabled(targetSeason) and targetSeason ~= seasonmgr:GetSeason() then
                            OnSeasonChange(inst, targetSeason)    
                        end
                    end                        
                end
            end
        end, GetWorld())

        inst.leaf_state = "normal"
        local season = GetSeasonManager():GetSeason()
        if season == SEASONS.AUTUMN then
            inst.target_leaf_state = "colorful"
        elseif season == SEASONS.WINTER then
            inst.target_leaf_state = "barren"
        else --SPRING AND SUMMER
            inst.target_leaf_state = "normal"
        end

        --OnChangeLeaves(inst, inst.monster)

        inst.StartMonster = StartMonster
        inst.StopMonster = StopMonster
        inst.monster = false

        inst.AnimState:SetTime(math.random()*2)
     
        inst.OnSave = onsave 
        inst.OnLoad = onload
        
		MakeSnowCovered(inst, .01)

		inst:SetPrefabName( GetBuild(inst).prefab_name )

        if data =="burnt"  then
            OnBurnt(inst)
        end
        
        if data =="stump"  then
            inst:RemoveTag("shelter")
            inst:RemoveComponent("burnable")
            MakeSmallBurnable(inst)            
            inst:RemoveComponent("workable")
            inst:RemoveComponent("propagator")
            inst:RemoveComponent("growable")
            RemovePhysicsColliders(inst)
            inst.AnimState:PlayAnimation(inst.anims.stump)
            inst:AddTag("stump")
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.DIG)
            inst.components.workable:SetOnFinishCallback(dig_up_stump)
            inst.components.workable:SetWorkLeft(1)
        end


        inst.OnEntitySleep = OnEntitySleep
        inst.OnEntityWake = OnEntityWake


        return inst
    end
    return fn
end    

local function tree(name, build, stage, data)
    return Prefab("forest/objects/trees/"..name, makefn(build, stage, data), assets, prefabs)
end

return tree("deciduoustree", "normal", 0),
		tree("deciduoustree_normal", "normal", 2),
        tree("deciduoustree_tall", "normal", 3),
        tree("deciduoustree_short", "normal", 1),
        tree("deciduoustree_burnt", "normal", 0, "burnt"),
        tree("deciduoustree_stump", "normal", 0, "stump") 
