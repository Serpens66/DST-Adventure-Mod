local EndGameDialog = require("screens/endgamedialog")
local PopupDialogScreenRedux= require "screens/redux/popupdialog"
local assets =
{
	Asset("ANIM", "anim/maxwell_throne.zip"),
    Asset("SOUND", "sound/sanity.fsb"),
    Asset("SOUND", "sound/common.fsb"),
    Asset("SOUND", "sound/wilson.fsb")

}

local prefabs =
{
    "maxwellendgame",
}

local function SpawnPuppet(inst, name)

    if name ~= "maxwellendgame" then
        name = "puppet_"..name
    end 
    local pt = Vector3(inst.Transform:GetWorldPosition())
    local puppet = SpawnPrefab(name)                 -- wortox and wormthing are not displayed, guess because of restrictions from devs to not allow to spawn them via mods
    if puppet then
        puppet.Transform:SetPosition(pt.x, pt.y + 0.1, pt.z)
        puppet.persists = false
    else
        print("Throne failed to spawn puppet "..tostring(name))
    end
    return puppet
end


local function ZoomAndFade(inst,CLIENT_SIDE)
    if not CLIENT_SIDE then
        for _,player in pairs(AllPlayers) do
            player:SetCameraDistance(15) -- do as many code as possible on server
            player.components.health:SetInvincible(true) -- make player invincible
        end
    end
    if CLIENT_SIDE then
        TheCamera:SetOffset(Vector3(0, 1.45, 0))
    end
    Sleep(2)
    if not CLIENT_SIDE then
        if inst.phonograph then
            if not inst.phonograph.components.machine:IsOn() then
                inst.phonograph.components.machine:TurnOn()
            end
        end
        TheNet:Announce("Congratulation! You won the adventure!")
        for _,player in pairs(AllPlayers) do
            if player~=inst.shadowlord and player.components.health and not player.components.health:IsDead() then
                player.sg:GoToState("shadowdance")
            end
        end
    end
    Sleep(6)
    if CLIENT_SIDE then
        local screen = PopupDialogScreenRedux( STRINGS.UI.ENDGAME.TITLE, STRINGS.UI.ENDGAME.BODY1..(inst.shadowlord.name or inst.shadowlord.prefab)..string.format(STRINGS.UI.ENDGAME.BODY2,STRINGS.UI.GENDERSTRINGS[GetGenderStrings(inst.shadowlord.prefab)].ONE , STRINGS.UI.GENDERSTRINGS[GetGenderStrings(inst.shadowlord.prefab)].TWO), { { text = STRINGS.UI.ENDGAME.YES, cb = function() TheFrontEnd:ClearScreens() end } }, nil,"bigger")
		TheFrontEnd:PushScreen( screen )
    end
    Sleep(18)
    if not CLIENT_SIDE then
        for _,player in pairs(AllPlayers) do
            player:ScreenFade(false, 5) -- do as many code as possible on server
        end
    end
    Sleep(2)
    if not CLIENT_SIDE then
        TheWorld:DoTaskInTime(5,function(world) world.components.adventurejump:DoJump(false,false,false) end)
    end

end

local function DecomposePuppet(inst,CLIENT_SIDE)
    local tick_time = TheSim:GetTickTime()
    local time_to_erode = 4
    inst.puppet:StartThread( function()
        local ticks = 0
        while ticks * tick_time < time_to_erode do
            local erode_amount = ticks * tick_time / time_to_erode
            inst.puppet.AnimState:SetErosionParams( erode_amount, 0.1, 1.0 )
            ticks = ticks + 1
            Yield()
        end
        inst.puppet:Remove()
    end)
end

