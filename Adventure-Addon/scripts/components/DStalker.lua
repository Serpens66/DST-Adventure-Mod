local FollowText = require "widgets/followtext"

Line = Class(function(self, message, duration, noanim)
    self.message = message
    self.duration = duration
    self.noanim = noanim
end)


local DStalker = Class(function(self, inst)
    self.inst = inst
    self.task = nil
    self.ignoring = false

    self.special_speech = false
end)

function DStalker:IgnoreAll()
    self.ignoring = true
end

function DStalker:StopIgnoringAll()
    self.ignoring = false
end

local function sayfn(inst, script)
    
    -- if not inst.components.DStalker.widget then
        -- inst.components.DStalker.widget = GetPlayer().HUD:AddChild(FollowText(inst.components.DStalker.font or TALKINGFONT, inst.components.DStalker.fontsize or 35))
    -- end
    
    local player = ThePlayer
    if inst.components.DStalker.widget == nil and player ~= nil and player.HUD ~= nil then
        inst.components.DStalker.widget = player.HUD:AddChild(FollowText(inst.components.DStalker.font or TALKINGFONT, inst.components.DStalker.fontsize or 35))
        inst.components.DStalker.widget:SetHUD(player.HUD.inst)
    end
    if inst.components.DStalker.widget~=nil then
        inst.components.DStalker.widget.symbol = inst.components.DStalker.symbol
        inst.components.DStalker.widget:SetOffset(inst.components.DStalker.offset or Vector3(0, -400, 0))
        inst.components.DStalker.widget:SetTarget(inst)
        if inst.components.DStalker.colour then
            inst.components.DStalker.widget.text:SetColour(inst.components.DStalker.colour.x, inst.components.DStalker.colour.y, inst.components.DStalker.colour.z, 1)
        end
    end

    for k,line in ipairs(script) do
        
        if inst.components.DStalker.widget~=nil then
            if line.message then
                inst.components.DStalker.widget.text:SetString(line.message)
                inst:PushEvent("ontalk", {noanim = line.noanim})
            else
                inst.components.DStalker.widget:Hide()
            end
        end    
        Sleep(line.duration or 2.5)
    
    end
    if inst.components.DStalker.widget~=nil then
        inst.components.DStalker.widget:Kill()    
        inst.components.DStalker.widget = nil
    end
    inst:PushEvent("donetalking")

end

function DStalker:OnRemoveEntity()
	self:ShutUp()	
end

function DStalker:ShutUp()
    if self.task then
        scheduler:KillTask(self.task)
        
        if self.widget then
            self.widget:Kill()
            self.widget = nil
        end
        self.inst:PushEvent("donetalking")
        self.task = nil
    end
end

function DStalker:SetSpecialSpeechFn(fn)
    if fn then self.specialspeechfn = fn end
    self.special_speech = true
end

function DStalker:Say(script, time, noanim)
    if self.inst.components.health and  self.inst.components.health:IsDead() then
        return
    end
    
    if self.inst.components.sleeper and  self.inst.components.sleeper:IsAsleep() then
        return
    end
    
    if self.ignoring then
        return
    end

    if self.special_speech then
        if self.specialspeechfn then
            script = self.specialspeechfn(self.inst.prefab)
        else
            script = GetSpecialCharacterString(self.inst.prefab)
        end
    end
    
	if self.ontalk then
		self.ontalk(self.inst, script)
	end
    
    local lines = nil
    if type(script) == "string" then
        lines = {Line(script, time or 2.5, noanim)}
    else
        lines = script
    end

    self:ShutUp()
    if lines then
        self.task = self.inst:StartThread( function() sayfn(self.inst, lines) end)    
    end
end



return DStalker
