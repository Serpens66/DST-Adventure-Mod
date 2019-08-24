local function onspeech(self, speech)
    if speech == nil then
        self.inst:AddTag("maxwellnottalking")
    else
        self.inst:RemoveTag("maxwellnottalking")
    end
end

local MaxwellTalker = Class(function(self, inst)
	self.inst = inst
    inst:AddTag("maxwellnottalking")
	self.speech = nil
	self.speeches = nil
	self.canskip = false
	self.defaultvoice = "dontstarve/maxwell/talk_LP"
	self.inputhandlers = {}
    -- table.insert(self.inputhandlers, TheInput:AddControlHandler(CONTROL_PRIMARY, function() self:OnClick() end))    
    -- table.insert(self.inputhandlers, TheInput:AddControlHandler(CONTROL_SECONDARY, function() self:OnClick() end))
    -- table.insert(self.inputhandlers, TheInput:AddControlHandler(CONTROL_ATTACK, function() self:OnClick() end))
    -- table.insert(self.inputhandlers, TheInput:AddControlHandler(CONTROL_INSPECT, function() self:OnClick() end))
    -- table.insert(self.inputhandlers, TheInput:AddControlHandler(CONTROL_ACTION, function() self:OnClick() end))
    -- table.insert(self.inputhandlers, TheInput:AddControlHandler(CONTROL_CONTROLLER_ACTION, function() self:OnClick() end))
end,
nil,
{
    speech = onspeech,
})

function MaxwellTalker:OnRemoveFromEntity()
    self.inst:RemoveTag("maxwellnottalking")
end

function MaxwellTalker:OnCancel()

    if self.inst.components.talker then
		self.inst.components.talker:ShutUp()
	end
    
    
    if self.inst.speech.disableplayer and self.inst.wilson then
	    -- if self.inst.wilson.sg.currentstate.name == "sleep" then		
		    self.inst.SoundEmitter:KillSound("talk")	--ensures any talking sounds have stopped
		    if self.inst.speech.disappearanim then
                self.inst.SoundEmitter:PlaySound("dontstarve/maxwell/disappear_adventure")
                SpawnPrefab("maxwell_smoke").Transform:SetPosition(self.inst.Transform:GetWorldPosition())

		        self.inst.AnimState:PlayAnimation(self.inst.speech.disappearanim, false)
		    end	--plays the disappear animation and removes from scene
			self.inst:ListenForEvent("animqueueover", function() self.inst:Remove() end)	
        -- end
    end
    for _,player in pairs(AllPlayers) do
        if self.inst.speech.disableplayer and player then
            -- if player.sg.currentstate.name == "sleep" then			    
                -- player.sg:GoToState("wakeup")
                player:DoTaskInTime(1.5, function() player.components.playercontroller:Enable(true) end)
            -- else
                -- player.components.playercontroller:Enable(true)
            -- end
            
            if player.HUD then player.HUD:Show() end
            -- TheCamera:SetDefault()
            -- player.mynetvarTitleStufff:set(3)
            player:SetCameraDistance()
        end
    end
end

function MaxwellTalker:OnClick() -- does not work, and we don't need it
	-- if self.inst.speech and self.canskip and self.inst.speech.disableplayer then

		-- scheduler:KillTask(self.inst.task)
		-- self:OnCancel()
		-- for k,v in pairs(self.inputhandlers) do
	        -- v:Remove()
	    -- end
	-- end
end

function MaxwellTalker:StopTalking()
	
    if self.inst.components.talker then
		self.inst.components.talker:ShutUp()
	end

	scheduler:KillTask(self.inst.task)
	self.inst.SoundEmitter:KillSound("talk")
	self.inst.speech = nil


end

