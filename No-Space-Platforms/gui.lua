local GUI_KEY = "No-Space-Platforms-rocket-silo"
local GUI_KEY_GHOST = "No-Space-Platforms-rocket-silo-ghost"

local function get_planet_options(force)
	local planets = {}
	for name, prototype in pairs(prototypes.space_location) do
		if prototype.type == "planet" and force.is_space_location_unlocked(name) then
			table.insert(planets, {
				name = name,
				display_name = { "", "[space-location=" .. name .. "] ", { "space-location-name." .. name } },
			})
		end
	end
	return planets
end

local function update_rendering(entity, planet_name_or_nil, storage_entry)
	local is_ghost = entity.name == "entity-ghost"

	if storage_entry.rendering_id then
		local existing_rendering = rendering.get_object_by_id(storage_entry.rendering_id)
		if existing_rendering and existing_rendering.valid then
			existing_rendering.destroy()
		end
	end

	if planet_name_or_nil then
		local new_rendering = rendering.draw_text({
			text = "[space-location=" .. planet_name_or_nil .. "]",
			surface = entity.surface,
			target = entity,
			color = is_ghost and { r = 1, g = 1, b = 1, a = 0.6 } or { r = 1, g = 1, b = 1, a = 1 },
			scale = 1.5,
			use_rich_text = true,
			font = "default-large",
			alignment = "center",
			vertical_alignment = "middle",
			only_in_alt_mode = true,
		})
		storage_entry.rendering_id = new_rendering.id
	end
end

local function silo_set_state(entity, planet_name)
	storage.silos = storage.silos or {}

	if entity.type == "rocket-silo" then
		storage.silos[entity.unit_number] = storage.silos[entity.unit_number] or {}

		storage.silos[entity.unit_number].planet = planet_name

		update_rendering(entity, planet_name, storage.silos[entity.unit_number])
	elseif entity.name == "entity-ghost" and entity.ghost_name then
		local ghost_name = entity.ghost_name
		if prototypes.entity[ghost_name].type == "rocket-silo" then
			local tags = entity.tags or {}

			tags.planet = planet_name

			update_rendering(entity, planet_name, tags)

			entity.tags = tags
		end
	end

	for _, other_player in pairs(game.connected_players) do
		if
			other_player.valid
			and other_player.opened
			and other_player.opened.valid
			and other_player.opened == entity
		then
			local gui_key = entity.type == "rocket-silo" and GUI_KEY or GUI_KEY_GHOST

			local gui = other_player.gui.relative[gui_key]
			if gui and gui.content["planet-selector"] then
				if planet_name then
					local options = get_planet_options(other_player.force)
					for i, option in ipairs(options) do
						if option.name == planet_name then
							gui.content["planet-selector"].selected_index = i
							break
						end
					end
				else
					gui.content["planet-selector"].selected_index = 0
				end
			end
		end
	end
end

local function silo_built(entity, tags)
	if not (entity and entity.valid) then
		return
	end

	storage.silos = storage.silos or {}
	storage.silos[entity.unit_number] = {
		planet = "nauvis",
	}

	if tags and tags.planet then
		silo_set_state(entity, tags.planet)
	end
end

script.on_event({
	defines.events.on_built_entity,
	defines.events.on_robot_built_entity,
	defines.events.script_raised_built,
	defines.events.script_raised_revive,
}, function(event)
	storage.silos = storage.silos or {}

	local entity = event.entity
	if not (entity and entity.valid) then
		return
	end

	if entity.type == "rocket-silo" then
		silo_built(entity, event.tags or {})
	end
end)

