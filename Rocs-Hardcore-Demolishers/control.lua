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

script.on_configuration_changed(function()
	if storage.migrated_pumps then
		return
	end

	storage.migrated_pumps = true

	if game.surfaces["vulcanus"] == nil then
		return
	end

	for _, e in pairs(game.surfaces["vulcanus"].find_entities_filtered({ name = "lava-pump" })) do
		replace_with_normal_pump(e)
	end
end)
