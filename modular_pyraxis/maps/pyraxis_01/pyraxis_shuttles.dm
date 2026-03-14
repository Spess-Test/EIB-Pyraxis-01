// Late arrivals tram
/datum/shuttle/autodock/ferry/emergency/escape
	name = "Escape"
	location = FERRY_LOCATION_OFFSITE // At offsite
	warmup_time = 10
	docking_controller_tag = "escape_shuttle"
	shuttle_area = /area/shuttle/escape
	landmark_offsite = "escape_centcom"
	landmark_station = "escape_station"
	landmark_transition = "escape_transit"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	ceiling_type = /turf/simulated/shuttle/floor/black/turfpack/pyraxis

/obj/effect/shuttle_landmark/premade/escape/centcom
	name = "Departure Tram - Offsite"
	landmark_tag = "escape_centcom"
	docking_controller = "centcom_dock"
	base_area = /area/centcom/main_hall
	base_turf = /turf/simulated/floor/tiled/techfloor/grid

/obj/effect/shuttle_landmark/premade/escape/transit
	name = "Departure Tram - Transit"
	landmark_tag = "escape_transit"
	base_turf = /turf/unsimulated/floor/maglev

/obj/effect/shuttle_landmark/premade/escape/station
	name = "Departure Tram - Station"
	landmark_tag = "escape_station"
	docking_controller = "escape_dock"
	base_area = /area/engineering/gravgen
	base_turf = /turf/simulated/floor/maglev

/obj/effect/shuttle_landmark/pyraxis/arrivals/offsite
	name = "Transit to Station"
	landmark_tag = "arrivals_offsite"
	base_area = /area/space
	base_turf = /turf/simulated/floor/tiled/techfloor/grid

/obj/effect/shuttle_landmark/pyraxis/arrivals/station
	name = "Arrivals Station"
	landmark_tag = "arrivals_station"
	docking_controller = "arrivals_dock"

// Supply shuttle
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply Tram"
	location = FERRY_LOCATION_OFFSITE
	warmup_time = 10
	shuttle_area = /area/shuttle/supply
	landmark_offsite = "supply_centcom"
	landmark_station = "supply_station"
	docking_controller_tag = "supply_shuttle"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY
	ceiling_type = /turf/simulated/shuttle/floor/black/turfpack/pyraxis

/obj/effect/shuttle_landmark/premade/supply/centcom
	name = "Central"
	landmark_tag = "supply_centcom"
	base_area = /area/centcom/suppy
	base_turf = /turf/unsimulated/floor/techfloor_grid

/obj/effect/shuttle_landmark/premade/supply/station
	name = "Central"
	landmark_tag = "supply_station"
	docking_controller = "cargo_bay"

#define PYRAXIS_MINING_CRASHES list("crash_underground_one")

// Mining Elevator
/datum/shuttle/autodock/multi/drillevator
	name = "Mining Elevator"
	warmup_time = 5
	move_time = 90
	shuttle_area = /area/shuttle/drillevator
	current_location = "mining_station"
	landmark_transition = "mining_transit"
	docking_controller_tag = "mine_elevator_controller"
	ceiling_type = /turf/simulated/shuttle/floor/black/turfpack/pyraxis
	can_be_haunted = TRUE
	move_direction = SOUTH

	destination_tags = list(
		"mining_station",
		"mining_underground"
	)

	allow_short_crashes = TRUE
	crash_message = "Mining Elevator connection severed. Please ensure it's functionality, and beging rescue operations."

/datum/shuttle/autodock/multi/drillevator/should_crash(var/obj/effect/shuttle_landmark/intended_destination)
	if(!intended_destination.local_crash_sites?.len)
		return FALSE
	if(emagged_crash)
		return TRUE
	if(SShaunting.get_world_haunt() >= 5)
		return prob(1) && prob(1)
	return FALSE

/obj/effect/shuttle_landmark/pyraxis/drillevator/station
	name = "Mining Elevator - Station"
	landmark_tag = "mining_station"
	docking_controller = "mine_cargo_controller"
	base_turf = /turf/simulated/open
	base_area = /area/shuttle/drillevator/station

/obj/effect/shuttle_landmark/pyraxis/drillevator/transit
	name = "Mining Elevator - Diving Deep"
	landmark_tag = "mining_transit"

/obj/effect/shuttle_landmark/pyraxis/drillevator/underground
	name = "Mining Elevator - Underground"
	landmark_tag = "mining_underground"
	docking_controller = "mine_underground_controller"
	base_area = /area/shuttle/drillevator/underground
	base_turf = /turf/simulated/floor/concrete
	local_crash_sites = PYRAXIS_MINING_CRASHES

// Crash landmarks
/obj/effect/shuttle_landmark/premade/generic/crash_underground_one
	name = "Crash - Underground 1"
	landmark_tag = "crash_underground_one"
	base_turf = /turf/simulated/mineral/cave
