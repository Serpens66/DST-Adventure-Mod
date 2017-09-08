    
local function OnCreate(inst, scenariorunner)
    
end

local function OnLoad(inst, scenariorunner) 
    inst:AddTag("wormhole5")
end

return
{
    OnCreate = OnCreate,
	OnLoad = OnLoad,
}