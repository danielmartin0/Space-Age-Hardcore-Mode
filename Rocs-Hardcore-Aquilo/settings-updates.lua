data:extend({
	{
		type = "bool-setting",
		name = "rocs-hardcore-aquilo-fission-prevented",
		setting_type = "startup",
		default_value = true,
		order = "a",
	},
	{
		type = "bool-setting",
		name = "rocs-hardcore-aquilo-fluoroketone-requires-light-oil",
		setting_type = "startup",
		default_value = true,
		order = "b",
	},
})

data.raw["bool-setting"]["PlanetsLib-enable-temperature"].forced_value = true
