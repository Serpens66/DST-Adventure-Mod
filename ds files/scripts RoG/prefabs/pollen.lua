local texture = "fx/snow.tex"
local shader = "shaders/particle.ksh"
local colour_envelope_name = "pollencolourenvelope"
local scale_envelope_name = "pollenscaleenvelope"

local assets =
{
	Asset( "IMAGE", texture ),
	Asset( "SHADER", shader ),
}

local function IntColour( r, g, b, a )
	return { r / 255.0, g / 255.0, b / 255.0, a / 255.0 }
end

local init = false
local function InitEnvelope()
	if EnvelopeManager and not init then
		init = true
		EnvelopeManager:AddColourEnvelope(
			colour_envelope_name,
			{	{ 0,	IntColour( 255, 255, 0, 0 ) },
				{ 0.5,	IntColour( 255, 255, 0, 127 ) },				
				{ 1,	IntColour( 255, 255, 0, 0 ) },
			} )

        local min_scale = 0.8
		local max_scale = 1.0
		EnvelopeManager:AddVector2Envelope(
			scale_envelope_name,
			{
				{ 0,	{ min_scale, min_scale } },
				{ 0.5,	{ max_scale, max_scale } },
				{ 1,	{ min_scale, min_scale } },
			} )
	end
end

local max_lifetime = 60
local min_lifetime = 30

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local emitter = inst.entity:AddParticleEmitter()
	inst:AddTag("FX")

	InitEnvelope()

	emitter:SetRenderResources( texture, shader )
	emitter:SetMaxNumParticles( 1000 )
	emitter:SetMaxLifetime( max_lifetime )
	emitter:SetColourEnvelope( colour_envelope_name )
	emitter:SetScaleEnvelope( scale_envelope_name );
	emitter:SetBlendMode( BLENDMODE.Premultiplied )
	emitter:SetSortOrder( 3 )
	emitter:SetLayer( LAYER_BACKGROUND )
	emitter:SetAcceleration( 0, 0.0001, 0 )
	emitter:SetDragCoefficient( 0.0001 )
	emitter:EnableDepthTest( false )

	-----------------------------------------------------
	local rng = math.random
	local tick_time = TheSim:GetTickTime()

	local desired_particles_per_second = 0--300
	inst.particles_per_tick = desired_particles_per_second * tick_time

	local emitter = inst.ParticleEmitter

	inst.num_particles_to_emit = inst.particles_per_tick

	local bx, by, bz = 0, 0.3, 0
	local emitter_shape = CreateBoxEmitter( bx, by, bz, bx + 40, by, bz + 40 )

	local emit_fn = function()
		if GetWorld().Map ~= nil then
			local x, y, z = GetPlayer().Transform:GetWorldPosition()
	        local px, py, pz = emitter_shape()		
			x = x + px
			z = z + pz

            -- don't spawn particles over water
			if GetWorld().Map:GetTileAtPoint( x, y, z ) ~= GROUND.IMPASSABLE then
				
	            local vx = 0.03 * (math.random() - 0.5)
	            local vy = 0
	            local vz = 0.03 * (math.random() - 0.5)        		
	            local lifetime = min_lifetime + ( max_lifetime - min_lifetime ) * UnitRand()

	            emitter:AddParticle(
		            lifetime,			-- lifetime
		            px, py, pz,			-- position
		            vx, vy, vz			-- velocity
	            )
			end
		end		
	end

	local updateFunc = function()
		while inst.num_particles_to_emit > 1 do
			emit_fn( emitter )
			inst.num_particles_to_emit = inst.num_particles_to_emit - 1
		end

		inst.num_particles_to_emit = inst.num_particles_to_emit + inst.particles_per_tick
		
		-- vary the acceleration with time in a circular pattern
		-- together with the random initial velocities this should give a variety of motion		
		inst.time = inst.time + tick_time		
		inst.interval = inst.interval + 1
		if 10 < inst.interval then
		    inst.interval = 0
		    local sin_val = 0.006 * math.sin(inst.time/3)
		    local cos_val = 0.006 * math.cos(inst.time/3)
		    emitter:SetAcceleration( sin_val, 0.05 * sin_val, cos_val )
		end
		
	end
	
	inst.time = 0.0
	inst.interval = 0

	EmitterManager:AddEmitter( inst, nil, updateFunc )

    return inst
end

return Prefab( "common/fx/pollen", fn, assets) 
 
