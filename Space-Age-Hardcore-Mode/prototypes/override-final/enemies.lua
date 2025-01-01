-- Regular units
for _, entity in pairs(data.raw["unit"]) do
	if entity.max_health then
		entity.max_health = entity.max_health
			* (1 + settings.startup["rocs-hardcore-bonus-unit-health-percentage"].value / 100)
	end
end

-- Spider units
for _, entity in pairs(data.raw["spider-unit"]) do
	if entity.max_health then
		entity.max_health = entity.max_health
			* (1 + settings.startup["rocs-hardcore-bonus-spider-unit-health-percentage"].value / 100)
	end
end

-- Turrets
for _, entity in pairs(data.raw["turret"]) do
	if entity.max_health then
		entity.max_health = entity.max_health
			* (1 + settings.startup["rocs-hardcore-bonus-worm-turret-health-percentage"].value / 100)
	end
end
