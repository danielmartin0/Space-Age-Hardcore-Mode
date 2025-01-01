if settings.startup["rocs-hardcore-a-cargo-pods-enable-mod"].value then
	table.insert(data.raw.technology["rocket-silo"].effects, {
		type = "unlock-recipe",
		recipe = "cargo-pod-nauvis",
	})

	table.insert(data.raw.technology["planet-discovery-fulgora"].effects, {
		type = "unlock-recipe",
		recipe = "cargo-pod-fulgora",
	})

	table.insert(data.raw.technology["planet-discovery-vulcanus"].effects, {
		type = "unlock-recipe",
		recipe = "cargo-pod-vulcanus",
	})

	table.insert(data.raw.technology["planet-discovery-gleba"].effects, {
		type = "unlock-recipe",
		recipe = "cargo-pod-gleba",
	})

	table.insert(data.raw.technology["planet-discovery-aquilo"].effects, {
		type = "unlock-recipe",
		recipe = "cargo-pod-aquilo",
	})
end
