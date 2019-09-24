require "behaviours/follow"
require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/panic"
require "behaviours/runaway"
require "behaviours/leash"

local MIN_FOLLOW_DIST = 0
local MAX_FOLLOW_DIST = 25
local TARGET_FOLLOW_DIST = 6
local MAX_WANDER_DIST = 10

local LEASH_RETURN_DIST = 15
local LEASH_MAX_DIST = 30

local MAX_CHASE_TIME = 4
local MAX_CHASE_DIST = 10

local AVOID_DIST = 3
local AVOID_STOP = 10

local NO_TAGS = {"FX", "NOCLICK", "DECOR","INLIMBO", "stump", "burnt"}
local PLAY_TAGS = {"cattoy", "cattoyairborne", "catfood"}

local CatcoonBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function PlayAction(inst)
    if inst.sg:HasStateTag("busy") then return end
    if inst.hairball_friend_interval and inst.hairball_friend_interval <= 5 then return end
    
    local target = nil
    local pt = inst:GetPosition()
    target = FindEntity(inst, TUNING.CATCOON_TARGET_DIST, nil, nil, NO_TAGS, PLAY_TAGS)

    if target and target:HasTag("cattoyairborne") and not (target.sg and (target.sg:HasStateTag("landing") or target.sg:HasStateTag("landed"))) then
        if inst.last_play_air_time and (GetTime() - inst.last_play_air_time) < 15 then return end
        target:RemoveTag("cattoyairborne")
        target:DoTaskInTime(GetRandomWithVariance(30, 5), function(target) 
            if target and not target:HasTag("cattoyairborne") and not target:HasTag("stump") and not target:HasTag("burnt") then 
                target:AddTag("cattoyairborne") 
            end 
        end)
        return BufferedAction(inst, target, ACTIONS.CATPLAYAIR)
    elseif target then
        local tag = target:HasTag("cattoy") and "cattoy" or "catfood"
        target:RemoveTag(tag)
        target:DoTaskInTime(30, function(targ) if not targ:HasTag(tag) then targ:AddTag(tag) end end)
        return BufferedAction(inst, target, ACTIONS.CATPLAYGROUND)
    end
end

local function HasValidHome(inst)
    return inst.components.homeseeker and 
       inst.components.homeseeker.home and 
       not inst.components.homeseeker.home:HasTag("fire") and
       not inst.components.homeseeker.home:HasTag("burnt") and
       inst.components.homeseeker.home:IsValid()
end

local function GetNoLeaderHomePos(inst)
    if inst.components.follower and inst.components.follower.leader then
        return nil
    end
    return HasValidHome(inst) and inst.components.homeseeker:GetHomePos()
end

local function GetLeader(inst)
    return inst.components.follower.leader 
end

local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

local function GoHomeAction(inst)
    if inst.components.homeseeker and 
       inst.components.homeseeker.home and 
       inst.components.homeseeker.home:IsValid() then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    else
        inst.raining = false
    end
end

local function ShouldHairball(inst)
    if inst.components.follower and inst.components.follower.leader then
        if GetTime() - inst.last_hairball_time >= inst.hairball_friend_interval then
            inst.hairball_friend_interval = math.random(TUNING.MIN_HAIRBALL_FRIEND_INTERVAL, TUNING.MAX_HAIRBALL_FRIEND_INTERVAL)
            return true
        end
    else
        if GetTime() - inst.last_hairball_time >= inst.hairball_neutral_interval then
            inst.hairball_neutral_interval = math.random(TUNING.MIN_HAIRBALL_NEUTRAL_INTERVAL, TUNING.MAX_HAIRBALL_NEUTRAL_INTERVAL)
            return true
        end
    end
end

local function HairballAction(inst)
    if inst.sg:HasStateTag("busy") then return end
    if inst.components.follower and inst.components.follower.leader then
        return BufferedAction(inst, GetPlayer(), ACTIONS.HAIRBALL)
    else
        return BufferedAction(inst, nil, ACTIONS.HAIRBALL)
    end
end

local function WhineAction(inst)
    if inst.sg:HasStateTag("busy") then return end
    if inst.components.follower and inst.components.follower.leader and inst.components.follower:GetLoyaltyPercent() < .03 then
        return BufferedAction(inst, inst.components.follower.leader, ACTIONS.CATPLAYGROUND)
    end
end

function CatcoonBrain:OnStart()
    local root = 
    PriorityNode(
    {
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        IfNode(function() return ShouldHairball(self.inst) end, "hairball",
            DoAction(self.inst, HairballAction, "hairballact", true)),
        ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
        DoAction(self.inst, WhineAction, "whine", true),
        Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
        WhileNode(function() return self.inst.raining end, "GoingHome", 
            DoAction(self.inst, GoHomeAction, "go home", true )),
        DoAction(self.inst, PlayAction, "play", true),
        IfNode(function() return GetLeader(self.inst) end, "has leader",
            FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn )),
        Leash(self.inst, GetNoLeaderHomePos, LEASH_MAX_DIST, LEASH_RETURN_DIST),
        RunAway(self.inst, "player", AVOID_DIST, AVOID_STOP, nil, nil, NO_TAGS),
        Wander(self.inst, function() return self.inst:GetPosition() end, MAX_WANDER_DIST),   
    }, .25)
    self.bt = BT(self.inst, root)
end

return CatcoonBrain