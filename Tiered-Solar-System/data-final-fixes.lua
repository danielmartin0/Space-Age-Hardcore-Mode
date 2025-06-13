if data.raw["space-connection"] then
	for name, connection in pairs(data.raw["space-connection"]) do
		local from_loc = data.raw.planet[connection.from] or data.raw["space-location"][connection.from]
		local to_loc = data.raw.planet[connection.to] or data.raw["space-location"][connection.to]

		if from_loc and to_loc then
			local o1 = (from_loc.orientation or 0) % 1
			local o2 = (to_loc.orientation or 0) % 1

			local crosses_axis = (o1 <= 0.25 and o2 >= 0.75) or (o2 <= 0.25 and o1 >= 0.75)

			if crosses_axis then
				log(
					string.format(
						"Tiered Solar System: Removing connection '%s' as it likely crosses the orientation=0 axis. Orientations: %.2f, %.2f",
						name,
						o1,
						o2
					)
				)
				data.raw["space-connection"][name] = nil
			end
		end
	end
end
