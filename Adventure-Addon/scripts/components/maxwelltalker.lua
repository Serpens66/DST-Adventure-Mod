local helpers = require("adv_helpers") 

local MaxwellTalker = Class(function(self, inst)
	self.inst = inst
	self.speech = nil
	self.speeches = nil
	self.defaultvoice = "dontstarve/maxwell/talk_LP"
end,
nil,
{}
)

function MaxwellTalker:StopTalking()
	
    if self.inst.components.talker then
		self.inst.components.talker:ShutUp()
	end

	scheduler:KillTask(self.inst.task)
	self.inst.SoundEmitter:KillSound("talk")
	self.inst.speech = nil

end

function MaxwellTalker:IsTalking()
	return self.inst.speech ~= nil
end

function MaxwellTalker:EndgameDoTalk() -- only server stuff
    self.inst.speech = self.speeches[self.speech or "NULL_SPEECH"] --This would be specified through whatever spawns this at the start of a level
    if self.inst.speech~=nil then
        for k, section in ipairs(self.inst.speech) do --the loop that goes on while the speech is happening
            if self.inst.speech~=nil then -- if someone dies, it can get nil during talking ?!
                local wait = section.wait or 1
                if self.inst.speech~=nil and self.inst.speech.delay then
                    Sleep(self.inst.speech.delay)
                end
                if section.anim then --If there's a custom animation it plays it here.
                    self.inst.AnimState:PlayAnimation(section.anim)
                    if self.inst.speech~=nil and self.inst.speech.idleanim then self.inst.AnimState:PushAnimation(self.inst.speech.idleanim, true) end
                end
                if section.string then --If there is speech to be said, it displays the text and overwrites any custom anims with the talking anims
                    if self.inst.speech~=nil and self.inst.speech.dialogpreanim then self.inst.AnimState:PlayAnimation(self.inst.speech.dialogpreanim) end
                    if self.inst.speech~=nil and self.inst.speech.dialoganim then self.inst.AnimState:PushAnimation(self.inst.speech.dialoganim, true) end
                    self.inst.SoundEmitter:PlaySound(self.inst.speech~=nil and self.inst.speech.voice or self.defaultvoice, "talk")
                    if self.inst.components.talker then
                        self.inst.components.talker:Say(section.string, wait+3, true, true)
                    end
                end
                if section.sound then	--If there's an extra sound to be played it plays here.
                    self.inst.SoundEmitter:PlaySound(section.sound)
                end
                Sleep(wait)	--waits for the allocated time.
                if section.string then	--If maxwell was talking it winds down here and stops the anim.
                    self.inst.SoundEmitter:KillSound("talk")
                    if self.inst.speech~=nil and self.inst.speech.dialogpostanim then self.inst.AnimState:PlayAnimation(self.inst.speech.dialogpostanim) end
                end
                if self.inst.speech~=nil and self.inst.speech.idleanim then  self.inst.AnimState:PushAnimation(self.inst.speech.idleanim, true) end--goes to an idle animation
                Sleep(section.waitbetweenlines or 0.5)	--pauses between lines
            end
        end
    end
    self.inst.speech = nil --remove the speech after done
end

