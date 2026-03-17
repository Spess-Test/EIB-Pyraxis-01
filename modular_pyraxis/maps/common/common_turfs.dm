/turf/simulated/mineral/turfpack/pyraxis/make_ore(rare_ore)
	if(mineral || ignore_mapgen)
		return

	var/rare_allow_chance = 5
	if(z in using_map.rare_ore_levels)
		rare_allow_chance = 100

	var/mineral_name
	if(rare_ore && prob(rare_allow_chance))
		mineral_name = pickweight(list(
			ORE_MARBLE = 3,
			ORE_URANIUM = 5,
			ORE_PLATINUM = 5,
			ORE_HEMATITE = 10,
			ORE_CARBON = 10,
			ORE_DIAMOND = 1,
			ORE_GOLD = 4,
			ORE_SILVER = 4,
			ORE_PHORON = 5,
			ORE_LEAD = 2,
			ORE_VERDANTIUM = 1))
	else
		if((z in using_map.rare_ore_levels) || prob(20))
			mineral_name = pickweight(list(
				ORE_MARBLE = 2,
				ORE_URANIUM = 5,
				ORE_PLATINUM = 5,
				ORE_HEMATITE = 25,
				ORE_CARBON = 25,
				ORE_GOLD = 3,
				ORE_SILVER = 3,
				ORE_PHORON = 2,
				ORE_LEAD = 1))
	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		UpdateMineral()
	update_icon()

/turf/simulated/mineral/rich/turfpack/pyraxis/make_ore(rare_ore)
	if(mineral || ignore_mapgen)
		return

	var/rare_allow_chance = 5
	if(z in using_map.rare_ore_levels)
		rare_allow_chance = 100

	var/mineral_name
	if(rare_ore && prob(rare_allow_chance))
		mineral_name = pickweight(list(
			ORE_MARBLE = 3,
			ORE_URANIUM = 10,
			ORE_PLATINUM = 10,
			ORE_HEMATITE = 20,
			ORE_CARBON = 20,
			ORE_DIAMOND = 1,
			ORE_GOLD = 8,
			ORE_SILVER = 8,
			ORE_PHORON = 10,
			ORE_LEAD = 2,
			ORE_VERDANTIUM = 1))
	else
		if((z in using_map.rare_ore_levels) || prob(20))
			mineral_name = pickweight(list(
				ORE_MARBLE = 2,
				ORE_URANIUM = 5,
				ORE_PLATINUM = 5,
				ORE_HEMATITE = 25,
				ORE_CARBON = 25,
				ORE_GOLD = 3,
				ORE_SILVER = 3,
				ORE_PHORON = 2,
				ORE_LEAD = 1))
	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		UpdateMineral()
	update_icon()

/turf/unsimulated/mineral/pyraxis
	blocks_air = TRUE
