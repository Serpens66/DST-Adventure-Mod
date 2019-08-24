chestfunctions = require("scenarios/chestfunctions")

local function OnCreate(inst, scenariorunner)
    local difficulty = TUNING.ADV_DIFFICULTY or 0
    
    local loot = {}
    if difficulty==0 then   -- DS
        loot = 
        {
            {
                item = "cutgrass",
                count = math.random(3, 30),
            },
            {
                item = "log",
                count = math.random(3, 30),
            },
            {
                item = "minerhat_blueprint",
            },
        }
    elseif difficulty==1 then   -- easy
        loot = 
        {
            {
                item = "cutgrass",
                count = math.random(15, 30),
            },
            {
                item = "log",
                count = math.random(10, 22),
            },
            {
                item = "twigs",
                count = math.random(15, 30),
            },
            {
                item = "grass_umbrella",
                count = 1,
            },
            {
                item = "minerhat_blueprint",
            },
        }
    elseif difficulty==2 then   
        loot = 
        {
            {
                item = "cutgrass",
                count = math.random(7, 15),
            },
            {
                item = "log",
                count = math.random(4, 10),
            },
            {
                item = "twigs",
                count = math.random(7, 15),
            },
            {
                item = "grass_umbrella",
                count = 1,
                chance = 0.6,
            },
            {
                item = "minerhat_blueprint",
            },
        }
    elseif difficulty==3 then   -- hard
        loot = 
        {
            {
                item = "cutgrass",
                count = math.random(3, 7),
            },
            {
                item = "log",
                count = math.random(2, 4),
            },
            {
                item = "twigs",
                count = math.random(3, 7),
            },
            {
                item = "minerhat_blueprint",
            },
        }
    end

    local chanceloot =
    {
        --set1
        {
            {
                item = "gunpowder",
                count = math.random(3, 5),
            },
            {
                item = "firestaff",
            },
        },

        --set2
        {
            item = "fishingrod_blueprint",
        },
    }

    chestfunctions.AddChestItems(inst, loot)
    chestfunctions.AddChestItems(inst, chanceloot[math.random(#chanceloot)])
end

return
{
    OnCreate = OnCreate,
}
