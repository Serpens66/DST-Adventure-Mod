assets = 
{
	Asset("ANIM", "anim/purple_gem.zip"),
}


local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    inst.AnimState:SetBank("purplegem")
    inst.AnimState:SetBuild("purple_gem")
    inst.AnimState:PlayAnimation("idle")
    MakeInventoryPhysics(inst)
    
    inst.entity:SetPristine()
	
	 if not TheWorld.ismastersim then
        return inst
    end
    
	inst:AddComponent("key")
	inst.components.key.keytype = "maxwell"	

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:ChangeImageName("purplegem")

	return inst
end

return Prefab("maxwellkey", fn, assets)  , 
MakePlacer("maxwellkey_placer", "purplegem", "purple_gem", "idle")
