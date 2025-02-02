local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

data:extend({
	{
		type = "space-connection",
		name = "vulcanus-fulgora",
		subgroup = "planet-connections",
		from = "vulcanus",
		to = "fulgora",
		order = "b",
		length = 15000,
		asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_fulgora),
	},
})

if mods["tenebris"] then
	data:extend({
		{
			type = "space-connection",
			name = "tenebris-aquilo",
			subgroup = "planet-connections",
			from = "tenebris",
			to = "aquilo",
			order = "b",
			length = 15000,
			asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo),
		},
	})
	data:extend({
		{
			type = "space-connection",
			name = "tenebris-solar-system-edge",
			subgroup = "planet-connections",
			from = "tenebris",
			to = "solar-system-edge",
			order = "b",
			length = 500 * 1000,
			asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.aquilo_solar_system_edge),
		},
	})
end

if mods["maraxsis"] then
	data:extend({
		{
			type = "space-connection",
			name = "gleba-maraxsis",
			subgroup = "planet-connections",
			from = "gleba",
			to = "maraxsis",
			order = "g",
			length = 30 * 1000,
			asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo),
		},
	})

	data:extend({
		{
			type = "space-connection",
			name = "maraxsis-aquilo",
			subgroup = "planet-connections",
			from = "maraxsis",
			to = "aquilo",
			order = "g",
			length = 25 * 1000,
			asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo),
		},
	})
end

if mods["naufulglebunusilo"] then
	data:extend({
		{
			type = "space-connection",
			name = "naufulglebunusilo-solar-system-edge",
			subgroup = "planet-connections",
			from = "naufulglebunusilo",
			to = "solar-system-edge",
			order = "b",
			length = 300 * 1000,
			asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.aquilo_solar_system_edge),
		},
	})
end

if mods["maraxsis"] and mods["naufulglebunusilo"] then
	data:extend({
		{
			type = "space-connection",
			name = "maraxsis-naufulglebunusilo",
			subgroup = "planet-connections",
			from = "maraxsis",
			to = "naufulglebunusilo",
			order = "g",
			length = 200 * 1000,
			asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.aquilo_solar_system_edge),
		},
	})
end

if mods["tenebris"] and mods["naufulglebunusilo"] then
	data:extend({
		{
			type = "space-connection",
			name = "tenebris-naufulglebunusilo",
			subgroup = "planet-connections",
			from = "tenebris",
			to = "naufulglebunusilo",
			order = "g",
			length = 220 * 1000,
			asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.aquilo_solar_system_edge),
		},
	})
end
