
local helpers = {}


-- #################################################
------------------ Technical Helpers --------------------
-- #################################################

--  custom listenforevent, puts our function at the beginning of the list of fns to execute (instead of at the end)
local function AddListener(t, event, inst, fn)
    local listeners = t[event]
    if not listeners then
        listeners = {}
        t[event] = listeners
    end
    local listener_fns = listeners[inst]
    if not listener_fns then
        listener_fns = {}
        listeners[inst] = listener_fns
    end
    table.insert(listener_fns, 1, fn) -- put it on the first position
end
local function MyListenForEventPutinFirst(self, event, fn, source)
    source = source or self
    if not source.event_listeners then
        source.event_listeners = {}
    end
    AddListener(source.event_listeners, event, self, fn)
    if not self.event_listening then
        self.event_listening = {}
    end
    AddListener(self.event_listening, event, source, fn)
end
helpers["MyListenForEventPutinFirst"] = MyListenForEventPutinFirst


local function removetablekey(t, lookup_key)
    for k, v in pairs(t) do
        if k == lookup_key then
            t[k] = nil
            return v
        end
    end
end
helpers["removetablekey"] = removetablekey


local function nroot(num,root)
  return num^(1/root)
end
helpers["nroot"] = nroot

local function exists_in_table(var,G)
  for k, _ in pairs(G) do
    if k == var then
      return true
    end
  end
end
helpers["exists_in_table"] = exists_in_table

 -- Made to work with (And return) array-style tables
