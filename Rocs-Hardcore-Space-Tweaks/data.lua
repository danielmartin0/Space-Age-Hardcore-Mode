local util = require("util")

local function merge(old, new)
	old = util.table.deepcopy(old)

	for k, v in pairs(new) do
		if v == "nil" then
			old[k] = nil
		else
			old[k] = v
		end
	end

	return old
end

if settings.startup["no-underground-pipes-on-platforms"].value then
	local tech = merge(data.raw.technology["logistics"], {
		enabled = false,
		name = "underground-pipes-on-space-platforms",
		icon = "__Rocs-Hardcore-Space-Tweaks__/graphics/technology/underground-pipes-on-space-platforms.png",
		icon_size = 256,
		prerequisites = {
			"space-science-pack",
		},
		effects = {
			{
				type = "nothing",
				effect_description = { "no-undergrounds-on-platforms.tech-description-pipes" },
			},
		},
		research_trigger = {
			type = "mine-entity",
			entity = "medium-oxide-asteroid",
		},
	})
	data:extend({ tech })
end

if settings.startup["no-underground-belts-on-platforms"].value then
	local tech = merge(data.raw.technology["logistics"], {
		name = "underground-belts-on-space-platforms",
		icon = "__Rocs-Hardcore-Space-Tweaks__/graphics/technology/underground-belts-on-space-platforms.png",
		icon_size = 256,
		prerequisites = {
			"underground-pipes-on-space-platforms",
			"metallurgic-science-pack",
			"electromagnetic-science-pack",
			"agricultural-science-pack",
			"utility-science-pack",
		},
		effects = {
			{
				type = "nothing",
				effect_description = { "no-undergrounds-on-platforms.tech-description-belts" },
			},
		},
		unit = {
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
		},
	})
	data:extend({ tech })
end