local function SpawnNewPuppet(inst,CLIENT_SIDE)
    
    if not CLIENT_SIDE then
        inst.SoundEmitter:PlaySound("dontstarve/common/throne/thronemagic", "deathrattle")    
        if inst.puppet~=nil then
            DecomposePuppet(inst,CLIENT_SIDE)
        end
        -- TheCamera:Shake("FULL", 4, 0.033, 0.1)
        for _,player in pairs(AllPlayers) do
            player:ShakeCamera(CAMERASHAKE.FULL, 4, 0.033, 0.1)
            if player.components.health and not player.components.health:IsDead() then player.sg:GoToState("teleportato_teleport") end
            if player.DynamicShadow then
                player.DynamicShadow:Enable(false)
            end
            player.components.health:SetInvincible(true) -- make player invincible
        end
    end
    Sleep(4)
    if not CLIENT_SIDE then
        inst.SoundEmitter:KillSound("deathrattle")
        for _,player in pairs(AllPlayers) do
            player:Hide()
            if inst.shadowlord==nil and player:HasTag("shadowlord") then
                inst.shadowlord = player -- double check
            end
            player.components.health:SetInvincible(true) -- make player invincible
        end
        local puppetToSpawn = inst.shadowlord~=nil and inst.shadowlord.prefab or "wilson"
        if puppetToSpawn == "waxwell" then 
            puppetToSpawn = "maxwellendgame" 
        end
          
    
        local pos = Vector3( inst.Transform:GetWorldPosition() )
        TheWorld:PushEvent('ms_sendlightningstrike', pos)
    
        if puppetToSpawn == "maxwellendgame" then
            local puppet = SpawnPuppet(inst, puppetToSpawn) -- puppet will be nil for new characters
            print("puppet "..tostring(puppet))
            if puppet~=nil and puppet.components.maxwelltalker then puppet:RemoveComponent("maxwelltalker") end  
            inst.AnimState:PlayAnimation("appear")
            inst.AnimState:PushAnimation("idle")
            inst.isMaxwell = true
            if puppet~=nil then
                puppet.AnimState:PlayAnimation("appear")
                puppet.AnimState:PushAnimation("idle_loop", true)
            end
        else
            inst.AnimState:PlayAnimation("player_appear")
            inst.AnimState:PushAnimation("player_idle_loop")
            inst.isMaxwell = false
            inst.shadowlord.Transform:SetPosition(pos.x, pos.y + 0.1, pos.z)
            inst.shadowlord:Show()
            if inst.shadowlord.components.health and not inst.shadowlord.components.health:IsDead() then  inst.shadowlord.sg:GoToState("throne_sit") end
            if inst.shadowlord.HUD ~= nil then
                inst.shadowlord.HUD:Hide()
            end
            local phys = inst.shadowlord.Physics
            inst.shadowlord:AddTag("blocker")
            phys:SetMass(0) --Bullet wants 0 mass for static objects
            phys:SetCollisionGroup(COLLISION.OBSTACLES)
            phys:ClearCollisionMask()
            phys:CollidesWith(COLLISION.ITEMS)
            phys:CollidesWith(COLLISION.CHARACTERS)
            phys:CollidesWith(COLLISION.GIANTS)
            phys:SetCapsule(2,2)
        end
        if inst.DynamicShadow then
            inst.DynamicShadow:Enable(true)
        end

    end
    local soundframedelay = 2
    Sleep(soundframedelay * (1/30))
    if not CLIENT_SIDE then
        inst.SoundEmitter:PlaySound("dontstarve/common/throne/playerappear")
        for _,player in pairs(AllPlayers) do
            if player~=inst.shadowlord then
                if player.endingmaxwellposition~=nil then player.Transform:SetPosition(player.endingmaxwellposition:Get()) end
                SpawnPrefab("collapse_small").Transform:SetPosition(player.Transform:GetWorldPosition())
                player.sg:GoToState("idle")
                player.AnimState:SetMultColour(0, 0, 0, 0.7)
                player:Show()
            end
            player.components.health:SetInvincible(true) -- make player invincible
        end
    end
    Sleep(3)

    inst:StartThread(function() ZoomAndFade(inst,CLIENT_SIDE) end)
    

