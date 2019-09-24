local Eater = Class(function(self, inst)
    self.inst = inst
    self.eater = false
    self.strongstomach = false
    self.foodprefs = { "GENERIC" }
    self.ablefoods = { "MEAT", "VEGGIE", "INSECT", "SEEDS", "GENERIC" }
    self:SetOmnivore()
    self.oneatfn = nil
    self.lasteattime = nil
    self.ignoresspoilage = false
    self.eatwholestack = false
    self.monsterimmune = false

    self.healthabsorption = 1
    self.hungerabsorption = 1
    self.sanityabsorption = 1        
end)

function Eater:SetAbsorptionModifiers(health, hunger, sanity)
    self.healthabsorption = health
    self.hungerabsorption = hunger
    self.sanityabsorption = sanity
end

function Eater:SetVegetarian(human)
    self.foodprefs = { "VEGGIE" }
    if human then
        self.ablefoods = { "MEAT", "VEGGIE", "INSECT", "SEEDS", "GENERIC" }
    else
        self.ablefoods = { "VEGGIE" }
    end
end

function Eater:SetCarnivore(human)
    self.foodprefs = { "MEAT" }
    if human then
        self.ablefoods = { "MEAT", "VEGGIE", "INSECT", "SEEDS", "GENERIC" }
    else
        self.ablefoods = { "MEAT" }
    end
end

function Eater:SetInsectivore()
    self.foodprefs = { "INSECT" }
    self.ablefoods = { "INSECT" }
end

function Eater:SetBird()
    self.foodprefs = {"SEEDS"}
    self.ablefoods = {"SEEDS"}
end

function Eater:SetBeaver()
    self.foodprefs = {"WOOD","ROUGHAGE"}
    self.ablefoods = {"WOOD","ROUGHAGE"}
end

function Eater:SetElemental(human)
    self.foodprefs = {"ELEMENTAL"}
    if human then
        self.ablefoods = { "MEAT", "VEGGIE", "INSECT", "SEEDS", "GENERIC", "ELEMENTAL" }
    else
        self.ablefoods = { "ELEMENTAL" }
    end
end

function Eater:TimeSinceLastEating()
	if self.lasteattime then
		return GetTime() - self.lasteattime
	end
end

function Eater:HasBeen(time)
    return self.lasteattime and self:TimeSinceLastEating() >= time or true
end

function Eater:OnSave()
    if self.lasteattime then
        return {time_since_eat = self:TimeSinceLastEating()}
    end
end

function Eater:OnLoad(data)
    if data.time_since_eat then
        self.lasteattime = GetTime() - data.time_since_eat
    end
end

function Eater:SetCanEatHorrible()
	table.insert(self.foodprefs, "HORRIBLE")
end

function Eater:SetOmnivore()
    self.foodprefs = { "MEAT", "VEGGIE", "INSECT", "SEEDS", "GENERIC" }
    self.ablefoods = { "MEAT", "VEGGIE", "INSECT", "SEEDS", "GENERIC" }
end

function Eater:SetOnEatFn(fn)
    self.oneatfn = fn
end

function Eater:SetCanEatTestFn(fn)
    self.caneattest = fn
end

function Eater:DoFoodEffects(food)
    if food:HasTag("monstermeat") then
        if self.inst:HasTag("player") then
            return not self.monsterimmune
        else
            return not self.strongstomach
        end
    else
        return true
    end
end

function Eater:Eat( food )
    if self:CanEat(food) then
        local stack_mult = self.eatwholestack and food.components.stackable ~= nil and food.components.stackable:StackSize() or 1

        if self.inst.components.health then
            if (food.components.edible.healthvalue < 0 and self:DoFoodEffects(food) or food.components.edible.healthvalue > 0) and self.inst.components.health then
                local delta = food.components.edible:GetHealth(self.inst) * self.healthabsorption * self.healthabsorption
                self.inst.components.health:DoDelta(delta* stack_mult, nil, food.prefab) 
            end
        end

        if self.inst.components.hunger then
            local delta = food.components.edible:GetHunger(self.inst) * self.hungerabsorption
            if delta ~= 0 then
                self.inst.components.hunger:DoDelta(delta * stack_mult)
            end
        end
        
        if (food.components.edible.sanityvalue < 0 and self:DoFoodEffects(food) or food.components.edible.sanityvalue > 0) and self.inst.components.sanity then
            local delta = food.components.edible:GetSanity(self.inst) * self.sanityabsorption
            if delta ~= 0 then
                self.inst.components.sanity:DoDelta(delta * stack_mult)
            end
        end
        
        self.inst:PushEvent("oneat", {food = food})
        if self.oneatfn then
            self.oneatfn(self.inst, food)
        end
        
        if food.components.edible then
            food.components.edible:OnEaten(self.inst)
        end
        
        if food.components.stackable and food.components.stackable.stacksize > 1 and not self.eatwholestack then
            food.components.stackable:Get():Remove()
        else
            food:Remove()
        end
        
        self.lasteattime = GetTime()
        
        self.inst:PushEvent("oneatsomething", {food = food})
        
        return true
    end
end

function Eater:IsValidFood(food)
    if self.inst == GetPlayer() and food.components.edible.foodtype == "ELEMENTAL" then
        return false
    elseif food.components.edible.foodtype == "WOOD" then
        if self.inst.components.beaverness and self.inst.components.beaverness:IsBeaver() then
            return true
        else
            return false
        end
    elseif self.inst ~= GetPlayer() then
        return self:CanEat(food)
    else
        return true
    end
end

function Eater:AbleToEat(inst)
    if inst and inst.components.edible then
        for k,v in pairs(self.ablefoods) do
            if v == inst.components.edible.foodtype then
                if self.caneattest then
                    return self.caneattest(self.inst, inst)
                end
                return true
            end
        end
    end
end

function Eater:CanEat(inst)
    if inst and inst.components.edible then
        for k,v in pairs(self.foodprefs) do
            if v == inst.components.edible.foodtype then
				if self.caneattest then
					return self.caneattest(self.inst, inst)
				end
                return true
            end
        end
    end
end

return Eater