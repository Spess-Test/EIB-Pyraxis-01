var/datum/planet/pyraxis/planet_pyraxis = null

/datum/time/pyraxis
	seconds_in_day = 21 HOURS

/datum/planet/pyraxis
	name = "pyraxis"
	desc = "pyraxis - TODO: LORE"
	current_time = new /datum/time/pyraxis()
	planetary_wall_type = /turf/unsimulated/wall/planetary/pyraxis

	sun_name = "Valkyr"

/datum/planet/pyraxis/New()
	..()
	planet_pyraxis = null
	weather_holder = new /datum/weather_holder/pyraxis(src)

/datum/planet/pyraxis/update_sun()
	..()
	planet_pyraxis = src
	weather_holder = new /datum/weather_holder/pyraxis(src)

// This code is horrible.
/datum/planet/pyraxis/update_sun()
	..()
	// Debug locked lighting
	if(!isnull(locked_light_color))
		spawn(1)
			update_sun_deferred(locked_light_intensity, locked_light_color)
		return
	// Normal sunlight
	var/datum/time/time = current_time
	var/length_of_day = time.seconds_in_day / 10 / 60 / 60
	var/noon = length_of_day / 2
	var/distance_from_noon = abs(text2num(time.show_time("hh")) - noon)
	sun_position = distance_from_noon / noon
	sun_position = abs(sun_position - 1)

	var/low_brightness = null
	var/high_brightness = null

	var/low_color = null
	var/high_color = null
	var/min = 0

	switch(sun_position)
		if(0 to 0.40) // Night
			low_brightness = 0.2
			low_color = "#660000"

			high_brightness = 0.25
			high_color = "#4D0000"
			min = 0

		if(0.40 to 0.50) // Twilight
			low_brightness = 0.5
			low_color = "#66004D"

			high_brightness = 0.6
			high_color = "#CC3300"
			min = 0.40

		if(0.50 to 0.70) // Sunrise/set
			low_brightness = 0.8
			low_color = "#DDDDDD"

			high_brightness = 0.9
			high_color = "#FFFFFF"
			min = 0.50

		if(0.70 to 1.00) // Noon
			low_brightness = 0.85
			low_color = "#CC3300"

			high_brightness = 0.9
			high_color = "#FF9933"
			min = 0.70

	var/interpolate_weight = (abs(min - sun_position)) * 4
	var/weather_light_modifier = 1
	if(weather_holder && weather_holder.current_weather)
		weather_light_modifier = weather_holder.current_weather.light_modifier

	var/new_brightness = (LERP(low_brightness, high_brightness, interpolate_weight) ) * weather_light_modifier

	var/new_color = null
	if(weather_holder && weather_holder.current_weather && weather_holder.current_weather.light_color)
		new_color = weather_holder.current_weather.light_color
	else
		var/list/low_color_list = hex2rgb(low_color)
		var/low_r = low_color_list[1]
		var/low_g = low_color_list[2]
		var/low_b = low_color_list[3]

		var/list/high_color_list = hex2rgb(high_color)
		var/high_r = high_color_list[1]
		var/high_g = high_color_list[2]
		var/high_b = high_color_list[3]

		var/new_r = LERP(low_r, high_r, interpolate_weight)
		var/new_g = LERP(low_g, high_g, interpolate_weight)
		var/new_b = LERP(low_b, high_b, interpolate_weight)

		new_color = rgb(new_r, new_g, new_b)

	// Seasonal adjust
	switch(GLOB.world_time_season)
		if("spring")
			new_brightness *= 0.9
		if("summer")
			new_brightness *= 1
		if("autumn")
			new_brightness *= 0.9
		if("winter")
			new_brightness *= 0.8

	spawn(1)
		update_sun_deferred(new_brightness, new_color)

/proc/get_pyraxis_time()
	if(planet_pyraxis)
		return planet_pyraxis.current_time

/datum/weather/pyraxis
	var/next_lightning_strike = 0 // world.time when lightning will strike.
	var/min_lightning_cooldown = 0
	var/max_lightning_cooldown = 0