function MaxwellTalker:DoTalk(CLIENT_SIDE,dolevelspeech)
    print("msxwelltaler do speak")
    self.inst.speech = self.speeches[self.speech or "NULL_SPEECH"] --This would be specified through whatever spawns this at the start of a level
    if CLIENT_SIDE and ThePlayer==self.inst.wilson then
        self.inst:Show()
    end
    if self.inst.speech~=nil then
        if self.inst.speech~=nil and self.inst.speech.delay then
            Sleep(self.inst.speech.delay)
        end
        if CLIENT_SIDE and ThePlayer==self.inst.wilson then
            if self.inst.speech~=nil and self.inst.speech.appearanim then self.inst.AnimState:PlayAnimation(self.inst.speech.appearanim) end
            if self.inst.speech~=nil and self.inst.speech.idleanim then self.inst.AnimState:PushAnimation(self.inst.speech.idleanim, true) end
        end
        if self.inst.speech~=nil and self.inst.speech.appearanim then			
            if CLIENT_SIDE and ThePlayer==self.inst.wilson then
                self.inst.SoundEmitter:PlaySound("dontstarve/maxwell/appear_adventure")
            end
            Sleep(1.4)
        end
    
        local length = #self.inst.speech or 1
        local wait = 1
        for k, section in ipairs(self.inst.speech) do --the loop that goes on while the speech is happening
            if self.inst.speech~=nil then
                wait = section.wait or 1

                if CLIENT_SIDE and ThePlayer==self.inst.wilson then
                    if section.anim then --If there's a custom animation it plays it here.
                        self.inst.AnimState:PlayAnimation(section.anim)
                        if self.inst.speech~=nil and self.inst.speech.idleanim then self.inst.AnimState:PushAnimation(self.inst.speech.idleanim, true) end
                    end

                    if section.string then --If there is speech to be said, it displays the text and overwrites any custom anims with the talking anims
                        if self.inst.speech~=nil and self.inst.speech.dialogpreanim then self.inst.AnimState:PlayAnimation(self.inst.speech.dialogpreanim) end
                        if self.inst.speech~=nil and self.inst.speech.dialoganim then self.inst.AnimState:PushAnimation(self.inst.speech.dialoganim, true) end
                        self.inst.SoundEmitter:PlaySound(self.inst.speech~=nil and self.inst.speech.voice or self.defaultvoice, "talk")
                        if self.inst.components.talker then
                            self.inst.components.talker:Say(section.string, wait+3, true, true)
                        end
                    end

                    if section.sound then	--If there's an extra sound to be played it plays here.
                        self.inst.SoundEmitter:PlaySound(section.sound)
                    end
                end
                Sleep(wait)	--waits for the allocated time.
                if CLIENT_SIDE and ThePlayer==self.inst.wilson then
                    if section.string then	--If maxwell was talking it winds down here and stops the anim.
                        self.inst.SoundEmitter:KillSound("talk")
                        if self.inst.speech~=nil and self.inst.speech.dialogpostanim then self.inst.AnimState:PlayAnimation(self.inst.speech.dialogpostanim) end
                    end

                    if self.inst.speech~=nil and self.inst.speech.idleanim then  self.inst.AnimState:PushAnimation(self.inst.speech.idleanim, true) end--goes to an idle animation
                end
                Sleep(section.waitbetweenlines or 0.5)	--pauses between lines
            end
        end
        if CLIENT_SIDE and ThePlayer==self.inst.wilson then
            self.inst.SoundEmitter:KillSound("talk")	--ensures any talking sounds have stopped
        end
        if self.inst.speech~=nil and self.inst.speech.disappearanim then
            if CLIENT_SIDE and ThePlayer==self.inst.wilson then
                self.inst.SoundEmitter:PlaySound("dontstarve/maxwell/disappear_adventure")
                local fx = SpawnPrefab("maxwell_smoke")
                fx.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
                self.inst.AnimState:PlayAnimation(self.inst.speech~=nil and self.inst.speech.disappearanim, false) --plays the disappear animation and removes from scene
            end
            if TheNet:GetIsServer() and dolevelspeech then
                if TUNING.TELEPORTATOMOD.WORLDS[TUNING.TELEPORTATOMOD.LEVEL].name=="Archipelago" then -- maxwells text says he sends some hounds, so send some
                    helpers.SpawnPrefabAtLandPlotNearInst("hound",self.inst.wilson,10,0,10,TUNING.ADV_DIFFICULTY+1,3,3) -- spawn hounds
                elseif TUNING.TELEPORTATOMOD.WORLDS[TUNING.TELEPORTATOMOD.LEVEL].name=="Darkness" then
                    helpers.SpawnPrefabAtLandPlotNearInst("spider",self.inst.wilson,10,0,10,2*TUNING.ADV_DIFFICULTY,3,3) -- spawn spiders
                elseif TUNING.TELEPORTATOMOD.WORLDS[TUNING.TELEPORTATOMOD.LEVEL].name=="A Cold Reception" then
                    helpers.SpawnPrefabAtLandPlotNearInst("frog",self.inst.wilson,10,0,10,2*TUNING.ADV_DIFFICULTY,3,3) -- spawn frogs
                elseif TUNING.TELEPORTATOMOD.WORLDS[TUNING.TELEPORTATOMOD.LEVEL].name=="King of Winter" then
                    local clops = helpers.SpawnPrefabAtLandPlotNearInst("deerclops",self.inst.wilson,200,0,200,1,60,60) -- spawn a deerclops, but far away
                    if TUNING.ADV_DIFFICULTY~=3 and clops and clops.components and clops.components.health and not clops.components.health:IsDead() then
                        if TUNING.ADV_DIFFICULTY==1 then -- easy
                            clops.components.health:SetPercent(0.1)
                        elseif TUNING.ADV_DIFFICULTY==2 then -- default (at hard no health adjustment and at DS this code it never executed)
                            clops.components.health:SetPercent(0.25)
                        end
                    end
                    self.inst.wilson.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/distant") -- noise of deerclops
                    self.inst.wilson:DoTaskInTime(0.8,function()
                        self.inst.wilson.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/distant") -- noise of deerclops
                    end)
                    self.inst.wilson:DoTaskInTime(2,function()
                        if self and self.inst and self.inst.wilson then
                            self.inst.wilson.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/distant") -- noise of deerclops
                        end
                    end)
                elseif TUNING.TELEPORTATOMOD.WORLDS[TUNING.TELEPORTATOMOD.LEVEL].name=="Two Worlds" then
                    helpers.SpawnPrefabAtLandPlotNearInst("goldnugget",self.inst.wilson,10,0,10,1,3,3)
                    helpers.SpawnPrefabAtLandPlotNearInst("pigman",self.inst.wilson,10,0,10,1,3,3)
                    helpers.SpawnPrefabAtLandPlotNearInst("meatballs",self.inst.wilson,10,0,10,1,3,3)
                elseif TUNING.TELEPORTATOMOD.WORLDS[TUNING.TELEPORTATOMOD.LEVEL].name=="The Game is Afoot" then
                    helpers.SpawnPrefabAtLandPlotNearInst("flower_evil",self.inst.wilson,3,0,3,8,0,0)
                end
            end
            self.inst:ListenForEvent("animqueueover", function() -- does not seems to work...
                if self.inst:IsValid() then self.inst:Remove() end 
            end)
        end
        
        if self.inst.speech~=nil and self.inst.speech.disableplayer then
            self.inst.wilson:DoTaskInTime(0.9, function() 
                if CLIENT_SIDE and ThePlayer==self.inst.wilson then
                    if self.inst.wilson.HUD then self.inst.wilson.HUD:Show() end
                    TheCamera:SetDefault()
                end
                if TheNet:GetIsServer() then
                    if self.inst.wilson.components.grogginess then self.inst.wilson.components.grogginess:ComeTo() end
                    if self.inst.wilson.components.playercontroller and self.inst.wilson.components.playercontroller.classified then self.inst.wilson.components.playercontroller:Enable(true) end
                    if self.inst.wilson.components.health then self.inst.wilson.components.health:SetInvincible(false) end -- make player vincible again
                end
            end)
        end	
        
    end
    if self.inst:IsValid() and self.inst.speech~=nil and self.inst.speech.disappearanim then
        self.inst:DoTaskInTime(1.0,function() if self.inst:IsValid() then self.inst:Remove() end end)
    end
    self.inst.speech = nil --remove the speech after done
