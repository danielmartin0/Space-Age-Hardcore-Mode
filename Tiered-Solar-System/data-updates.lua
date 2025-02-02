local defaults = require("defaults")

for name, tier in pairs(defaults.default_modded_planet_tiers) do
	if data.raw.planet[name] and not data.raw.planet[name].tier then
		data.raw.planet[name].tier = tier
	end
end

for name, tier in pairs(defaults.default_modded_location_tiers) do
	if data.raw["space-location"][name] and not data.raw["space-location"][name].tier then
		data.raw["space-location"][name].tier = tier
	end
end

for _, type in pairs({ "space-location", "planet" }) do
	for _, loc in pairs(data.raw[type] or {}) do
		if loc.orbit and loc.orbit.parent and loc.orbit.parent.name then
			if loc.orbit.parent.name == "star" then
				loc.tier = loc.tier or defaults.fallback_tier

				loc.orientation = 1 - (loc.tier * 0.15)
			end
		end
	end
end