/datum/weather/pyraxis/proc/fill_vats(var/global_chance,var/single_chance,var/amount)
	if(!prob(global_chance))
		return
	for(var/obj/machinery/reagent_refinery/vat/V in GLOB.vats_to_rain_into)
		if(V.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(V)
			if(!T.is_outdoors())
				continue
			if(prob(single_chance))
				V.reagents.add_reagent(REAGENT_ID_WATER, amount)

/datum/weather/pyraxis/proc/wet_plating(var/chance)
	if(holder.our_planet.planet_floors.len)
		var/i = rand(6,18)
		while(i-- > 0)
			if(!prob(chance))
				continue
			var/turf/T = pick(holder.our_planet.planet_floors)
			if((istype(T,/turf/simulated/floor/plating) || istype(T,/turf/simulated/floor/outpost_roof)) && T.is_outdoors())
				var/turf/simulated/floor/F = T
				F.wet_floor(1)

// This gets called to do lightning periodically.
// There is a seperate function to do the actual lightning strike, so that badmins can play with it.
/datum/weather/pyraxis/proc/handle_lightning()
	if(world.time < next_lightning_strike)
		return // It's too soon to strike again.
	next_lightning_strike = world.time + rand(min_lightning_cooldown, max_lightning_cooldown)
	var/turf/T = pick(holder.our_planet.planet_floors) // This has the chance to 'strike' the sky, but that might be a good thing, to scare reckless pilots.
	lightning_strike(T)

//Weather definitions
/datum/weather_holder/pyraxis
	temperature = 287.15 // 14c
	allowed_weather_types = list(
		WEATHER_CLEAR		= new /datum/weather/pyraxis/clear(),
		WEATHER_LIGHT_SNOW	= new /datum/weather/pyraxis/light_snow(),
		WEATHER_SNOW		= new /datum/weather/pyraxis/snow(),
		WEATHER_BLIZZARD	= new /datum/weather/pyraxis/blizzard(),
		WEATHER_OVERCAST	= new /datum/weather/pyraxis/overcast(),
		WEATHER_FOG			= new /datum/weather/pyraxis/fog(),
		WEATHER_RAIN        = new /datum/weather/pyraxis/rain(),
		WEATHER_STORM		= new /datum/weather/pyraxis/storm(),
		WEATHER_HAIL		= new /datum/weather/pyraxis/hail(),
		WEATHER_DOWNPOURWARNING = new /datum/weather/pyraxis/downpourwarning(),
		WEATHER_DOWNPOUR 		= new /datum/weather/pyraxis/downpour(),
		WEATHER_DOWNPOURFATAL 	= new /datum/weather/pyraxis/downpourfatal(),
		WEATHER_COLDDARKNESS	= new /datum/weather/pyraxis/clear/hidden_evildarkness(),
		WEATHER_LONGBLIZZARD	= new /datum/weather/pyraxis/blizzard/hidden_dangerous()
		)
	roundstart_weather_chances = list() // See New() for seasonal starting weathers

/datum/weather_holder/pyraxis/New(source)
	switch(GLOB.world_time_season)
		if("spring")
			roundstart_weather_chances = list(
				WEATHER_CLEAR = 20,
				WEATHER_LIGHT_SNOW = 25,
				WEATHER_OVERCAST = 5,
				WEATHER_RAIN = 20,
				WEATHER_STORM = 20,
				WEATHER_HAIL = 15
				)
		if("summer")
			roundstart_weather_chances = list(
				WEATHER_CLEAR = 20,
				WEATHER_LIGHT_SNOW = 0,
				WEATHER_OVERCAST = 10,
				WEATHER_RAIN = 20,
				WEATHER_STORM = 50,
				WEATHER_HAIL = 5
				)
		if("autumn")
			roundstart_weather_chances = list(
				WEATHER_CLEAR = 20,
				WEATHER_LIGHT_SNOW = 10,
				WEATHER_OVERCAST = 0,
				WEATHER_RAIN = 40,
				WEATHER_STORM = 40,
				WEATHER_HAIL = 15
				)
		if("winter")
			roundstart_weather_chances = list(
				WEATHER_CLEAR = 20,
				WEATHER_LIGHT_SNOW = 50,
				WEATHER_OVERCAST = 0,
				WEATHER_RAIN = 20,
				WEATHER_STORM = 10,
				WEATHER_HAIL = 24,
				WEATHER_LONGBLIZZARD = 1
				)
	. = ..()

/datum/weather/pyraxis
	name = "pyraxis base"
	temp_high = 287.15 // 14c
	temp_low = 282.15 // 9c

/datum/weather/pyraxis/clear
	name = "clear"
	temp_high = 287.15 // 14c
	temp_low = T0C
	wind_high = 2
	wind_low = 1
	transition_chances = list() // See New() for seasonal transitions
	observed_message = "The sky is clear."
	transition_messages = list(
		"The sky clears up.",
		"The sky is visible.",
		"The weather is calm."
		)
	sky_visible = TRUE
	color_grading = COLORTINT_COZY

/datum/weather/pyraxis/clear/New()
	switch(GLOB.world_time_season)
		if("spring")
			transition_chances = list(
				WEATHER_CLEAR = 15,
				WEATHER_RAIN = 65,
				WEATHER_HAIL = 5,
				WEATHER_LIGHT_SNOW = 15
				)
		if("summer")
			transition_chances = list(
				WEATHER_CLEAR = 15,
				WEATHER_RAIN = 65,
				WEATHER_HAIL = 5,
				WEATHER_OVERCAST = 15
				)
		if("autumn")
			transition_chances = list(
				WEATHER_CLEAR = 15,
				WEATHER_RAIN = 75,
				WEATHER_HAIL = 5,
				WEATHER_LIGHT_SNOW = 5
				)
		if("winter")
			transition_chances = list(
				WEATHER_CLEAR = 15,
				WEATHER_RAIN = 45,
				WEATHER_HAIL = 15,
				WEATHER_LIGHT_SNOW = 25
				)
	. = ..()

/datum/weather/pyraxis/overcast
	name = "overcast"
	light_modifier = 0.8
	transition_chances = list(
		WEATHER_CLEAR = 25,
		WEATHER_OVERCAST = 50,
		WEATHER_LIGHT_SNOW = 10,
		WEATHER_FOG = 30,
		WEATHER_SNOW = 5,
		WEATHER_RAIN = 5,
		WEATHER_HAIL = 5
		)
	observed_message = "It is overcast, all you can see are clouds."
	transition_messages = list(
		"All you can see above are clouds.",
		"Clouds cut off your view of the sky.",
		"It's very cloudy."
		)

	outdoor_sounds_type = /datum/looping_sound/weather/wind/gentle
	indoor_sounds_type = /datum/looping_sound/weather/wind/gentle/indoors

/datum/weather/pyraxis/fog
	name = "fog"
	icon_state = "acidfog"
	wind_high = 1
	wind_low = 0
	light_modifier = 0.7
	effect_message = span_notice("Mist surrounds you.")
	transition_chances = list()
	observed_message = "It is misting."
	effect_flags = HAS_PLANET_EFFECT|EFFECT_ONLY_LIVING

	transition_messages = list(
		"All you can see is fog.",
		"Fog cuts off your view.",
		"It's very foggy."
		)

	outdoor_sounds_type = /datum/looping_sound/weather/wind/gentle
	indoor_sounds_type = /datum/looping_sound/weather/wind/gentle/indoors
	color_grading = COLORTINT_WARM

/datum/weather/pyraxis/fog/New()
	switch(GLOB.world_time_season)
		if("spring")
			transition_chances = list(
				WEATHER_OVERCAST = 15,
				WEATHER_RAIN = 60,
				WEATHER_HAIL = 10,
				WEATHER_LIGHT_SNOW = 10,
				WEATHER_CLEAR = 5,
				)
		if("summer")
			transition_chances = list(
				WEATHER_OVERCAST = 35,
				WEATHER_RAIN = 60,
				WEATHER_CLEAR = 5
				)
		if("autumn")
			transition_chances = list(
				WEATHER_OVERCAST = 15,
				WEATHER_RAIN = 80,
				WEATHER_HAIL = 4,
				WEATHER_CLEAR = 1
				)
		if("winter")
			transition_chances = list(
				WEATHER_OVERCAST = 15,
				WEATHER_RAIN = 40,
				WEATHER_LIGHT_SNOW = 20,
				WEATHER_HAIL = 25
				)
	. = ..()

/datum/weather/pyraxis/fog/planet_effect(mob/living/L)
	if(L.z in holder.our_planet.expected_z_levels)
		var/turf/T = get_turf(L)
		if(!T.is_outdoors())
			return

		L.water_act(1)

/datum/weather/pyraxis/rain
	name = "rain"
	icon_state = "rain"
	temp_high = 413.15 // 10c
	temp_low = T0C
	wind_high = 2
	wind_low = 1
	light_modifier = 0.5
	effect_message = span_notice("Rain falls on you.")
	effect_flags = HAS_PLANET_EFFECT|EFFECT_ONLY_LIVING

	transition_chances = list() // See New() for seasonal transitions
	observed_message = "It is raining."
	transition_messages = list(
		"The sky is dark, and rain falls down upon you."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/rain
	indoor_sounds_type = /datum/looping_sound/weather/rain/indoors
	color_grading = COLORTINT_DIM

/datum/weather/pyraxis/rain/New()
	switch(GLOB.world_time_season)
		if("spring")
			transition_chances = list(
				WEATHER_OVERCAST = 5,
				WEATHER_RAIN = 60,
				WEATHER_STORM = 45,
				WEATHER_HAIL = 10,
				WEATHER_LIGHT_SNOW = 5
			)
		if("summer")
			transition_chances = list(
				WEATHER_OVERCAST = 55,
				WEATHER_RAIN = 25,
				WEATHER_STORM = 10,
				WEATHER_HAIL = 5,
				WEATHER_CLEAR = 5
			)
		if("autumn")
			transition_chances = list(
				WEATHER_OVERCAST = 15,
				WEATHER_RAIN = 30,
				WEATHER_STORM = 45,
				WEATHER_HAIL = 5,
				WEATHER_LIGHT_SNOW = 5,
			)
		if("winter")
			transition_chances = list(
				WEATHER_OVERCAST = 5,
				WEATHER_RAIN = 15,
				WEATHER_STORM = 50,
				WEATHER_LIGHT_SNOW = 10,
				WEATHER_HAIL = 15
			)
	. = ..()

/datum/weather/pyraxis/rain/process_effects()
	..()
	wet_plating(30)
	fill_vats(10,40,8)

/datum/weather/pyraxis/rain/planet_effect(mob/living/L)
	if(L.z in holder.our_planet.expected_z_levels)
		var/turf/T = get_turf(L)
		if(!T.is_outdoors())
			return // They're indoors, so no need to rain on them.

		// If they have an open umbrella, it'll guard from rain
		if(istype(L.get_active_hand(), /obj/item/melee/umbrella))
			var/obj/item/melee/umbrella/U = L.get_active_hand()
			if(U.open)
				if(show_message)
					to_chat(L, span_notice("Rain showers loudly onto your umbrella!"))
				return
		else if(istype(L.get_inactive_hand(), /obj/item/melee/umbrella))
			var/obj/item/melee/umbrella/U = L.get_inactive_hand()
			if(U.open)
				if(show_message)
					to_chat(L, span_notice("Rain showers loudly onto your umbrella!"))
				return

		if(show_message)
			to_chat(L, effect_message)

		L.water_act(2)

/datum/weather/pyraxis/storm
	name = "storm"
	icon_state = "storm"
	temp_high = T0C
	temp_low =  268.15 // -5c
	wind_high = 4
	wind_low = 2
	light_modifier = 0.3
	flight_failure_modifier = 10
	effect_message = span_notice("Rain falls on you.")
	effect_flags = HAS_PLANET_EFFECT|EFFECT_ONLY_LIVING

	min_lightning_cooldown = 5 SECONDS
	max_lightning_cooldown = 1 MINUTE
	observed_message = "An intense storm pours down over the region."
	transition_messages = list(
		"You feel intense winds hit you as the weather takes a turn for the worst.",
		"Loud thunder is heard in the distance.",
		"A bright flash heralds the approach of a storm."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/rain
	indoor_sounds_type = /datum/looping_sound/weather/rain/indoors

	transition_chances = list() // See New() for seasonal transitions
	color_grading = COLORTINT_DARK

/datum/weather/pyraxis/storm/New()
	switch(GLOB.world_time_season)
		if("spring")
			transition_chances = list(
				WEATHER_RAIN = 45,
				WEATHER_STORM = 30,
				WEATHER_DOWNPOURWARNING = 6, // Fun times ahead
				WEATHER_HAIL = 15,
				WEATHER_OVERCAST = 4
				)
		if("summer")
			transition_chances = list(
				WEATHER_RAIN = 70,
				WEATHER_STORM = 26,
				WEATHER_DOWNPOURWARNING = 4 // Fun times ahead
				)
		if("autumn")
			transition_chances = list(
				WEATHER_RAIN = 45,
				WEATHER_STORM = 30,
				WEATHER_DOWNPOURWARNING = 4, // Fun times ahead
				WEATHER_HAIL = 15,
				WEATHER_OVERCAST = 6
				)
		if("winter")
			transition_chances = list(
				WEATHER_RAIN = 55,
				WEATHER_STORM = 10,
				WEATHER_DOWNPOURWARNING = 3, // Fun times ahead
				WEATHER_HAIL = 25,
				WEATHER_OVERCAST = 7
				)
	. = ..()

/datum/weather/pyraxis/storm/process_effects()
	..()
	handle_lightning()
	wet_plating(60)
	fill_vats(20,40,16)

/datum/weather/pyraxis/storm/planet_effect(mob/living/L)
	if(L.z in holder.our_planet.expected_z_levels)
		var/turf/T = get_turf(L)
		if(!T.is_outdoors())
			return // They're indoors so no need to rain on them.

		// Lazy wind code
		if(prob(4))
			if(istype(L.get_active_hand(), /obj/item/melee/umbrella))
				var/obj/item/melee/umbrella/U = L.get_active_hand()
				if(U.open)
					to_chat(L, span_danger("You struggle to keep hold of your umbrella!"))
					L.Stun(10)
					playsound(L, 'sound/effects/rustle1.ogg', 100, 1)	// Closest sound I've got to "Umbrella in the wind"
			else if(istype(L.get_inactive_hand(), /obj/item/melee/umbrella))
				var/obj/item/melee/umbrella/U = L.get_inactive_hand()
				if(U.open)
					to_chat(L, span_danger("A gust of wind yanks the umbrella from your hand!"))
					playsound(L, 'sound/effects/rustle1.ogg', 100, 1)
					L.drop_from_inventory(U)
					U.toggle_umbrella()
					U.throw_at(get_edge_target_turf(U, pick(GLOB.alldirs)), 8, 1, L)

		// If they have an open umbrella, it'll guard from rain
		if(istype(L.get_active_hand(), /obj/item/melee/umbrella))
			var/obj/item/melee/umbrella/U = L.get_active_hand()
			if(U.open)
				if(show_message)
					to_chat(L, span_notice("Rain showers loudly onto your umbrella!"))
				return
		else if(istype(L.get_inactive_hand(), /obj/item/melee/umbrella))
			var/obj/item/melee/umbrella/U = L.get_inactive_hand()
			if(U.open)
				if(show_message)
					to_chat(L, span_notice("Rain showers loudly onto your umbrella!"))
				return

		if(show_message)
			to_chat(L, effect_message)

		L.water_act(3)

/datum/weather/pyraxis/downpourwarning
	name = "early extreme monsoon"
	light_modifier = 0.4
	timer_low_bound = 1
	timer_high_bound = 2

	transition_chances = list(
		WEATHER_DOWNPOUR = 100
	)
	observed_message = "It looks like a very bad storm is about to approach."
	transition_messages = list(
		span_danger("Inky black clouds cover the sky in a eerie rumble, get to cover!")
	)
	outdoor_sounds_type = /datum/looping_sound/weather/rainrumble
	indoor_sounds_type = /datum/looping_sound/weather/rainrumble/indoors
	color_grading = COLORTINT_DARK

/datum/weather/pyraxis/downpour
	name = "extreme monsoon"
	icon_state = "downpour"
	light_modifier = 0.3
	timer_low_bound = 1
	timer_high_bound = 1
	wind_high = 4
	wind_low = 2
	flight_failure_modifier = 100
	effect_message = span_warning("Extreme rain is knocking you down!")
	effect_flags = HAS_PLANET_EFFECT|EFFECT_ONLY_LIVING

	min_lightning_cooldown = 5 SECONDS
	max_lightning_cooldown = 15 SECONDS

	transition_chances = list(
		WEATHER_DOWNPOURFATAL = 95,
		WEATHER_STORM = 5
	)
	observed_message = "Extreme rain is crushing you, get to cover!"
	transition_messages = list(
		span_danger("An immense downpour of falls on top of of the planet crushing anything in its path!")
	)
	outdoor_sounds_type = /datum/looping_sound/weather/rainheavy
	indoor_sounds_type = /datum/looping_sound/weather/rainindoors
	color_grading = COLORTINT_DARK

	hazardous_weather = TRUE

/datum/weather/pyraxis/downpour/process_effects()
	..()
	handle_lightning()
	wet_plating(70)
	fill_vats(25,50,25)

/datum/weather/pyraxis/downpour/planet_effect(mob/living/L)
	if(L.z in holder.our_planet.expected_z_levels)
		var/turf/T = get_turf(L)
		if(!T.is_outdoors())
			return // They're indoors, so no need to rain on them.

		// If they have an open umbrella, knock it off
		var/obj/item/melee/umbrella/U = L.get_active_hand()
		if(!istype(U) || !U.open)
			U = L.get_inactive_hand()
		if(istype(U) && U.open)
			if(show_message)
				to_chat(L, span_notice("The storm pushes the umbrella out of your hands!"))
				L.drop_both_hands()

		L.water_act(2)
		L.Weaken(3)

		if(show_message)
			to_chat(L, effect_message)

		L.water_act(5)

/datum/weather/pyraxis/downpourfatal
	name = "fatal monsoon"
	icon_state = "downpourfatal"
	light_modifier = 0.15
	timer_low_bound = 1
	timer_high_bound = 3
	wind_high = 6
	wind_low = 4
	flight_failure_modifier = 100
	effect_message = span_warning("Extreme rain is crushing you!")
	effect_flags = HAS_PLANET_EFFECT|EFFECT_ONLY_LIVING

	min_lightning_cooldown = 1 SECONDS
	max_lightning_cooldown = 3 SECONDS

	transition_chances = list(
		WEATHER_DOWNPOURFATAL = 65,
		WEATHER_RAIN = 25,
		WEATHER_CLEAR = 10
	)
	observed_message = "Extreme rain is crushing you, get to cover!"
	//No transition message, supposed to be the 'actual' rain
	outdoor_sounds_type = /datum/looping_sound/weather/rainextreme
	indoor_sounds_type = /datum/looping_sound/weather/rainindoors
	color_grading = COLORTINT_DARK

	hazardous_weather = TRUE

/datum/weather/pyraxis/downpourfatal/process_effects()
	..()
	handle_lightning()
	wet_plating(60)
	fill_vats(45,60,35)

/datum/weather/pyraxis/downpourfatal/planet_effect(mob/living/L)
	if(L.z in holder.our_planet.expected_z_levels)
		var/turf/T = get_turf(L)
		if(!T.is_outdoors())
			return // They're indoors, so no need to rain on them.

		// If they have an open umbrella, knock it off
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/obj/item/melee/umbrella/U = L.get_active_hand()
			if(!istype(U) || !U.open)
				U = L.get_inactive_hand()

			if(istype(U) && U.open)
				if(show_message)
					to_chat(L, span_notice("The rain pushes the umbrella off your hands!"))
					H.drop_both_hands()

		var/target_zone = pick(BP_ALL)
		var/amount_blocked = L.run_armor_check(target_zone, "melee")

		var/damage = rand(10,30) //Ow

		if(amount_blocked >= 30)
			return

		L.apply_damage(damage, BRUTE, target_zone, amount_blocked, used_weapon = "rain bludgoning")
		L.Weaken(3)

		if(show_message)
			to_chat(L, effect_message)

		L.water_act(6)

/datum/weather/pyraxis/hail
	name = "hail"
	icon_state = "hail"
	temp_high = 263.15  // -10c
	temp_low = 258.15 // -15c
	light_modifier = 0.3
	flight_failure_modifier = 15
	timer_low_bound = 2
	timer_high_bound = 5
	effect_message = span_warning("The hail smacks into you!")
	effect_flags = HAS_PLANET_EFFECT|EFFECT_ONLY_LIVING
	outdoor_sounds_type = /datum/looping_sound/weather/outside_snow
	indoor_sounds_type = /datum/looping_sound/weather/inside_snow

	transition_chances = list(
		WEATHER_RAIN = 20,
		WEATHER_STORM = 5,
		WEATHER_HAIL = 4,
		WEATHER_OVERCAST = 70,
		WEATHER_CLEAR = 1
		)
	observed_message = "Frozen acid is falling from the sky."
	transition_messages = list(
		"Frozen acid begins to fall from the sky.",
		"It begins to hail.",
		"An intense chill is felt, and chunks of frozen acid start to fall from the sky, towards you."
	)
	color_grading = COLORTINT_CHILL

/datum/weather/pyraxis/hail/planet_effect(mob/living/L)
	if(L.z in holder.our_planet.expected_z_levels)
		var/turf/T = get_turf(L)
		if(!T.is_outdoors())
			return // They're indoors or dead, so no need to pelt them with ice.

		// If they have an open umbrella, it'll guard from hail
		var/obj/item/melee/umbrella/U = L.get_active_hand()
		if(!istype(U) || !U.open)
			U = L.get_inactive_hand()

		if(istype(U) && U.open)
			if(show_message)
				to_chat(L, span_notice("Hail patters onto your umbrella."))
			return

		var/target_zone = pick(BP_ALL)
		var/amount_blocked = L.run_armor_check(target_zone, "melee")

		var/damage = rand(1,3)

		if(amount_blocked >= 30)
			return // No need to apply damage. Hardhats are 30. They should probably protect you from hail on your head.
			//Voidsuits are likewise 40, and riot, 80. Clothes are all less than 30.

		L.apply_damage(damage, BRUTE, target_zone, amount_blocked, used_weapon = "hail")

		// show transition messages
		if(show_message)
			to_chat(L, effect_message)

/datum/weather/pyraxis/light_snow
	name = "light snow"
	icon_state = "snowfall_light"
	temp_high = T0C
	temp_low = 263.15 // -10c
	wind_high = 1
	wind_low = 0
	light_modifier = 0.8
	transition_chances = list() // See New() for seasonal transitions
	observed_message = "It is snowing lightly."
	transition_messages = list(
		"Small snowflakes begin to fall from above.",
		"It begins to snow lightly.",
		)
	color_grading = COLORTINT_CHILL

/datum/weather/pyraxis/light_snow/New()
	switch(GLOB.world_time_season)
		if("spring")
			transition_chances = list(
				WEATHER_LIGHT_SNOW = 50,
				WEATHER_CLEAR = 50
				)
		if("summer")
			transition_chances = list(
				WEATHER_LIGHT_SNOW = 10,
				WEATHER_CLEAR = 90
				)
		if("autumn")
			transition_chances = list(
				WEATHER_LIGHT_SNOW = 50,
				WEATHER_CLEAR = 50
				)
		if("winter")
			transition_chances = list(
				WEATHER_LIGHT_SNOW = 40,
				WEATHER_SNOW = 40,
				WEATHER_CLEAR = 20
				)
	. = ..()

/datum/weather/pyraxis/snow
	name = "moderate snow"
	icon_state = "snowfall_med"
	temp_high = 258.15 // -15c
	temp_low = 253.15 // -20c
	wind_high = 2
	wind_low = 0
	light_modifier = 0.5
	flight_failure_modifier = 5
	transition_chances = list(
		WEATHER_LIGHT_SNOW = 10,
		WEATHER_SNOW = 50,
		WEATHER_BLIZZARD = 30,
		WEATHER_HAIL = 5,
		WEATHER_CLEAR = 5
		)
	observed_message = "It is snowing."
	transition_messages = list(
		"It's starting to snow.",
		"The air feels much colder as snowflakes fall from above."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/outside_snow
	indoor_sounds_type = /datum/looping_sound/weather/inside_snow
	color_grading = COLORTINT_COLD

/datum/weather/pyraxis/blizzard
	name = "blizzard"
	icon_state = "snowfall_heavy"
	temp_high = 243.15 // -30c
	temp_low = 213.15 // -60c
	wind_high = 4
	wind_low = 2
	light_modifier = 0.3
	flight_failure_modifier = 10
	effect_message = span_warning("The ice shards cut into you!")
	effect_flags = HAS_PLANET_EFFECT|EFFECT_ONLY_LIVING
	transition_chances = list(
		WEATHER_SNOW = 45,
		WEATHER_BLIZZARD = 40,
		WEATHER_HAIL = 10,
		WEATHER_CLEAR = 5
		)
	observed_message = "A blizzard blows snow everywhere."
	transition_messages = list(
		"Strong winds howl around you as a blizzard appears.",
		"It starts snowing heavily, and it feels extremly cold now."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/outside_blizzard
	indoor_sounds_type = /datum/looping_sound/weather/inside_blizzard
	color_grading = COLORTINT_COLD

	hazardous_weather = TRUE

/datum/weather/pyraxis/blizzard/planet_effect(mob/living/L)
	if(L.z in holder.our_planet.expected_z_levels)
		var/turf/T = get_turf(L)
		if(!T.is_outdoors())
			return // They're indoors or dead, so no need to pelt them with ice.

		if(prob(10))
			// If they have an open umbrella, it'll guard from hail
			var/obj/item/melee/umbrella/U = L.get_active_hand()
			if(!istype(U) || !U.open)
				U = L.get_inactive_hand()
			if(istype(U) && U.open)
				if(prob(10))
					if(show_message)
						to_chat(L, span_notice("The storm pushes the umbrella out of your hands!"))
						L.drop_both_hands()
				else
					if(show_message)
						to_chat(L, span_notice("ice shards patter onto your umbrella."))
				return

			var/target_zone = pick(BP_ALL)
			var/amount_blocked = L.run_armor_check(target_zone, "melee")

			var/damage = rand(1,3)

			if(amount_blocked >= 30)
				return // No need to apply damage. Hardhats are 30. They should probably protect you from hail on your head.
				//Voidsuits are likewise 40, and riot, 80. Clothes are all less than 30.

			L.apply_damage(damage, BRUTE, target_zone, amount_blocked, used_weapon = "sharp ice")

			// show transition messages
			if(show_message)
				to_chat(L, effect_message)

/////////////////////////////////////////////////////////////////////////////////////////
// EVENT WEATHERS

/////////////////////////////////////////////////////////////////////////////////////////
// EXTREME BLIZZARD
/////////////////////////////////////////////////////////////////////////////////////////
/datum/weather/pyraxis/blizzard/hidden_dangerous
	name = "extreme blizzard"
	temp_high = 213.15 // -60c
	temp_low = 183.15 // -90c
	light_modifier = 0.1
	flight_failure_modifier = 10
	transition_chances = list(
		WEATHER_LONGBLIZZARD = 98,
		WEATHER_BLIZZARD = 2,
		)
	color_grading = COLORTINT_EXTREMECOLD
	observed_message = "The blizzard grows more intense."
	transition_messages = list(
		"The blizzard's wind chills you to your bones."
	)
	hazardous_weather = TRUE

/////////////////////////////////////////////////////////////////////////////////////////
// EVIL DARKNESS
/////////////////////////////////////////////////////////////////////////////////////////
/datum/weather/pyraxis/clear/hidden_evildarkness
	name = "frigid darkness"
	temp_high = 120
	temp_low = 100
	wind_high = 0
	wind_low = 0
	light_modifier = 0.01
	transition_chances = list(
		WEATHER_COLDDARKNESS = 99,
		WEATHER_CLEAR = 1,
		)
	color_grading = COLORTINT_UNDERDARK
	observed_message = "The world feels still."
	transition_messages = list(
		"Everything around you seems to stop, it's quiet enough to hear the air creaking under the weight of something you cannot see."
	)
	hazardous_weather = TRUE
