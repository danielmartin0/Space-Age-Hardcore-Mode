for _, entity in pairs(data.raw["unit"]) do
	if entity.max_health and settings.startup["rocs-hardcore-bonus-unit-health-percentage"].value ~= 0 then
		entity.max_health = entity.max_health
			* (1 + settings.startup["rocs-hardcore-bonus-unit-health-percentage"].value / 100)
	end
end

for _, entity in pairs(data.raw["spider-unit"]) do
	if entity.max_health and settings.startup["rocs-hardcore-bonus-unit-health-percentage"].value ~= 0 then
		entity.max_health = entity.max_health
			* (1 + settings.startup["rocs-hardcore-bonus-unit-health-percentage"].value / 100)
	end
end

for _, entity in pairs(data.raw["turret"]) do
	if entity.max_health and settings.startup["rocs-hardcore-bonus-unit-health-percentage"].value ~= 0 then
		entity.max_health = entity.max_health
			* (1 + settings.startup["rocs-hardcore-bonus-unit-health-percentage"].value / 100)
	end
end

for _, entity in pairs(data.raw["segmented-unit"]) do
	if entity.max_health and settings.startup["rocs-hardcore-bonus-unit-health-percentage"].value ~= 0 then
		entity.max_health = entity.max_health
			* (1 + settings.startup["rocs-hardcore-bonus-unit-health-percentage"].value / 100)
	end
end

for _, entity in pairs(data.raw["segment"]) do
	if entity.max_health and settings.startup["rocs-hardcore-bonus-unit-health-percentage"].value ~= 0 then
		entity.max_health = entity.max_health
			* (1 + settings.startup["rocs-hardcore-bonus-unit-health-percentage"].value / 100)
	end
end