function MaxwellTalker:Initialize()
	self.inst.speech = self.speeches[self.speech or "NULL_SPEECH"] --This would be specified through whatever spawns this at the start of a level

	if self.inst.speech and self.inst.speech.disableplayer then
		self.inst.wilson = AllPlayers[1] -- just pick the first player
        local sum = 0
        local waitbetweenlines = 0
        local wait = 0
        for k, section in ipairs(self.inst.speech) do --the loop that goes on while the speech is happening
            waitbetweenlines = section.waitbetweenlines or 0.5
            wait = section.wait or 1
            sum = sum + waitbetweenlines + wait -- get how long the speech will take
        end
        
		for _,player in pairs(AllPlayers) do
            if player.HUD then player.HUD:Hide() end
            player.components.playercontroller:Enable(false)
            -- player.sg:GoToState("sleep")
            if player.components.grogginess then player.components.grogginess:AddGrogginess(8, sum-1) end    
        end
        

        local pt = Vector3(self.inst.wilson.Transform:GetWorldPosition()) + TheCamera:GetRightVec()*4
        self.inst.Transform:SetPosition(pt.x,pt.y,pt.z)
        self.inst:FacePoint(self.inst.wilson.Transform:GetWorldPosition())
        	
        self.inst:Hide()

        --zoom in
        -- TheCamera:SetOffset( (Vector3(self.inst.Transform:GetWorldPosition()) - Vector3(self.inst.wilson.Transform:GetWorldPosition()))*.5  + Vector3(0,2,0) )
        -- TheCamera:SetDistance(15)
        -- TheCamera:Snap()
        for _,player in pairs(AllPlayers) do
            if player.HUD then player.HUD:Hide() end
            -- player.mynetvarTitleStufff:set(2) -- move the camera for client
            player:SetCameraDistance(12)
        end
	end
end

function MaxwellTalker:IsTalking()
	return self.inst.speech ~= nil
end


local function SpeakTalk2(inst,section,self)
    self.inst = inst
    if section.string then	--If maxwell was talking it winds down here and stops the anim.
        self.inst.SoundEmitter:KillSound("talk")
        if self.inst.speech~=nil and self.inst.speech.dialogpostanim then self.inst.AnimState:PlayAnimation(self.inst.speech.dialogpostanim) end
    end

    if self.inst.speech~=nil and self.inst.speech.idleanim then  self.inst.AnimState:PushAnimation(self.inst.speech.idleanim, true) end--goes to an idle animation

    -- Sleep(section.waitbetweenlines or 0.5)	--pauses between lines -- not needed here, it is calculated in sum
end

local function SpeakTalk(inst,section,self)
    
    self.inst = inst
    local wait = section.wait or 1

    if section.anim then --If there's a custom animation it plays it here.
        self.inst.AnimState:PlayAnimation(section.anim)
        if self.inst.speech~=nil and self.inst.speech.idleanim then self.inst.AnimState:PushAnimation(self.inst.speech.idleanim, true) end
    end

    if section.string then --If there is speech to be said, it displays the text and overwrites any custom anims with the talking anims
        if self.inst.speech~=nil and self.inst.speech.dialogpreanim then self.inst.AnimState:PlayAnimation(self.inst.speech.dialogpreanim) end
        if self.inst.speech~=nil and self.inst.speech.dialoganim then self.inst.AnimState:PushAnimation(self.inst.speech.dialoganim, true) end
        self.inst.SoundEmitter:PlaySound(self.inst.speech~=nil and self.inst.speech.voice or self.defaultvoice, "talk")
        if self.inst.components.talker then
            self.inst.components.talker:Say(section.string, wait)
        end
    end

    if section.sound then	--If there's an extra sound to be played it plays here.
        self.inst.SoundEmitter:PlaySound(section.sound)
    end

    -- Sleep(wait)	--waits for the allocated time.
    self.inst:DoTaskInTime(wait,SpeakTalk2,section,self)
end

local function DoTalk4(inst,self)	
    self.inst.SoundEmitter:KillSound("talk")	--ensures any talking sounds have stopped

    if self.inst.speech.disappearanim then
        self.inst.SoundEmitter:PlaySound("dontstarve/maxwell/disappear_adventure")
        SpawnPrefab("maxwell_smoke").Transform:SetPosition(self.inst.Transform:GetWorldPosition())

        self.inst.AnimState:PlayAnimation(self.inst.speech.disappearanim, false) --plays the disappear animation and removes from scene
        self.inst:ListenForEvent("animqueueover", function()  self.inst:Remove() end)
    end
    for _,player in pairs(AllPlayers) do
        if self.inst.speech.disableplayer and player then--and player.sg.currentstate.name == "sleep" then		
            -- player.sg:GoToState("wakeup") 
            player:DoTaskInTime(1.5, function() 
                player.components.playercontroller:Enable(true)			
                if player.HUD then player.HUD:Show() end
                -- TheCamera:SetDefault()
                -- player.mynetvarTitleStufff:set(3)
                player:SetCameraDistance()
            end)
        end
    end
    
    self.inst.speech = nil --remove the speech after done
	
    
    for k,v in pairs(self.inputhandlers) do
	        v:Remove()
	end
