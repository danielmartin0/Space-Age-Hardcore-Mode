local util = require("util")

if settings.startup["rocs-hardcore-fulgora-lightning-rods-need-research"].value then
	local lightning_rod_tech = util.table.deepcopy(data.raw.technology["lightning-collector"])
	lightning_rod_tech.name = "lightning-rod"
	lightning_rod_tech.prerequisites = { "electromagnetic-science-pack" }
	lightning_rod_tech.icon = "__Rocs-Hardcore-Fulgora__/graphics/technology/lightning-rod.png"
	lightning_rod_tech.icon_size = 352
	lightning_rod_tech.effects = {
		{
			type = "unlock-recipe",
			recipe = "lightning-rod",
		},
	}
	lightning_rod_tech.unit = {
		count = 100,
		ingredients = {
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
			{ "chemical-science-pack", 1 },
			{ "electromagnetic-science-pack", 1 },
		},
		time = 60,
	}
	data:extend({ lightning_rod_tech })
end

if settings.startup["rocs-hardcore-fulgora-make-ruins-placeable"].value then
	local fulgoran_ruin_attractor = util.table.deepcopy(data.raw.item["lightning-rod"])
	fulgoran_ruin_attractor.name = "fulgoran-ruin-attractor"

	fulgoran_ruin_attractor.icon = "__space-age__/graphics/icons/fulgoran-ruin-attractor.png"
	fulgoran_ruin_attractor.icon_size = 64
	fulgoran_ruin_attractor.order = "0[fulgoran-ruin-attractor]"
	fulgoran_ruin_attractor.place_result = "fulgoran-ruin-attractor"

	data:extend({ fulgoran_ruin_attractor })
end

if settings.startup["rocs-hardcore-fulgora-a-cargo-drops-need-research"].value then
	local fulgora_cargo_tech =
		PlanetsLib.cargo_drops_technology_base("fulgora", "__space-age__/graphics/technology/fulgora.png", 256)
	fulgora_cargo_tech.prerequisites = { "electromagnetic-science-pack" }
	fulgora_cargo_tech.unit = {
		count = 2500,
		time = 60,
		ingredients = {
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
			{ "chemical-science-pack", 1 },
			{ "space-science-pack", 1 },
			{ "electromagnetic-science-pack", 1 },
		},
	}

	data:extend({ fulgora_cargo_tech })
end