-- This function does not preserve the original table
local function MyPickSome(num, choices) -- better function than in util.lua
	local l_choices = choices
	local ret = {}
	if l_choices then -- nil check
        for i=1,num do
            if #l_choices > 0 then -- bigger 0 check
                local choice = math.random(#l_choices)
                table.insert(ret, l_choices[choice])
                table.remove(l_choices, choice)
            end
        end
    end
	return ret
end
helpers["MyPickSome"] = MyPickSome


local function FindWaterBetweenPoints(p0x, p0y, p1x, p1y)
	local map = TheWorld.Map

	local dx = math.abs(p1x - p0x)
	local dy = math.abs(p1y - p0y)

    local ix = p0x < p1x and TILE_SCALE or -TILE_SCALE
    local iy = p0y < p1y and TILE_SCALE or -TILE_SCALE

    local e = 0;
    for i = 0, dx+dy - 1 do
	    if map:IsOceanTileAtPoint(p0x, 0, p0y) then
			return p0x, 0, p0y -- we only need the coordinates
		end

        local e1 = e + dy
        local e2 = e - dx
        if math.abs(e1) < math.abs(e2) then
            p0x = p0x + ix
            e = e1
		else 
            p0y = p0y + iy
            e = e2
        end
	end

	return nil
end
helpers["FindWaterBetweenPoints"] = FindWaterBetweenPoints

local function IsNearOcean(x,y,z,radius)
    if FindWaterBetweenPoints(x,z,x+radius,z+radius) or FindWaterBetweenPoints(x,z,x-radius,z-radius) or FindWaterBetweenPoints(x,z,x-radius,z+radius) or 
    FindWaterBetweenPoints(x,z,x+radius,z-radius) or FindWaterBetweenPoints(x,z,x+radius,z) or FindWaterBetweenPoints(x,z,x-radius,z) or 
    FindWaterBetweenPoints(x,z,x,z+radius) or FindWaterBetweenPoints(x,z,x,z-radius) then
        return true
    end
    return false
end
helpers["IsNearOcean"] = IsNearOcean


-- #################################################
------------------ Game Helpers Get Info --------------------
-- #################################################

local _T = TUNING

local function SpawnPrefabAtLandPlotNearInst(prefab,loc,x,y,z,times,xmin,zmin,landradius) -- xmin and zmin are the mind distance it should have to the given position
    -- print("Spawn "..tostring(prefab).." near "..tostring(loc).." times: "..tostring(times))
    if prefab==nil or loc==nil or type(prefab)~="string" then
        print("Teleportato: Spawnprefab is "..tostring(prefab).." instead of a prefab string? or loc is nil: "..tostring(loc).."... error")
        return nil 
    end
    local pos = nil
    if loc.prefab then    
        pos = loc:GetPosition()
    else -- loc can also be a position already
        pos = loc
    end
    x = x or 5
    y = y or 0 -- should be 0 most of the time, it is the height
    z = z or 5
    xmin = xmin or 3
    zmin = zmin or 3
    local xn = 0
    local zn = 0
    times = times or 1
    times = math.ceil(times)
    local found = false
    local tp_pos
    local attempts = 100
    local spawn = nil
    for i=1,times,1 do 
        found = false
        attempts = 100 --try multiple times to get a spot on ground before giving up so we don't infinite loop
        while attempts > 0 do
            xn = GetRandomWithVariance(0,x)
            zn = GetRandomWithVariance(0,z)
            xn = (xn>=0 and xn<=xmin and xn+xmin) or (xn<0 and xn>=-xmin and xn-xmin) or xn -- dont be between -1 and 1, because this is too near
            zn = (zn>=0 and zn<=zmin and zn+zmin) or (zn<0 and zn>=-zmin and zn-zmin) or zn
            tp_pos = pos + Vector3(xn ,GetRandomWithVariance(0,y) ,zn  )
            if (landradius==nil and TheWorld.Map:IsAboveGroundAtPoint(tp_pos:Get())) or (landradius~=nil and not IsNearOcean(tp_pos.x,tp_pos.y,tp_pos.z,landradius)) then
                found = true
                break
            end
            attempts = attempts - 1
        end
        spawn = nil
        if found then
            spawn = SpawnPrefab(prefab)
            if spawn then
                spawn.Transform:SetPosition(tp_pos:Get())
                SpawnPrefab("collapse_small").Transform:SetPosition(tp_pos:Get()) -- a small effect
            else
                print("Spawn of "..tostring(prefab).." failed...")
            end
            -- print("spawned "..tostring(prefab).." at "..tostring(tp_pos).." times: "..tostring(times).." spawn: "..tostring(spawn))
        end
    end
    return spawn -- does only return the last spawn, if times is higher than 1
end
helpers["SpawnPrefabAtLandPlotNearInst"] = SpawnPrefabAtLandPlotNearInst


local function MoveInstAtLandPlotNearInst(inst,loc,x,y,z,xmin,zmin,landradius) -- xmin and zmin are the mind distance it should have to the given position
    -- print("Spawn "..tostring(inst).." near "..tostring(loc).." times: "..tostring(times))
    if inst==nil or loc==nil or not inst:IsValid() then
        print("Teleportato: inst is "..tostring(inst).." ? or loc is nil: "..tostring(loc).."... error")
        return nil 
    end
    local pos = nil
    if loc.prefab then    
        pos = loc:GetPosition()
    else -- loc can also be a position already
        pos = loc
    end
    x = x or 5
    y = y or 0 -- should be 0 most of the time, it is the height
    z = z or 5
    xmin = xmin or 3
    zmin = zmin or 3
    local xn = 0
    local zn = 0
    local found = false
    local tp_pos
    local attempts = 100
    local spawn = nil
    while attempts > 0 do
        xn = GetRandomWithVariance(0,x)
        zn = GetRandomWithVariance(0,z)
        xn = (xn>=0 and xn<=xmin and xn+xmin) or (xn<0 and xn>=-xmin and xn-xmin) or xn -- dont be between -1 and 1, because this is too near
        zn = (zn>=0 and zn<=zmin and zn+zmin) or (zn<0 and zn>=-zmin and zn-zmin) or zn
        tp_pos = pos + Vector3(xn ,GetRandomWithVariance(0,y) ,zn  )
        if (landradius==nil and TheWorld.Map:IsAboveGroundAtPoint(tp_pos:Get())) or (landradius~=nil and not IsNearOcean(tp_pos.x,tp_pos.y,tp_pos.z,landradius)) then
            found = true
            break
        end
        attempts = attempts - 1
    end
    if found then
        inst.Transform:SetPosition(tp_pos:Get())
    else
        print("MoveInstAtLandPlotNearInst: failed to move "..tostring(inst).." to valid location..")
    end
    return found
end
helpers["MoveInstAtLandPlotNearInst"] = MoveInstAtLandPlotNearInst


local function CheckHowManyPlayers(inst) -- inst is teleportato and this checks how many are near to it
    local x, y, z = inst.Transform:GetWorldPosition() 
    local nearplayers = TheSim:FindEntities(x, y, z, 17, nil, nil, {"player"})
    local counter = 0
    for _,plyer in pairs(nearplayers) do
        counter = counter + 1
    end
    return counter
end
helpers["CheckHowManyPlayers"] = CheckHowManyPlayers


-- #################################################
------------------ Game Helpers Set Info --------------------
-- #################################################

local function DeactivateTeleportato(inst)
    inst.AnimState:PlayAnimation("power_on", false)
    inst.AnimState:PushAnimation("idle_on", true)
    inst.activatedonce = false
    inst.components.activatable.inactive = true
    inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_powerup", "teleportato_on")
    inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_idle_LP", "teleportato_idle")
end
helpers["DeactivateTeleportato"] = DeactivateTeleportato

-- slow pick, thx DarkXero
local function PickedFn(inst, data)
	inst.components.pickable:Regen()
	local picker = data and data.picker
	if picker and picker.components.inventory then
		local pos = inst:GetPosition()
		picker.components.inventory:GiveItem(inst, nil, pos)
	end
end
local function MakeSlowPick(inst)
	if inst.components.inventoryitem then
		inst.components.inventoryitem.canbepickedup = false
		inst:AddComponent("pickable")
		inst:ListenForEvent("picked", PickedFn)
		inst.components.pickable:Regen()
	end
end
helpers["MakeSlowPick"] = MakeSlowPick

local function AddScenario(inst,scen)
    if inst and inst.components and not inst.components.scenariorunner then
        inst:AddComponent("scenariorunner")
        inst.components.scenariorunner:SetScript(scen)
        inst.components.scenariorunner:Run()
    end
end
helpers["AddScenario"] = AddScenario

local function MakeFireProof(inst,howlong)
    if inst and inst.components and inst.components.burnable then
        inst:AddTag("fireimmune")
        if howlong then
            inst:DoTaskInTime(howlong,function(inst)
                inst:RemoveTag("fireimmune")
            end)
        end
    end
end
helpers["MakeFireProof"] = MakeFireProof


local function FuelNearFires(player) -- fuel fires near players if they spawn the first time (to make winter/dark easier at start)
    local x, y, z = player.Transform:GetWorldPosition() 
    local nearfires = TheSim:FindEntities(x, y, z, 10, nil, nil, {"campfire"})
    for _,fire in pairs(nearfires) do
        if fire~=nil and fire:IsValid() and fire.components~=nil and fire.components.fueled~=nil and fire.components.fueled.accepting then
            fire.components.fueled:DoDelta( TUNING.LARGE_FUEL )
        end
    end
end
helpers["FuelNearFires"] = FuelNearFires

local ClockworkEnemiesList = {"bishop","knight","rook","knight_nightmare","bishop_nightmare","rook_nightmare","bishop","knight","knight_nightmare","bishop_nightmare",}
local ClockworkEnemiesListWithoutRook = {"bishop","knight","knight_nightmare","bishop_nightmare","bishop","knight","knight_nightmare","bishop_nightmare",}
local ClockworkEnemies = {bishop={1,2},knight={1,2},rook={0,1},knight_nightmare={0,1},bishop_nightmare={0,1},rook_nightmare={0,1},}
local ClockworkEnemiesWithoutRook = {bishop={1,2},knight={1,2},knight_nightmare={0,2},bishop_nightmare={0,2}}
local HoundEnemies = {houndmound={3,6},icehound={0,2},firehound={0,2},}
local SpiderEnemies = {spiderden={3,6},spider_dropper={0,2},spider_hider={0,2},spider_spitter={0,2},spider_moon={0,2},}
local CaveSpiderEnemies = {spiderden={1,2},dropperweb={1,2},spiderhole={1,3}}
local PigEnemies = {pigtorch={3,6},}
local KillerBeeEnemies = {wasphive={3,6},}
local MermEnemies = {mermhouse={2,5},}
local CaveShadows = {crawlingnightmare={1,3},nightmarebeak={1,3}}
local CaveWorms = {worm={2,4},}
local Enemies = {ClockworkEnemies,HoundEnemies,SpiderEnemies,PigEnemies,KillerBeeEnemies,MermEnemies,HoundEnemies,SpiderEnemies}
local CaveEnemies = {ClockworkEnemies,CaveSpiderEnemies,CaveShadows,CaveSpiderEnemies,CaveWorms}
local function SpawnEnemies(inst,world) -- inst may be the base but also a random tele part, so better dont use it
    print("SpawnEnemies1")
    if TUNING.TELEPORTATOMOD.Enemies > 0 then
        local multi = TUNING.TELEPORTATOMOD.Enemies
        local ChosenEnemies = nil
        local pos = nil
        for _,partprefab in ipairs({"teleportato_potato","teleportato_box","teleportato_ring","teleportato_crank"}) do
            pos = TheWorld.components.adv_startstuff.partpositions[partprefab]
            if pos~=nil then
                ChosenEnemies = TheWorld:HasTag("cave") and GetRandomItem(CaveEnemies) or GetRandomItem(Enemies) -- spawn the same kind of enemies at one location
                for prefab,numbers in pairs(ChosenEnemies) do 
                    for i=1, math.random(numbers[1],numbers[2])*multi do 
                        helpers.SpawnPrefabAtLandPlotNearInst(prefab,pos,10,0,10)
                    end
                end
            end    
        end
        local addmore = world.telebasewasspawnedbymod==true and 1 or 0
        if TheWorld.components.adv_startstuff.partpositions["teleportato_base"]~=nil then
            -- print("SpawnEnemiesbase")
            for prefab,numbers in pairs(ClockworkEnemiesWithoutRook) do  -- clockworkenemies at base from teleportato, yes there were you are at the moment. Without Rook since they are destroing the ancient station...
                for i=1, (math.random(numbers[1],numbers[2])*multi-1)+addmore do -- but not too much, since we are there at the moment... and also at beginning of world there are already some clockworks 
                    helpers.SpawnPrefabAtLandPlotNearInst(prefab,TheWorld.components.adv_startstuff.partpositions["teleportato_base"],10,0,10)
                end
            end
        end
    end
end
helpers["SpawnEnemies"] = SpawnEnemies

local function SpawnThuleciteStatue(inst) -- will be from 4 to 18
    -- print("SpawnThuleciteStatue")
    if TUNING.TELEPORTATOMOD.Thulecite>0 then
        local number = 4
        if TUNING.TELEPORTATOMOD.Ancient==0 and TUNING.TELEPORTATOMOD.Thulecite>0 then -- 
            number = TUNING.TELEPORTATOMOD.Thulecite*4
        elseif TUNING.TELEPORTATOMOD.Ancient==1 and TUNING.TELEPORTATOMOD.Thulecite>0 then -- 
            number = TUNING.TELEPORTATOMOD.Thulecite*6-- 12 if medium
        elseif TUNING.TELEPORTATOMOD.Ancient==2 and TUNING.TELEPORTATOMOD.Thulecite>0 then -- 
            number = TUNING.TELEPORTATOMOD.Thulecite*5
        end
        if TheWorld.components.adv_startstuff.partpositions["teleportato_base"]~=nil then
            helpers.SpawnPrefabAtLandPlotNearInst("ruins_statue_head",TheWorld.components.adv_startstuff.partpositions["teleportato_base"],10,0,10)
            helpers.SpawnPrefabAtLandPlotNearInst("ruins_statue_mage",TheWorld.components.adv_startstuff.partpositions["teleportato_base"],10,0,10,number/4)
            helpers.SpawnPrefabAtLandPlotNearInst("ruins_statue_mage_nogem",TheWorld.components.adv_startstuff.partpositions["teleportato_base"],10,0,10,number/4) -- 3 at medium and broken
            helpers.SpawnPrefabAtLandPlotNearInst("thulecite_pieces",TheWorld.components.adv_startstuff.partpositions["teleportato_base"],10,0,10,number/2)-- 6 at medium and broken
        end
        local pos = nil
        for _,partprefab in ipairs({"teleportato_potato","teleportato_box","teleportato_ring","teleportato_crank"}) do
            pos = TheWorld.components.adv_startstuff.partpositions[partprefab]
            for i=1,number,1 do 
                if GetRandomMinMax(0,1)>0.5 then -- 1/2 chance -- "ruins_statue_mage" "ruins_statue_mage_nogem"
                    helpers.SpawnPrefabAtLandPlotNearInst("ruins_statue_mage_nogem",pos,10,0,10)
                end
                helpers.SpawnPrefabAtLandPlotNearInst("thulecite_pieces",pos,10,0,10) -- 6 Thulecite Fragments
            end
            if GetRandomMinMax(0,1)>0.5 then -- 1/2 chance -- "ruins_statue_mage" "ruins_statue_mage_nogem"
                helpers.SpawnPrefabAtLandPlotNearInst("ruins_statue_head",pos,10,0,10)
            end
            if GetRandomMinMax(0,1)>0.5 then -- 1/2 chance -- "ruins_statue_mage" "ruins_statue_mage_nogem"
                helpers.SpawnPrefabAtLandPlotNearInst("ruins_statue_mage",pos,10,0,10)
            end -- so ~ 4 statue per position 
        end
    end
end
helpers["SpawnThuleciteStatue"] = SpawnThuleciteStatue

local function SpawnAncientStation(inst)
    -- print("SpawnAncientStation")
    if TUNING.TELEPORTATOMOD.Ancient > 0 and TheWorld.components.adv_startstuff.partpositions["teleportato_base"]~=nil then -- 
        if TUNING.TELEPORTATOMOD.Ancient == 1 then -- broken
            helpers.SpawnPrefabAtLandPlotNearInst("ancient_altar_broken",TheWorld.components.adv_startstuff.partpositions["teleportato_base"],7,0,7)
        elseif TUNING.TELEPORTATOMOD.Ancient == 2 then -- complete
            helpers.SpawnPrefabAtLandPlotNearInst("ancient_altar",TheWorld.components.adv_startstuff.partpositions["teleportato_base"],7,0,7)
        end
        helpers.SpawnPrefabAtLandPlotNearInst(GetRandomItem(ClockworkEnemiesListWithoutRook),TheWorld.components.adv_startstuff.partpositions["teleportato_base"],8,0,8) -- always spawn one enemy if AncientStation is enabled
    end
end
helpers["SpawnAncientStation"] = SpawnAncientStation


local ChestScripts = {"chest_total_random"} -- ,"chest_insanity" -- sucks, cause of undesctructable sanityrocks
local ChestTypes = {"treasurechest"} --  pandoraschests do listen to ruins now and are undestructable...
local consolation = {"log","cutgrass","rocks","twigs"} -- in chests that only contain something if trap is triggered, consolation thing is always in it 
local function InitChest(inst,script)
    if inst then
        helpers.AddScenario(inst,script)  -- add the items and traps
        if inst.components.container:IsEmpty() then -- some chests like chest_bees only contain something if trap is triggered, which is in only 66% the case. Add something that is there even if it is no trap
            for i = 1, math.ceil(GetRandomMinMax(0,60)) do
                local item = SpawnPrefab(GetRandomItem(consolation))
                if item ~= nil then
                    inst.components.container:GiveItem( item )
                end
            end
        end
    end
end
local function SpawnOrnateChest(inst) -- if big chest, 2 additional enemy
    -- print("SpawnOrnateChest")
    if TUNING.TELEPORTATOMOD.Chests > 0 then
        local number = 2 -- ~ 1 chest per pos
        local chest = nil
        -- Had to remove pandoras and minotaurchest cause of recent New Reign update, were these chests are undestructable and refill with ruins resett. we use treasurechests instead
        if TUNING.TELEPORTATOMOD.Chests == 2 then -- medium
            number = 4 --~ 2 chest per pos
        elseif TUNING.TELEPORTATOMOD.Chests == 3 then -- many
            number = 6 --~ 3 chest per pos
        end
        if TheWorld.components.adv_startstuff.partpositions["teleportato_base"]~=nil then
            for i=1,number,1 do --
                if GetRandomMinMax(0,1)>0.5 then -- 1/2 chance 
                    chest = helpers.SpawnPrefabAtLandPlotNearInst("treasurechest",TheWorld.components.adv_startstuff.partpositions["teleportato_base"],8,0,8) -- pandoraschests do listen to runs now and are undestructable...
                    if chest then
                        chest:DoTaskInTime(i, InitChest,GetRandomItem(ChestScripts)) -- dont init them all at once, cause this lags
                    end
                end
            end
        end
        
        local pos = nil
        for _,partprefab in ipairs({"teleportato_potato","teleportato_box","teleportato_ring","teleportato_crank"}) do
            pos = TheWorld.components.adv_startstuff.partpositions[partprefab]
            for i=1,number,1 do --
                if GetRandomMinMax(0,1)>0.5 then -- 1/2 chance 
                    chest = helpers.SpawnPrefabAtLandPlotNearInst(GetRandomItem(ChestTypes),pos,10,0,10)
                    if chest then
                        chest:DoTaskInTime(i, InitChest,GetRandomItem(ChestScripts)) -- dont init them all at once, cause this lags
                    end
                end
            end
        end
    end
end
helpers["SpawnOrnateChest"] = SpawnOrnateChest

local function CallthisfnIfthatfnIsTrue(inst,thisfn,thatfn,maxcounter,...)
    -- print("CallthisfnIfthatfnIsTrue")
    -- print(inst)
    -- print(thisfn)
    -- print(thatfn)
    -- print(...)
    if thatfn(inst) then
        thisfn(...)
    else
        -- print("call CallthisfnIfthatfnIsTrue again later...")
        if maxcounter>0 then -- only try it that often to prevent endless loop
            maxcounter = maxcounter-1
            inst:DoTaskInTime(0.1,CallthisfnIfthatfnIsTrue,thisfn,thatfn,maxcounter,...)
        else
            print("CallthisfnIfthatfnIsTrue: Gave up, tried maxcounter times, but thatfn "..tostring(thatfn).." was never true, thisfn was never called: "..tostring(thisfn))
        end
    end
end
helpers["CallthisfnIfthatfnIsTrue"] = CallthisfnIfthatfnIsTrue


return helpers