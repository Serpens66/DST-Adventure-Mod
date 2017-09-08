questfunctions = require("scenarios/questfunctions")


local function OnCreate(inst, scenariorunner)
    local keeper = TheSim:FindFirstEntityWithTag("king") or questfunctions.SpawnPrefabAtLandPlotNearInst("shopkeeper",inst,17,0,17,1,15,15)
    if keeper then -- is enough to do this at start, cause component will save and load stuff
        if keeper.components.questgiver then -- needs to be added in prefab
            table.insert(keeper.components.questgiver.questlist,{"DestroyStatueMerm",inst})
        end
    end
end


return
{
    OnCreate = OnCreate,
}