if settings.startup["Tiered-Solar-System-ensure-vanilla-planets-connected"].value then
	log("Tiered-Solar-System: Ensuring vanilla planets are connected")
	if data.raw["space-connection"]["gleba-fulgora"] then
		log("Tiered-Solar-System: Ensuring Gleba and Fulgora are connected")
		local connection = data.raw["space-connection"]["gleba-fulgora"]
		connection.redrawn_connections_keep = true
		connection.redrawn_connections_rescale = true
	end

	if data.raw["space-connection"]["nauvis-vulcanus"] then
		log("Tiered-Solar-System: Ensuring Nauvis and Vulcanus are connected")
		local connection = data.raw["space-connection"]["nauvis-vulcanus"]
		connection.redrawn_connections_keep = true
		connection.redrawn_connections_rescale = true
	end

	if data.raw["space-connection"]["vulcanus-gleba"] then
		log("Tiered-Solar-System: Ensuring Vulcanus and Gleba are connected")
		local connection = data.raw["space-connection"]["vulcanus-gleba"]
		connection.redrawn_connections_keep = true
		connection.redrawn_connections_rescale = true
	end
end
