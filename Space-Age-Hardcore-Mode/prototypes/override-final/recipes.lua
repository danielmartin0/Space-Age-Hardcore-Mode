--== More expensive recipes ==--

if settings.startup["rocs-hardcore-expensive-utility-science"].value then
	local recipe = data.raw.recipe["utility-science-pack"]
	if recipe and recipe.ingredients then
		for _, ingredient in pairs(recipe.ingredients) do
			ingredient.amount = ingredient.amount * 3
		end
		recipe.energy_required = recipe.energy_required * 1.5
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
