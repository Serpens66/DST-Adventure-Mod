AddRoom("BGBadlands", {
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.DIRT_NOISE, 
					contents =  {
									distributepercent = 0.07,
									distributeprefabs =
									{
										marsh_bush = 0.05,
										marsh_tree = 0.2,
										rock_flintless = 1,
										--rock_ice = .5,
										grass = 0.1,
										houndbone = 0.2,
										cactus = 0.2,
										tumbleweedspawner = .05,
									},
					            }
					})

AddRoom("Lightning", {
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.DIRT_NOISE, 
					contents =  {
									distributepercent = 0.05,
									distributeprefabs =
									{
										marsh_bush = .8,
										grass = .5,
										--rock_ice = .5,
										lightninggoat = 1,
										cactus = .8,
										tumbleweedspawner = .1,
									},
								}
					})

AddRoom("Badlands", {
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.DIRT_NOISE, 
					contents =  {
									distributepercent = 0.07,
									distributeprefabs =
									{
										rock_flintless = .8,
										--rock_ice = .5,
										marsh_bush = 0.25,
										marsh_tree = 0.75,
										grass = .5,
										cactus = .7,
										houndbone = .6,
										tumbleweedspawner = .1,
									},
					            }
					})

AddRoom("HoundyBadlands", {
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.DIRT_NOISE, 
					contents =  {
									distributepercent = 0.2,
									distributeprefabs =
									{
										rock1 = .5,
										rock2 = 1,
										--rock_ice = .1,
										houndbone = .5,
										houndmound = .33,
									},
					            }
					})

AddRoom("BuzzardyBadlands", {
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.DIRT_NOISE, 
					contents =  {
									distributepercent = 0.1,
									distributeprefabs =
									{
										marsh_bush = .66,
										marsh_tree = 1,
										grass = .33,
										buzzardspawner = .25,
										houndbone = .15,
										tumbleweedspawner = .1,										
									},
					            }
					})

AddRoom("BGDeciduous", {
					colour={r=.1,g=.8,b=.1,a=.50},
					value = GROUND.DECIDUOUS,
					tags = {"ExitPiece", "Chester_Eyebone"},
					contents =  {
					                distributepercent = .2,
					                distributeprefabs=
					                {
										deciduoustree=6,
										
										pighouse=.1,
										catcoonden=.1,
										
										rock1=0.05,
										rock2=0.05,
										
										sapling=1,
										grass=0.03,
																				
										flower=0.75,
					                    
					                    red_mushroom = 0.3,
					                    blue_mushroom = 0.3,
					                    green_mushroom = 0.3,			                    
										berrybush=0.1,
										carrot_planted = 0.1,
										
										fireflies = 1,

										pond=.01,
					                },
					            }
					})

AddRoom("DeepDeciduous", {
					colour={r=0,g=.9,b=0,a=.50},
					value = GROUND.DECIDUOUS,
					tags = {"ExitPiece", "Chester_Eyebone"},
					contents =  {
					                distributepercent = .4,
					                distributeprefabs=
					                {
					                    grass = .03,
					                    sapling=1,
					                    berrybush=.1,
					                    
					                    deciduoustree = 10,
					                    catcoonden = .05,
					                    
					                    red_mushroom = 0.15,
					                    blue_mushroom = 0.15,
					                    green_mushroom = 0.15,
                                        
                                        fireflies = 3,

					                },
					            }					
					})

AddRoom("MagicalDeciduous", {
					colour={r=0,g=.9,b=0,a=.50},
					value = GROUND.DECIDUOUS,
					tags = {"ExitPiece", "Chester_Eyebone"},
					contents =  {

									countstaticlayouts={
										["DeciduousPond"] = 1,
									},

					                distributepercent = .3,
					                distributeprefabs=
					                {
					                    grass = .03,
					                    sapling=1,
					                    berrybush=1,					                    
            
					                    red_mushroom = 2,
					                    blue_mushroom = 2,
					                    green_mushroom = 2,
                                        
                                        fireflies = 4,
										flower=5,

										molehill = 2, 
										catcoonden = .25,

										berrybush = 3,
					                },
					            }					
					})

AddRoom("DeciduousMole", {
					colour={r=0,g=.9,b=0,a=.50},
					value = GROUND.DECIDUOUS,
					tags = {"ExitPiece", "Chester_Eyebone"},
					contents =  {
					                distributepercent = .3,
					                distributeprefabs=
					                {
                                        fireflies = 0.2,
					                    rock1 = 0.05,
					                    grass = .05,
					                    sapling=.8,
					                    rocks=.05,
					                    flint=.05,
					                    molehill=.5,
					                    catcoonden=.05,
					                    berrybush=.03,
					                    deciduoustree = 6,
					                    red_mushroom = 0.3,
					                    blue_mushroom = 0.3,
					                    green_mushroom = 0.3,
					                },
					            }
					})

AddRoom("MolesvilleDeciduous", {
					colour={r=0,g=.9,b=0,a=.50},
					value = GROUND.DECIDUOUS,
					tags = {"ExitPiece", "Chester_Eyebone"},
					contents =  {
					                distributepercent = .3,
					                distributeprefabs=
					                {
                                        fireflies = 0.1,
					                    molehill=.7,
					                    grass = .05,
					                    sapling=.5,
					                    rocks=.03,
					                    flint=.03,
					                    berrybush=.02,
					                    deciduoustree = 6,
					                    red_mushroom = 0.3,
					                    blue_mushroom = 0.3,
					                    green_mushroom = 0.3,
					                },
					            }
					
					})

AddRoom("DeciduousClearing", {
					colour={r=0,g=.9,b=0,a=.50},
					value = GROUND.DECIDUOUS,
					tags = {"ExitPiece", "Chester_Eyebone"},
					contents =  {
									countstaticlayouts={["MushroomRingLarge"]=function()  
																				if math.random(0,1000) > 985 then 
																					return 1 
																				end
																				return 0 
																			   end},
					                distributepercent = .2,
					                distributeprefabs=
					                {

					                	deciduoustree = 1,

                                        fireflies = 1,
															                    
					                    grass = .5,
					                    sapling = .5,					                    
					                    berrybush = .5,
                    
					                    red_mushroom = .5,
					                    blue_mushroom = .5,
					                    green_mushroom = .5,
					                },
					            }
					})


AddRoom("PondyGrass", {
					colour={r=0,g=.9,b=0,a=.50},
					value = GROUND.GRASS,
					tags = {"ExitPiece", "Chester_Eyebone"},
					contents =  {
					                distributepercent = .2,
					                distributeprefabs=
					                {
                                        fireflies = 0.1,
					                    grass = .05,
					                    sapling=.2,
					                    berrybush=.02,
					                    pond = 0.15,
					                    deciduoustree = 1,
					                    catcoonden = .05,

					                },
					            }
					
					})

--[[
	-----Badlands-----
	Background Badlands
	Lightning
	Badlands
	Hound
	Bone
	Graveyard?
	Buzzardy

		--Lightning Goat
		--Cactus
		--Buzzard
		--Spiked Bush
		--Tumble Weeds

	-----Deciduous-----
	Background Decid Forest
	Decid Forest
	Dense Decid Forest

		--Catcoons
		--Decid Trees
		--Twigs
		--Grass
		--Rabbits/ Moles
--]]