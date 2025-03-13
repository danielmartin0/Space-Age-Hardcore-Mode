data.raw["lightning"]["lightning"].damage = data.raw["lightning"]["lightning"].damage
	* settings.startup["rocs-hardcore-lightning-damage-multiplier"].value

if settings.startup["rocs-hardcore-lightning-damages-locomotives"].value then
	local exemption_rules = data.raw.planet.fulgora.lightning_properties.exemption_rules
	local locomotive_index = nil

	for i, rule in pairs(exemption_rules) do
		if rule.string == "locomotive" then
			locomotive_index = i
			break
		end
	end

	if locomotive_index then
		table.remove(exemption_rules, locomotive_index)
		data.raw.planet.fulgora.lightning_properties.exemption_rules = exemption_rules
	end

	table.insert(data.raw.planet.fulgora.lightning_properties.priority_rules, {
		type = "prototype",
		string = "locomotive",
		priority_bonus = 250,
	})
end
