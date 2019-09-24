require "prefabutil"
require "tuning"

local assets =
{
	Asset("ANIM", "anim/farmplot.zip"),
	Asset("MINIMAP_IMAGE", "farm1"),
	Asset("MINIMAP_IMAGE", "farm2"),
	Asset("MINIMAP_IMAGE", "farm3"),
}

local prefabs = 
{
	"plant_normal",
	"farmrock",
	"farmrocktall",
	"farmrockflat",
	"stick",
	"stickleft",
	"stickright",
	"burntstick",
	"burntstickleft",
	"burntstickright",
	"signleft",
	"signright",
	"fencepost",
	"fencepostright",
	"burntfencepost",
	"burntfencepostright",
	"collapse_small",
}


local back = -1
local front = 0
local left = 1.5
local right = -1.5


        
local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	if inst.components.grower then inst.components.grower:Reset() end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
end

local function onhit(inst, worker)
	--inst.AnimState:PlayAnimation("hit")
	--inst.AnimState:PushAnimation("idle")
end



local function setfertilityfn(inst, fert_percent)
	if not inst:HasTag("burnt") then
		local anim = "full"
		if fert_percent <= 0 then
			anim = "empty"
		elseif fert_percent <= .33 then
			anim = "med2"
		elseif fert_percent <= .66 then
			anim = "med1"
		end
		
		inst.AnimState:PlayAnimation(anim)
	end	
end

local rates = 
{
	TUNING.FARM1_GROW_BONUS,
	TUNING.FARM2_GROW_BONUS,
	TUNING.FARM3_GROW_BONUS,
}

local croppoints = {
	{ Vector3(0,0,0) },
	{ Vector3(0,0,0) },
	{ Vector3(0,0,0) },
}

local rock_front = 1

local decor_defs =
{
	[1] = { { signright = { { -1.1, 0, 0.5 } } } },

	[2] = {	{ stick = {
						{ left - 0.9, 0, back },
						{ right, 0, front },
					  }
			},
			{ stickleft = {
						{ 0.0, 0, back },
						{ left, 0, front },
					  }
			},
			{ stickright = {
						{ right + 0.9, 0, back },
						{ left - 0.3, 0, back + 0.5 },
						{ right + 0.3, 0, back + 0.5 },
					  }
			},
			{ signleft = { { -1.0, 0, 0.5 } } }
		  },

	[3] = {	{ signleft = { { -1.0, 0, 0.5 } } },

			-- left side
			{ farmrock = {
					{ right + 3.0, 0, rock_front + 0.2 },
					{ right + 3.05, 0, rock_front - 1.5 },
				}
			},

			{ farmrocktall = { { right + 3.07, 0, rock_front - 1.0 }, }	},
			{ farmrockflat = { { right + 3.06, 0, rock_front - 0.4 }, }	},

			-- right side
			{ farmrock = { { left - 3.05, 0, rock_front - 1.0 }, } },
			{ farmrocktall = { { left - 3.07, 0, rock_front - 1.5 }, } },
			{ farmrockflat = { { left - 3.06, 0, rock_front - 0.4 }, } },

			-- front row
			{ farmrock = {
					{ right + 1.1, 0, rock_front + 0.21 },
					{ right + 2.4, 0, rock_front + 0.25 },
				}
			},

			{ farmrocktall = { { right + 0.5, 0, rock_front + 0.195 }, } },
			
			{ farmrockflat = {
					{ right + 0.0, 0, rock_front - 0.0 },
					{ right + 1.8, 0, rock_front + 0.22 },
				}
			},

			-- back row
			{ farmrockflat = {
					
					{ left - 1.3, 0, back - 0.19 },
				}
			},

			{ farmrock = {
					{ left - 0.5, 0, back - 0.21 },
					{ left - 2.5, 0, back - 0.22 },
				}
			},

			{ farmrocktall = {
					{ left + 0.0, 0, back - 0.15 },
					{ left - 3.0, 0, back - 0.20 },
					{ left - 1.9, 0, back - 0.205 },
				}
			},

			{ fencepost = {
					{ left - 1.0,  0, back + 0.15 },
					{ right + 0.8, 0, back + 0.15 },
					{ right + 0.3, 0, back + 0.15 },
				},
			},

			{ fencepostright = {
					{ left - 0.5,  0, back + 0.15 },
					{ 0,		   0, back + 0.15 },
				},
			},
	  }
}

