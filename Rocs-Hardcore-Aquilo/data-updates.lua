if settings.startup["rocs-hardcore-aquilo-fission-prevented"].value then
	local reactor = data.raw.reactor["nuclear-reactor"]
	local temp_condition = {
		property = "temperature",
		min = 259,
	}

	if reactor.surface_conditions then
		table.insert(reactor.surface_conditions, temp_condition)
	else
		reactor.surface_conditions = { temp_condition }
	end
end
