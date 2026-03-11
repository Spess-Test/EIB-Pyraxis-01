/datum/map/pyraxis
	name = "EIB Pyraxis-01"
	full_name = "Einstein Engines Industrial Base Pyraxis 01"
	path = "pyraxis"

	holomap_smoosh = list(list(
		Z_LEVEL_PYRAXIS_BASEMENT,
		Z_LEVEL_PYRAXIS_SURFACE,
		Z_LEVEL_PYRAXIS_UPPER,
		Z_LEVEL_PYRAXIS_ROOFTOPS
	))

	zlevel_datum_type = /datum/map_z_level/pyraxis

	station_name = "Einstein Engines Industrial Base Pyraxis 01"
	station_short = "EIB Pyraxis-01"
	facility_type = "base"
	dock_name = "Pyraxis 01 ATC"
	boss_name = "Pyraxis Coalition"
	boss_short = "PyrCoal"
	company_name = "Einstein Engines"
	company_short = "EE"
	// starsys_name = "" - TBD
	use_overmap = TRUE
	overmap_size = 25
	overmap_event_areas = 9

	shuttle_docked_message = "The scheduled tram to the %dock_name% has arrived at the station. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The crew transfer tram has left the station. Estimate %ETA% until the tram arrives at the %dock_name%."
	shuttle_called_message = "A crew transfer to the %dock_name% has been scheduled. The tram has been called. Those leaving should proceed to departure bay in approximately %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The emergency bunker tram has arrived at the station. You have approximately %ETD% to board the tram."
	emergency_shuttle_leaving_dock = "The emergency tram has left the station. Estimate %ETA% until it arrives at the %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation tram has been called. It will arrive at the departure bay in approximately %ETA%."
	emergency_shuttle_recall_message = "The emergency tram has been recalled."

	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_ENGINEERING_OUTPOST,
							NETWORK_DEFAULT,
							NETWORK_MEDICAL,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_PRISON,
							NETWORK_SECURITY,
							NETWORK_INTERROGATION,
							NETWORK_TELECOM,
							NETWORK_OUTSIDE,
							NETWORK_FOUNDATIONS,
							)
	secondary_networks = list(
							NETWORK_ERT,
							NETWORK_MERCENARY,
							NETWORK_THUNDER,
							NETWORK_COMMUNICATORS,
							NETWORK_ALARM_ATMOS,
							NETWORK_ALARM_POWER,
							NETWORK_ALARM_FIRE
							)
	usable_email_tlds = list("internalmail.ee")
	allowed_spawns = list("Tram", "Cryogenic Storage", "Cyborg Storage")

	planet_datums_to_make = list(/datum/planet/pyraxis)

	unit_test_z_levels = list(
		Z_LEVEL_PYRAXIS_UNDERGROUND,
		Z_LEVEL_PYRAXIS_UNDERGROUND,
		Z_LEVEL_PYRAXIS_SURFACE,
		Z_LEVEL_PYRAXIS_UPPER,
		Z_LEVEL_PYRAXIS_ROOFTOPS,
		Z_LEVEL_PYRAXIS_TIPPYTOP
	)

	lateload_z_levels = list(
		list(Z_NAME_PYRAXIS_CENTCOM)
	)

	overmap_z = Z_NAME_ALIAS_MISC
	map_levels = list(
		Z_LEVEL_PYRAXIS_UNDERGROUND,
		Z_LEVEL_PYRAXIS_BASEMENT,
		Z_LEVEL_PYRAXIS_SURFACE,
		Z_LEVEL_PYRAXIS_UPPER,
		Z_LEVEL_PYRAXIS_ROOFTOPS,
		Z_LEVEL_PYRAXIS_TIPPYTOP
	)

	ai_shell_restricted = TRUE
	ai_shell_allowed_levels = list(
		Z_LEVEL_PYRAXIS_UNDERGROUND,
		Z_LEVEL_PYRAXIS_BASEMENT,
		Z_LEVEL_PYRAXIS_SURFACE,
		Z_LEVEL_PYRAXIS_UPPER,
		Z_LEVEL_PYRAXIS_ROOFTOPS,
		Z_LEVEL_PYRAXIS_TIPPYTOP
	)

	confinement_beam_z_levels = list(
		Z_LEVEL_PYRAXIS_BASEMENT,
		Z_LEVEL_PYRAXIS_SURFACE,
		Z_LEVEL_PYRAXIS_UPPER,
		Z_LEVEL_PYRAXIS_ROOFTOPS,
		Z_LEVEL_PYRAXIS_TIPPYTOP
	)

	rare_ore_levels = list(
		Z_LEVEL_PYRAXIS_UNDERGROUND
	)

	belter_docked_z = 		list(Z_LEVEL_OUTPOST_ASTEROID)
	belter_transit_z =	 	list(Z_NAME_ALIAS_CENTCOM)

	common_ores = list(ORE_MARBLE = 8, ORE_QUARTZ = 10, ORE_COPPER = 2, ORE_TIN = 2, ORE_BAUXITE = 1, ORE_URANIUM = 0, ORE_PLATINUM = 1, ORE_HEMATITE = 1, ORE_RUTILE = 2, ORE_CARBON = 5, ORE_DIAMOND = 0, ORE_GOLD = 3, ORE_SILVER = 2, ORE_PHORON = 0, ORE_LEAD = 5, ORE_VOPAL = 0, ORE_VERDANTIUM = 0, ORE_PAINITE = 0)
	rare_ores = list(ORE_MARBLE = 5, ORE_QUARTZ = 15, ORE_COPPER = 20, ORE_TIN = 15, ORE_BAUXITE = 5, ORE_URANIUM = 25, ORE_PLATINUM = 25, ORE_HEMATITE = 15, ORE_RUTILE = 20, ORE_CARBON = 25, ORE_DIAMOND = 8, ORE_GOLD = 25, ORE_SILVER = 10, ORE_PHORON = 25, ORE_LEAD = 15, ORE_VOPAL = 1, ORE_VERDANTIUM = 3, ORE_PAINITE = 1)

