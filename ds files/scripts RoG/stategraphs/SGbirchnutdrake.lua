require("stategraphs/commonstates")

local actionhandlers = 
{
    ActionHandler(ACTIONS.GOHOME, "action"),
}

local events=
{
    EventHandler("gotosleep", function(inst)
    	if not inst.sg:HasStateTag("hidden") then
        	inst.sg:GoToState("exit")
        end
    end),
    CommonHandlers.OnFreeze(),
    EventHandler("doattack", function(inst, data) 
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then 
            if inst:GetDistanceSqToInst(data.target) > 2*2 then
                inst.sg:GoToState("attack_leap")
            else
            	inst.sg:GoToState("attack")
            end
        end 
    end),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
    CommonHandlers.OnLocomote(false,true),
}

local states=
{
	State
	{
		name = "idle",
		tags = {"idle"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.target = nil
			inst.AnimState:PlayAnimation("idle_loop")
		end,

		timeline = 
		{
		},

		events = 
		{
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("idle") 
			end)
		},
	},

	State
	{
		name = "spawn",
		tags = {"busy", "hidden"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("ground_enter")
		end,

		timeline = 
		{
			TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/drake_pop_small") end),
		},

		events = 
		{
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("enter") 
			end)
		},
	},

	State
	{
		name = "ground_idle",
		tags = {"idle", "hidden"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("ground_loop")
		end,

		timeline = 
		{
		},

		events = 
		{
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("ground_idle") 
			end)
		},
	},

	State
	{
		name = "enter",
		tags = {"busy", "hidden"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("enter")
		end,

		timeline = 
		{
			TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/drake_pop_large") end),
		},

		events = 
		{
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("idle") 
			end)
		},
	},

	State
	{
		name = "exit",
		tags = {"busy", "hidden", "exit"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.Physics:SetMass(99999)
			inst.AnimState:PushAnimation("exit", false)
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/drake_jump")
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/drake_run_voice")
		end,

		timeline = 
		{
			TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/drake_intoground") end),
			TimeEvent(20*FRAMES, function(inst) inst.Physics:ClearCollisionMask() end),
		},

		events = 
		{
			EventHandler("animqueueover", function(inst) 
				inst:Remove()
			end)
		},
	},

	State
	{
		name = "attack_leap",
		tags = {"attack", "canrotate", "busy", "jumping"},

        onenter = function(inst, target)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk")
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/drake_jump")
        end,

        onexit = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
        end,

		timeline = 
		{
            TimeEvent(3*FRAMES, function(inst) inst.Physics:SetMotorVelOverride(5,0,0) end),
            TimeEvent(12*FRAMES, function(inst) 
            	inst.components.combat:DoAttack() 
            	inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/drake_attack")
            end),
            TimeEvent(25*FRAMES,
				function(inst)
                    inst.Physics:ClearMotorVelOverride()
					inst.components.locomotor:Stop()
				end),
		},

		events = 
		{
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("idle")
			end)
		},
	},
}

CommonStates.AddCombatStates(states,
{
	hittimeline = {},
	attacktimeline = 
	{
		TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/drake_jump") end),
		TimeEvent(12*FRAMES, function(inst) 
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/drake_attack")
			inst.components.combat:DoAttack() 
		end)
	},
	deathtimeline = 
	{
		TimeEvent(1*FRAMES, function(inst) 
			inst.Physics:ClearCollisionMask()
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/drake_die") 
		end),
	},
})
CommonStates.AddWalkStates(states, 
{	
	starttimeline = {},
	walktimeline = 
	{
		TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/drake_run_voice") end),
		TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/decidous/drake_run_rustle") end),
	},
	endtimeline = {},
})
CommonStates.AddSleepStates(states,
{
	starttimeline = {},
	sleeptimeline = {},
	endtimeline = {},
})
CommonStates.AddFrozenStates(states)
  
return StateGraph("birchnutdrake", states, events, "spawn", actionhandlers)