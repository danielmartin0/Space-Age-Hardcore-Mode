if settings.startup["rocs-hardcore-z-infinite-tech-needs-cryogenic"].value then
	data:extend({
		{
			type = "technology",
			name = "infinite-research",
			icon = "__Rocs-Hardcore-Delayed-Tech-Tree__/graphics/technology/material-crystal-red-gem.png",
			icon_size = 256,
			prerequisites = {
				"cryogenic-science-pack",
			},
			effects = { {
				type = "nothing",
			} },
			unit = {
				count = 100,
				ingredients = {
					{ "cryogenic-science-pack", 1 },
				},
				time = 60,
			},
		},
	})
end
