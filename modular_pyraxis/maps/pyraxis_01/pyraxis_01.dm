#if !defined(USING_MAP_DATUM)

	#include "pyraxis_defines.dm"
	#include "pyraxis_presets.dm"
	#include "pyraxis_areas.dm"

	#ifndef AWAY_MISSION_TEST
		#include "pyraxis-01-underground.dmm"
		#include "pyraxis-02-basement.dmm"
		#include "pyraxis-03-surface.dmm"
		#include "pyraxis-04-upper.dmm"
		#include "pyraxis-05-rooftops.dmm"
		#include "pyraxis-06-tippytop.dmm"
	#endif

	#include "pyraxis_lateload.dm"

	#define USING_MAP_DATUM /datum/map/pyraxis
#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring EIS Pyraxis 01

#endif
