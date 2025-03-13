local Public = {}

local MixedOreSettings = {
	DISABLED = 0,
	FULLY_MIXED = 1,
	HALF_MIXED = 2,
}

local STARTING_AREA_RADIUS = 120 + 15
local ORE_PATCH_SEPARATION_DISTANCE = 70

local ORE_NAMES = { "iron-ore", "copper-ore", "coal", "stone" }

script.on_event(defines.events.on_chunk_generated, function(event)
	local surface = event.surface

	if not (surface.valid and surface.name == "nauvis") then
		return
	end

	if
		not (
			surface.map_gen_settings.autoplace_controls
			and surface.map_gen_settings.autoplace_controls.stone
			and surface.map_gen_settings.autoplace_controls.coal
			and surface.map_gen_settings.autoplace_controls["copper-ore"]
			and surface.map_gen_settings.autoplace_controls["iron-ore"]
		)
	then
		return
	end

	if
		not (
			settings.global["rocs-hardcore-oresa-half-mixed-nauvis-ores"].value
			or settings.global["rocs-hardcore-oresb-fully-mixed-nauvis-ores"].value
		)
	then
		return
	end

	local richness = {}

	for _, ore_name in pairs(ORE_NAMES) do
		richness[ore_name] = surface.map_gen_settings.autoplace_controls[ore_name].richness
	end

	if not storage.ore_data then
		storage.ore_data = {
			locations_recorded = {
				["iron-ore"] = {},
				["copper-ore"] = {},
				["coal"] = {},
				["stone"] = {},
			},
			-- The initial amounts matter only near the start of the game:
			floating_amounts = {
				["iron-ore"] = Public.starting_ore_estimates["iron-ore"] * richness["iron-ore"],
				["copper-ore"] = Public.starting_ore_estimates["copper-ore"] * richness["copper-ore"],
				["coal"] = Public.starting_ore_estimates["coal"] * richness["coal"],
				["stone"] = Public.starting_ore_estimates["stone"] * richness["stone"],
			},
			next_patch_is_mixed = {
				["iron-ore"] = true,
				["copper-ore"] = true,
				["coal"] = true,
				["stone"] = true,
			},
		}
	end

	local setting = MixedOreSettings.DISABLED
	if settings.global["rocs-hardcore-oresb-fully-mixed-nauvis-ores"].value then
		setting = MixedOreSettings.FULLY_MIXED
	elseif settings.global["rocs-hardcore-oresa-half-mixed-nauvis-ores"].value then
		setting = MixedOreSettings.HALF_MIXED
	end

	local ores =
		surface.find_entities_filtered({ area = event.area, name = { "iron-ore", "copper-ore", "coal", "stone" } })

	for _, ore in pairs(ores) do
		local ore_name = ore.name
		local ore_pos = ore.position
		local is_mixed = false

		if setting == MixedOreSettings.FULLY_MIXED then
			is_mixed = true
		elseif setting == MixedOreSettings.HALF_MIXED then
			local distance_from_spawn = math.sqrt(ore_pos.x ^ 2 + ore_pos.y ^ 2)
			if distance_from_spawn < STARTING_AREA_RADIUS then
				break
			end

			local closest_dist_square = math.huge
			local closest_is_mixed = false

			for _, location in pairs(storage.ore_data.locations_recorded[ore_name]) do
				local dist_square = (ore_pos.x - location.pos.x) ^ 2 + (ore_pos.y - location.pos.y) ^ 2
				if dist_square < closest_dist_square then
					closest_dist_square = dist_square
					closest_is_mixed = location.is_mixed
				end
			end

			if closest_dist_square > ORE_PATCH_SEPARATION_DISTANCE ^ 2 then
				is_mixed = storage.ore_data.next_patch_is_mixed[ore_name]
				storage.ore_data.locations_recorded[ore_name][#storage.ore_data.locations_recorded[ore_name] + 1] = {
					pos = { x = ore_pos.x, y = ore_pos.y },
					is_mixed = is_mixed,
				}
				storage.ore_data.next_patch_is_mixed[ore_name] = not is_mixed
			else
				is_mixed = closest_is_mixed
			end
		end

		if is_mixed then
			local amount = ore.amount
			storage.ore_data.floating_amounts[ore_name] = storage.ore_data.floating_amounts[ore_name] + amount
			ore.destroy()

			local total_probability_units = 0
			for name, _ in pairs(storage.ore_data.floating_amounts) do
				local probability_units = Public.get_ore_probability_units(name, richness[name])
				if probability_units > 0 then
					total_probability_units = total_probability_units + probability_units
				end
			end

			local new_ore_name
			local random_value = math.random() * total_probability_units
			local current_sum = 0
			for name, _ in pairs(storage.ore_data.floating_amounts) do
				local probability_units = Public.get_ore_probability_units(name, richness[name])
				if probability_units > 0 then
					current_sum = current_sum + probability_units
				end
				if random_value <= current_sum then
					new_ore_name = name
					break
				end
			end

			if not new_ore_name then
				new_ore_name = ore_name
			end

			surface.create_entity({
				name = new_ore_name,
				position = ore_pos,
				amount = amount,
			})
			storage.ore_data.floating_amounts[new_ore_name] = storage.ore_data.floating_amounts[new_ore_name] - amount
		end
	end

	if #ores > 0 then
		surface.request_to_generate_chunks({ x = event.position.x + 16, y = event.position.y + 16 }, 1)
	end
end)

Public.starting_ore_estimates = {
	-- From observations of Factorio 2.0 ore gen:
	["iron-ore"] = 3 * 310 * 1000,
	["copper-ore"] = 3 * 325 * 1000,
	["coal"] = 3 * 325 * 1000,
	["stone"] = 3 * 165 * 1000,
}

function Public.get_ore_probability_units(ore_name, richness)
	local extra_buffer = Public.starting_ore_estimates[ore_name] * richness

	return math.max(0, storage.ore_data.floating_amounts[ore_name] + extra_buffer)
end

return Public
