local tiers = require("default-tiers")

for name, tier in pairs(tiers.default_modded_planet_tiers) do
	if data.raw.planet[name] and not data.raw.planet[name].tier then
		data.raw.planet[name].tier = tier
	end
end

for name, tier in pairs(tiers.default_modded_location_tiers) do
	if data.raw["space-location"][name] then
		if data.raw["space-location"][name].tier then
			log(
				"Tiered-Solar-System: "
					.. name
					.. " has a pre-existing tier of "
					.. data.raw["space-location"][name].tier
					.. "."
			)
		else
			data.raw["space-location"][name].tier = tier
		end
	end
end

for _, type in pairs({ "space-location", "planet" }) do
	for _, loc in pairs(data.raw[type] or {}) do
		if loc.orbit and loc.orbit.parent and loc.orbit.parent.name then
			if loc.orbit.parent.name == "star" then
				if loc.tier == nil then
					loc.tier = tiers.fallback_tier
					loc.label_orientation = loc.orientation
				end

				if loc.tier ~= -1 then
					loc.orientation = 1 - (loc.tier * 0.15)
					loc.label_orientation = loc.orientation
				end
			end
		end
	end
end

if data.raw["space-location"]["slp-solar-system-sun2"] then
	data.raw["space-location"]["slp-solar-system-sun2"].redrawn_connections_exclude = true
end

if data.raw.planet["terrapalus"] then
	local planet = data.raw.planet["terrapalus"]
	if
		not (planet.orbit and planet.orbit.parent and planet.orbit.parent.name and planet.orbit.parent.name == "gleba")
	then
		PlanetsLib:update({
			{
				type = "planet",
				name = "terrapalus",
				orbit = {
					parent = {
						type = "planet",
						name = "gleba",
					},
					distance = 3.5,
					orientation = 0.46,
				},
			},
		})
	end
end
