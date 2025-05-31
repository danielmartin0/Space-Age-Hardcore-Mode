if settings.startup["rocs-hardcore-aquilo-fission-prevented"].value then
	for _, reactor in pairs(data.raw["reactor"]) do
		if reactor.energy_source.type == "burner" then
			local contains_chemical_fuel_category = false
			for _, fuel_category in pairs(reactor.energy_source.fuel_categories) do
				if fuel_category == "chemical" or fuel_category == "chemical-or-radiative" then -- Cerys compat
					contains_chemical_fuel_category = true
					break
				end
			end

			if not contains_chemical_fuel_category then
				PlanetsLib.restrict_surface_conditions(reactor, {
					property = "temperature",
					min = 259,
				})
			end
		end
	end
end

if settings.startup["rocs-hardcore-aquilo-fluoroketone-requires-light-oil"].value then
	local recipe = data.raw["recipe"]["fluoroketone"]
	if recipe then
		local has_light_oil = false
		for _, ingredient in pairs(recipe.ingredients) do
			if ingredient.name == "light-oil" then
				has_light_oil = true
				break
			end
		end

		if not has_light_oil then
			local new_ingredients = {}
			for _, ingredient in pairs(recipe.ingredients) do
				if ingredient.name ~= "solid-fuel" then
					table.insert(new_ingredients, ingredient)
				end
			end
			table.insert(new_ingredients, { type = "fluid", name = "light-oil", amount = 20 })
			recipe.ingredients = new_ingredients
		end
	end
end

data.raw["noise-expression"]["aquilo_starting_island"].expression =
	"1 - 1.4 * distance * (aquilo_segmentation_multiplier / 100)"
