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
	SANDBOX_1 =
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

	ADVENTURE_1 =
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

	ADVENTURE_2 =
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

	ADVENTURE_3 =
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

	ADVENTURE_4 =
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

	ADVENTURE_TWOLANDS =
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
			wait = 3.5, 
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
	},

	ADVENTURE_5 =
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

	ADVENTURE_6 =
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

	ADVENTURE_6_TELEPORTFAIL =
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
    
    
    
    ADVENTURE_LEVEL1 = -- sandbox
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
			string = "You have some space to explore methinks.", 
			wait = 3.5, 
			anim = nil, 
			sound = nil,
		},
	},

	ADVENTURE_LEVEL2 = -- A Cold Reception
	{		
		delay = 2,
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
			string = "The dew has fallen with a particularly sickening thud this morning...",
			wait = 4,
			anim = nil,
			sound = nil,
		},
		{
			string = "I'm off to find Zem...", 
			wait = 2, 
			anim = nil, 
			sound = nil,
		},
	},

	ADVENTURE_LEVEL3 = -- King of Winter
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
			string = "Well would you look at that, you survived.",
			wait = 3,
			anim = nil,
			sound = nil,
		},
        {
			string = "Now don't get a big head, you aren't the first.",
			wait = 3,
			anim = nil,
			sound = nil,
		},
		{
			string = "Let's see what you're really made of.",
			wait = 2.5, 
			anim = nil, 
			sound = nil,
		},
        {
			string = "And by that I mean to say,",
			wait = 2, 
			anim = nil, 
			sound = nil,
		},
        {
			string = "I will enjoy inspecting your entrails once the Deerclops is done with you.",
			wait = 5, 
			anim = nil, 
			sound = nil,
		},
	},

	ADVENTURE_LEVEL4 = -- The Game is Afoot
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
			string = "Say pal, keep your chin up.",
			wait = 2,
			anim = nil,
			sound = nil,
		},
		{
			string = "You will probably find it hard to stay dapper.", 
			wait = 3, 
			anim = nil, 
			sound = nil,
		},
	},


	ADVENTURE_LEVEL5 = -- Archipelago
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
			string = "What? You're still here?",
			wait = 2.5,
			anim = nil,
			sound = nil,
		},
		{
			string = "Must I do everything myself?", 
			wait = 2.5, 
			anim = nil, 
			sound = nil,
		},
		{
			string = "HOUNDS! DISPOSE OF THIS PEST!", 
			wait = 2.5, 
			anim = nil, 
			sound = nil, 
		},
	},

	ADVENTURE_LEVEL6 = -- Two World
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
	},
    
    ADVENTURE_LEVEL7 = -- Darkness
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
			string = "I left you a little something...",
			wait = 3,
			anim = nil,
			sound = nil,
		},
		{
			string = "I don't think it will help you though.", 
			wait = 3, 
			anim = nil, 
			sound = nil,
		},
		{
			string = "You know what I like about nighttime?", 
			wait = 3, 
			anim = nil, 
			sound = nil, 
		},
        {
			string = "All the spiders.", 
			wait = 2, 
			anim = nil, 
			sound = nil, 
		},
	},
    
    ADVENTURE_LEVEL8 = -- MaxwellHome, currently the same like last chapter text
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
    
}

local function fn(Sim)	
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.75, .75 )
    inst.Transform:SetTwoFaced()
    inst.entity:AddNetwork()
    
    anim:SetBank("maxwell")
    anim:SetBuild("maxwell_build")

    inst:AddTag("notarget")
    
    
    -- inst:AddComponent("talker")
    -- inst.components.talker.fontsize = 40
    -- inst.components.talker.font = TALKINGFONT
    -- inst.components.talker.colour = Vector3(133/255, 140/255, 167/255)
    -- inst.components.talker.offset = Vector3(0,-700,0)
    inst:AddComponent("DStalker") -- the old DS talker component, because here the Say() has still a funcitonal time argument
    inst.components.DStalker.fontsize = 40
    inst.components.DStalker.font = TALKINGFONT
    inst.components.DStalker.colour = Vector3(133/255, 140/255, 167/255)
    inst.components.DStalker.offset = Vector3(0,-700,0)
    
    
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