local burntdecor_defs =
{
	[2] = {	
			{ burntstick = {
						{ left - 0.9, 0, back },
						{ right, 0, front },
					  }
			},
			{ burntstickleft = {
						{ 0.0, 0, back },
						{ left, 0, front },
					  }
			},
			{ burntstickright = {
						{ right + 0.9, 0, back },
						--{ left - 0.3, 0, back + 0.5 },
						--{ right + 0.3, 0, back + 0.5 },
					  }
			},
		  },

	[3] = {	-- back row
			{ burntfencepost = {
					--{ left - 1.0,  0, back + 0.15 },
					{ right + 0.8, 0, back + 0.15 },
					--{ right + 0.3, 0, back + 0.15 },
				},
			},

			{ burntfencepostright = {
					{ left - 0.5,  0, back + 0.15 },
					{ 0,		   0, back + 0.15 },
				},
			},
	  }
}

local function makeburnt(inst)
	local burntdecor = {}
	for k, item_info in pairs( burntdecor_defs[ inst.level ] ) do
		for item_name, item_offsets in pairs( item_info ) do
			for l, offset in pairs( item_offsets ) do
				local item_inst = SpawnPrefab( item_name )
				item_inst.entity:SetParent( inst.entity )
				item_inst.Transform:SetPosition( offset[1], offset[2], offset[3] )
				table.insert( burntdecor, item_inst )
			end
		end
	end
	for k, v in pairs(inst.decor) do
		v:Remove()
	end
	inst.decor = burntdecor
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
	if data and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
    inst:DoTaskInTime(0,function() setfertilityfn(inst, inst.components.grower and inst.components.grower:GetFertilePercent() or 0) end)
end

local function onbuilt(inst, sound)
	inst.SoundEmitter:PlaySound(sound)
end

local function plot(level)
	
    return function(Sim)
        local inst = CreateEntity()
        local trans = inst.entity:AddTransform()
        local anim = inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        
        inst:AddTag("structure")
        inst.level = level
        
        anim:SetBank("farmplot")
        anim:SetBuild("farmplot")
        anim:PlayAnimation( "full" )
		anim:SetOrientation( ANIM_ORIENTATION.OnGround )
		anim:SetLayer( LAYER_BACKGROUND )
		anim:SetSortOrder( 3 )

	    local minimap = inst.entity:AddMiniMapEntity()
	    minimap:SetIcon( "farm"..level..".png" )

        inst:AddComponent("inspectable")
        inst.components.inspectable.nameoverride = "FARMPLOT"
        inst.components.inspectable.getstatus = function(inst)
        	if inst:HasTag("burnt") then
        		return "BURNT"
        	elseif not inst.components.grower:IsFertile() then
				return "NEEDSFERTILIZER"
            elseif not inst.components.grower:IsEmpty() then
                return "GROWING"
            end
        end

        MakeLargeBurnable(inst, nil, nil, true)
        MakeLargePropagator(inst)
        inst.OnSave = onsave 
        inst.OnLoad = onload
        inst:ListenForEvent("burntup", makeburnt)
        
        inst:AddComponent("grower")
        inst.components.grower.level = level
        inst.components.grower.onplantfn = function() inst.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds") end
        inst.components.grower.croppoints = croppoints[level]
        inst.components.grower.growrate = rates[level]
        
        local cycles_per_level = {10,20,30}
        
        inst.components.grower.max_cycles_left = cycles_per_level[level] or 6
        inst.components.grower.cycles_left = inst.components.grower.max_cycles_left
		inst.components.grower.setfertility = setfertilityfn
		inst.decor = {}

		trans:SetRotation( 45 )


		inst:AddComponent("lootdropper")
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(4)
		inst.components.workable:SetOnFinishCallback(onhammered)
		inst.components.workable:SetOnWorkCallback(onhit)

		local sound_name = "dontstarve/common/craftable/farm_basic"
		if level > 2 then
			sound_name = "dontstarve/common/craftable/farm_improved"
		end
		inst:ListenForEvent("onbuilt", function () onbuilt(inst, sound_name) end)


		local decor_items = decor_defs[ level ]

		for k, item_info in pairs( decor_items ) do
			for item_name, item_offsets in pairs( item_info ) do
				for l, offset in pairs( item_offsets ) do
					local item_inst = SpawnPrefab( item_name )
					item_inst.entity:SetParent( inst.entity )
					item_inst.Transform:SetPosition( offset[1], offset[2], offset[3] )
					table.insert( inst.decor, item_inst )
				end
			end
		end
        
        return inst
    end
end    

return --Prefab( "common/objects/farmplot",  plot(1), assets, prefabs ),
       Prefab( "common/objects/slow_farmplot", plot(2), assets, prefabs ),
       Prefab( "common/objects/fast_farmplot", plot(3), assets, prefabs ),
	   MakePlacer( "common/slow_farmplot_placer", "farmplot", "farmplot", "full" ),
	   MakePlacer( "common/fast_farmplot_placer", "farmplot", "farmplot", "full" ) 