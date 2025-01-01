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
