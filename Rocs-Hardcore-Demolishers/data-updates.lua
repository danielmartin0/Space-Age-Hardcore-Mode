if settings.startup["rocs-hardcore-vulcanus-condensed-map"].value then
	data.raw["noise-expression"]["vulcanus_starting_area_radius"].expression = "(4 / 7) * 0.7 * 0.75"

	data.raw["noise-expression"]["demolisher_starting_area"].expression =
		"0 < starting_spot_at_angle{angle = vulcanus_mountains_angle - 5 * vulcanus_starting_direction,\z
													  distance = 100 * vulcanus_starting_area_radius + 32,\z
													  radius = (4 / 7) * 7 * 32,\z
													  x_distortion = 0,\z
													  y_distortion = 0}"

	data.raw["noise-expression"]["vulcanus_ore_dist"].expression = "max(1, distance / ((4 / 7) * 4000))"

	data.raw["noise-expression"]["vulcanus_calcite_size"].expression =
		"slider_rescale((1 / 2) * control:calcite:size, 2)"
	data.raw["noise-expression"]["vulcanus_starting_calcite"].expression =
		"starting_spot_at_angle{ angle = vulcanus_mountains_angle - 20 * vulcanus_starting_direction,\z
									distance = (1 / 6) * 350 * vulcanus_starting_area_radius,\z
									radius = (9 / 10) * 35 / 1.5 * vulcanus_calcite_size,\z
									x_distortion = 0.5 * vulcanus_resource_wobble_x,\z
									y_distortion = 0.5 * vulcanus_resource_wobble_y}"
	data.raw["noise-expression"]["vulcanus_calcite_region"].expression = "max(vulcanus_starting_calcite,\z
                          min(1 - vulcanus_starting_circle,\z
                          vulcanus_place_non_metal_spots(749, 12, 1,\z
                          vulcanus_calcite_size * min(1.2, vulcanus_ore_dist) * 25,\z
                          (2) * control:calcite:frequency,\z
                          vulcanus_mountains_resource_favorability)))"

	data.raw["noise-expression"]["vulcanus_starting_tungsten"].expression =
		"starting_spot_at_angle{ angle = vulcanus_basalts_angle - 10 * vulcanus_starting_direction,\z
									distance = 450 * vulcanus_starting_area_radius,\z
									radius = (5 / 6) * 30 / 1.5,\z
									x_distortion = 0.5 * vulcanus_resource_wobble_x,\z
									y_distortion = 0.5 * vulcanus_resource_wobble_y}"
	data.raw["noise-expression"]["vulcanus_tungsten_ore_region"].expression = "max(vulcanus_starting_tungsten,\z
                          min(1 - vulcanus_starting_circle,\z
                          vulcanus_place_metal_spots(789, 15, 2,\z
                          vulcanus_tungsten_ore_size * min(1.2, vulcanus_ore_dist) * 25,\z
                          (4 / 3) * control:tungsten_ore:frequency,\z
                          vulcanus_basalts_resource_favorability)))"

	data.raw["noise-expression"]["vulcanus_coal_size"].expression =
		"slider_rescale((3 / 4) * control:vulcanus_coal:size, 2)"
	data.raw["noise-expression"]["vulcanus_coal_region"].expression = "max(vulcanus_starting_coal,\z
                          min(1 - vulcanus_starting_circle,\z
                          vulcanus_place_non_metal_spots(782349, 12, 1,\z
                          vulcanus_coal_size * min(1.2, vulcanus_ore_dist) * 25,\z
                          (4 / 3) * control:vulcanus_coal:frequency,\z
                          vulcanus_ashlands_resource_favorability)))"

	-- Only the second starting patch is kept:
	data.raw["noise-expression"]["vulcanus_starting_sulfur"].expression =
		"starting_spot_at_angle{ angle = (-30) + vulcanus_mountains_angle + 10 * vulcanus_starting_direction,\z
                                              distance = (85 / 100) * 590 * vulcanus_starting_area_radius,\z
                                              radius = (7 / 5) * 30,\z
                                              x_distortion = 0.75 * vulcanus_resource_wobble_x,\z
                                              y_distortion = 0.75 * vulcanus_resource_wobble_y}"
	data.raw["noise-expression"]["vulcanus_sulfuric_acid_region"].expression = "max(vulcanus_starting_sulfur,\z
                          min(1 - vulcanus_starting_circle,\z
                          vulcanus_place_sulfur_spots(759, 9, 0,\z
                          vulcanus_sulfuric_acid_geyser_size * min(1.2, vulcanus_ore_dist) * 25,\z
                          (4 / 3) * control:sulfuric_acid_geyser:frequency,\z
                          vulcanus_mountains_sulfur_favorability)))"
