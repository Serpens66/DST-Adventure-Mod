local easing = require("easing")

local assets=
{
	Asset("ANIM", "anim/tree_leaf_spike.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddPhysics()
    inst.Physics:SetCylinder(0.25,2)

    inst.Transform:SetFourFaced()
    
    inst.AnimState:SetBank("tree_leaf_spike")
    inst.AnimState:SetBuild("tree_leaf_spike")
 	inst.entity:AddSoundEmitter()

    inst:AddTag("birchnutroot")

    inst.target = nil
    inst:ListenForEvent("givetarget", function(inst, data)
        if data then
            if data.owner then inst.owner = data.owner end
            if data.target then inst.target = data.target end
            if data.targetangle then inst.targetangle = data.targetangle end
            if data.targetpos and inst.targetangle then 
                inst.targetpos = data.targetpos 
                inst.dist_to_cover = math.sqrt(distsq(inst:GetPosition(), inst.targetpos))
                inst.origin = inst:GetPosition()
                inst.vector = Vector3(math.cos(inst.targetangle) * inst.dist_to_cover, 0, -math.sin(inst.targetangle) * inst.dist_to_cover)
            end 

            if inst.vector and inst.origin then
                inst.step = 0
                inst.movetask = inst:DoPeriodicTask(1*FRAMES, function(inst)
                    inst.step = inst.step + 1
                    local x_dist = easing.inQuad(inst.step, 0, inst.vector.x, 29)
                    local z_dist = easing.inQuad(inst.step, 0, inst.vector.z, 29)
                    local x,y,z = inst.Transform:GetWorldPosition()
                    inst.Transform:SetPosition(inst.origin.x + x_dist, y, inst.origin.z + z_dist)
                end)
                inst:DoTaskInTime(29*FRAMES, function(inst) inst.movetask:Cancel() inst.movetask = nil end)
            end
        end
    end)
    
    inst:AddComponent("combat")
    inst.components.combat:SetAreaDamage(TUNING.DECID_MONSTER_ROOT_ATTACK_RADIUS)
    inst.components.combat:SetDefaultDamage(TUNING.DECID_MONSTER_DAMAGE)
    inst.components.combat.canbeattackedfn = function(inst) return false end
    inst.components.combat.notags = {"birchnutdrake", "birchnutroot", "birchnut"}

    inst.AnimState:PlayAnimation("ground_loop")
    inst.AnimState:PushAnimation("up", false)
    inst.AnimState:PushAnimation("idle", false)
    inst.AnimState:PushAnimation("atk", false)
    inst.AnimState:PushAnimation("down", false)

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/whip_move", "rumble")
    inst:DoTaskInTime(29*FRAMES, function(inst) 
        inst.SoundEmitter:KillSound("rumble")
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/whip_pop")
        if inst.target then 
            inst:FacePoint(inst.target.Transform:GetWorldPosition()) 
        end 
    end)
    inst:DoTaskInTime(50*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/whip") end)
    inst:DoTaskInTime(55*FRAMES, function(inst) inst.components.combat:DoAttack() end)
    inst:DoTaskInTime(59*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/whip") end)

    inst:ListenForEvent("animqueueover", function(inst) inst:Remove() end)

    return inst
end

return Prefab( "forest/objects/trees/deciduous_root", fn, assets) 
