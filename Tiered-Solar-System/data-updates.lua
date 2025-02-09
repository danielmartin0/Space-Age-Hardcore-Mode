local defaults = require("modded-defaults")

for name, tier in pairs(defaults.default_modded_planet_tiers) do
	if data.raw.planet[name] and not data.raw.planet[name].tier then
		data.raw.planet[name].tier = tier
	end
end

for name, tier in pairs(defaults.default_modded_location_tiers) do
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
					loc.tier = defaults.fallback_tier
				end

				if loc.tier ~= -1 then
					loc.orientation = 1 - (loc.tier * 0.155)
				end
			end
		end
	end
end
