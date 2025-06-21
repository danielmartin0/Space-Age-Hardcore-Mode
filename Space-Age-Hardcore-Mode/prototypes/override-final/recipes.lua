--== More expensive recipes ==--

if settings.startup["rocs-hardcore-expensive-utility-science"].value then
	for _, recipe in pairs(data.raw.recipe) do
		local has_utility_science = false

		for _, result in pairs(recipe.results or {}) do
			if result.name == "utility-science-pack" then
				has_utility_science = true
				break
			end
		end

		if has_utility_science then
			if recipe.ingredients then
				for _, ingredient in pairs(recipe.ingredients) do
					ingredient.amount = ingredient.amount * 3
				end
			end
			if recipe.energy_required then
				recipe.energy_required = recipe.energy_required * 1.5
			end
		end
	end
end

-- --== Recycling ==--

-- for _, recipe in pairs(data.raw.recipe) do
-- 	if recipe.category == "recycling" and recipe.category ~= "recycling-or-hand-crafting" then
-- 		if recipe.energy_required then
-- 			recipe.energy_required = recipe.energy_required * settings.item_recycling_time_multiplier
-- 		end
-- 	end
-- end
