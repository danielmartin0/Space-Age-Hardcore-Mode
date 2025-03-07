local Public = {}

local function get_override_choices(force, planet_name_to_exclude)
	local choices = {
		{
			key = nil,
			display_name = { "hopper.no-override" },
		},
	}

	for name, _ in pairs(game.planets) do
		if force.is_space_location_unlocked(name) and name ~= planet_name_to_exclude then
			table.insert(choices, {
				key = name,
				display_name = { "", "[space-location=" .. name .. "] ", { "space-location-name." .. name } },
			})
		end
	end

	return choices
end

local function is_valid_silo(entity)
	return entity
		and entity.valid
		and (
			(entity.type == "rocket-silo" and entity.name == "planet-hopper-launcher")
			or (entity.name == "entity-ghost" and entity.ghost_name == "planet-hopper-launcher")
		)
end

local GUI_KEY = "Planet-Hopper-override"

local function silo_set_override(entity, destination_override)
	storage.silos = storage.silos or {}
	storage.silos[entity.unit_number] = storage.silos[entity.unit_number] or {}
	storage.silos[entity.unit_number].destination_override = destination_override

	for _, other_player in pairs(game.connected_players) do
		if
			other_player.valid
			and other_player.opened
			and other_player.opened.valid
			and other_player.opened == entity
		then
			local gui = other_player.gui.relative[GUI_KEY]
			if gui and gui.content["override-selector"] then
				if destination_override then
					local options = get_override_choices(other_player.force, entity.surface.planet.name)
					for i, option in ipairs(options) do
						if option.key == destination_override then
							gui.content["override-selector"].selected_index = i
							break
						end
					end
				else
					gui.content["override-selector"].selected_index = 1
				end
			end
		end
	end
end

script.on_event(defines.events.on_rocket_launch_ordered, function(event)
	local rocket = event.rocket
	local silo = event.rocket_silo

	if not (silo and silo.valid and rocket and rocket.valid) then
		return
	end

	if silo.name ~= "planet-hopper-launcher" then
		return
	end

	storage.silos[silo.unit_number].disabled = true

	local cargo_pod = rocket.cargo_pod
	if not cargo_pod or not cargo_pod.valid then
		return
	end

	local inv = cargo_pod.get_inventory(defines.inventory.cargo_unit)
	if not inv or not inv.valid then
		return
	end

	inv.clear()

	storage.silos = storage.silos or {}

	local destination_override = storage.silos[silo.unit_number]
		and storage.silos[silo.unit_number].destination_override

	if destination_override then
		cargo_pod.cargo_pod_destination = {
			type = defines.cargo_destination.surface,
			surface = game.surfaces[destination_override],
		}

		for _, player in pairs(game.connected_players) do
			if player.valid and player.opened and player.opened.valid and player.opened == silo then
				local gui = player.gui.relative[GUI_KEY]
				if gui then
					-- The GUI probably closes anyway, but just to be sure:
					gui.destroy()
				end
			end
		end
	end
end)

script.on_event(defines.events.on_rocket_launched, function(event)
	local silo = event.rocket_silo

	if not (silo and silo.valid) then
		return
	end

	if silo.name ~= "planet-hopper-launcher" then
		return
	end

	storage.silos[silo.unit_number].disabled = false
end)

script.on_event(defines.events.on_gui_opened, function(event)
	if not settings.global["allow-destination-override"].value then
		return
	end

	storage.silos = storage.silos or {}

	if event.gui_type ~= defines.gui_type.entity then
		return
	end

	local player = game.players[event.player_index]

	if not (player and player.valid) then
		return
	end

	local entity = event.entity

	if not is_valid_silo(entity) then
		return
	end

	if not (entity.surface and entity.surface.valid and entity.surface.planet and entity.surface.planet.valid) then
		return
	end

	if not storage.silos[entity.unit_number] then
		storage.silos[entity.unit_number] = {}
	end

	local relative = player.gui.relative
	if relative[GUI_KEY] then
		relative[GUI_KEY].destroy()
	end

	local options = get_override_choices(player.force, entity.surface.planet.name)

	if #options <= 1 then
		return
	end

	if storage.silos[entity.unit_number].disabled then
		return
	end

	if not relative[GUI_KEY] then
		local main_frame = relative.add({
			type = "frame",
			name = GUI_KEY,
			direction = "vertical",
			tags = {
				mod_version = script.active_mods["Planet-Hopper"],
			},
			anchor = {
				name = entity.name,
				gui = defines.relative_gui_type.rocket_silo_gui,
				position = defines.relative_gui_position.right,
			},
		})

		local titlebar_flow = main_frame.add({
			type = "flow",
			direction = "horizontal",
			drag_target = main_frame,
		})

		titlebar_flow.add({
			type = "label",
			caption = { "hopper.destination-override" },
			style = "frame_title",
			ignored_by_interaction = true,
		})

		local drag_handle = titlebar_flow.add({
			type = "empty-widget",
			ignored_by_interaction = true,
			style = "draggable_space_header",
		})
		drag_handle.style.horizontally_stretchable = true
		drag_handle.style.height = 24
		drag_handle.style.right_margin = 4

		local content_frame = main_frame.add({
			type = "frame",
			name = "content",
			style = "inside_shallow_frame_with_padding_and_vertical_spacing",
			direction = "vertical",
		})

		local override_list = content_frame.add({
			type = "list-box",
			name = "override-selector",
			items = {},
		})

		for _, override in ipairs(options) do
			override_list.add_item(override.display_name)
		end
	end

	local selector = relative[GUI_KEY].content["override-selector"]
	local current_override = storage.silos[entity.unit_number].destination_override

	if current_override then
		for i, option in ipairs(options) do
			if option.key == current_override then
				selector.selected_index = i
				break
			end
		end
	else
		selector.selected_index = 1
	end
end)

script.on_event(defines.events.on_gui_selection_state_changed, function(event)
	storage.silos = storage.silos or {}

	if event.element.name ~= "override-selector" then
		return
	end

	local player = game.players[event.player_index]
	if not (player and player.valid) then
		return
	end

	local entity = player.opened
	if
		not (
			entity
			and entity.valid
			and entity.surface
			and entity.surface.valid
			and entity.surface.planet
			and entity.surface.planet.valid
		)
	then
		return
	end

	if event.element.parent.parent.name ~= GUI_KEY then
		return
	end

	local choices = get_override_choices(player.force, entity.surface.planet.name)

	local selected_override = choices[event.element.selected_index].key
	silo_set_override(entity, selected_override)
end)

local function cleanup_silo(entity)
	if not storage.silos[entity.unit_number] then
		return
	end

	storage.silos[entity.unit_number] = nil
end

script.on_event({
	defines.events.on_player_mined_entity,
	defines.events.on_robot_mined_entity,
	defines.events.on_entity_died,
}, function(event)
	local entity = event.entity
	if not (entity and entity.valid and entity.name == "planet-hopper-launcher") then
		return
	end
	cleanup_silo(entity)
end)

return Public
