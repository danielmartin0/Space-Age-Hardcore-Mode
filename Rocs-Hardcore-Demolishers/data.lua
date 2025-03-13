local util = require("util")

if settings.startup["rocs-hardcore-advanced-casting-recipe"].value then
	data:extend({
		{
			type = "technology",
			name = "advanced-casting",
			icon = "__Rocs-Hardcore-Demolishers__/graphics/technology/advanced-casting.png",
			icon_size = 256,
			prerequisites = {
				"metallurgic-science-pack",
			},
			unit = {
				count = 100,
				ingredients = {
					{ "automation-science-pack", 1 },
					{ "logistic-science-pack", 1 },
					{ "chemical-science-pack", 1 },
					{ "metallurgic-science-pack", 1 },
				},
				time = 60,
			},
			effects = {
				{
					type = "unlock-recipe",
					recipe = "concrete-from-molten-iron",
				},
				{
					type = "unlock-recipe",
					recipe = "casting-low-density-structure",
				},
				{
					type = "unlock-recipe",
					recipe = "casting-steel",
				},
				{
					type = "unlock-recipe",
					recipe = "casting-iron-gear-wheel",
				},
				{
					type = "unlock-recipe",
					recipe = "casting-iron-stick",
				},
				{
					type = "unlock-recipe",
					recipe = "casting-pipe",
				},
				{
					type = "unlock-recipe",
					recipe = "casting-pipe-to-ground",
				},
				{
					type = "unlock-recipe",
					recipe = "casting-copper-cable",
				},
				{
					type = "unlock-recipe",
					recipe = "transport-belt-metallurgy",
				},
				{
					type = "unlock-recipe",
					recipe = "underground-belt-metallurgy",
				},
				{
					type = "unlock-recipe",
					recipe = "splitter-metallurgy",
				},
				{
					type = "unlock-recipe",
					recipe = "fast-transport-belt-metallurgy",
				},
				{
					type = "unlock-recipe",
					recipe = "fast-underground-belt-metallurgy",
				},
				{
					type = "unlock-recipe",
					recipe = "fast-splitter-metallurgy",
				},
				{
					type = "unlock-recipe",
					recipe = "express-transport-belt-metallurgy",
				},
				{
					type = "unlock-recipe",
					recipe = "express-underground-belt-metallurgy",
				},
				{
					type = "unlock-recipe",
					recipe = "express-splitter-metallurgy",
				},
				{
					type = "unlock-recipe",
					recipe = "foundry-metallurgy",
				},
			},
		},
	})

	-- Clone recipes so that we can enable and disable foundries to craft them independent of assemblers:
	local entity_recipes_to_clone = {
		"transport-belt",
		"underground-belt",
		"splitter",
		"fast-transport-belt",
		"fast-underground-belt",
		"fast-splitter",
		"express-transport-belt",
		"express-underground-belt",
		"express-splitter",
		"foundry",
	}

	for _, recipe_name in pairs(entity_recipes_to_clone) do
		local recipe = util.table.deepcopy(data.raw.recipe[recipe_name])
		recipe.category = "metallurgy"
		recipe.enabled = false
		recipe.localised_name = {
			"",
			{ "entity-name." .. recipe_name },
			{ "rocs-hardcore-vulcanus.metallurgy-recipe-suffix" },
		}
		recipe.localised_description = { "entity-description." .. recipe_name }
		recipe.hide_from_player_crafting = true
		recipe.allow_as_intermediate = false
		recipe.name = recipe_name .. "-metallurgy"

		data:extend({ recipe })
	end

	if mods["Rocs-Hardcore-Cargo-Drops"] then
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
end

if settings.startup["rocs-hardcore-demolishers-cargo-drops-need-research"].value then
	local vulcanus_cargo_tech =
		PlanetsLib.cargo_drops_technology_base("vulcanus", "__space-age__/graphics/technology/vulcanus.png", 256)
	vulcanus_cargo_tech.prerequisites = { "metallurgic-science-pack" }
	vulcanus_cargo_tech.unit = {
		count = 2500,
		time = 60,
		ingredients = {
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
			{ "chemical-science-pack", 1 },
			{ "space-science-pack", 1 },
			{ "metallurgic-science-pack", 1 },
		},
	}

	data:extend({ vulcanus_cargo_tech })
end
