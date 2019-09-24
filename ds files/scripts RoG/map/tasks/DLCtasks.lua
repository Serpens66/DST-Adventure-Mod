AddTask("Badlands", {
		locks={LOCKS.ADVANCED_COMBAT,LOCKS.MONSTERS_DEFEATED,LOCKS.TIER4},
		keys_given={KEYS.HOUNDS,KEYS.TIER5, KEYS.ROCKS},
		room_choices={
			["Lightning"] = 1,
			["Badlands"] = 3,
			["HoundyBadlands"] = 2,
			["BarePlain"] = 1,
			["BuzzardyBadlands"] = 2,
		},
		room_bg=GROUND.DIRT,
		background_room="BGBadlands",
		colour={r=1,g=0.6,b=1,a=1},
	})


AddTask("Oasis", {
		locks={LOCKS.ADVANCED_COMBAT,LOCKS.TIER4, LOCKS.MONSTERS_DEFEATED},
		keys_given={KEYS.ROCKS, KEYS.TIER5},
		room_choices={
			["Badlands"] = 3,
			["PondyGrass"] = 1,
			["BuzzardyBadlands"] = 2,
		},  
		room_bg=GROUND.DIRT,
		background_room="BGBadlands",
		colour={r=.05,g=.5,b=.05,a=1},
	})