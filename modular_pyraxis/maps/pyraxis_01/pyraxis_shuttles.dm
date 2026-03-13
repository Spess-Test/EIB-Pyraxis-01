// Late arrivals tram
/obj/effect/shuttle_landmark/pyraxis/arrivals/offsite
	name = "Transit to Station"
	landmark_tag = "arrivals_offsite"
	base_area = /area/space
	base_turf = /turf/simulated/floor/tiled/techfloor/grid

/obj/effect/shuttle_landmark/pyraxis/arrivals/station
	name = "Arrivals Station"
	landmark_tag = "arrivals_station"
	docking_controller = "arrivals_dock"

// Escape tram

/obj/effect/shuttle_landmark/pyraxis/escape/offsite
	name = "Departure - Offsit"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid

/obj/effect/shuttle_landmark/pyraxis/escape/station
	name = "Departure - Station"
	landmark_tag = "escape_station"
	docking_controller = "escape_dock"

/obj/effect/shuttle_landmark/pyraxis/escape/transit
	name = "Departure - Transit"
	landmark_tag = "escape_transit"

// Mining Elevator
/area/shuttle/drillevator
	name = "\improper Mining Elevator"
	flags = AREA_FLAG_IS_NOT_PERSISTENT
	base_turf = /turf/simulated/open

/area/shuttle/drillevator/station

/area/shuttle/drillevator/transit
	name = "\improper Mining Elevator - Diving Deep"

/area/shuttle/drillevator/underground
	name = "\improper Mining Elevator - Underground"

/obj/effect/shuttle_landmark/pyraxis/drillevator/station
	name = "Mining Elevator - Station"
	landmark_tag = "mining_station"
	docking_controller = "mining_dock_station"

/obj/effect/shuttle_landmark/pyraxis/drillevator/transit
	name = "Mining Elevator - Diving Deep"
	landmark_tag = "mining_transit"

/obj/effect/shuttle_landmark/pyraxis/drillevator/underground
	name = "Mining Elevator - Underground"
	landmark_tag = "mining_underground"
	docking_controller = "mining_dock_underground"
