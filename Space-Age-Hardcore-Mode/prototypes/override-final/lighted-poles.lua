if settings.startup["rocs-hardcore-disable-lighted-electric-poles"].value then
	-- Remove all recipes starting with "lighted-"
	for name, _ in pairs(data.raw.recipe) do
		if name and type(name) == "string" and string.sub(name, 1, 8) == "lighted-" then
			data.raw.recipe[name] = nil
		end
	end

	-- Remove all recipes starting with "item-lighted-"
	for name, _ in pairs(data.raw.recipe) do
		if name and type(name) == "string" and string.sub(name, 1, 13) == "item-lighted-" then
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

	-- Remove all items starting with "lighted-"
	for name, _ in pairs(data.raw.item) do
		if name and type(name) == "string" and string.sub(name, 1, 8) == "lighted-" then
			data.raw.item[name] = nil
		end
	end

	-- Remove all items starting with "lighted-"
	for name, _ in pairs(data.raw.item) do
		if name and type(name) == "string" and string.sub(name, 1, 13) == "item-lighted-" then
			data.raw.item[name] = nil
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
else
	local NAME_TO_ICON_SHIFT = {
		["lighted-small-electric-pole"] = { -0.4, 0 },
		["lighted-medium-electric-pole"] = { -0.2, -0.4 },
		["lighted-big-electric-pole"] = { 0, 0 },
		["lighted-substation"] = { 0.2, 0 },
	}

	-- Add icons on the entity pictures, since this 2.0 port apparently no longer does that:
	for _, entity in pairs(data.raw["electric-pole"]) do
		if string.sub(entity.name, 1, 8) == "lighted-" then
			local pictures = entity.pictures
			if pictures and pictures.layers then
				local new_layers = util.table.deepcopy(pictures.layers)

				local entity_collision_box = entity.collision_box
				local shift = {
					entity_collision_box[1][1] + 0.5,
					entity_collision_box[1][2] + 0.5 - (entity.drawing_box_vertical_extension or 0),
				}

				if NAME_TO_ICON_SHIFT[entity.name] then
					shift[1] = shift[1] + NAME_TO_ICON_SHIFT[entity.name][1]
					shift[2] = shift[2] + NAME_TO_ICON_SHIFT[entity.name][2]
				end

				new_layers[#new_layers + 1] = {
					filename = "__Space-Age-Hardcore-Mode__/graphics/entity-lighted-icons.png",
					priority = "extra-high",
					width = 32,
					height = 32,
					shift = shift,
					direction_count = 4,
					scale = 1.1,
					draw_as_glow = true,
				}

				pictures.layers = new_layers
			end
		end
	end
end
