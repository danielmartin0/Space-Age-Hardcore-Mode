if settings.startup["rocs-hardcore-fulgora-lightning-rods-need-research"].value then
	local effects = data.raw.technology["planet-discovery-fulgora"].effects
	for i = #effects, 1, -1 do
		if effects[i].type == "unlock-recipe" and effects[i].recipe == "lightning-rod" then
			table.remove(effects, i)
		end
	end

	table.insert(data.raw.technology["lightning-collector"].prerequisites, "lightning-rod")

	table.insert(data.raw["simple-entity"]["fulgoran-ruin-stonehenge"].minable.results, {
		type = "item",
		name = "solar-panel",
		amount = 1,
	})

	table.insert(data.raw["simple-entity"]["fulgoran-ruin-big"].minable.results, {
		type = "item",
		name = "solar-panel",
		amount = 1,
	})

	table.insert(data.raw["simple-entity"]["fulgoran-ruin-huge"].minable.results, {
		type = "item",
		name = "solar-panel",
		amount = 3,
	})

	table.insert(data.raw["simple-entity"]["fulgoran-ruin-colossal"].minable.results, {
		type = "item",
		name = "solar-panel",
		amount = 8,
	})

	table.insert(data.raw["simple-entity"]["fulgoran-ruin-vault"].minable.results, {
		type = "item",
		name = "solar-panel",
		amount = 15,
	})

	-- Buff ice production, as we'll need it for power:
	local recipe = data.raw.recipe["scrap-recycling"]
	if recipe and recipe.results then
		for _, result in pairs(recipe.results) do
			if result.name == "ice" and result.probability then
				result.probability = result.probability * 1.4
			end
		end
	end
end

if settings.startup["rocs-hardcore-fulgora-make-ruin-attractors-generate-power"].value then
	data.raw["lightning-attractor"]["fulgoran-ruin-attractor"].energy_source = {
		type = "electric",
		buffer_capacity = "20MJ",
		usage_priority = "primary-output",
		output_flow_limit = "100MJ",
		drain = "100kJ",
	}
	data.raw["lightning-attractor"]["fulgoran-ruin-attractor"].efficiency = 0.01
end

if settings.startup["rocs-hardcore-fulgora-increase-oil-walking-speed"].value then
	-- Picking up bodies happens more often due to the lightning:
	data.raw.tile["oil-ocean-shallow"].walking_speed_modifier = 1
	data.raw.tile["oil-ocean-deep"].walking_speed_modifier = 0.8
end

if settings.startup["rocs-hardcore-fulgora-make-ruins-placeable"].value then
	-- Make Fulgoran ruin attractors placeable:
	data.raw["lightning-attractor"]["fulgoran-ruin-attractor"].minable =
		{ mining_time = 0.1, result = "fulgoran-ruin-attractor" }
	data.raw["lightning-attractor"]["fulgoran-ruin-attractor"].subgroup = nil
end