end

if settings.startup["rocs-hardcore-vulcanus-condensed-map"].value then
	local rock_yield_multiplier = mods["Expensive-Mode"] and 5 or 3

	for _, result in pairs(data.raw["simple-entity"]["big-volcanic-rock"].minable.results) do
		result.amount_min = result.amount_min * rock_yield_multiplier
		result.amount_max = result.amount_max * rock_yield_multiplier
	end

	for _, result in pairs(data.raw["simple-entity"]["huge-volcanic-rock"].minable.results) do
		result.amount_min = result.amount_min * rock_yield_multiplier
		result.amount_max = result.amount_max * rock_yield_multiplier
	end
end

if settings.startup["rocs-hardcore-vulcanus-cooler-steam"].value then
	if
		data.raw.recipe["acid-neutralisation"]
		and data.raw.recipe["acid-neutralisation"].results
		and data.raw.recipe["acid-neutralisation"].results[1]
		and data.raw.recipe["acid-neutralisation"].results[1].name == "steam"
	then
		data.raw.recipe["acid-neutralisation"].results[1].temperature = 165
	end
end

if settings.startup["rocs-hardcore-advanced-casting-recipe"].value then
	data.raw.recipe["transport-belt"].category = "crafting"
	data.raw.recipe["underground-belt"].category = "crafting"
	data.raw.recipe["splitter"].category = "crafting"
	data.raw.recipe["fast-transport-belt"].category = "crafting"
	data.raw.recipe["fast-underground-belt"].category = "crafting"
	data.raw.recipe["fast-splitter"].category = "crafting"
	data.raw.recipe["express-transport-belt"].category = "crafting-with-fluid"
	data.raw.recipe["express-underground-belt"].category = "crafting-with-fluid"
	data.raw.recipe["express-splitter"].category = "crafting-with-fluid"
	data.raw.recipe["foundry"].category = "crafting-with-fluid"

	if mods["Rocs-Hardcore-Cargo-Drops"] then
		data.raw.recipe["cargo-pod-vulcanus"].category = "crafting"
		-- For consistency in the 'crafted in' tooltip":
		data.raw.recipe["cargo-pod-vulcanus"].localised_name = {
			"",
			{ "item-name." .. data.raw.item["cargo-pod-vulcanus"].name },
			{ "rocs-hardcore-vulcanus.non-metallurgy-recipe-suffix" },
		}

		local recipe = util.table.deepcopy(data.raw.recipe["cargo-pod-vulcanus"])
		recipe.category = "metallurgy"
		recipe.enabled = false
		recipe.localised_name = {
			"",
			{ "item-name." .. recipe.name },
			{ "rocs-hardcore-vulcanus.metallurgy-recipe-suffix" },
		}
		recipe.localised_description = { "item-description." .. recipe.name }
		recipe.hide_from_player_crafting = true
		recipe.allow_as_intermediate = false
		recipe.name = "cargo-pod-vulcanus-metallurgy"
		data:extend({ recipe })

		table.insert(data.raw.technology["advanced-casting"].effects, {
			type = "unlock-recipe",
			recipe = "cargo-pod-vulcanus-metallurgy",
		})
	end

	local foundry_tech = data.raw.technology["foundry"]
	if foundry_tech and foundry_tech.effects then
		local new_effects = {}
		for _, effect in pairs(foundry_tech.effects) do
			if
				effect.type ~= "unlock-recipe"
				or not (
					effect.recipe == "concrete-from-molten-iron"
					or effect.recipe == "casting-low-density-structure"
					or effect.recipe == "casting-steel"
					or effect.recipe == "casting-iron-gear-wheel"
					or effect.recipe == "casting-iron-stick"
					or effect.recipe == "casting-pipe"
					or effect.recipe == "casting-pipe-to-ground"
					or effect.recipe == "casting-copper-cable"
				)
			then
				table.insert(new_effects, effect)
			end
		end

		foundry_tech.effects = new_effects
	end

	local turbo_tech = data.raw.technology["turbo-transport-belt"]
	if turbo_tech then
		table.insert(turbo_tech.prerequisites, "advanced-casting")
	end
end

if settings.startup["rocs-hardcore-demolishers-disable-no-lava-in-pipes"].value then
	data.raw["offshore-pump"]["lava-pump"].created_effect = {
		type = "direct",
		action_delivery = {
			type = "instant",
			source_effects = {
				type = "script",
				effect_id = "hard-mode-replace-lava-pump",
			},
		},
	}
end