end


local function MaxwellDie(inst,CLIENT_SIDE)
    if not CLIENT_SIDE then
        inst.AnimState:PlayAnimation("death")
        if inst.puppet~=nil then
            inst.puppet.AnimState:PlayAnimation("death")
        end
        inst.SoundEmitter:PlaySound("dontstarve/maxwell/breakchains")    
        inst:DoTaskInTime(113 * (1/30), function() inst.SoundEmitter:PlaySound("dontstarve/maxwell/blowsaway") end)
        inst:DoTaskInTime(95 * (1/30), function() inst.SoundEmitter:PlaySound("dontstarve/maxwell/throne_scream") end)    
        inst:DoTaskInTime(213 * (1/30), function() inst.SoundEmitter:KillSound("deathrattle") end)
    end
    Sleep(9.5)
    inst:StartThread(function() SpawnNewPuppet(inst,CLIENT_SIDE) end)
end


local function PlayerDie(inst,CLIENT_SIDE)
    if not CLIENT_SIDE then
        inst.AnimState:PlayAnimation("player_death")
        if inst.puppet~=nil then
            inst.puppet.AnimState:PlayAnimation("dismount")
            inst.puppet.AnimState:PushAnimation("death", false)
        end
        inst:DoTaskInTime(24 * (1/30), function() inst.SoundEmitter:PlaySound("dontstarve/wilson/death") end)
        inst:DoTaskInTime(40 * (1/30), function() inst.SoundEmitter:KillSound("deathrattle") end)
    end
    Sleep(4)
    inst:StartThread(function() SpawnNewPuppet(inst,CLIENT_SIDE) end)
end

local function SetUpCutscene(inst,CLIENT_SIDE) -- make it work if only server calls this... TODO
    print("SetUpCutscene maxwellthrone")
    
    local pt = Vector3(inst.Transform:GetWorldPosition())
    -- print("throne steht auf position "..tostring(pt))
    --Put game into "cutscene" mode. 
    if not CLIENT_SIDE then
        -- remove all hostile mobs and extinguish all fires
        local nearenemies = TheSim:FindEntities(pt.x, pt.y, pt.z, 100, nil, nil, {"hostile","smolder", "fire"})
        for _,enemy in pairs(nearenemies) do
            if enemy~=nil and enemy:IsValid() then
                if enemy.components~=nil and enemy.components.burnable~=nil and not string.match(enemy.prefab,"maxwelllight") then
                    enemy.components.burnable:Extinguish(true, 0)
                end
                if enemy:HasTag("hostile") then
                    enemy:Remove()
                end
            end
        end
        
        if inst.puppet~=nil and inst.puppet.components.maxwelltalker then
            if inst.puppet.components.maxwelltalker:IsTalking() then
                inst.puppet.components.maxwelltalker:StopTalking()
            end
            inst.puppet:RemoveComponent("maxwelltalker")
            inst.puppet.AnimState:PlayAnimation("idle_loop")
        end
    end
    local x,y = 0,0
    for _,player in pairs(AllPlayers) do
        if player:HasTag("shadowlord") then
            inst.shadowlord = player -- the player who freed maxwell and will be put onto the throne
        end
        if not CLIENT_SIDE then
            player.components.health:SetInvincible(true) -- make player invincible
            if player.components.playercontroller~=nil then player.components.playercontroller:Enable(false) end
            player:ShowHUD(false)
            -- player:SetCameraDistance(15)
            player:ShakeCamera(CAMERASHAKE.FULL, 5, 0.033, 0.1)
        end
        if _<=15 then -- only up to 15 players go to maxwell, for others there is no space left
            if _<5 then
                x = 0
            elseif _>=5 and _<=10 then
                x = 1.5
            elseif _>10 then
                x = 3
            end
            if _==1 or _==6  or _==11 then
                y = 0
            elseif _==2 or _==7 or _==12  then
                y = -1.5
            elseif _==3 or _==8 or _==13  then
                y = 1.5
            elseif _==4 or _==9 or _==14  then
                y = 3
            elseif _==5 or _==10 or _==15  then
                y = -3
            end
            if player.components and player.components.locomotor then
                player.components.locomotor:GoToPoint(pt+Vector3(-3-x, 0, y))
            end
            player.endingmaxwellposition = pt+Vector3(-3-x, 0, y)
            -- print("player "..tostring(_).." soll zu position "..tostring(pt+Vector3(-3-x, 0, y)))
            player:FacePoint(pt)
            player:DoTaskInTime(3,function() player:FacePoint(pt) end)
        end
    end
    if CLIENT_SIDE then
        TheCamera:CutsceneMode(true)
        TheCamera:SetCustomLocation(Vector3(pt.x, pt.y, pt.z))
        TheCamera:SetGains(0.5, .1, 2)
        TheCamera:SetMinDistance(5)
    end
    if not CLIENT_SIDE then
        inst.previousLock = "waxwell"
        inst.phonograph = TheSim:FindFirstEntityWithTag("maxwellphonograph")
        if inst.phonograph then
            if inst.phonograph.components.machine:IsOn() then
                inst.phonograph.components.machine:TurnOff()
            end
        end
        inst.SoundEmitter:PlaySound("dontstarve/common/throne/thronemagic", "deathrattle")
    end
    Sleep(3)
    if CLIENT_SIDE then
        TheCamera:SetGains(0.5, .1, .3)
    end

    Sleep(2)
    
    if not CLIENT_SIDE then
        if inst.DynamicShadow then
            inst.DynamicShadow:Enable(false)
        end
        inst.SoundEmitter:PlaySound("dontstarve/common/throne/thronedisappear")
    end
    if inst.isMaxwell then
        inst:StartThread(function() MaxwellDie(inst,CLIENT_SIDE) end)
    else
        inst:StartThread(function() PlayerDie(inst,CLIENT_SIDE) end)
    end
