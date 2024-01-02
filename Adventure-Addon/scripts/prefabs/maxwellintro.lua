local assets =
{
	Asset("ANIM", "anim/maxwell_basic.zip"),
	Asset("ANIM", "anim/maxwell_build.zip"),
	Asset("ANIM", "anim/max_fx.zip"),
	Asset("SOUND", "sound/maxwell.fsb"),
}

local prefabs = 
{
    "diviningrodstart"
}

local SPEECHES =
{
	NULL_SPEECH=
	{
	    voice = "dontstarve/maxwell/talk_LP",
		appearanim = "appear",
		idleanim= "idle",
		dialogpreanim = "dialog_pre",
		dialoganim="dial_loop",
		dialogpostanim = "dialog_pst",
		disappearanim = "disappear",
		disableplayer = true,
		skippable = true,
		{
			string = "There is no speech number.", --The string maxwell will say
			wait = 2, --The time this segment will last for
			anim = nil, --If there's a different animation, the animation maxwell will play
			sound = nil, --if there's an extra sound, the sound that will play
		},
		{
			string = nil, 
			wait = 0.5, 
			anim = "smoke", 
			sound = "dontstarve/common/destroy_metal", 
		},
		{
			string = "Go set one.", 
			wait = 2, 
			anim = nil, 
			sound = nil, 
		},
		{
			string = "Goodbye", 
			wait = 1,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",
		},
	
	},
	ADVENTURE_1 =
	{
		appearsound = "dontstarve/maxwell/disappear",
	    voice = "dontstarve/maxwell/talk_LP",
		appearanim = "appear",
		idleanim= "idle",
		dialogpreanim = "dialog_pre",
		dialoganim="dial_loop",
		dialogpostanim = "dialog_pst",
		disappearanim = "disappear",
		disableplayer = true,
		skippable = true,
		{
			string = STRINGS.MAXWELL_SANDBOXINTROS.ONE,
			wait = 3,
			anim = nil,
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_SANDBOXINTROS.TWO, 
			wait = 3, 
			anim = nil, 
			sound = nil,
		},
	},

	ADVENTURE_2 =
	{
		delay = 2,
	    voice = "dontstarve/maxwell/talk_LP_world1",
		appearanim = "appear2",
		idleanim= "idle2_loop",
		dialogpreanim = "dialog2_pre",
		dialoganim="dialog2_loop",
		dialogpostanim = "dialog2_pst",
		disappearanim = "disappear2",
		disableplayer = true,
		skippable = true,
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_1.ONE,
			wait = 2.5,
			anim = nil,
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_1.TWO, 
			wait = 3.5, 
			anim = nil, 
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_1.THREE, 
			wait = 3.5, 
			anim = nil, 
			sound = nil, 
		},
	},

	ADVENTURE_3 =
	{		
		delay = 2,
	    voice = "dontstarve/maxwell/talk_LP_world2",
		appearanim = "appear2",
		idleanim= "idle2_loop",
		dialogpreanim = "dialog2_pre",
		dialoganim="dialog2_loop",
		dialogpostanim = "dialog2_pst",
		disappearanim = "disappear2",
		disableplayer = true,
		skippable = true,
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_2.ONE,
			wait = 3,
			anim = nil,
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_2.TWO, 
			wait = 2.5, 
			anim = nil, 
			sound = nil,
		},
	},

	ADVENTURE_4 =
	{		
		delay = 2,
	    voice = "dontstarve/maxwell/talk_LP_world3",
		appearanim = "appear3",
		idleanim= "idle3_loop",
		dialogpreanim = "dialog3_pre",
		dialoganim="dialog3_loop",
		dialogpostanim = "dialog3_pst",
		disappearanim = "disappear3",
		disableplayer = true,
		skippable = true,
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_3.ONE,
			wait = 2.5,
			anim = nil,
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_3.TWO, 
			wait = 3.5, 
			anim = nil, 
			sound = nil,
		},
	},

	ADVENTURE_5 =
	{		
		delay = 2,
	    voice = "dontstarve/maxwell/talk_LP_world4",
		appearanim = "appear4",
		idleanim= "idle4_loop",
		dialogpreanim = "dialog4_pre",
		dialoganim="dialog4_loop",
		dialogpostanim = "dialog4_pst",
		disappearanim = "disappear4",
		disableplayer = true,
		skippable = true,
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_4.ONE,
			wait = 1.5,
			anim = nil,
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_4.TWO, 
			wait = 3.5, 
			anim = nil, 
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_4.THREE, 
			wait = 3.5, 
			anim = nil, 
			sound = nil,
		},
	},

	ADVENTURE_6 =
	{		
		delay = 2,
	    voice = "dontstarve/maxwell/talk_LP_world5",
		appearanim = "appear5",
		idleanim= "idle5_loop",
		dialogpreanim = "dialog5_pre",
		dialoganim="dialog5_loop",
		dialogpostanim = "dialog5_pst",
		disappearanim = "disappear5",
		disableplayer = true,
		skippable = true,
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_5.ONE,
			wait = 3.5,
			anim = nil,
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_5.TWO, 
			wait = 3.5, 
			anim = nil, 
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_5.THREE, 
			wait = 3.5, 
			anim = nil, 
			sound = nil, 
		},
	},

	ADVENTURE_7 =
	{		
		delay = 2,
	    voice = "dontstarve/maxwell/talk_LP_world6",
		appearanim = "appear",
		idleanim= "idle",
		dialogpreanim = "dialog_pre",
		dialoganim="dial_loop",
		dialogpostanim = "dialog_pst",
		disappearanim = "disappear",
		disableplayer = true,
		skippable = true,
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_6.ONE,
			wait = 3,
			anim = nil,
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_6.TWO, 
			wait = 3, 
			anim = nil, 
			sound = nil,
		},
	},

	ADVENTURE_6_TELEPORTFAIL = -- not used
	{		
		delay = 2,
	    voice = "dontstarve/maxwell/talk_LP_world5",
		appearanim = "appear5",
		idleanim= "idle5_loop",
		dialogpreanim = "dialog5_pre",
		dialoganim="dialog5_loop",
		dialogpostanim = "dialog5_pst",
		disappearanim = "disappear5",
		disableplayer = true,
		skippable = true,
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_6.TELEPORTFAIL,
			wait = 3,
			anim = nil,
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_6.TELEPORTFAIL2,
			wait = 3,
			anim = nil,
			sound = nil,
		},
	},
}
    
    
    SPEECHES["ADVENTURE Maxwells Door"] = -- sandbox
 	{
		appearsound = "dontstarve/maxwell/disappear",
	    voice = "dontstarve/maxwell/talk_LP",
		appearanim = "appear",
		idleanim= "idle",
		dialogpreanim = "dialog_pre",
		dialoganim="dial_loop",
		dialogpostanim = "dialog_pst",
		disappearanim = "disappear",
		disableplayer = true,
		skippable = true,
		{
			string = STRINGS.MAXWELL_SANDBOXINTROS.ONE,
			wait = 2.5,
			anim = nil,
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_SANDBOXINTROS.MAXWELLINTRO_EXPLORE, 
			wait = 3.5, 
			anim = nil, 
			sound = nil,
		},
	}

	SPEECHES["ADVENTURE A Cold Reception"] = -- A Cold Reception
	{		
		delay = 2,
	    voice = "dontstarve/maxwell/talk_LP_world2",
		appearanim = "appear2",
		idleanim= "idle2_loop",
		dialogpreanim = "dialog2_pre",
		dialoganim="dialog2_loop",
		dialogpostanim = "dialog2_pst",
		disappearanim = "disappear2",
		disableplayer = true,
		skippable = true,
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.ACR.ONE,
			wait = 4,
			anim = nil,
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.ACR.TWO, 
			wait = 2, 
			anim = nil, 
			sound = nil,
		},
	}

	SPEECHES["ADVENTURE King of Winter"] = -- King of Winter
	{		
		delay = 2,
	    voice = "dontstarve/maxwell/talk_LP_world3",
		appearanim = "appear3",
		idleanim= "idle3_loop",
		dialogpreanim = "dialog3_pre",
		dialoganim="dialog3_loop",
		dialogpostanim = "dialog3_pst",
		disappearanim = "disappear3",
		disableplayer = true,
		skippable = true,
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.KOW.ONE,
			wait = 3,
			anim = nil,
			sound = nil,
		},
        {
			string = STRINGS.MAXWELL_ADVENTUREINTROS.KOW.TWO,
			wait = 3,
			anim = nil,
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.KOW.THREE,
			wait = 2.5, 
			anim = nil, 
			sound = nil,
		},
        {
			string = STRINGS.MAXWELL_ADVENTUREINTROS.KOW.FOUR,
			wait = 2, 
			anim = nil, 
			sound = nil,
		},
        {
			string = STRINGS.MAXWELL_ADVENTUREINTROS.KOW.FIVE,
			wait = 5, 
			anim = nil, 
			sound = nil,
		},
	}

	SPEECHES["ADVENTURE The Game is Afoot"] = -- The Game is Afoot
	{		
		delay = 2,
	    voice = "dontstarve/maxwell/talk_LP_world4",
		appearanim = "appear4",
		idleanim= "idle4_loop",
		dialogpreanim = "dialog4_pre",
		dialoganim="dialog4_loop",
		dialogpostanim = "dialog4_pst",
		disappearanim = "disappear4",
		disableplayer = true,
		skippable = true,
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.GIA.ONE,
			wait = 2,
			anim = nil,
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.GIA.TWO, 
			wait = 3, 
			anim = nil, 
			sound = nil,
		},
	}


	SPEECHES["ADVENTURE Archipelago"] = -- Archipelago
	{		
		delay = 2,
	    voice = "dontstarve/maxwell/talk_LP_world3",
		appearanim = "appear3",
		idleanim= "idle3_loop",
		dialogpreanim = "dialog3_pre",
		dialoganim="dialog3_loop",
		dialogpostanim = "dialog3_pst",
		disappearanim = "disappear3",
		disableplayer = true,
		skippable = true,
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.ARCHI.ONE,
			wait = 2.5,
			anim = nil,
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.ARCHI.TWO, 
			wait = 2.5, 
			anim = nil, 
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.ARCHI.THREE, 
			wait = 2.5, 
			anim = nil, 
			sound = nil, 
		},
	}

	SPEECHES["ADVENTURE Two Worlds"] = -- Two Worlds
	{		
		delay = 2,
	    voice = "dontstarve/maxwell/talk_LP_world4",
		appearanim = "appear4",
		idleanim= "idle4_loop",
		dialogpreanim = "dialog4_pre",
		dialoganim="dialog4_loop",
		dialogpostanim = "dialog4_pst",
		disappearanim = "disappear4",
		disableplayer = true,
		skippable = true,
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.TWOLANDS.ONE,
			wait = 1.5,
			anim = nil,
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.TWOLANDS.TWO, 
			wait = 4, 
			anim = nil, 
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.TWOLANDS.THREE, 
			wait = 3.5, 
			anim = nil, 
			sound = nil, 
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.TWOLANDS.FOUR, 
			wait = 2.5,
			anim = nil,
			sound = nil,
		},
	}
    
    SPEECHES["ADVENTURE Darkness"] = -- Darkness
	{		
		delay = 2,
	    voice = "dontstarve/maxwell/talk_LP_world5",
		appearanim = "appear5",
		idleanim= "idle5_loop",
		dialogpreanim = "dialog5_pre",
		dialoganim="dialog5_loop",
		dialogpostanim = "dialog5_pst",
		disappearanim = "disappear5",
		disableplayer = true,
		skippable = true,
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.DARKNESS.ONE,
			wait = 3,
			anim = nil,
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.DARKNESS.TWO, 
			wait = 3, 
			anim = nil, 
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.DARKNESS.THREE, 
			wait = 3, 
			anim = nil, 
			sound = nil, 
		},
        {
			string = STRINGS.MAXWELL_ADVENTUREINTROS.DARKNESS.FOUR, 
			wait = 2, 
			anim = nil, 
			sound = nil, 
		},
	}
    
    SPEECHES["ADVENTURE Checkmate"] = -- MaxwellHome, currently the same like last chapter text
	{		
		delay = 2,
	    voice = "dontstarve/maxwell/talk_LP_world6",
		appearanim = "appear",
		idleanim= "idle",
		dialogpreanim = "dialog_pre",
		dialoganim="dial_loop",
		dialogpostanim = "dialog_pst",
		disappearanim = "disappear",
		disableplayer = true,
		skippable = true,
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_6.ONE,
			wait = 3,
			anim = nil,
			sound = nil,
		},
		{
			string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_6.TWO, 
			wait = 3, 
			anim = nil, 
			sound = nil,
		},
	}
    


