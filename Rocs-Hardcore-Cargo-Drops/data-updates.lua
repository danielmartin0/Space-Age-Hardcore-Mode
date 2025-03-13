for _, planet in pairs({ "nauvis", "fulgora", "vulcanus", "gleba", "aquilo" }) do
	if data.raw.technology["planetslib-" .. planet .. "-cargo-drops"] then
		table.insert(data.raw.technology["planetslib-" .. planet .. "-cargo-drops"].effects, {
			type = "unlock-recipe",
			recipe = "cargo-pod-" .. planet,
		})
	elseif data.raw.technology["planet-discovery-" .. planet] then
		table.insert(data.raw.technology["planet-discovery-" .. planet].effects, {
			type = "unlock-recipe",
			recipe = "cargo-pod-" .. planet,
		})
	elseif data.raw.technology["rocket-silo"] then
		table.insert(data.raw.technology["rocket-silo"].effects, {
			type = "unlock-recipe",
			recipe = "cargo-pod-" .. planet,
		})
	else
		data.raw.item["cargo-pod-" .. planet].enabled = true
	end
end
