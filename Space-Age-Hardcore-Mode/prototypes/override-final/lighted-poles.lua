if settings.startup["rocs-hardcore-disable-lighted-electric-poles"].value then
	-- Remove all items starting with "lighted-"
	for name, _ in pairs(data.raw.item) do
		if name and type(name) == "string" and string.sub(name, 1, 8) == "lighted-" then
			data.raw.item[name] = nil
		end
	end

	-- Remove all recipes starting with "lighted-"
	for name, _ in pairs(data.raw.recipe) do
		if name and type(name) == "string" and string.sub(name, 1, 8) == "lighted-" then
			data.raw.recipe[name] = nil
		end
	end

	-- Remove all entities starting with "lighted-" from all entity types
	for _, entity_type in pairs(data.raw) do
		if type(entity_type) == "table" then
			for name, _ in pairs(entity_type) do
				if name and type(name) == "string" and string.sub(name, 1, 8) == "lighted-" then
					entity_type[name] = nil
				end
			end
		end
	end

	-- Remove any technology effects that unlock recipes starting with "lighted-"
	for _, tech in pairs(data.raw["technology"]) do
		if tech.effects then
			local new_effects = {}
			for _, effect in pairs(tech.effects) do
				if
					effect.type ~= "unlock-recipe"
					or not (
						effect.recipe
						and type(effect.recipe) == "string"
						and string.sub(effect.recipe, 1, 8) == "lighted-"
					)
				then
					table.insert(new_effects, effect)
				end
			end
			tech.effects = new_effects
		end
	end
end
