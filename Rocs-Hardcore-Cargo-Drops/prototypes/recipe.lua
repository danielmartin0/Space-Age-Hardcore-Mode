data:extend({
	{
		type = "recipe",
		name = "cargo-pod-nauvis",
		enabled = false,
		ingredients = {
			{ type = "item", name = "steel-plate", amount = 30 },
			{ type = "item", name = "uranium-238", amount = 10 }, -- rocket takes 20
			{ type = "item", name = "iron-stick", amount = 8 },
		},
		energy_required = 10,
		results = { { type = "item", name = "cargo-pod-nauvis", amount = 1 } },
	},
	{
		type = "recipe",
		name = "cargo-pod-vulcanus",
		category = "metallurgy-or-assembling",
		enabled = false,
		ingredients = {
			{ type = "item", name = "steel-plate", amount = 30 },
			{ type = "item", name = "tungsten-plate", amount = 30 }, -- rocket takes 250
			{ type = "item", name = "iron-stick", amount = 8 },
		},
		energy_required = 10,
		results = { { type = "item", name = "cargo-pod-vulcanus", amount = 1 } },
	},
	{
		type = "recipe",
		name = "cargo-pod-fulgora",
		category = "electronics-or-assembling",
		enabled = false,
		ingredients = {
			{ type = "item", name = "steel-plate", amount = 30 },
			{ type = "item", name = "holmium-plate", amount = 15 }, -- rocket takes 1k
			{ type = "item", name = "iron-stick", amount = 8 },
		},
		energy_required = 10,
		results = { { type = "item", name = "cargo-pod-fulgora", amount = 1 } },
	},
	{
		type = "recipe",
		name = "cargo-pod-gleba",
		category = "organic-or-assembling",
		enabled = false,
		ingredients = {
			{ type = "item", name = "steel-plate", amount = 30 },
			{ type = "item", name = "bioflux", amount = 50 }, -- rocket takes 1k
			{ type = "item", name = "iron-stick", amount = 8 },
		},
		energy_required = 10,
		results = { { type = "item", name = "cargo-pod-gleba", amount = 1 } },
	},
	{
		type = "recipe",
		name = "cargo-pod-aquilo",
		category = "cryogenics-or-assembling",
		enabled = false,
		ingredients = {
			{ type = "item", name = "steel-plate", amount = 30 },
			{ type = "item", name = "ice", amount = 50 }, -- rocket takes 2k
			{ type = "item", name = "iron-stick", amount = 8 },
		},
		energy_required = 10,
		results = { { type = "item", name = "cargo-pod-aquilo", amount = 1 } },
	},
})
