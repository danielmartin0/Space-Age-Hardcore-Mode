local function calculate_connection_length(from_name, to_name)
	-- This function assumes the angle between the planets is lesser than 180 degrees.

	local from_planet = data.raw.planet[from_name] or data.raw["space-location"][from_name]
	local to_planet = data.raw.planet[to_name] or data.raw["space-location"][to_name]

	if not from_planet or not to_planet then
		return nil
	end

	local angle1 = from_planet.orientation * 2 * math.pi
	local angle2 = to_planet.orientation * 2 * math.pi

	local r1 = from_planet.distance or 0
	local r2 = to_planet.distance or 0

	local angle_diff = math.abs(angle2 - angle1)

	-- Using c² = a² + b² - 2ab*cos(C)
	local straight_distance = math.sqrt(r1 * r1 + r2 * r2 - 2 * r1 * r2 * math.cos(angle_diff))

	-- local curvature_factor = 1.0 + (math.pi / 2 - 1.0) * (angle_diff / math.pi)
	-- This factor is less strictly accurate, but it respects 'triangle inequalities' better:
	local curvature_factor = 1.0 + (math.pi / 2 - 1.0) * (angle_diff / math.pi) / 2

	local curved_distance = straight_distance * curvature_factor

	return math.ceil(curved_distance * 815)
end

if mods["Tiered-Solar-System"] then
	for _, connection in pairs(data.raw["space-connection"]) do
		if not (connection.from == "shattered-planet" or connection.to == "shattered-planet") then
			local length = calculate_connection_length(connection.from, connection.to)
			if length then
				if connection.from == "solar-system-edge" or connection.to == "solar-system-edge" then
					length = length * 2
				end
				connection.length = length
			end
		end
	end
else
	data.raw["space-connection"]["nauvis-vulcanus"].length = math.floor(
		data.raw["space-connection"]["nauvis-vulcanus"].length
			* settings.startup["planetary-distance-adjustments-nauvis-vulcanus-multiplier"].value
	)
	data.raw["space-connection"]["nauvis-gleba"].length = math.floor(
		data.raw["space-connection"]["nauvis-gleba"].length
			* settings.startup["planetary-distance-adjustments-nauvis-gleba-multiplier"].value
	)
	data.raw["space-connection"]["nauvis-fulgora"].length = math.floor(
		data.raw["space-connection"]["nauvis-fulgora"].length
			* settings.startup["planetary-distance-adjustments-nauvis-fulgora-multiplier"].value
	)
	data.raw["space-connection"]["vulcanus-gleba"].length = math.floor(
		data.raw["space-connection"]["vulcanus-gleba"].length
			* settings.startup["planetary-distance-adjustments-vulcanus-gleba-multiplier"].value
	)
	data.raw["space-connection"]["gleba-fulgora"].length = math.floor(
		data.raw["space-connection"]["gleba-fulgora"].length
			* settings.startup["planetary-distance-adjustments-gleba-fulgora-multiplier"].value
	)
	data.raw["space-connection"]["gleba-aquilo"].length = math.floor(
		data.raw["space-connection"]["gleba-aquilo"].length
			* settings.startup["planetary-distance-adjustments-gleba-aquilo-multiplier"].value
	)
	data.raw["space-connection"]["fulgora-aquilo"].length = math.floor(
		data.raw["space-connection"]["fulgora-aquilo"].length
			* settings.startup["planetary-distance-adjustments-fulgora-aquilo-multiplier"].value
	)
	data.raw["space-connection"]["aquilo-solar-system-edge"].length = math.floor(
		data.raw["space-connection"]["aquilo-solar-system-edge"].length
			* settings.startup["planetary-distance-adjustments-aquilo-solar-system-edge-multiplier"].value
	)
	data.raw["space-connection"]["solar-system-edge-shattered-planet"].length = math.floor(
		data.raw["space-connection"]["solar-system-edge-shattered-planet"].length
			* settings.startup["planetary-distance-adjustments-solar-system-edge-multiplier-shattered-planet"].value
	)
end
