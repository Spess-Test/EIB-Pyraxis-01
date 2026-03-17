#if !defined(CITESTING)

/*********************/
/* MAP SELECTION     */
/* FOR LIVE SERVER   */
/*********************/

// EIB Pyraxis-01
#define USE_MAP_PYRAXIS01

// Debug
// #define USE_MAP_MINITEST

/*********************/
/* End Map Selection */
/*********************/

#endif

// EIB Pyraxis-01
#ifdef USE_MAP_PYRAXIS01
#include "../pyraxis_01/pyraxis_01.dm"
#endif

#ifdef USE_MAP_MINITEST
#include "../virgo_minitest/virgo_minitest.dm"
#endif
