local assets=
{
	Asset("ANIM", "anim/goatmilk.zip"),
}

local function defaultfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.AnimState:SetBank("goatmilk")
    inst.AnimState:SetBuild("goatmilk")
    inst.AnimState:PlayAnimation("idle")  
    
    MakeInventoryPhysics(inst)
    
    inst:AddTag("catfood")

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING.HEALING_SMALL
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
    inst.components.edible.sanityvalue = TUNING.SANITY_SMALL
    -- inst.components.edible.foodtype = "MEAT"
    
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"
    
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")  
    
	return inst
end

return Prefab("common/inventory/goatmilk", defaultfn, assets)
