questfunctions = require("scenarios/questfunctions")


local function OnCreate(inst, scenariorunner)
    local keeper = inst --questfunctions.SpawnPrefabAtLandPlotNearInst("shopkeeper",inst,17,0,17,1,15,15) -- don't spawn a keeper for this quest. the pigking will be questgiver
    if keeper then -- is enough to do this at start, cause component will save and load stuff
        if keeper.components.questgiver then -- needs to be added in prefab
            keeper.components.questgiver.questname = "BuildPighouses"
            
            keeper.components.questgiver.near = 8
            keeper.components.questgiver.far = 9
            
            keeper.components.questgiver.questdiff = 3
            keeper.components.questgiver.questobject = inst
            local x, y, z = inst.Transform:GetWorldPosition() -- find houses near pigking
            local structures = TheSim:FindEntities(x, y, z, 50, nil, nil, {"structure"})
            local houses = {}
            for k,v in pairs(structures) do
                if v.prefab == "pighouse" then
                    table.insert(houses,v) -- a table that only include the houses near it. we have to count it first
                end
            end
            keeper.components.questgiver.questnumber = #houses -- number of houses in range at beginning
        end
    end
end


local function OnFinished(inst)
end

local function OnLoad(inst, scenariorunner) 
end

return
{
    OnCreate = OnCreate,
	OnLoad = OnLoad,
}