script.on_event(defines.events.on_gui_opened, function(event)
	storage.silos = storage.silos or {}

	if event.gui_type ~= defines.gui_type.entity then
		return
	end

	local player = game.players[event.player_index]

	if not (player and player.valid) then
		return
	end

	local entity = event.entity

	if
		not (
			entity
			and entity.valid
			and (
				entity.type == "rocket-silo"
				or (entity.name == "entity-ghost" and prototypes.entity[entity.ghost_name].type == "rocket-silo")
			)
		)
	then
		return
	end

	if not storage.silos[entity.unit_number] then
		storage.silos[entity.unit_number] = {
			planet = "nauvis",
		}
	end

	local gui_key = entity.type == "rocket-silo" and GUI_KEY or GUI_KEY_GHOST

	local relative = player.gui.relative
	if relative[gui_key] then
		if (relative[gui_key].tags or {}).mod_version ~= script.active_mods["No-Space-Platforms"] then
			relative[gui_key].destroy()
		end
	end

	local options = get_planet_options(player.force)

	if #options <= 1 then
		if relative[gui_key] then
			relative[gui_key].destroy()
		end
		return
	end

	if not relative[gui_key] then
		local main_frame = relative.add({
			type = "frame",
			name = gui_key,
			direction = "vertical",
			tags = { mod_version = script.active_mods["No-Space-Platforms"] },
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
			caption = "Select destination",
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

		local planet_list = content_frame.add({
			type = "list-box",
			name = "planet-selector",
			items = {},
		})

		for _, planet in ipairs(options) do
			planet_list.add_item(planet.display_name)
		end
	end

	local current_planet
	if entity.name == "entity-ghost" then
		current_planet = (entity.tags and entity.tags.planet)
	else
		current_planet = storage.silos[entity.unit_number].planet
	end

	local selector = relative[gui_key].content["planet-selector"]

	if current_planet then
		for i, option in ipairs(options) do
			if option.name == current_planet then
				selector.selected_index = i
				break
			end
		end
	else
		selector.selected_index = 0
	end
end)

script.on_event(defines.events.on_gui_selection_state_changed, function(event)
	storage.silos = storage.silos or {}

	if event.element.name ~= "planet-selector" then
		return
	end

	local player = game.players[event.player_index]
	if not (player and player.valid) then
		return
	end

	local entity = player.opened
	if not (entity and entity.valid) then
		return
	end

	local options = get_planet_options(player.force)

	local selected_planet = options[event.element.selected_index].name
	silo_set_state(entity, selected_planet)
end)

script.on_event(defines.events.on_player_setup_blueprint, function(event)
	storage.silos = storage.silos or {}

	local player = game.players[event.player_index]
	if not (player and player.valid) then
		return
	end

	local blueprint = player.blueprint_to_setup
	if blueprint and blueprint.valid_for_read then
		local mapping = event.mpping.get()
		for blueprint_entity_number, entity in pairs(mapping) do
			if
				entity.type == "rocket-silo"
				and storage.silos[entity.unit_number]
				and storage.silos[entity.unit_number].planet
			then
				local tags = blueprint.get_blueprint_entity_tags(blueprint_entity_number) or {}

				tags.planet = storage.silos[entity.unit_number].planet

				blueprint.set_blueprint_entity_tags(blueprint_entity_number, tags)
			end
		end
	else
		local cursor_stack = player.cursor_stack
		if cursor_stack and cursor_stack.valid_for_read and cursor_stack.is_blueprint then
			local source_entity = event.mapping.get()[1]
			if source_entity and source_entity.valid and source_entity.type == "rocket-silo" then
				local tags = cursor_stack.get_blueprint_entity_tags(1) or {}

				if storage.silos[source_entity.unit_number] and storage.silos[source_entity.unit_number].planet then
					tags.planet = storage.silos[source_entity.unit_number].planet

					cursor_stack.set_blueprint_entity_tags(1, tags)
				end
			end
		end
	end
end)

script.on_event(defines.events.on_entity_settings_pasted, function(event)
	storage.silos = storage.silos or {}

	local source = event.source
	local destination = event.destination

	if not (source and source.valid and destination and destination.valid) then
		return
	end

	if
		not (
			source.type == "rocket-silo"
			or source.name == "entity-ghost" and prototypes.entity[source.ghost_name].type == "rocket-silo"
		)
	then
		return
	end

	if
		not (
			destination.type == "rocket-silo"
			or destination.name == "entity-ghost"
				and prototypes.entity[destination.ghost_name].type == "rocket-silo"
		)
	then
		return
	end

	local planet
	if storage.silos[source.unit_number] and storage.silos[source.unit_number].planet then
		planet = storage.silos[source.unit_number].planet
	end

	silo_set_state(destination, planet)
end)

script.on_event(defines.events.on_entity_cloned, function(event)
	storage.silos = storage.silos or {}

	local source = event.source
	local destination = event.destination

	if not (source and source.valid and destination and destination.valid) then
		return
	end

	if source.type ~= "rocket-silo" then
		return
	end

	silo_set_state(destination, storage.silos[source.unit_number].planet)
end)

script.on_event(defines.events.on_pre_build, function(event)
	local player = game.get_player(event.player_index)
	local cursor_stack = player.cursor_stack

	if cursor_stack and cursor_stack.valid_for_read then
		local item_name = cursor_stack.name

		local prototype = prototypes.entity[item_name]
		if prototype and prototype.type == "rocket-silo" then
			game.print("on_pre_build from " .. item_name)
		end
	end
end)