end

local function startthread(inst,CLIENT_SIDE)
    inst.task =  inst:StartThread(function() SetUpCutscene(inst,CLIENT_SIDE) end)
end

local function fn(Sim)

    local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 3, 2 )    
    inst.entity:AddNetwork()
    MakeObstaclePhysics(inst, .1)
    inst.AnimState:SetBank("throne")
    inst.AnimState:SetBuild("maxwell_throne")
    inst.AnimState:PlayAnimation("idle", false)

    inst:AddTag("maxwellthrone")
    inst.startthread = startthread
    -- local charlist = GetActiveCharacterList and GetActiveCharacterList() or MAIN_CHARACTERLIST
    local characterinthrone = "waxwell" --charlist[math.random(#charlist)] -- waxwell is most intersting and chars like wortox can not be displayed..
    
    if characterinthrone == "waxwell" then --special case for maxwell
        inst.isMaxwell = true
    else
        inst.isMaxwell = false
    end
    
    
    inst.entity:SetPristine()
	
	 if not TheWorld.ismastersim then
        return inst
    end

    inst.lock = nil
    inst.startthread = startthread

    if characterinthrone == "waxwell" then --special case for maxwell
        inst.isMaxwell = true
        characterinthrone = "maxwellendgame"
        inst:ListenForEvent("free", function()EndGameSequence(inst) end, inst.lock)  --is called when diviningrod is placed at lock
    else
        inst.isMaxwell = false
        anim:PlayAnimation("player_idle_loop")
        inst:ListenForEvent("free", function() EndGameSequenceNoMaxwell(inst) end, inst.lock)  --is called when diviningrod is placed at lock
    end
    
    inst:AddComponent("inspectable") 
    
    inst:DoTaskInTime(0, function() inst.puppet = SpawnPuppet(inst, characterinthrone) end)

    return inst
end

return Prefab( "common/characters/maxwellthrone", fn, assets, prefabs) 
