chestfunctions = require("scenarios/chestfunctions")

local superrare = {"deerclops_eyeball","minotaurhorn","eyeturret_item",}
local rare = {"yellowgem", "orangegem", "greengem", "purplegem",}
local rarenostack = {"multitool_axe_pickaxe","batbat","armorslurper","greenamulet","nightsword","greenstaff","orangeamulet","yellowamulet","armor_sanity","yellowstaff",
    "ruinshat","armorruins","eyebrellahat","purpleamulet","trunkvest_winter","slurtlehat","walrushat","telestaff","orangestaff","molehat","armordragonfly","staff_tornado",
    "raincoat","beargervest",}
local medium = {"bluegem","redgem","manrabbit_tail","gears","livinglog","nightmarefuel","pigskin","slurper_pelt","slurtleslime","tentaclespots","transistor","blowdart_sleep",
    "blowdart_fire","blowdart_pipe","marble","healingsalve",}
local mediumnostack = {"beemine","beefalohat","beehat","blueprint","trunkvest_summer","bugnet","blueamulet","sweatervest","featherhat","firestaff",
    "bedroll_furry","icestaff","lantern","amulet","onemanband","panflute","sewing_kit","spiderhat","tentaclespike","trap_teeth","umbrella","cane",
    "winterhat","featherfan","nightstick","catcoonhat","rainhat","reflectivevest","tallbirdegg","fertilizer","minerhat",}
local often = {"boards","cutstone","fireflies","guano","gunpowder","houndstooth","poop","rope","charcoal","log","cutgrass","flint","rocks","twigs",}
local oftennostack = {"boomerang","fishingrod","footballhat","bedroll_straw","armorgrass","heatrock","armorwood","goldenaxe","goldenpickaxe","earmuffshat","goldenshovel",
    "strawhat","tophat",}
local food = {"butter","dragonfruit","goatmilk","trunk_summer","trunk_winter","mandrake","meat_dried","smallmeat_dried","dragonpie","fishsticks","jammypreserves","flowersalad",
    "frogglebunwich","fruitmedley","guacamole","honeyham","honeynuggets","kabobs","mandrakesoup","meatballs","bonestew","watermelonicle","monsterlasagna","perogies","powcake",
    "pumpkincookie","ratatouille","hotchili","stuffedeggplant","taffy","turkeydinner","unagi","waffles",}
    
    
local function SetRandomUses(item,low,up) -- low up between 0 and 1
    local rand = 0.8
    if item.components and item.components.finiteuses then
        item.components.finiteuses:SetUses(math.random(item.components.finiteuses.total * low, item.components.finiteuses.total * up))
        -- print("make finiteuses fuer "..tostring(item.prefab))
    end
    if item.components and item.components.armor then
        rand = GetRandomMinMax(low, up)
        item.components.armor:SetPercent(rand)
        -- print("make armor fuer "..tostring(item.prefab).." auf "..tostring(rand))
    end
    if item.components and item.components.fueled then
        rand = GetRandomMinMax(low, up)
        item.components.fueled:SetPercent(rand)
        -- print("make fuel fuer "..tostring(item.prefab).." auf "..tostring(rand))
    end
end    
    
local function OnCreate(inst, scenariorunner)
    local loot =  
    {
        {
            item = GetRandomItem(superrare),  
            chance = 0.01,
            count = 1,
        },
        {
            item = GetRandomItem(rarenostack),  
            chance = 0.05,
            initfn = function(item) SetRandomUses(item,0.5,1) end,
            count = 1,
        },
        {
            item = GetRandomItem(rare),  
            chance = 0.05,
            count = math.random(1,4),
        },
        {
            item = GetRandomItem(medium),  
            chance = 0.6,
            count = math.random(1,9),
        },
        {
            item = GetRandomItem(mediumnostack),  
            chance = 0.6,
            initfn = function(item) SetRandomUses(item,0.5,1) end,
            count = 1,
        },
        {
            item = GetRandomItem(medium),  
            chance = 0.6,
            count = math.random(1,9),
        },
        {
            item = GetRandomItem(mediumnostack),  
            chance = 0.6,
            initfn = function(item) SetRandomUses(item,0.5,1) end,
            count = 1,
        },
        {
            item = GetRandomItem(often),  
            chance = 0.95,
            count = math.random(1,20),
        },
        {
            item = GetRandomItem(oftennostack),  
            chance = 0.95,
            initfn = function(item) SetRandomUses(item,0.5,1) end,
            count = 1,
        },
        {
            item = GetRandomItem(often),  
            chance = 0.95,
            count = math.random(1,20),
        },
        {
            item = GetRandomItem(oftennostack),  
            chance = 0.95,
            initfn = function(item) SetRandomUses(item,0.5,1) end,
            count = 1,
        },
    }
	chestfunctions.AddChestItems(inst, loot)
end
    

local function settarget(inst, player)
    if inst and inst.brain then
        inst.brain.followtarget = player
    end
end

