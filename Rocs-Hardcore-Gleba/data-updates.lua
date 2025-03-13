if settings.startup["rocs-hardcore-gleba-push-back-heating-tower"].value then
	data.raw.technology["heating-tower"].prerequisites = {
		"agricultural-science-pack",
	}
	data.raw.technology["heating-tower"].research_trigger = nil
	data.raw.technology["heating-tower"].unit = {
		count = 100,
		ingredients = {
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
			{ "chemical-science-pack", 1 },
			{ "agricultural-science-pack", 1 },
		},
		time = 60,
	}
end

if settings.startup["rocs-hardcore-gleba-move-forward-coal-synthesis"].value then
	for i, effect in ipairs(data.raw.technology["rocket-turret"].effects) do
		if effect.recipe == "coal-synthesis" then
			table.remove(data.raw.technology["rocket-turret"].effects, i)
			break
		end
	end

	table.insert(data.raw.technology["biochamber"].effects, { type = "unlock-recipe", recipe = "coal-synthesis" })
end

local discovery_tech = data.raw.technology["planet-discovery-gleba"]
if discovery_tech and discovery_tech.prerequisites then
	table.insert(discovery_tech.prerequisites, "rocketry")
end
