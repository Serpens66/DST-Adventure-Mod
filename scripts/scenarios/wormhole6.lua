    
local function OnCreate(inst, scenariorunner)
    
end

local function OnLoad(inst, scenariorunner) 
    inst:AddTag("wormhole6")
end

return
{
    OnCreate = OnCreate,
	OnLoad = OnLoad,
}