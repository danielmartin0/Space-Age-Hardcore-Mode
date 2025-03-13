local Public = {}

local warning_color = { r = 255, g = 60, b = 60 }

script.on_event(defines.events.on_built_entity, function(event)
	local entity = event.entity

	if not (entity and entity.valid) then
		return
	end

	if entity.name and entity.name ~= "entity-ghost" then
		return
	end

	if entity.surface and entity.surface.valid and not entity.surface.platform then
		return
	end

	if entity.ghost_type == "underground-belt" and settings.startup["no-underground-belts-on-platforms"].value then
		Public.remove_belt_unless_researched(entity, game.players[event.player_index])
	elseif entity.ghost_type == "pipe-to-ground" and settings.startup["no-underground-pipes-on-platforms"].value then
		Public.remove_pipe_unless_researched(entity, game.players[event.player_index])
	end
end)

script.on_event(defines.events.on_space_platform_built_entity, function(event)
	local entity = event.entity

	if not (entity and entity.valid) then
		return
	end

	if entity.type == "underground-belt" and settings.startup["no-underground-belts-on-platforms"].value then
		Public.remove_belt_unless_researched(entity)
	elseif entity.type == "pipe-to-ground" and settings.startup["no-underground-pipes-on-platforms"].value then
		Public.remove_pipe_unless_researched(entity)
	end
end)

function Public.remove_belt_unless_researched(entity, player)
	if not (entity.force and entity.force.valid) then
		return
	end

	local tech = entity.force.technologies["underground-belts-on-space-platforms"]

	if tech and tech.valid and tech.researched then
		return
	end

	entity.destroy()

	if player and player.valid then
		player.print({
			"no-undergrounds-on-platforms.warning-belts",
		}, { color = warning_color })
	end
end

function Public.remove_pipe_unless_researched(entity, player)
	if not (entity.force and entity.force.valid) then
		return
	end

	local tech = entity.force.technologies["underground-pipes-on-space-platforms"]

	if tech and tech.valid and tech.researched then
		return
	end

	entity.destroy()

	if player and player.valid then
		player.print({
			"no-undergrounds-on-platforms.warning-pipes",
		}, { color = warning_color })
	end
end

return Public
