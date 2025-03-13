local biters = {
	["small-biter"] = true,
	["medium-biter"] = true,
	["big-biter"] = true,
	["behemoth-biter"] = true,
	["leviathan-biter"] = true,
}

-- local spitters = {
-- 	["small-spitter"] = true,
-- 	["medium-spitter"] = true,
-- 	["big-spitter"] = true,
-- 	["behemoth-spitter"] = true,
-- 	["leviathan-spitter"] = true,
-- }

-- local snappers = {
-- 	["small-sniper-biter"] = true,
-- 	["medium-sniper-biter"] = true,
-- 	["big-sniper-biter"] = true,
-- 	["behemoth-sniper-biter"] = true,
-- 	["leviathan-sniper-biter"] = true,
-- }

script.on_event(defines.events.on_entity_damaged, function(event)
	local entity = event.entity
	local source = event.cause or event.source
	local surface = entity.surface

	if source and source.valid and entity and entity.valid and surface and surface.valid then
		local night_bonus = settings.global["rocs-hardcore-biter-nighttime-bonus-damage-percent"].value / 100

		local bonus_damage = 0

		local adjusted_darkness = surface.darkness / 0.85 -- a surface having min_brightness of 0.15 will cap darkness at 0.85

		if biters[source.name] and night_bonus > 0 and event.final_damage_amount > 0 then
			bonus_damage = bonus_damage + event.final_damage_amount * night_bonus * adjusted_darkness
		end

		if bonus_damage > 0 then
			entity.damage(bonus_damage, source.force, "impact", source)
		end
	end
end)
