local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
    inst.entity:AddNetwork()
	inst:AddTag("teleportlocation")
	
	return inst
end

return Prefab("common/teleportlocation", fn) 