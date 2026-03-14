//////////////////////////////////////////////////////////////////////////////////////
// Code Shenanigans for lateload maps

/datum/map_template/pyraxis_lateload
	allow_duplicates = FALSE
	var/associated_map_datum

/datum/map_template/pyraxis_lateload/on_map_loaded(z)
	if(!associated_map_datum || !ispath(associated_map_datum))
		log_game("Extra z-level [src] has no associated map datum")
		return

	new associated_map_datum(using_map, z)

/datum/map_z_level/pyraxis_lateload
	z = 0

/datum/map_z_level/pyraxis_lateload/New(var/datum/map/map, mapZ)
	if(mapZ && !z)
		z = mapZ
	return ..(map)

//////////////////////////////////////////////////////////////////////////////////////
// Centcom Z-Level
/datum/map_z_level/pyraxis_lateload/centcom
	name = Z_NAME_PYRAXIS_CENTCOM
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT|MAP_LEVEL_SEALED|MAP_LEVEL_BELOW_BLOCKED
	base_turf = /turf/simulated/floor/concrete

/datum/map_template/pyraxis_lateload/centcom
	name = Z_NAME_PYRAXIS_CENTCOM
	name_alias = Z_NAME_ALIAS_CENTCOM
	mappath = "modular_pyraxis/maps/pyraxis_01/pyraxis-centcom.dmm"
	associated_map_datum = /datum/map_z_level/pyraxis_lateload/centcom
