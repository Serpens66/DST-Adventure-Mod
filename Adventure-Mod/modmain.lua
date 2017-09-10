-- maxwell phonograph, mod by DoktorHolmes
-- maxwell light and throne, mod by Leonardo Coxington
-- and my own work...
PrefabFiles = { 
	"maxwellphonograph",
    "maxwelllight_p",
	"maxwelllight_flame",
	-- "maxwellthrone_p",
    "maxwellthrone",	
    "paired_maxwelllight",
    "maxwell",
    "maxwellendgame",
    "maxwellhead",
    "maxwellhead_trigger",
    "maxwellintro",
    "maxwellkey",
    "maxwelllock",
    "diviningrodstart",
    "teleportato_checkmate",
    "teleportlocation",
    "puppet",
}
Assets = {
	Asset("ANIM", "anim/phonograph.zip"),
	-- Asset("SOUND", "sound/phonograph.fsb"),
	-- Asset("SOUNDPACKAGE", "sound/phonograph.fev"),
	Asset("ATLAS", "images/inventoryimages/Gramophone.xml"),
    Asset("IMAGE", "images/inventoryimages/Gramophone.tex"),
    ----------------------------------------------------
    Asset( "IMAGE", "images/map_icons/evilthrone.tex" ),
	Asset( "ATLAS", "images/map_icons/evilthrone.xml" ),
	Asset( "IMAGE", "images/map_icons/evillight.tex" ),
	Asset( "ATLAS", "images/map_icons/evillight.xml" ),
	----------------------------------------------------
	Asset( "IMAGE", "images/inventoryimages/evilthrone.tex" ),
	Asset( "ATLAS", "images/inventoryimages/evilthrone.xml" ),
	Asset( "IMAGE", "images/inventoryimages/evillight.tex" ),
	Asset( "ATLAS", "images/inventoryimages/evillight.xml" ),
    -------------------------------------------------------
    Asset("ANIM", "anim/maxwell_build.zip"),
    Asset("ANIM", "anim/max_fx.zip"),
    Asset("ANIM", "anim/maxwell_basic.zip"),
	Asset("ANIM", "anim/maxwell_adventure.zip"),
	-- Asset("SOUND", "sound/maxwell.fsb"),
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
    Asset("ANIM", "anim/maxwell_endgame.zip"),
    Asset("ANIM", "anim/maxwell_floatinghead.zip"),
    Asset("ANIM", "anim/diviningrod_maxwell.zip"),
    Asset("ANIM", "anim/purple_gem.zip"),
    Asset("ANIM", "anim/player_throne.zip"),
}
RemapSoundEvent( "phonograph/play", "phonograph/sound/gramaphoneplay" )
RemapSoundEvent( "phonograph/end", "phonograph/sound/gramaphoneend" )


local _G = GLOBAL
GLOBAL.TUNING.ADV_DIFFICULTY = GetModConfigData("difficulty")
GLOBAL.TUNING.ITEMNUMBERTRANS = GetModConfigData("inventorysavenumber")
GLOBAL.TUNING.BLUEPRINTMODE = GetModConfigData("blueprintonly")

GLOBAL.OVERRIDELEVEL = nil
GLOBAL.CHAPTER = nil

if not GLOBAL.TUNING.ADVENTUREMOD then
    GLOBAL.TUNING.ADVENTUREMOD = {}
end
if not GLOBAL.TUNING.ADVENTUREMOD.WORLDS then
    GLOBAL.TUNING.ADVENTUREMOD.WORLDS = {}
end

WORLDS = GLOBAL.TUNING.ADVENTUREMOD.WORLDS


modes = {"survival","wilderness","endless"} -- overwriting every gamemode to the same, so regardless wich mode you choose, it is always the following
for i,mode in ipairs(modes) do
    GLOBAL.GAME_MODES[mode].spawn_mode = "fixed"
    GLOBAL.GAME_MODES[mode].ghost_sanity_drain = true
    GLOBAL.GAME_MODES[mode].ghost_enabled = true
    GLOBAL.GAME_MODES[mode].reset_time = { time = 120, loadingtime = 180 }
    GLOBAL.GAME_MODES[mode].portal_rez = true
    GLOBAL.GAME_MODES[mode].invalid_recipes = {} -- "lifeinjector", "resurrectionstatue", "reviver"
    GLOBAL.GAME_MODES[mode].resource_renewal = true
end


local shoptab = AddRecipeTab("Blueprints", 979, "images/inventoryimages.xml", "blueprint.tex", nil)	
questfunctions = GLOBAL.require("scenarios/questfunctions")

-- sort the items in various tables, depending how important the tech is 
GLOBAL.TUNING.PREFABSALWAYS = {"torch", "campfire", "axe", "compass", "bedroll_straw", "minifan", "pickaxe", "armorgrass", "homesign", "arrowsign", "wall_hay_item", "wardrobe", "flowerhat", "strawhat",
"moonrockcrater","trap","earmuffshat"} -- only these things should be always craftable without learning it

local function pairsOrdered(t, order) -- iterates in an ordered way
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end
    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end


