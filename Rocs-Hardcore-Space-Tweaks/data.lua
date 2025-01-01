local util = require("util")

if settings.startup["no-underground-pipes-on-platforms"].value then
	local tech = util.table.deepcopy(data.raw.technology["logistics"])
	tech.name = "underground-pipes-on-space-platforms"
	tech.icon = "__Rocs-Hardcore-Space-Tweaks__/graphics/technology/underground-pipes-on-space-platforms.png"
	tech.icon_size = 256
	tech.prerequisites = {
		"space-science-pack",
	}
	tech.effects = {
		{
			type = "nothing",
			effect_description = { "no-undergrounds-on-platforms.tech-description-pipes" },
		},
	}
	tech.unit = {
		count = 5000,
		ingredients = {
			{ "space-science-pack", 1 },
		},
		time = 60,
	}
	data:extend({ tech })
end

if settings.startup["no-underground-belts-on-platforms"].value then
	local tech = util.table.deepcopy(data.raw.technology["logistics"])
	tech.name = "underground-belts-on-space-platforms"
	tech.icon = "__Rocs-Hardcore-Space-Tweaks__/graphics/technology/underground-belts-on-space-platforms.png"
	tech.icon_size = 256
	tech.prerequisites = {
		"underground-pipes-on-space-platforms",
		"metallurgic-science-pack",
		"electromagnetic-science-pack",
		"agricultural-science-pack",
		"utility-science-pack",
	}
	tech.effects = {
		{
			type = "nothing",
			effect_description = { "no-undergrounds-on-platforms.tech-description-belts" },
		},
	}
	tech.unit = {
		count = 5000,
		ingredients = {
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
			{ "chemical-science-pack", 1 },
			{ "utility-science-pack", 1 },
			{ "space-science-pack", 1 },
			{ "metallurgic-science-pack", 1 },
			{ "electromagnetic-science-pack", 1 },
			{ "agricultural-science-pack", 1 },
		},
		time = 60,
	}
	data:extend({ tech })
end
