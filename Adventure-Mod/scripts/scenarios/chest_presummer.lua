chestfunctions = require("scenarios/chestfunctions")
-- local loot =
-- {
    -- {
        -- item = "log",
        -- count = 7
    -- },
    -- {
        -- item = "winterhat",
        -- count = 1
    -- },
    -- {
        -- item = "flint",
        -- count = 3
    -- },
-- }

local function OnCreate(inst, scenariorunner)
    local difficulty = TUNING.ADV_DIFFICULTY or 0
    
    local loot = {}
    if difficulty==0 then   -- DS
        loot =
        {
            {
                item = "log",
                count = 7
            },
            {
                item = "winterhat",
                count = 1
            },
            {
                item = "flint",
                count = 3
            },
        }
    elseif difficulty==1 then -- easy
        loot =
        {
            {
                item = "log",
                count = math.random(7, 14),
            },
            {
                item = "winterhat",
                count = 1
            },
            {
                item = "flint",
                count = math.random(3, 7),
            },
            {
                item = "grass_umbrella",
                count = 1,
            },
        }
    elseif difficulty==2 then -- medium
        loot =
        {
            {
                item = "log",
                count = math.random(4, 10),
            },
            {
                item = "winterhat",
                count = 1
            },
            {
                item = "flint",
                count = math.random(3, 5),
            },
            {
                item = "grass_umbrella",
                count = 1,
            },
        }
    elseif difficulty==3 then -- hard
        loot =
        {
            {
                item = "log",
                count = math.random(3, 5),
            },
            {
                item = "winterhat",
                count = 1,
                chance = 0.5,
            },
            {
                item = "flint",
                count = 2
            },
            {
                item = "grass_umbrella",
                count = 1,
                chance = 0.6,
            },
        }
    end
    chestfunctions.AddChestItems(inst, loot)
end

return
{
    OnCreate = OnCreate,
}
