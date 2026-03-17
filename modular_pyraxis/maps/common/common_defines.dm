// Z_LEVEL are just hard coded z-levels
// Z_NAME are late loaded z-level maps that can be looked up in GLOB.map_templates_loaded
// GLOB.map_templates_loaded is populated as /datum/map_template/proc/on_map_preload(z) is called
// Some Z_NAME ultimately will be indexed under an alias however e.g. Z_NAME_ALIAS_GATEWAY

// Outpost 21
//Outpost map defs
#define Z_LEVEL_PYRAXIS_UNDERGROUND					1
#define Z_LEVEL_PYRAXIS_BASEMENT					2
#define Z_LEVEL_PYRAXIS_SURFACE						3
#define Z_LEVEL_PYRAXIS_UPPER						4
#define Z_LEVEL_PYRAXIS_ROOFTOPS 					5
#define Z_LEVEL_PYRAXIS_TIPPYTOP					6
#define Z_LEVEL_PYRAXIS_ASTEROID					7


// Lateload Z level names
#define Z_NAME_PYRAXIS_CENTCOM					"Pyraxis - Central Command" // Aliased to Z_NAME_ALIAS_CENTCOM
#define Z_NAME_PYRAXIS_MISC						"Pyraxis - Misc" // Aliased to Z_NAME_ALIAS_MISC
