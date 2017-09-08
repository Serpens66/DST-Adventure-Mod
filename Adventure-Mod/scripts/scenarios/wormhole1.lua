    
local function OnCreate(inst, scenariorunner)
    
end

local function OnLoad(inst, scenariorunner) 
    inst:AddTag("wormhole1")
end

return
{
    OnCreate = OnCreate,
	OnLoad = OnLoad,
}