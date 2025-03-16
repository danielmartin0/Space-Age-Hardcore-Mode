if settings.startup["rocs-hardcore-gleba-cargo-drops-need-research"].value then
	local gleba_cargo_tech =
		PlanetsLib.cargo_drops_technology_base("gleba", "__space-age__/graphics/technology/gleba.png", 256)
	gleba_cargo_tech.prerequisites = { "agricultural-science-pack" }
	gleba_cargo_tech.unit = {
		count = 2500,
		time = 60,
		ingredients = {
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
			{ "chemical-science-pack", 1 },
			{ "space-science-pack", 1 },
			{ "agricultural-science-pack", 1 },
		},
	}

	data:extend({ gleba_cargo_tech })
end
