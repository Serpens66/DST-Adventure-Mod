local helpers = _G.require("tele_helpers")

local function OnCreate(inst, scenariorunner)
    local difficulty = TUNING.ADV_DIFFICULTY or 0
    if difficulty~=0 then -- ds
        local spawn = nil
        local prefabs = {"shadow_bishop","shadow_knight","shadow_rook"} -- normal
        if difficulty==1 then -- easy
            prefabs = {"shadow_rook"}
        elseif difficulty==3 then -- hard
            prefabs = {"shadow_bishop","shadow_knight","shadow_rook","nightmarebeak","crawlingnightmare"}
        end
        for _,prefab in ipairs(prefabs) do
            spawn = helpers.SpawnPrefabAtLandPlotNearInst(prefab,inst,10,0,10,nil,1,1)
        end
    end
end

return
{
    OnCreate = OnCreate,
}
