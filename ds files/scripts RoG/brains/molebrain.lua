require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"

local STOP_RUN_DIST = 10
local SEE_PLAYER_DIST = 5

local AVOID_PLAYER_DIST = 0
local AVOID_PLAYER_STOP = 6

local SEE_BAIT_DIST = 20
local MAX_WANDER_DIST = 20

local MoleBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GoHomeAction(inst)
    if inst.components.homeseeker and 
       inst.components.homeseeker.home and 
       inst.components.homeseeker.home:IsValid() and
	   inst.sg:HasStateTag("trapped") == false then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function ShouldMakeHome(inst)
    local make_home = false
    if not (inst.components.homeseeker and inst.components.homeseeker.home and inst.components.homeseeker.home:IsValid()) then
        make_home = true
    end
    make_home = make_home and (inst.needs_home_time and (GetTime() - inst.needs_home_time > inst.make_home_delay))

    return make_home
end

local function MakeNewHomeAction(inst)
    local angle = math.random(0,360)
    local offset = FindWalkableOffset(inst:GetPosition(), angle*DEGREES, math.random(5,15), 120, false, false)
    return BufferedAction(inst, nil, ACTIONS.MAKEMOLEHILL, nil, inst:GetPosition() + offset)
end

local function TakeBaitAction(inst)
    -- Don't look for bait if just spawned, busy making a new home, or has full inventory
    if inst:GetTimeAlive() < 3 or inst.needs_home_time or (inst.components.inventory and inst.components.inventory:IsFull()) then
        return
    end

    local target = FindEntity(inst, SEE_BAIT_DIST, function(item) return item:HasTag("molebait") and (item.components.bait or item:HasTag("bell")) and not (item.components.inventoryitem and item.components.inventoryitem:IsHeld()) end)
    if target and not target.selectedasmoletarget then
        target.selectedasmoletarget = true
        target:DoTaskInTime(5, function(target) target.selectedasmoletarget = false end)
        local act = BufferedAction(inst, target, ACTIONS.STEALMOLEBAIT)
        act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem:IsHeld()) end
        return act
    end
end

local function PeekAction(inst)
    return BufferedAction(inst, nil, ACTIONS.MOLEPEEK)
end

function MoleBrain:OnStart()
    local clock = GetClock()
    local seasonmgr = GetSeasonManager()
    
    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        WhileNode( function() return ShouldMakeHome(self.inst) end, "HomeDugUp", 
            DoAction(self.inst, MakeNewHomeAction, "make home", false)),
        WhileNode(function() return self.inst.flee == true end, "Flee",
            RunAway(self.inst, "scarytoprey", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP)),
        WhileNode(function() return (GetTime() > (self.inst.last_above_time + self.inst.peek_interval) and not self.inst.sg:HasStateTag("busy")) end, "Peek", --check if no buffered action?
            DoAction(self.inst, PeekAction, "peek", false)),
        WhileNode(function() return self.inst.components.inventory:IsFull() end, "DepositInv",
            DoAction(self.inst, GoHomeAction, "go home", false)),
        EventNode(self.inst, "gohome", 
            DoAction(self.inst, GoHomeAction, "go home", false)),
        DoAction(self.inst, TakeBaitAction, "take bait", false),
        WhileNode(function() return clock and clock:IsDay() end, "IsDay",
            DoAction(self.inst, GoHomeAction, "go home", false )),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),
    }, .25)
    self.bt = BT(self.inst, root)
end

return MoleBrain
