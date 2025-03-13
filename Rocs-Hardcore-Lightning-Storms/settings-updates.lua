data:extend({
	{
		type = "bool-setting",
		name = "rocs-hardcore-lightning-damages-locomotives",
		setting_type = "startup",
		default_value = true,
	},
	{
		type = "double-setting",
		name = "rocs-hardcore-lightning-damage-multiplier",
		setting_type = "startup",
		default_value = 2.5,
		minimum_value = 0.0001,
		maximum_value = 10000,
	},
	{
		type = "bool-setting",
		name = "rocs-hardcore-lightning-day-length-variations",
		setting_type = "runtime-global",
		default_value = true,
	},
})
