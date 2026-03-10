/datum/map_template/pyraxis/cave_underground
	name = "Cave Content - Small"
	desc = "Used to fill extra space to explore in the underground."
	annihilate = TRUE

/datum/map_template/pyraxis/cave_underground_huge
	name = "Cave Content - Big"
	desc = "Used to fill EXTRA space to explore in the underground."
	annihilate = TRUE

/area/mine/explored/pyraxis/cave/underground
	name = "\improper Pyraxis Underground"
	sound_env = TUNNEL_ENCLOSED
	icon_state = "orange"
	always_unpowered = TRUE
	flags = AREA_BLOCK_GHOST_SIGHT | AREA_FORBID_EVENTS
	haunted = TRUE
	color_grading = COLORTINT_UNDERDARK
	ambience = AMBIENCE_UNDERDARK

/area/mine/unexplored/pyraxis/cave/underground
	name = "\improper Pyraxis Underground"
	sound_env = TUNNEL_ENCLOSED
	icon_state = "yellow"
	always_unpowered = TRUE
	flags = AREA_BLOCK_GHOST_SIGHT | AREA_FORBID_EVENTS
	haunted = TRUE
	color_grading = COLORTINT_UNDERDARK
	ambience = AMBIENCE_UNDERDARK
