local speed_factor = 1
local health_multiplier = 1

if settings.startup["rocs-hardcore-demolishers-stronger-demolishers"].value then
	speed_factor = 1.5
	health_multiplier = 1.8
end

local smaller_demolisher_territory_radius = settings.startup["rocs-hardcore-smaller-demolisher-territory-radius"].value

for _, entity in pairs(data.raw["segmented-unit"]) do
	if entity.max_health then
		entity.max_health = entity.max_health * health_multiplier
	end

	-- entity.patrolling_speed = entity.patrolling_speed * 0.9
	entity.patrolling_speed = entity.patrolling_speed * 1
	entity.investigating_speed = entity.investigating_speed * (speed_factor ^ (1 / 2))
	entity.attacking_speed = entity.attacking_speed * speed_factor
	entity.enraged_speed = entity.enraged_speed * speed_factor

	entity.acceleration_rate = entity.acceleration_rate * speed_factor

	entity.turn_smoothing = entity.turn_smoothing / speed_factor
end

for _, entity in pairs(data.raw["segment"]) do
	if entity.max_health then
		entity.max_health = entity.max_health * health_multiplier
	end
end

if smaller_demolisher_territory_radius then
	data.raw["noise-expression"]["demolisher_territory_radius"].expression = 210 -- from 384
	-- data.raw["noise-expression"]["demolisher_territory_radius"].expression = 150 -- we observed lag issues in multiplayer at 150 when fighting demolishers
end