end


function MaxwellTalker:Initialize(pl,CLIENT_SIDE) -- is exclusively spawned for a specific player and only visible to him (do this outside of this compoennt)
	self.inst.wilson = pl
    self.inst.speech = self.speeches[self.speech or "NULL_SPEECH"] --This would be specified through whatever spawns this at the start of a level
    local pt = nil
    if CLIENT_SIDE and ThePlayer==self.inst.wilson then
        if self.inst.wilson~=nil and self.inst.speech~=nil and self.inst.speech.disableplayer then
            if self.inst.wilson:IsValid() and self.inst.wilson.HUD then self.inst.wilson.HUD:Hide() end

            pt = Vector3(self.inst.wilson.Transform:GetWorldPosition()) + TheCamera:GetRightVec()*4
            self.inst.Transform:SetPosition(pt.x,pt.y,pt.z)
            self.inst:FacePoint(self.inst.wilson.Transform:GetWorldPosition())
            self.inst:Hide()
            
            if self.inst.wilson~=nil then
                TheCamera:SetOffset( (Vector3(self.inst.Transform:GetWorldPosition()) - Vector3(self.inst.wilson.Transform:GetWorldPosition()))*.5  + Vector3(0,2,0) )
            end
            TheCamera:SetDistance(15)
            TheCamera:Snap()
        end
    end
    if TheNet:GetIsServer() then
        if self.inst.wilson~=nil and self.inst.speech~=nil and self.inst.speech.disableplayer then    
            if not (CLIENT_SIDE and ThePlayer==self.inst.wilson and TheNet:GetIsServer()) then -- do not execute, if we already executed them above
                pt = Vector3(self.inst.wilson.Transform:GetWorldPosition()) + Vector3(-4,0,4) --TheCamera:GetRightVec()*4
                self.inst.Transform:SetPosition(pt.x,pt.y,pt.z) -- also set it for host at least near, so it can spawn his divinigrod if needed
                self.inst:Hide()
            end
            if self.inst.wilson.components.grogginess then self.inst.wilson.components.grogginess:KnockOut() end
            if self.inst.wilson.components.playercontroller and self.inst.wilson.components.playercontroller.classified then self.inst.wilson.components.playercontroller:Enable(false) end
        end
    end
    -- if self.inst.wilson~=nil and self.inst.speech~=nil and self.inst.speech.disableplayer then -- server and client
        -- if self.inst.wilson.components.grogginess then self.inst.wilson.components.grogginess:KnockOut() end
        -- if self.inst.wilson.components.playercontroller then self.inst.wilson.components.playercontroller:Enable(false) end
    -- end
    
end

function MaxwellTalker:SetSpeech(speech)
	if speech then self.speech = speech end
end

return MaxwellTalker