end

local function DoTalk3(inst,self)	
    self.inst = inst	
    self.canskip = true
    local length = #self.inst.speech or 1
    local sum = 0
    local waitbetweenlines = 0
    local wait = 0
    for k, section in ipairs(self.inst.speech) do --the loop that goes on while the speech is happening
        
        self.inst:DoTaskInTime(sum,SpeakTalk,section,self) -- again workaround for missing Sleep...
        waitbetweenlines = section.waitbetweenlines or 0.5
        wait = section.wait or 1
        sum = sum + waitbetweenlines + wait
        -- local wait = section.wait or 1

        -- if section.anim then --If there's a custom animation it plays it here.
            -- self.inst.AnimState:PlayAnimation(section.anim)
            -- if self.inst.speech.idleanim then self.inst.AnimState:PushAnimation(self.inst.speech.idleanim, true) end
        -- end

        -- if section.string then --If there is speech to be said, it displays the text and overwrites any custom anims with the talking anims
            -- if self.inst.speech.dialogpreanim then self.inst.AnimState:PlayAnimation(self.inst.speech.dialogpreanim) end
            -- if self.inst.speech.dialoganim then self.inst.AnimState:PushAnimation(self.inst.speech.dialoganim, true) end
            -- self.inst.SoundEmitter:PlaySound(self.inst.speech.voice or self.defaultvoice, "talk")
            -- if self.inst.components.talker then
                -- self.inst.components.talker:Say(section.string, wait)
            -- end
        -- end

        -- if section.sound then	--If there's an extra sound to be played it plays here.
            -- self.inst.SoundEmitter:PlaySound(section.sound)
        -- end

        -- Sleep(wait)	--waits for the allocated time.

        -- if section.string then	--If maxwell was talking it winds down here and stops the anim.
            -- self.inst.SoundEmitter:KillSound("talk")
            -- if self.inst.speech.dialogpostanim then self.inst.AnimState:PlayAnimation(self.inst.speech.dialogpostanim) end
        -- end

        -- if self.inst.speech.idleanim then  self.inst.AnimState:PushAnimation(self.inst.speech.idleanim, true) end--goes to an idle animation

        -- Sleep(section.waitbetweenlines or 0.5)	--pauses between lines
    end
    
    self.inst:DoTaskInTime(sum,DoTalk4,self)
end

local function DoTalk2(inst,self)		
    self.inst = inst
    -- if self.inst.speech then  -- is true if we are here now
    if self.inst.speech.appearanim then
        if self.inst.AnimState then
            self.inst.AnimState:PlayAnimation(self.inst.speech.appearanim)
        end
    end
    if self.inst.speech.idleanim then self.inst.AnimState:PushAnimation(self.inst.speech.idleanim, true) end
    
    if self.inst.speech.appearanim then			
        self.inst.SoundEmitter:PlaySound("dontstarve/maxwell/appear_adventure")
        -- Sleep(1.4)
        self.inst:DoTaskInTime(1.4,DoTalk3,self)
    else
        self.inst:DoTaskInTime(0,DoTalk3,self)
    end
end

function MaxwellTalker:DoTalk()	
	self.inst.speech = self.speeches[self.speech or "NULL_SPEECH"] --This would be specified through whatever spawns this at the start of a level
	self.inst:Show()
	
	if self.inst.speech then
        -- Sleep(self.inst.speech.delay)
        local delay = self.inst.speech.delay or 0
        -- self.inst:DoTaskInTime(delay,self.DoTalk2)
        self.inst:DoTaskInTime(delay,DoTalk2,self)
	else
        for k,v in pairs(self.inputhandlers) do
	        v:Remove()
        end
    end	
end

function MaxwellTalker:SetSpeech(speech)
	if speech then self.speech = speech end
end

return MaxwellTalker