-- local function ChangeSomeTechLevels()
    -- seems it does not work with ChangeSomeTechLevels, cause with it there is no firepit blueprint (which was none before)...
    if TUNING.BLUEPRINTMODE then--and WORLDS[GLOBAL.OVERRIDELEVEL].name~="Maxwells Door" then -- change tech_level of some things
        for k,v in pairs(GLOBAL.AllRecipes) do
            if v.level==GLOBAL.TECH.NONE and v.builder_tag == nil then -- character specific items should stay NONE tech, if they are before 
                if not table.contains(GLOBAL.TUNING.PREFABSALWAYS,v.name) then
                    v.level = GLOBAL.TECH.SCIENCE_ONE -- make require researchlab1
                end
            elseif table.contains(GLOBAL.TUNING.PREFABSALWAYS,v.name) or v.builder_tag ~= nil then -- make also all character specifc items tech none, otherwise they won't be buildable, cause no blueprints for them exist
                v.level = GLOBAL.TECH.NONE -- make these things requre no learning
            end
        end
    end
    
    if TUNING.BLUEPRINTMODE then-- and WORLDS[GLOBAL.OVERRIDELEVEL].name~="Maxwells Door" then --blueprint recipes to buy
        local names = {}
        local recipes = GLOBAL.AllRecipes 
        for k,v in pairsOrdered(recipes, function(t,a,b) return tostring(GLOBAL.STRINGS.NAMES[string.upper(t[b].name)]) > tostring(GLOBAL.STRINGS.NAMES[string.upper(t[a].name)]) end) do -- add the blueprint recipes alphabetically sorted
            -- if v.level~=GLOBAL.TECH.NONE and v.level~=GLOBAL.TECH.LOST then -- for these things no blueprint exists ... but I could change TECH for things that have NONE at the moment, like firepit, pickaxe and so on.
            if v.level==GLOBAL.TECH.SCIENCE_ONE or v.level==GLOBAL.TECH.SCIENCE_TWO or v.level==GLOBAL.TECH.MAGIC_TWO or v.level==GLOBAL.TECH.MAGIC_THREE then -- only make blueprints for these techs, cause only those researchlabs are forbidden. All other techtree buildings are allowed (events, other mods, cartographer ...)
                table.insert(names,v.name) -- make it that way, cause you cant add recipes while iterating over recipes. and we also cant use a deepcopy of recipes, cause then v.level would never mathc any tech, since they are tables and therefore only match, if they are the same object, not when they have sma content...
            end            
        end
        for i,name in pairs(names) do
            recipe = AddRecipe(tostring(name).."_blueprint_shop",  {}, shoptab, nil, nil, nil, false, nil, nil, nil, "blueprint.tex");recipe.product = tostring(name).."_blueprint";
            GLOBAL.STRINGS.RECIPE_DESC[string.upper(tostring(name).."_blueprint_shop")] = tostring(GLOBAL.STRINGS.RECIPE_DESC[string.upper(name)])
            GLOBAL.STRINGS.NAMES[string.upper(tostring(name).."_blueprint_shop")] = tostring(GLOBAL.STRINGS.NAMES[string.upper(name)]).." Blueprint"
        end
    end
-- end


-- a new testfunction if something can be build
local function recipetestfn(recname,recipe,builder)
    if string.match(recname,"_blueprint_shop") then
        local isreleased = GLOBAL.TheWorld.components and GLOBAL.TheWorld.components.adv_rememberstuff and GLOBAL.TheWorld.components.adv_rememberstuff.stuff1 and GLOBAL.TheWorld.components.adv_rememberstuff.stuff1[recname] or false
        if not GLOBAL.TheNet:GetIsServer() and not GLOBAL.POPULATING and builder["mynetvar"..tostring(recname)] then
            isreleased = builder["mynetvar"..tostring(recname)]:value()
        end
        if GLOBAL.TUNING.BLUEPRINTMODE and WORLDS[GLOBAL.OVERRIDELEVEL].name~="Maxwells Door" and isreleased then
            return true
        else
            return false
        end
    elseif GLOBAL.TUNING.BLUEPRINTMODE and WORLDS[GLOBAL.OVERRIDELEVEL].name~="Maxwells Door" then -- remove researchlabs
        if recname=="researchlab" or recname=="researchlab2" or recname=="researchlab3" or recname=="researchlab4" then
            return false
        end
        return true
    else
        return true
    end
    return true
end

-- builder mod for client
AddClassPostConstruct("components/builder_replica",  function(self)
	local _CanLearn = self.CanLearn
	self.CanLearn = function(self, recname)
        local recipe = GLOBAL.GetValidRecipe(recname)
        if recipe~=nil and not recipetestfn(recname,recipe,self.inst) then 
            return false
        else
            return _CanLearn(self, recname) 
        end
	end
end)

local function AddScenario(inst,scen)
    if inst and inst.components and not inst.components.scenariorunner then
        inst:AddComponent("scenariorunner")
        inst.components.scenariorunner:SetScript(scen)
        inst.components.scenariorunner:Run()
    end
end



local function MakeFireProof(inst,howlong) -- this is not real fire proofness, just a "hack" another dev made. we set burning to true, so game things it burns, but it does not. So this is only for short protection of items!
    if inst and inst.components and inst.components.burnable and howlong then
        inst.components.burnable.burning = true
        inst:DoTaskInTime(howlong,function(inst)
            inst.components.burnable.burning = false -- use it e.g for the backpack in king of winter, so it won't burn while maxwell is talking to us
        end)
    end
end



local function SpawnMaxwell(world)
    world:DoTaskInTime(4,function(world)
        if GLOBAL.CHAPTER then
            if GLOBAL.CHAPTER>0 then
                local maxw = GLOBAL.SpawnPrefab("maxwellintro")
                local speechName = "NULL_SPEECH"
                speechName = "ADVENTURE_"..GLOBAL.CHAPTER
                maxw.components.maxwelltalker:SetSpeech(speechName)
                maxw.components.maxwelltalker:Initialize()
                maxw:DoTaskInTime(1,function()	maxw.components.maxwelltalker:DoTalk() end) 
            end
        else
            print("Adventure: SpawnMaxwell GLOBAL.CHAPTER is nil?!")
        end
    end)
end

local function TitleStufff(inst) -- inst is player
    
    local chapter = GLOBAL.CHAPTER or inst.mynetvarAdvChapter:value()
    local level = GLOBAL.OVERRIDELEVEL or inst.mynetvarAdvLevel:value()
    
    local title = "test"
    local subtitle = "test"
    if chapter and chapter > 0 then -- show title and chapter
        -- TheNet:Announce("Congratulation! You won the adventure!")
        title = WORLDS[level].name
        subtitle = GLOBAL.STRINGS.UI.SANDBOXMENU.CHAPTERS[chapter]
    elseif chapter and chapter == 0 then
        title = WORLDS[level].name
        subtitle = "Chapter 0 of 5"
        GLOBAL.TheCamera:SetDistance(12)
    end
    -- print("HIER TITLESTUFF funktion chapter: "..tostring(chapter).."title: "..tostring(title).." subtitle: "..tostring(subtitle))
    GLOBAL.TheFrontEnd:ShowTitle(title,subtitle)
    GLOBAL.TheFrontEnd:Fade(true, 1, function()
        GLOBAL.SetPause(false)

        GLOBAL.TheFrontEnd:HideTitle()
    end, 3 ,function() GLOBAL.SetPause(false) end)
    
    inst:DoTaskInTime(4,function(inst)
         if chapter and chapter==0 then
            GLOBAL.TheCamera:SetDefault()
        end
    end)
