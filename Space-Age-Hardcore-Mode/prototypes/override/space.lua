--== Asteroids ==--
for _, entity in pairs(data.raw.asteroid) do
	if
		entity.name == "medium-metallic-asteroid"
		or entity.name == "medium-carbonic-asteroid"
		or entity.name == "medium-oxide-asteroid"
		or entity.name == "medium-promethium-asteroid"
	then
		local extra = settings.startup["rocs-hardcore-spacec-medium-asteroid-extra-physical-resistance"].value

		if extra > 0 then
			entity.resistances = entity.resistances or {}

			local existing_physical_res = nil
			for _, resistance in pairs(entity.resistances) do
				if resistance.type == "physical" then
					existing_physical_res = resistance
					break
				end
			end

			if existing_physical_res then
				existing_physical_res.decrease = existing_physical_res.decrease + extra
			end
		end
	end
end

local asteroid_metallic_resources_multiplier = (
	1 + 0.5 * settings.startup["rocs-hardcore-spaceb-bonus-asteroid-health-percentage"].value / 100
)

if asteroid_metallic_resources_multiplier > 1 then
	if data.raw.recipe["metallic-asteroid-crushing"] then
		for _, result in pairs(data.raw.recipe["metallic-asteroid-crushing"].results or {}) do
			if result.name == "iron-ore" then
				result.amount = math.floor(result.amount * asteroid_metallic_resources_multiplier)
			end
		end
	end

	if data.raw.recipe["advanced-metallic-asteroid-crushing"] then
		for _, result in pairs(data.raw.recipe["advanced-metallic-asteroid-crushing"].results or {}) do
			if result.name == "iron-ore" then
				result.amount = math.floor(result.amount * asteroid_metallic_resources_multiplier)
			end
		end
	end
end

if settings.startup["rocs-hardcore-spaced-asteroids-early-copper-available"].value then
	if data.raw.technology["space-platform"] then
		table.insert(
			data.raw.technology["space-platform"].effects,
			{ type = "unlock-recipe", recipe = "advanced-metallic-asteroid-crushing" }
		)

		if data.raw.technology["advanced-asteroid-processing"] then
			local effects = data.raw.technology["advanced-asteroid-processing"].effects or {}
			for i, effect in ipairs(effects) do
				if effect.type == "unlock-recipe" and effect.recipe == "advanced-metallic-asteroid-crushing" then
					table.remove(effects, i)
					break
				end
			end
		end
	end
end

--== Space platform foundation ==--
if data.raw.tile["space-platform-foundation"] and data.raw.tile["space-platform-foundation"].weight then
	data.raw.tile["space-platform-foundation"].weight = data.raw.tile["space-platform-foundation"].weight
		* (1 + settings.startup["rocs-hardcore-spacea-bonus-platform-foundation-tile-weight-percentage"].value / 100)
end