/datum/map/pyraxis/perform_map_generation()
	seed_submaps(list(Z_LEVEL_PYRAXIS_UNDERGROUND), 400, /area/mine/unexplored/pyraxis/cave/underground, /datum/map_template/pyraxis/cave_underground_huge)
	seed_submaps(list(Z_LEVEL_PYRAXIS_UNDERGROUND), 450, /area/mine/unexplored/pyraxis/cave/underground, /datum/map_template/pyraxis/cave_underground)

	new /datum/random_map/automata/cave_system(null, 1, 1, Z_LEVEL_PYRAXIS_UNDERGROUND, world.maxx, world.maxy)
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_PYRAXIS_UNDERGROUND, world.maxx, world.maxy)

	new /datum/random_map/automata/cave_system(null, 1, 1, Z_LEVEL_PYRAXIS_BASEMENT, world.maxx, world.maxy)
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_PYRAXIS_BASEMENT, world.maxx, world.maxy)

	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_PYRAXIS_SURFACE, world.maxx, world.maxy)

	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_PYRAXIS_UPPER, world.maxx, world.maxy)

	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_PYRAXIS_ROOFTOPS, world.maxx, world.maxy)

	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_PYRAXIS_TIPPYTOP, world.maxx, world.maxy)

	return 1

/datum/planet/pyraxis
	expected_z_levels = list(
		Z_LEVEL_PYRAXIS_UNDERGROUND,
		Z_LEVEL_PYRAXIS_BASEMENT,
		Z_LEVEL_PYRAXIS_SURFACE,
		Z_LEVEL_PYRAXIS_UPPER,
		Z_LEVEL_PYRAXIS_ROOFTOPS,
		Z_LEVEL_PYRAXIS_TIPPYTOP
	)

/datum/skybox_settings/pyraxis
	icon_state = "dyable"
	random_color = TRUE

/datum/map_z_level/pyraxis/underground
	z = Z_LEVEL_PYRAXIS_UNDERGROUND
	name = "Underground"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_BELOW_BLOCKED|MAP_LEVEL_MAPPABLE|MAP_LEVEL_EVENTS|MAP_LEVEL_VORESPAWN|MAP_LEVEL_EXTREMEFALL
	base_turf = /turf/simulated/mineral/thor/floor/cave

/datum/map_z_level/pyraxis/basement
	z = Z_LEVEL_PYRAXIS_BASEMENT
	name = "Basement"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_PERSIST|MAP_LEVEL_MAPPABLE|MAP_LEVEL_EVENTS|MAP_LEVEL_AIRMIX_CLEANS|MAP_LEVEL_VORESPAWN
	base_turf = /turf/simulated/open

/datum/map_z_level/pyraxis/main
	z = Z_LEVEL_PYRAXIS_SURFACE
	name = "Main"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_PERSIST|MAP_LEVEL_MAPPABLE|MAP_LEVEL_EVENTS|MAP_LEVEL_AIRMIX_CLEANS|MAP_LEVEL_VORESPAWN
	base_turf = /turf/simulated/open

