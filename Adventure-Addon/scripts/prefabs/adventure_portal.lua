local BigPopupDialogScreen = require "screens/bigpopupdialog"

local assets = {
	Asset("ANIM", "anim/portal_adventure.zip"),
	Asset("MINIMAP_IMAGE", "portal"),
}

local function GetVerb()
	return STRINGS.ACTIONS.ACTIVATE.GENERIC
end

local function JumpToAdventure(world)
	TheWorld.components.adventurejump:DoJump(false,false,false) -- without transfering stuff
end

local function OnStartAdventure(inst)
	local player = inst.adventureleader:value()
	local userid = player and player.userid
	if userid and userid == inst.valid_adventureleader_id then
		-- if TheNet:GetPlayerCount() ~= #AllPlayers then
			-- inst.components.talker:Say("Hey! Where are the others?")
		-- else
			local everybody_nearby = true
			local dist_sq = 30 * 30
			for k, v in pairs(AllPlayers) do
				if not v:IsNear(inst, 10) then
					inst.components.talker:Say("Somebody is too far away...")
					everybody_nearby = false
					break
				end
			end
			if everybody_nearby then
				inst.components.talker:Say("HA-HA-HA!")
				inst.SoundEmitter:KillSound("talk")
				inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_maxwelllaugh", "teleportato_laugh")
				for k, v in pairs(AllPlayers) do
					v.sg:GoToState("teleportato_teleport")
				end
				TheWorld:DoTaskInTime(5, JumpToAdventure)
			else
                player.components.health:SetInvincible(false) -- remove invincible 
            end
		-- end
		inst.components.activatable.inactive = true
	end
end

local function OnRejectAdventure(inst)
	local player = inst.adventureleader:value()
    player.components.health:SetInvincible(false) -- remove invincible 
	local userid = player and player.userid
	if userid and userid == inst.valid_adventureleader_id then
		inst.components.talker:Say("Maybe next time...")
		inst.components.activatable.inactive = true
	end
end

local function OnActivate(inst, doer)
	inst.valid_adventureleader_id = doer.userid
	inst.adventureleader:set_local(doer)
	inst.adventureleader:set(doer)
    doer.components.health:SetInvincible(true) -- make invincible 
end

local function StartRagtime(inst)
	if inst.ragtime_playing == nil then
		inst.ragtime_playing = true
		inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/ragtime", "ragtime")
	else
		inst.SoundEmitter:SetVolume("ragtime", 1)
	end
end

local function OnNearPlayer(inst, player)
	inst.AnimState:PushAnimation("activate", false)
	inst.AnimState:PushAnimation("idle_loop_on", true)
	inst.SoundEmitter:PlaySound("dontstarve/common/maxwellportal_activate")
	inst.SoundEmitter:PlaySound("dontstarve/common/maxwellportal_idle", "idle")

	inst:DoTaskInTime(1, StartRagtime)
end

local function ShutUpRagtime(inst)
	inst.SoundEmitter:SetVolume("ragtime", 0)
end

local function OnFarAllPlayers(inst)
	inst.AnimState:PushAnimation("deactivate", false)
	inst.AnimState:PushAnimation("idle_off", true)
	inst.SoundEmitter:KillSound("idle")
	inst.SoundEmitter:PlaySound("dontstarve/common/maxwellportal_shutdown")

	inst:DoTaskInTime(1, ShutUpRagtime)
end

local function OnAdventureLeaderDirty(inst)
	local player = inst.adventureleader:value()
	if player == ThePlayer then
		local function start_adventure()
			TheFrontEnd:PopScreen()
			local rpc = GetModRPC("adventure", "confirm")
			SendModRPCToServer(rpc, inst, true)
		end

		local function reject_adventure()
			TheFrontEnd:PopScreen()
			local rpc = GetModRPC("adventure", "confirm")
			SendModRPCToServer(rpc, inst, false)
		end

		local title = "Doorway to Adventure!"
		local bodytext = "You are about to embark on a long, arduous expedition to locate something familiar. You will need to survive five randomly generated worlds, each presenting you with a unique challenge."
		local yes_box = { text = "Go", cb = start_adventure }
		local no_box = { text = "Stay", cb = reject_adventure }

		local bpds = BigPopupDialogScreen(title, bodytext, { yes_box, no_box })
		bpds.title:SetPosition(0, 85, 0)
		bpds.text:SetPosition(0, -15, 0)

		TheFrontEnd:PushScreen(bpds)
	end
end

local function RegisterNetListeners(inst)
	inst:ListenForEvent("adventureleaderdirty", OnAdventureLeaderDirty)
end

local function OnTalk(inst, script)
	inst.SoundEmitter:PlaySound("dontstarve/characters/maxwell/talk_LP", "talk")
end

local function KillTalkSound(inst)
	inst.SoundEmitter:KillSound("talk")
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 1)

	inst.MiniMapEntity:SetIcon("portal.png")

	inst.AnimState:SetBank("portal_adventure")
	inst.AnimState:SetBuild("portal_adventure")
	inst.AnimState:PlayAnimation("idle_off", true)

	inst.GetActivateVerb = GetVerb

	inst.adventureleader = net_entity(inst.GUID, "adventure.leader", "adventureleaderdirty")

	inst:DoTaskInTime(0, RegisterNetListeners)

	inst:AddComponent("talker")
	inst.components.talker.fontsize = 35
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.offset = Vector3(0, -1050, 0)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.components.talker.ontalk = OnTalk
	inst:ListenForEvent("donetalking", KillTalkSound)

	inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()

	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(4, 5)
	inst.components.playerprox:SetOnPlayerNear(OnNearPlayer)
	inst.components.playerprox:SetOnPlayerFar(OnFarAllPlayers)

	inst:AddComponent("activatable")
	inst.components.activatable.OnActivate = OnActivate
	inst.components.activatable.inactive = true
	inst.components.activatable.quickaction = true

	inst.StartAdventure = OnStartAdventure
	inst.RejectAdventure = OnRejectAdventure

	return inst
end

return Prefab("adventure_portal", fn, assets)
