    
local function OnCreate(inst, scenariorunner)
    
end

local function OnLoad(inst, scenariorunner) 
    inst:AddTag("wormhole3")
end

return
{
    OnCreate = OnCreate,
	OnLoad = OnLoad,
}