local function ghosttrap(inst, scenariorunner, data)
	--spawn ghosts in a circle around you
	local pt = Vector3(inst.Transform:GetWorldPosition())
    local theta = math.random() * 2 * PI
    local radius = 10
    local steps = 8
    local map = TheWorld.Map
    local player = data.player

    -- Walk the circle trying to find a valid spawn point
    for i = 1, steps do
        local offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))
        local wander_point = pt + offset
       
        if map:IsPassableAtPoint(wander_point:Get()) then
        	local ghost = SpawnPrefab("ghost")
            ghost.Transform:SetPosition(wander_point:Get())
            ghost:DoTaskInTime(1, settarget, player)
        end
        theta = theta - (2 * PI / steps)
    end

    if player and player.components and player.components.sanity then
	    player.components.sanity:DoDelta(-TUNING.SANITY_HUGE)
	end
    TheWorld:PushEvent("ms_forceprecipitation", true)
    inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_howl_LP", "howl")
end

local function enemytrap(inst, scenariorunner, data)
	--spawn enemy in a circle around you
	local pt = Vector3(inst.Transform:GetWorldPosition())
    local theta = math.random() * 2 * PI
    local radius = 10
    local steps = 6
    local map = TheWorld.Map
    local player = data.player

    -- Walk the circle trying to find a valid spawn point
    local prefab = GetRandomItem({"spider","hound","killerbee"})
    for i = 1, steps do
        local offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))
        local wander_point = pt + offset
       
        if map:IsPassableAtPoint(wander_point:Get()) then
        	local enemy = SpawnPrefab(prefab)
            enemy.Transform:SetPosition(wander_point:Get())
            enemy:DoTaskInTime(1, settarget, player)
        end
        theta = theta - (2 * PI / steps)
    end

    if player and player.components and player.components.sanity then
	    player.components.sanity:DoDelta(-TUNING.SANITY_MED)
	end
end

local function foodspoiltrap(inst, scenariorunner,data)
	--spawn poop cloud around area
    local perishamount = 0.5
    local player = data.player
    local inv = player and player.components.inventory
    if inv then

        local pack = inv:GetEquippedItem(EQUIPSLOTS.BODY)

        local helm = inv:GetEquippedItem(EQUIPSLOTS.HEAD)

        if helm and helm.components.perishable then
            helm.components.perishable:ReducePercent(perishamount)
        end

        if pack and pack.components.container then
            for k = 1, pack.components.container.numslots do
                local item = pack.components.container.slots[k]
                if item and item.components.edible and item.components.perishable then
                    item.components.perishable:ReducePercent(perishamount)
                end
            end
        end

        for k = 1, inv.maxslots do
            local item = inv.itemslots[k]
            if item and item.components.edible and item.components.perishable then
                item.components.perishable:ReducePercent(perishamount)
            end
        end
    end
    local pt = Vector3(inst.Transform:GetWorldPosition())
    local particle = SpawnPrefab("poopcloud")
    particle.Transform:SetScale(1.5, 1.5, 1.5)
    particle.Transform:SetPosition(pt.x, pt.y, pt.z)
    inst.SoundEmitter:PlaySound("dontstarve/common/toxic_cloud")
    --player.components.sanity:DoDelta(-TUNING.SANITY_MED)
    --go through player's inventory and find all spoilable objects, change spoil value.
end

local function explosivetrap(inst)
    if not inst.components or not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:SetLoot({"gunpowder","gunpowder","gunpowder","gunpowder","gunpowder","gunpowder","houndfire","houndfire"})
	inst.components.lootdropper:DropLoot()	
	--give the chest a loot dropper.
	--make the chest drop gunpowder and the fire object from fire hounds.
end

local shadows = {
	{
		prefab = "crawlingnightmare",
		count = 4,
	},
}
local function shadowtrap(inst, scenariorunner, data)
	local player = data.player
	inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_spawner_open_warning")
	if player and player.components and player.components.sanity then
		player.components.sanity:SetPercent(0.1)
		for i,v in pairs(shadows) do
			for j=1,v.count do
				local creature = SpawnPrefab(v.prefab)
				creature.Transform:SetPosition(inst.Transform:GetWorldPosition())
			end
		end
	end
end


local function triggertrap(inst, scenariorunner, data)
    local rand = GetRandomMinMax(0,1)
    if rand <=0.2 then
        ghosttrap(inst, scenariorunner, data)
    elseif rand<=0.4 then
        foodspoiltrap(inst, scenariorunner,data)
    elseif rand<=0.6 then
        inst:DoTaskInTime(3,explosivetrap)
    elseif rand<=0.9 then
        enemytrap(inst, scenariorunner, data)
    elseif rand<=1 then
        shadowtrap(inst, scenariorunner, data)
        
        
    -- elseif rand<=0.5 then
        
    -- elseif rand<=0.6 then
        
    -- elseif rand<=0.7 then
        
    -- elseif rand<=0.8 then
        
    -- elseif rand<=0.9 then
        
    -- elseif rand<=1.0 then
        
    end
end


local function OnOpenChest(inst, scenariorunner) 
    if not inst.alreadyopened then
        local loot =  
        {
            {
                item = GetRandomItem(food),  
                chance = 0.35,
                count = math.random(1,3),
            },
            {
                item = GetRandomItem(food),  
                chance = 0.35,
                count = math.random(1,3),
            },
        }
        chestfunctions.AddChestItems(inst, loot)
        inst.alreadyopened = true
    end
end

local function OnLoad(inst, scenariorunner) 
    inst:ListenForEvent("onopen", OnOpenChest)
    chestfunctions.InitializeChestTrap(inst, scenariorunner, triggertrap)
end

local function OnDestroy(inst)
    chestfunctions.OnDestroy(inst)
end


return
{
    OnCreate = OnCreate,
	OnLoad = OnLoad,
	OnDestroy = OnDestroy
}