local function fn(Sim)	
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.75, .75 )
    inst.Transform:SetTwoFaced()
    
    -- inst.entity:AddNetwork()  -- we only want him to be visible and doing stuff for the client and not transfer his action from server to other clients, so no network
    
    anim:SetBank("maxwell")
    anim:SetBuild("maxwell_build")

    inst:AddTag("notarget")
    
    
    inst:AddComponent("talker")
    inst.components.talker.fontsize = 40
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.colour = Vector3(133/255, 140/255, 167/255)
    inst.components.talker.offset = Vector3(0,-700,0)    
    
    inst:AddComponent("maxwelltalker")
    inst.components.maxwelltalker.speeches = SPEECHES
    
    inst.entity:SetPristine()
	
	 if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("named")
    inst.components.named:SetName("Maxwell")

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "maxwell"
 
    inst:DoTaskInTime(0, function()
        if TheSim:FindFirstEntityWithTag("diviningrod") == nil then
            local rod = SpawnPrefab("diviningrodstart")
            if rod then
                local pt = Vector3(inst.Transform:GetWorldPosition()) - TheCamera:GetDownVec()*2
                rod.Transform:SetPosition(pt:Get() )
            end
        end
    end)

    return inst
end

return Prefab("maxwellintro", fn, assets, prefabs) , 
MakePlacer("maxwellintro_placer", "maxwell", "maxwell_build")
