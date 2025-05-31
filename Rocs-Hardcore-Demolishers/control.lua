local function replace_with_normal_pump(entity)
	if entity == nil or not entity.valid then
		return
	end
	if entity.name ~= "lava-pump" then
		return
	end
	local surface = entity.surface
	local info = {
		name = "offshore-pump",
		position = entity.position,
		quality = entity.quality,
		force = entity.force,
		fast_replace = true,
		player = entity.last_user,
		orientation = entity.orientation,
		direction = entity.direction,
	}
	entity.destroy()
	surface.create_entity(info)
end

script.on_event(defines.events.on_script_trigger_effect, function(event)
	local effect_id = event.effect_id

	if effect_id == "hard-mode-replace-lava-pump" then
		local entity = event.target_entity

		if not (entity and entity.valid) then
			return
		end

		replace_with_normal_pump(entity)
	end
end)