/datum/map_z_level/pyraxis/upper
	z = Z_LEVEL_PYRAXIS_UPPER
	name = "Upper"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_PERSIST|MAP_LEVEL_MAPPABLE|MAP_LEVEL_EVENTS|MAP_LEVEL_AIRMIX_CLEANS|MAP_LEVEL_VORESPAWN
	base_turf = /turf/simulated/open

/datum/map_z_level/pyraxis/rooftops
	z = Z_LEVEL_PYRAXIS_ROOFTOPS
	name = "Rooftops"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_PERSIST|MAP_LEVEL_MAPPABLE|MAP_LEVEL_EVENTS|MAP_LEVEL_AIRMIX_CLEANS|MAP_LEVEL_VORESPAWN|MAP_LEVEL_EXTREMEFALL
	base_turf = /turf/simulated/open

/datum/map_z_level/pyraxis/tippytop
	z = Z_LEVEL_PYRAXIS_TIPPYTOP
	name = "Tippytop"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED|MAP_LEVEL_PERSIST|MAP_LEVEL_MAPPABLE|MAP_LEVEL_EVENTS|MAP_LEVEL_AIRMIX_CLEANS|MAP_LEVEL_VORESPAWN
	base_turf = /turf/simulated/open

/obj/effect/landmark/map_data/pyraxis
	height = 6

/obj/effect/overmap/visitable/sector/pyraxis
	name = "Pyraxis"
	desc = "A recently colonized planet."

	base = TRUE
	icon_state = "globe"

/obj/effect/overmap/visitable/sector/pyraxis/Crossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM, going = FALSE)

/obj/effect/overmap/visitable/sector/pyraxis/Uncrossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM, going = TRUE)

/obj/effect/overmap/visitable/sector/pyraxis/announce_atc(var/atom/movable/AM, var/going = FALSE)
	var/message = "Sensor contact for vessel '[AM.name]' has [going ? "left" : "entered"] ATC control area."
	//For landables, we need to see if their shuttle is cloaked
	if(istype(AM, /obj/effect/overmap/visitable/ship/landable))
		var/obj/effect/overmap/visitable/ship/landable/SL = AM //Phew
		var/datum/shuttle/autodock/multi/shuttle = SSshuttles.shuttles[SL.shuttle]
		if(!istype(shuttle) || !shuttle.cloaked) //Not a multishuttle (the only kind that can cloak) or not cloaked
			atc.msg(message)

	//For ships, it's safe to assume they're big enough to not be sneaky
	else if(istype(AM, /obj/effect/overmap/visitable/ship))
		atc.msg(message)

/obj/effect/overmap/visitable/sector/pyraxis/get_space_zlevels()
	return list() //None!

/obj/effect/overmap/visitable/sector/pyraxis_space/asteroid
	initial_generic_waypoints = list("asteroid_civ")
	name = "Asteroid E-73 Platform"
	icon_state = "asteroid"

	map_z = list(Z_LEVEL_PYRAXIS_ASTEROID)
	extra_z_levels = list()
	levels_for_distress = list(Z_LEVEL_PYRAXIS_SURFACE)

/obj/effect/overmap/visitable/sector/pyraxis_space/asteroid/Crossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM, going = FALSE)

/obj/effect/overmap/visitable/sector/pyraxis_space/asteroid/Uncrossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM, going = TRUE)

/obj/effect/overmap/visitable/sector/pyraxis_space/asteroid/announce_atc(var/atom/movable/AM, var/going = FALSE)
	var/message = "Sensor contact for vessel '[AM.name]' has [going ? "left" : "entered"] ATC control area."
	//For landables, we need to see if their shuttle is cloaked
	if(istype(AM, /obj/effect/overmap/visitable/ship/landable))
		var/obj/effect/overmap/visitable/ship/landable/SL = AM //Phew
		var/datum/shuttle/autodock/multi/shuttle = SSshuttles.shuttles[SL.shuttle]
		if(!istype(shuttle) || !shuttle.cloaked) //Not a multishuttle (the only kind that can cloak) or not cloaked
			atc.msg(message)

	//For ships, it's safe to assume they're big enough to not be sneaky
	else if(istype(AM, /obj/effect/overmap/visitable/ship))
		atc.msg(message)

/obj/effect/overmap/visitable/sector/pyraxis_space/asteroid/get_space_zlevels()
	return list(Z_LEVEL_PYRAXIS_ASTEROID)