end


local function StartItems(inst)
    -- print("HIER startitems OVERRIDELEVEL: "..tostring(GLOBAL.OVERRIDELEVEL))
    inst.mynetvarTitleStufff:set(1) -- send info to clients, to show the game title at game start
    if GLOBAL.OVERRIDELEVEL then

        if GLOBAL.TheWorld.components.adv_rememberstuff and GLOBAL.TheWorld.components.adv_rememberstuff.stuff2 and GLOBAL.TheWorld.components.adv_rememberstuff.stuff2.firepit then GLOBAL.TheWorld.components.adv_rememberstuff.stuff2.firepit.components.fueled:DoDelta( GLOBAL.TUNING.MED_FUEL ) end
        
        if WORLDS[GLOBAL.OVERRIDELEVEL].name=="Maxwells Door" then
            inst:DoTaskInTime(4,function(inst)
                inst.components.talker:ShutUp()
                local strings = {"We have to find maxwells door!","Somewhere in this area we will find maxwells door","Lets find maxwells door"}
                inst.components.talker:Say(GLOBAL.GetRandomItem(strings))
            end)
            local chest = questfunctions.SpawnPrefabAtLandPlotNearInst("backpack",inst,15,0,15,1,3,3)
            chest:AddComponent("scenariorunner")
            chest.components.scenariorunner:SetScript("chest_random_good")
            chest.components.scenariorunner:Run()
            questfunctions.SpawnPrefabAtLandPlotNearInst("cutgrass",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("twigs",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("flint",inst,15,0,15,7,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("flint",inst,80,0,80,7,20,20)
            
            questfunctions.SpawnPrefabAtLandPlotNearInst("rock1",inst,150,0,150,7,15,15) -- some stone boulder, since its only swamp map
            questfunctions.SpawnPrefabAtLandPlotNearInst("rock2",inst,150,0,150,5,15,15) -- gold boulder
            
        elseif WORLDS[GLOBAL.OVERRIDELEVEL].name=="A Cold Reception" then
            questfunctions.SpawnPrefabAtLandPlotNearInst("axe",inst,15,0,15,1,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("grass_umbrella",inst,15,0,15,1,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("cutgrass",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("twigs",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("flint",inst,15,0,15,6,3,3)
        elseif WORLDS[GLOBAL.OVERRIDELEVEL].name=="King of Winter" then
            questfunctions.SpawnPrefabAtLandPlotNearInst("cutgrass",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("twigs",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("flint",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("log",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("axe",inst,15,0,15,1,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("skeleton",inst,15,0,15,1,3,3)
            local blueprint = questfunctions.SpawnPrefabAtLandPlotNearInst("earmuffshat_blueprint",inst,15,0,15,1,3,3)
            MakeFireProof(blueprint,20)
            local chest = questfunctions.SpawnPrefabAtLandPlotNearInst("backpack",inst,15,0,15,1,3,3)
            chest:AddComponent("scenariorunner")
            chest.components.scenariorunner:SetScript("packloot_winter_start_medium") 
            chest.components.scenariorunner:Run()
            MakeFireProof(chest,20)
        elseif WORLDS[GLOBAL.OVERRIDELEVEL].name=="The Game is Afoot" then
            questfunctions.SpawnPrefabAtLandPlotNearInst("cutgrass",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("twigs",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("flint",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("grass_umbrella",inst,15,0,15,1,3,3)
            local chest = questfunctions.SpawnPrefabAtLandPlotNearInst("backpack",inst,15,0,15,1,3,3)
            chest:AddComponent("scenariorunner")
            chest.components.scenariorunner:SetScript("chest_presummer") 
            chest.components.scenariorunner:Run()
        elseif WORLDS[GLOBAL.OVERRIDELEVEL].name=="Archipelago" then
            questfunctions.SpawnPrefabAtLandPlotNearInst("axe",inst,15,0,15,1,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("cutgrass",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("twigs",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("flint",inst,15,0,15,3,3,3)
        elseif WORLDS[GLOBAL.OVERRIDELEVEL].name=="Two Worlds" then
            questfunctions.SpawnPrefabAtLandPlotNearInst("cutgrass",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("twigs",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("flint",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("nitre",inst,15,0,15,3,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("grass_umbrella",inst,15,0,15,1,3,3)
        elseif WORLDS[GLOBAL.OVERRIDELEVEL].name=="Darkness" then
            local chest = questfunctions.SpawnPrefabAtLandPlotNearInst("backpack",inst,15,0,15,1,3,3)
            chest:AddComponent("scenariorunner")
            chest.components.scenariorunner:SetScript("packloot_nightmare") 
            chest.components.scenariorunner:Run()
            questfunctions.SpawnPrefabAtLandPlotNearInst("grass_umbrella",inst,15,0,15,1,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("torch",inst,15,0,15,1,3,3)
            questfunctions.SpawnPrefabAtLandPlotNearInst("skeleton",inst,15,0,15,1,3,3)
        end
    else
        print("Adventure: Missing Adventure Level in StartItems fn!! "..tostring(GLOBAL.OVERRIDELEVEL)) -- the world prefab postinit on the top must define OVERRIDELEVEL before this is called!
    end
end



local function OnDirtyEventTitleStufff(inst) -- this is called on client, if the server does inst.mynetvarTitleStufff:set(...)
    local val = inst.mynetvarTitleStufff:value()
    if val==1 then
        inst:DoTaskInTime(0.01,TitleStufff)
    elseif val==2 then
        GLOBAL.TheCamera:SetDistance(12)
    elseif val==3 then
        GLOBAL.TheCamera:SetDefault()
    end
	-- Use val and do client related stuff
end
local function RegisterListenersTitleStufff(inst)
	-- check that the entity is the playing player
	if inst.HUD ~= nil then
		inst:ListenForEvent("DirtyEventTitleStufff", OnDirtyEventTitleStufff)
	end
end
local function SetChapterStuffForPlayer(inst)
    inst.mynetvarAdvChapter:set(GLOBAL.CHAPTER)
    inst.mynetvarAdvLevel:set(GLOBAL.OVERRIDELEVEL)
end
local function OnPlayerSpawn(inst)
    -- defined in netvars.lua
	-- GUID of entity, unique name identifier (among entity netvars), dirty event name
	inst.mynetvarTitleStufff = GLOBAL.net_tinybyte(inst.GUID, "TitleStufffNetStuff", "DirtyEventTitleStufff") 
	-- set a default value
	inst.mynetvarTitleStufff:set(0)
	inst:DoTaskInTime(0, RegisterListenersTitleStufff)
    
    inst.mynetvarAdvChapter = GLOBAL.net_tinybyte(inst.GUID, "AdvChapterNetStuff", "DirtyEventAdvChapter") -- value from 0 to 7
    inst.mynetvarAdvChapter:set(0) -- set a default value
    -- inst:DoTaskInTime(0, RegisterListenersAdvChapter)
    inst.mynetvarAdvLevel = GLOBAL.net_tinybyte(inst.GUID, "AdvLevelNetStuff", "DirtyEventAdvLevel") -- value from 0 to 7
    inst.mynetvarAdvLevel:set(1) -- set a default value
    -- inst:DoTaskInTime(0, RegisterListenersAdvLevel)
    inst:DoTaskInTime(0.25,function(inst)
        if GLOBAL.TUNING.BLUEPRINTMODE and WORLDS[GLOBAL.OVERRIDELEVEL].name~="Maxwells Door" then
            for k,v in pairs(GLOBAL.AllRecipes) do 
                if string.match(v.name,"_blueprint_shop") then -- we need a boolean netvar for every blueprintshop recipe, cause client builder can't check the components...
                    inst["mynetvar"..tostring(v.name)] = GLOBAL.net_bool(inst.GUID, tostring(v.name).."NetStuff", "DirtyEvent"..tostring(v.name)) -- false or true
                    inst["mynetvar"..tostring(v.name)]:set(false) -- store in world does not work
                end
            end
        end
        if not GLOBAL.TheNet:GetIsServer() then 
            return
        end

        inst:ListenForEvent("invalidrpc", function(inst,data) print("Debug: InvalidRPC player "..tostring(data.player).." RPCName: "..tostring(data.rpcname)) end)
        if GLOBAL.TUNING.BLUEPRINTMODE and WORLDS[GLOBAL.OVERRIDELEVEL].name~="Maxwells Door" then
            inst:DoTaskInTime(1,function(inst)
                for k,v in pairs(GLOBAL.AllRecipes) do
                    if string.match(v.name,"_blueprint_shop") then -- we need a boolean netvar for every blueprintshop recipe, cause client builder can't check the components...
                        if inst["mynetvar"..tostring(v.name)] then
                            inst["mynetvar"..tostring(v.name)]:set(GLOBAL.TheWorld.components.adv_rememberstuff and GLOBAL.TheWorld.components.adv_rememberstuff.stuff1 and GLOBAL.TheWorld.components.adv_rememberstuff.stuff1[v.name] or false)
                        end
                    end
                end
            end)
        end
    end)
    inst:DoTaskInTime(0.2,SetChapterStuffForPlayer)
    inst:AddComponent("adv_startstuff")
    inst.components.adv_startstuff:GiveStartStuffIn(0.3,StartItems,"StartItems") -- should be done after the world did his adv_startstuff and maxwellspawn-- dealy of 0.3 is needed, cause otherwise the client netvar stuff does not work everytime...
end
AddPlayerPostInit(OnPlayerSpawn)
-- now when doing server stuff, use
-- inst.mynetvarTitleStufff:set(num), with inst being a player and num a number between 0 and 7
-- changes will propagate to clients


local function DoStartStuff(world)
    -- correct the globals if the world just generated
    GLOBAL.OVERRIDELEVEL = GLOBAL.OVERRIDELEVEL_GEN -- GEN is only correct just after the world generation using adventurejump. On every game load, it is wrong, that's why we set this once per world
    print("Adventure: OVERRIDELEVEL defined to _GEN "..tostring(GLOBAL.OVERRIDELEVEL_GEN))
    
    GLOBAL.CHAPTER = GLOBAL.CHAPTER_GEN
    print("Adventure: CHAPTER defined to GEN "..tostring(GLOBAL.CHAPTER))
    
    world:DoTaskInTime(1,function(world) world.components.adventurejump:MakeSave() end)
    
    if GLOBAL.TUNING.ADV_DIFFICULTY > 0 and GLOBAL.CHAPTER~=6 then
        local x,y,z = world.components.playerspawner.GetAnySpawnPoint()
        local spawnpointpos = GLOBAL.Vector3(x ,y ,z )
        local fire = questfunctions.SpawnPrefabAtLandPlotNearInst("firepit",spawnpointpos,7,0,7,1,3,3)
        world.components.adv_rememberstuff.stuff2.firepit=fire

        if WORLDS[GLOBAL.OVERRIDELEVEL].name=="Maxwells Door" then -- in lvl 0 add a pond to get some food
            questfunctions.SpawnPrefabAtLandPlotNearInst("pond",spawnpointpos,30,0,30,1,15,15)
            questfunctions.SpawnPrefabAtLandPlotNearInst("rock_ice",spawnpointpos,50,0,50,2,20,20)
            questfunctions.SpawnPrefabAtLandPlotNearInst("rabbithole",spawnpointpos,50,0,50,5,20,20)
            questfunctions.SpawnPrefabAtLandPlotNearInst("evergreen",spawnpointpos,100,0,100,15,10,10)
            questfunctions.SpawnPrefabAtLandPlotNearInst("sapling",spawnpointpos,100,0,100,20,10,10)
            questfunctions.SpawnPrefabAtLandPlotNearInst("grassgekko",spawnpointpos,100,0,100,20,5,5)
            questfunctions.SpawnPrefabAtLandPlotNearInst("grass",spawnpointpos,100,0,100,20,5,5)
            questfunctions.SpawnPrefabAtLandPlotNearInst("carrot_planted",spawnpointpos,100,0,100,10,10,10)
            questfunctions.SpawnPrefabAtLandPlotNearInst("berrybush",spawnpointpos,100,0,100,10,15,15)
            questfunctions.SpawnPrefabAtLandPlotNearInst("berrybush_juicy",spawnpointpos,100,0,100,10,15,15)
            questfunctions.SpawnPrefabAtLandPlotNearInst("flower",spawnpointpos,20,0,20,5,5,5)
        elseif WORLDS[GLOBAL.OVERRIDELEVEL].name=="Two Worlds" then -- in twoworlds some saplings would be good
            questfunctions.SpawnPrefabAtLandPlotNearInst("sapling",spawnpointpos,20,0,20,5,5,5)
        end
    end
    world:ListenForEvent("ms_playerspawn", function(world) world.components.adv_startstuff:GiveStartStuffIn(0.01,SpawnMaxwell,"SpawnMaxwell") end)
end



AddPrefabPostInit("world", function(world)
    -- world:DoTaskInTime(0.25,ChangeSomeTechLevels) -- has to be called AFTER SetChapterStuffForPlayer, to use the right GLOBAL.OVERRIDELEVEL also for clients
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
    if world.ismastersim and world.ismastershard then
        world:AddComponent("adv_rememberstuff") -- a component just to save and load information, like possible recipes for shop
        -- world.components.adv_rememberstuff.stuff1.cutgrass_shop_stuff = true -- allow recipes
        -- world.components.adv_rememberstuff.stuff1.twigs_shop_stuff = false

        
        world:AddComponent("worldjump") -- has to be added after adv_rememberstuff, cause it will save something there !
        world:AddComponent("adventurejump") -- better add this after worldjump, cause the jump itself uses worldjump
        -- world:DoTaskInTime(0.001,function(world) -- use DoTaskInTime cause otherwise component is not loaded completely .. -- do it in adventurejump instead?
            -- if world.components.adventurejump.adventure_info.level_list then 
                -- GLOBAL.OVERRIDELEVEL = world.components.adventurejump.adventure_info.level_list[world.components.adventurejump.adventure_info.current_level] or 1 -- this is to now the level when loading a world
                -- print("Adventure: OVERRIDELEVEL defined to "..tostring(GLOBAL.OVERRIDELEVEL)) -- is nil when world just generated, then we will set it to _GEN in StartStuff fn
                -- GLOBAL.CHAPTER = world.components.adventurejump.adventure_info.current_level or 0 -- the load from the component, if world is 0, it will be nil most likely
                -- print("Adventure: CHAPTER defined to "..tostring(GLOBAL.CHAPTER))
            -- else
                -- GLOBAL.OVERRIDELEVEL = 1 -- this is to now the level when loading a world
                -- print("Adventure: OVERRIDELEVEL defined to "..tostring(GLOBAL.OVERRIDELEVEL)) -- is nil when world just generated, then we will set it to _GEN in StartStuff fn
                -- GLOBAL.CHAPTER = 0 -- the load from the component, if world is 0, it will be nil most likely
                -- print("Adventure: CHAPTER defined to "..tostring(GLOBAL.CHAPTER))
            -- end 
        -- end) 
        world:AddComponent("adv_startstuff") 
        world:DoTaskInTime(0,function(world) world.components.adv_startstuff:GiveStartStuffIn(0.01,DoStartStuff,"DoStartStuff") end) -- also call after adding adv_rememberstuff!
        world:DoTaskInTime(0,function(world) world.components.adv_startstuff:GiveStartStuffIn(0.01,function(inst) -- sort the items in various tables, depending how important the tech is               
            -- set up blueprints in different category lists, which will be emptied when blueprints are found
            world.components.adv_rememberstuff.stuff3.veryimportantblueprints = {"heatrock","grass_umbrella","backpack","lightning_rod","spear","transistor","boomerang","treasurechest","rope","boards","cutstone",} -- without blueprint in name, it is added later
            world.components.adv_rememberstuff.stuff3.importantblueprints = {"fence_gate_item","fence_item","waxpaper","beeswax","mushroom_farm","slow_farmplot","fast_farmplot","firepit","hammer","shovel","pitchfork","razor","reviver","lifeinjector","bandage","tent","meatrack","cookpot","icebox",
            "gunpowder","footballhat","birdcage","blowdart_pipe","papyrus","nightmarefuel","purplegem","tophat","armorwood","featherpencil","cartographydesk",
            "trap_teeth","birdtrap","bugnet","fishingrod","healingsalve","pighouse",}
            world.components.adv_rememberstuff.stuff3.summerblueprints = {"coldfire","coldfirepit","siestahut","featherfan","firesuppressor","watermelonhat","icehat","reflectivevest",}
            world.components.adv_rememberstuff.stuff3.winterblueprints = {"winterhat","sweatervest",}
            world.components.adv_rememberstuff.stuff3.springblueprints = {"rainhat","raincoat","umbrealla",}
            world.components.adv_rememberstuff.stuff3.darknessblueprints = {"lantern","rabbithouse","minerhat",}
            world.components.adv_rememberstuff.stuff3.otherblueprints = {} -- if all other blueprints were already spawned, spawn these as reward. array is filled below                
            for k,v in pairs(GLOBAL.AllRecipes) do -- and all the other recipes...
                -- if v.level~=TECH.NONE and v.level~=TECH.LOST then
                if v.level==GLOBAL.TECH.SCIENCE_ONE or v.level==GLOBAL.TECH.SCIENCE_TWO or v.level==GLOBAL.TECH.MAGIC_TWO or v.level==GLOBAL.TECH.MAGIC_THREE then -- only make blueprints for these techs, cause only those researchlabs are forbidden. All other techtree buildings are allowed (events, other mods, cartographer ...)
                    if not (table.contains(GLOBAL.TUNING.PREFABSALWAYS,v.name) or table.contains(world.components.adv_rememberstuff.stuff3.veryimportantblueprints,v.name) or table.contains(world.components.adv_rememberstuff.stuff3.importantblueprints,v.name) or table.contains(world.components.adv_rememberstuff.stuff3.summerblueprints,v.name) or table.contains(world.components.adv_rememberstuff.stuff3.winterblueprints,v.name) or table.contains(world.components.adv_rememberstuff.stuff3.springblueprints,v.name) or table.contains(world.components.adv_rememberstuff.stuff3.darknessblueprints,v.name)) then -- if recipe is in none of this lists, then put it into others list
                        if not (v.nounlock or v.builder_tag ~= nil or v.name=="researchlab" or v.name=="researchlab2" or v.name=="researchlab3" or v.name=="researchlab4" or v.name=="earmuffshat" or v.name=="minerhat") then
                            table.insert(world.components.adv_rememberstuff.stuff3.otherblueprints,v.name) -- all other recipes, also modrecipes.
                        end
                    end
                end
            end
            
        end,"SetBlueprintadv_rememberstuff") end)
        
        world:DoTaskInTime(1, function(inst) -- connect the wormholes, do it after postinit of wormholes 0.05
            if WORLDS[GLOBAL.OVERRIDELEVEL].name=="Archipelago" then
                GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole1"].components.teleporter.targetTeleporter = GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole6"]
                GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole2"].components.teleporter.targetTeleporter = GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole7"]
                GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole3"].components.teleporter.targetTeleporter = GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole8"]
                GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole4"].components.teleporter.targetTeleporter = GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole9"]
                GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole5"].components.teleporter.targetTeleporter = GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole10"]
                GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole6"].components.teleporter.targetTeleporter = GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole1"]
                GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole7"].components.teleporter.targetTeleporter = GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole2"]
                GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole8"].components.teleporter.targetTeleporter = GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole3"]
                GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole9"].components.teleporter.targetTeleporter = GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole4"]
                GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole10"].components.teleporter.targetTeleporter = GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole5"]
            end
        end)
    end
end)


local function ConfirmAdventure(player, portal, answer)
	if type(portal) == "table" then
		if answer then
			if portal.StartAdventure then
				portal:StartAdventure()
			end
		else
			if portal.RejectAdventure then
				portal:RejectAdventure()
			end
		end
	end
end
AddModRPCHandler("adventure", "confirm", ConfirmAdventure)


if not GLOBAL.TheNet:GetIsServer() then 
	return
end

local function GetRoom(entity) -- written by ptr, thanks.
    local closestdist = math.huge
    local closestid = nil
    x,_,y=entity.Transform:GetWorldPosition()
    for i,v in pairs(GLOBAL.TheWorld.topology.nodes) do
        if #v.neighbours > 0 then
            local dx = math.floor((math.abs(v.x - x)+2)/4)
            local dy = math.floor((math.abs(v.y - y)+2)/4)
            local distsq = dx*dx + dy*dy
            if distsq < closestdist then
                closestdist = distsq
                closestid = i
            end
        end
    end
    return GLOBAL.TheWorld.topology.ids[closestid]
end

GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES = {} -- remember the wormholes and connect them in world post init
AddPrefabPostInit("wormhole",function(inst)
    if inst.components.teleporter then
        inst:DoTaskInTime(0.5,function(inst) -- do it after OVERRIDELEVEL is checked (0.001) and before ARCHIPELWORMHOLES are used 0.1
            if WORLDS[GLOBAL.OVERRIDELEVEL].name=="Archipelago" then
                taskandroom = GetRoom(inst) -- eg "IslandHop_Start:2:SpiderMarsh"
                if string.find(taskandroom,"IslandHop_Start") then
                    if not GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole1"] then
                        GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole1"] = inst
                    elseif not GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole2"] then
                        GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole2"] = inst
                    elseif not GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole3"] then
                        GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole3"] = inst
                    elseif not GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole4"] then
                        GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole4"] = inst
                    elseif not GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole5"] then
                        GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole5"] = inst
                    end
                elseif string.find(taskandroom,"IslandHop_Hounds") then
                    GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole6"] = inst
                elseif string.find(taskandroom,"IslandHop_Forest") then
                    GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole7"] = inst
                elseif string.find(taskandroom,"IslandHop_Savanna") then
                    GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole8"] = inst
                elseif string.find(taskandroom,"IslandHop_Rocky") then
                    GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole9"] = inst
                elseif string.find(taskandroom,"IslandHop_Merm") then
                    GLOBAL.TUNING.ADVENTUREMOD.ARCHIPELWORMHOLES["wormhole10"] = inst
                end
            end
        end)
    end
end)


-- mod the builder component to change recipes availibilty
AddComponentPostInit("builder", function(self)
	local _CanLearn = self.CanLearn
	self.CanLearn = function(self, recname)
        local recipe = GLOBAL.GetValidRecipe(recname)
        if recipe~=nil and not recipetestfn(recname,recipe,self.inst) then 
            return false
        else
            return _CanLearn(self, recname) 
        end
	end
end)




--######## TELEPORTATO 

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
AddPrefabPostInit("teleportato_box", MakeSlowPick)
AddPrefabPostInit("teleportato_crank", MakeSlowPick) 
AddPrefabPostInit("teleportato_ring", MakeSlowPick) 
AddPrefabPostInit("teleportato_potato", MakeSlowPick)  


local ClockworkEnemiesList = {"bishop","knight","rook","knight_nightmare","bishop_nightmare","rook_nightmare","bishop","knight","knight_nightmare","bishop_nightmare",}
local ClockworkEnemies = {bishop={0,3},knight={0,3},rook={0,2},knight_nightmare={0,3},bishop_nightmare={0,3},rook_nightmare={0,2},}
local ClockworkEnemiesWithoutRook = {bishop={0,4},knight={0,4},knight_nightmare={0,4},bishop_nightmare={0,4}}
local HoundEnemies = {houndmound={3,6},icehound={0,2},firehound={0,2},}
local SpiderEnemies = {spiderden={3,6},spider_dropper={0,2},spider_hider={0,2},spider_spitter={0,2},}
local PigEnemies = {pigtorch={3,6},}
local KillerBeeEnemies = {wasphive={3,6},}
local MermEnemies = {mermhouse={2,4},}
local Enemies = {ClockworkEnemies,HoundEnemies,SpiderEnemies,PigEnemies,KillerBeeEnemies,MermEnemies,HoundEnemies,SpiderEnemies}

local function SpawnEnemies(inst,partpositions)
    -- print("SpawnEnemies")
    if inst.baseposition then
        -- print("SpawnEnemies")
        if GetModConfigData("guards") > 0 then
            local multi = GetModConfigData("guards")
            local ChosenEnemies = nil
            for _,pos in pairs(partpositions) do
                ChosenEnemies = _G.GetRandomItem(Enemies) -- spawn the same kind of enemies at one location
                for prefab,numbers in pairs(ChosenEnemies) do 
                    for i=1, math.random(numbers[1],numbers[2])*multi do 
                        questfunctions.SpawnPrefabAtLandPlotNearInst(prefab,pos,10,0,10)
                    end
                end 
            end
            for prefab,numbers in pairs(ClockworkEnemiesWithoutRook) do  -- clockworkenemies at base from teleportato, yes there were you are at the moment. Without Rook since they are destroing the ancient station...
                for i=1, math.random(numbers[1],numbers[2])*multi-1 do -- but not too much, since we are there at the moment... and also at beginning of world there are already some clockworks 
                    questfunctions.SpawnPrefabAtLandPlotNearInst(prefab,inst.baseposition,10,0,10)
                end
            end
        end
    else
        inst:DoTaskInTime(5, SpawnEnemies)
    end
end

local function CheckHowManyPlayers(inst) -- inst is teleportato and this checks how many are near to it
    local x, y, z = inst.Transform:GetWorldPosition() 
    local nearplayers = GLOBAL.TheSim:FindEntities(x, y, z, 17, nil, nil, {"player"})
    local counter = 0
    for _,plyer in pairs(nearplayers) do
        counter = counter + 1
    end
    return counter
end

local function DeactivateTeleportato(inst)
    inst.AnimState:PlayAnimation("power_on", false)
    inst.AnimState:PushAnimation("idle_on", true)
    -- inst.activatedonce = false
    inst.components.activatable.inactive = true
    inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_powerup", "teleportato_on")
    inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_idle_LP", "teleportato_idle")
end

local function DoTheWorldJump(inst,doer) -- inst has to be the teleportate_base
    local counter = CheckHowManyPlayers(inst)
    local NeededPlayers = GetModConfigData("min_players")=="half" and GLOBAL.TheNet:GetPlayerCount()/2 or GetModConfigData("min_players")=="all" and GLOBAL.TheNet:GetPlayerCount() or GetModConfigData("min_players")
    if (GetModConfigData("min_players")=="half" and counter > NeededPlayers) or counter >= NeededPlayers then
        GLOBAL.TheNet:Announce("Worldjump!")
        inst:DoTaskInTime(4, function() inst.AnimState:PlayAnimation("laugh", false) ; inst.AnimState:PushAnimation("active_idle", true) ; inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_maxwelllaugh", "teleportato_laugh") end)
        GLOBAL.TheWorld:DoTaskInTime(6.46, function(world) GLOBAL.TheFrontEnd:Fade(false,1) end)
        GLOBAL.TheWorld:DoTaskInTime(2.11, function(world) for k,v in pairs(GLOBAL.AllPlayers) do v.sg:GoToState("teleportato_teleport") end end)
        GLOBAL.TheWorld:DoTaskInTime(8, function(world)
            if world.ismastersim and world.ismastershard then
                world.components.adventurejump:DoJump() -- transfer days, recipes and inventory
            end
        end)
    else
        if GetModConfigData("min_players")=="half" then
            GLOBAL.TheNet:Announce("Worldjump aborted, cause not enough players are near teleportato.\nMore than half needed"..tostring(counter).."/"..tostring(NeededPlayers))
        else
            GLOBAL.TheNet:Announce("Worldjump aborted, cause not enough players are near teleportato.\n"..tostring(counter).."/"..tostring(NeededPlayers))
        end
        inst:DoTaskInTime(7, DeactivateTeleportato)
    end
end

local function Init(inst) -- init teleportato base
    if not inst.initialized then 
        
        inst.baseposition = inst:GetPosition()
        local partpositions = {}
        for k,v in pairs(_G.Ents) do
            if v:HasTag("teleportato_part") then
                table.insert(partpositions,v:GetPosition())
            end
        end
        
        if GetModConfigData("guards")~=0 and GetModConfigData("difficulty")~=0 then
            inst:DoTaskInTime(5, SpawnEnemies, partpositions) -- some enemies at start of the game at the part positions
        end
        inst.initialized = true
        print("Teleportato: Initialized") -- only once
    end
end

local function TeleportatoPostInit(inst)
    
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
    
    local _OnSave = inst.OnSave
    local function OnSave(inst,data)
        _OnSave(inst,data) -- call the previous
        -- data.activatedonce = inst.activatedonce
        data.baseposition = inst.baseposition
        data.initialized = inst.initialized
        data.completed = inst.completed
    end
    inst.OnSave = OnSave
    
    local _OnLoad = inst.OnLoad
    local function OnLoad(inst,data)
        _OnLoad(inst,data) -- call the previous
        if data then
            -- if data.activatedonce then
                -- inst.activatedonce = data.activatedonce
            -- end
            if data.baseposition then
                inst.baseposition = data.baseposition
            end
            if data.initialized then
                inst.initialized = data.initialized
                OneBaseInitialized = data.initialized
            end
            if data.completed then
                inst.completed = data.completed
            end
        end
    end
    inst.OnLoad = OnLoad
    
    local _OnActivate = inst.components.activatable.OnActivate
    local function OnActivate(inst,doer,donothing) -- doer can be nil

        _OnActivate(inst,doer) -- call the previous OnAcvtivate to make animations and set the activatedonce to true
        
        local counter = CheckHowManyPlayers(inst)
        local NeededPlayers = GetModConfigData("min_players")=="half" and GLOBAL.TheNet:GetPlayerCount()/2 or GetModConfigData("min_players")=="all" and GLOBAL.TheNet:GetPlayerCount() or GetModConfigData("min_players")
            if (GetModConfigData("min_players")=="half" and counter > NeededPlayers) or counter >= NeededPlayers then
            GLOBAL.TheNet:Announce("Leave teleportato area, if you dont want the next world within 10 seconds!")
            inst:DoTaskInTime(10,DoTheWorldJump,doer)
            inst:DoTaskInTime(5,function() GLOBAL.TheNet:Announce("5 seconds left!") end)
            inst:DoTaskInTime(6,function() GLOBAL.TheNet:Announce("4 seconds left!") end)
            inst:DoTaskInTime(7,function() GLOBAL.TheNet:Announce("3 seconds left!") end)
            inst:DoTaskInTime(8,function() GLOBAL.TheNet:Announce("2 seconds left!") end)
            inst:DoTaskInTime(9,function() GLOBAL.TheNet:Announce("1 seconds left!") end)
        else
            inst:DoTaskInTime(2, function() inst.AnimState:PlayAnimation("laugh", false) ; inst.AnimState:PushAnimation("active_idle", true) ; inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_maxwelllaugh", "teleportato_laugh") end)
            if GetModConfigData("min_players")=="half" then
                GLOBAL.TheNet:Announce("More than "..tostring(NeededPlayers).." players must be near teleportato!\nCounted only: "..tostring(counter))
            else
                GLOBAL.TheNet:Announce("At least "..tostring(NeededPlayers).." players must be near teleportato!\nCounted only: "..tostring(counter))
            end
            inst:DoTaskInTime(7, DeactivateTeleportato)
        end
        return

    end
    inst.components.activatable.OnActivate = OnActivate
    
    local stringss = {
        "Woooooo!",
        "Yeah!",
        "We did it!",
        "I feel ALIVE!",
        "HaHAHA!",
        "YEEEESS!",
        "This is what I live for!",
        "Woo-hoohoo!",
        "RAAAA!",
        "This is AWESOME!",
        "Too easy!",}
        
    local _ItemGet = inst.components.trader.onaccept
    local function ItemGet(inst, giver, item) 
        _ItemGet(inst, giver, item)
        if inst.collectedParts.teleportato_ring and inst.collectedParts.teleportato_crank and inst.collectedParts.teleportato_box and inst.collectedParts.teleportato_potato then
            if not inst.completed then -- if it was completed the first time... and a check if it was already activated to don't break savegames were it is already active
                if giver and giver.components and giver.components.talker then
                    giver.components.talker:ShutUp()
                    giver.components.talker:Say(_G.GetRandomItem(stringss)) 
                end
                GLOBAL.TheNet:Announce("Teleportato Completed!")
            end
            inst.completed = true
        end
    end
    inst.components.trader.onaccept = ItemGet
    
    inst:DoTaskInTime(1, Init)
end
AddPrefabPostInit("teleportato_base", TeleportatoPostInit) 


--######## 



-- chance to find blueprints when slow picking/working something e.g grass
local function OnPicked(inst)
    if GLOBAL.TUNING.BLUEPRINTMODE and WORLDS[GLOBAL.OVERRIDELEVEL].name~="Maxwells Door" then -- we have to define what blueprint, which is not easy possible with lootdropper, so we assign them only to slow pickable things
        local blueprint = nil
        local dospawn = false
        if math.random() < GetModConfigData("findblueprints") then -- 0.2 for high chance and 0.005 for low chance. default 0.02
            dospawn = true
        end
        if dospawn then
            questfunctions.SpawnPuff(inst)
            blueprint = questfunctions.GetNewBlueprints(1)[1] -- a list with one entry, calling this function will remove blueprints from list, so only call this, if all of them will be spawned!
            if blueprint then
                questfunctions.SpawnDrop(inst,blueprint)
            end
        end
    end
end

local function OnWorked(inst,worker,workleft) -- is called for every hit... so it has to be very small chance... we cant use the finish event, cause it is rarely called, cause inst is removed before -.-
    if GLOBAL.TUNING.BLUEPRINTMODE and WORLDS[GLOBAL.OVERRIDELEVEL].name~="Maxwells Door" then -- we have to define what blueprint, which is not easy possible with lootdropper, so we assign them only to slow pickable things
        local blueprint = nil
        local dospawn = false
        if math.random() < GetModConfigData("findblueprints")/5 then
            dospawn = true
        end
        if dospawn and inst and inst:IsValid() then
            questfunctions.SpawnPuff(inst)
            blueprint = questfunctions.GetNewBlueprints(1)[1] -- a list with one entry, calling this function will remove blueprints from list, so only call this, if all of them will be spawned!
            if blueprint then
                questfunctions.SpawnDrop(inst,blueprint)
            end
        end
    end
end

AddPrefabPostInitAny(function(inst)
    if not GLOBAL.TheNet:GetIsServer() then 
        return
    end
    if not GLOBAL.TheWorld.ismastershard then return end -- only add blueprint stuff for forest world
    if inst and inst.components and inst.components.pickable and inst.components.pickable.quickpick==false then -- only things that take longer to pick up. this also means nothing for guys who use any quickpick mod for grass and such stuff
        inst:ListenForEvent("picked",OnPicked)
    end
    if inst and inst.components and inst.components.workable then
        inst:ListenForEvent("worked",OnWorked)
    end
end)


AddPrefabPostInit("blueprint",function(inst)
    if not GLOBAL.TheNet:GetIsServer() then -- ?
        return
    end
    if GLOBAL.TUNING.BLUEPRINTMODE then
        inst:DoTaskInTime(0,function(inst)
            GLOBAL.AddHauntableCustomReaction(inst, function(inst,haunter) end, true, false, true) -- remove the "change blueprint" haunt effect for this mode
        end)
    end
end)

