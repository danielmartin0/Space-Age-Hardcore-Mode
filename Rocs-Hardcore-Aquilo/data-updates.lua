if settings.startup["rocs-hardcore-aquilo-fission-prevented"].value then
	for _, reactor in pairs(data.raw["reactor"]) do
		if reactor.energy_source.type == "burner" then
			local contains_chemical_fuel_category = false
			for _, fuel_category in pairs(reactor.energy_source.fuel_categories) do
				if fuel_category == "chemical" or fuel_category == "chemical-or-radiative" then -- Cerys compat
					contains_chemical_fuel_category = true
					break
				end
			end

			if not contains_chemical_fuel_category then
				PlanetsLib.restrict_surface_conditions(reactor, {
					property = "temperature",
					min = 259,
				})
			end
		end
	end
end
