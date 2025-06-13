for _, type in pairs({ "space-location", "planet" }) do
	for _, loc in pairs(data.raw[type] or {}) do
		if loc.orbit and loc.orbit.parent and loc.orbit.parent.name then
			if loc.orbit.parent.name == "star" then
				local tier
				if type == "planet" then
					tier = PlanetsLib.get_planet_tier(loc.name)
				else
					tier = PlanetsLib.get_space_location_tier(loc.name)
				end

				if tier == 3.33333 then
					loc.cosmic_social_distancing_ignore = true
				end

				-- local has_oss_exclusion_parameter = false
				local has_oss_exclusion_parameter = loc.tier == -1

				if tier ~= -1 and not has_oss_exclusion_parameter then
					loc.orientation = 1 - (tier * 0.15)
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
