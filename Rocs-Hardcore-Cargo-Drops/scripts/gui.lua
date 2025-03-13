local Public = {}

-- TODO: Support for pasting from blueprint

local GUI_KEY = "roc-gui-space-platform-hub"

script.on_event(defines.events.on_gui_opened, function(event)
	if event.gui_type ~= defines.gui_type.entity then
		return
	end

	local player = game.connected_players[event.player_index]

	if not (player and player.valid) then
		return
	end

	local entity = event.entity

	if not (entity and entity.valid and entity.name == "space-platform-hub") then
		return
	end

	local relative = player.gui.relative
	if relative[GUI_KEY] then
		if (relative[GUI_KEY].tags or {}).mod_version ~= script.active_mods["Rocs-Hardcore-Cargo-Drops"] then
			relative[GUI_KEY].destroy()
		end
	end

	-- TODO: Remove this eventually
	local GUI_KEYS_FROM_OLD_VERSIONS = {
		"roc-1.2.15-space-platform-hub-gui",
		"roc-1.2.14-space-platform-hub-gui",
		"roc-1.2.13-space-platform-hub-gui",
	}

	for _, key in pairs(GUI_KEYS_FROM_OLD_VERSIONS) do
		if relative[key] then
			relative[key].destroy()
		end
	end

	if not relative[GUI_KEY] then
		local flow, flow2, flow3, flow4, flow5, flow6

		flow = relative.add({
			type = "flow",
			direction = "horizontal",
			name = GUI_KEY,
			tags = { mod_version = script.active_mods["Rocs-Hardcore-Cargo-Drops"] },
			anchor = {
				name = entity.name,
				gui = defines.relative_gui_type.space_platform_hub_gui,
				position = defines.relative_gui_position.bottom,
			},
		})
		flow.style.horizontally_stretchable = false

		flow2 = flow.add({
			type = "frame",
			name = "frame",
			direction = "vertical",
		})

		flow3 = flow2.add({
			type = "flow",
			direction = "horizontal",
			drag_target = flow2,
		})

		flow3.add({
			type = "label",
			caption = { "rocs-hardcore-cargo-drops.space-platform-hub-gui-title" },
			style = "frame_title",
			ignored_by_interaction = true,
		})

		flow4 = flow3.add({
			type = "empty-widget",
			ignored_by_interaction = true,
			style = "draggable_space_header",
		})
		flow4.style.horizontally_stretchable = true
		flow4.style.height = 24
		flow4.style.right_margin = 4

		flow3 = flow2.add({
			type = "frame",
			name = "content",
			style = "inside_shallow_frame_with_padding",
			direction = "vertical",
		})

		flow4 = flow3.add({
			type = "flow",
			direction = "horizontal",
			name = "content-flow",
		})

		flow5 = flow4.add({
			type = "flow",
			direction = "horizontal",
			name = "checkbox_flow",
			tooltip = { "rocs-hardcore-cargo-drops.space-platform-hub-gui-minimum-drop-count-tooltip" },
		})

		flow5.add({
			type = "checkbox",
			name = "minimum-drop-count-enabled",
			state = false, -- Default to disabled
			caption = { "rocs-hardcore-cargo-drops.space-platform-hub-gui-minimum-drop-count" },
			tooltip = { "rocs-hardcore-cargo-drops.space-platform-hub-gui-minimum-drop-count-tooltip" },
		})

		flow6 = flow5.add({
			type = "sprite",
			sprite = "info",
			tooltip = { "rocs-hardcore-cargo-drops.space-platform-hub-gui-minimum-drop-count-tooltip" },
		})
		flow6.style.height = 20
		flow6.style.width = 8
		flow6.style.stretch_image_to_widget_size = true

		flow5 = flow4.add({
			type = "flow",
			direction = "horizontal",
			name = "minimum-drop-count-flow",
		})
		flow5.style.horizontal_align = "center"
		flow5.style.horizontally_stretchable = true
		flow5.style.left_margin = 8
		flow5.style.right_margin = 8

		flow6 = flow5.add({
			type = "slider",
			name = "minimum-drop-count-slider",
			minimum_value = 1,
			maximum_value = 10,
			value = 1,
			value_step = 1,
			enabled = false, -- Default to disabled
			style = "notched_slider",
		})
		flow6.style.horizontally_stretchable = true
		flow6.style.width = 100

		flow5 = flow4.add({
			type = "textfield",
			name = "minimum-drop-count-textfield",
			text = "1",
			numeric = true,
			allow_decimal = false,
			allow_negative = false,
			enabled = false, -- Default to disabled
		})
		flow5.style.width = 60
		flow5.style.horizontal_align = "center"
	end

	local settings = storage.hub_settings and storage.hub_settings[entity.unit_number] or {}
	local enabled = settings.enabled
	if enabled == nil then
		enabled = false
	end
	local value = settings.minimum_drop_count or 1

	local checkbox =
		relative[GUI_KEY]["frame"]["content"]["content-flow"]["checkbox_flow"]["minimum-drop-count-enabled"]

	local slider =
		relative[GUI_KEY]["frame"]["content"]["content-flow"]["minimum-drop-count-flow"]["minimum-drop-count-slider"]
	local textfield = relative[GUI_KEY]["frame"]["content"]["content-flow"]["minimum-drop-count-textfield"]

	checkbox.state = enabled
	slider.slider_value = value
	slider.enabled = enabled
	textfield.text = tostring(value)
	textfield.enabled = enabled
end)

script.on_event(defines.events.on_gui_checked_state_changed, function(event)
	if event.element.name ~= "minimum-drop-count-enabled" then
		return
	end

	local player = game.connected_players[event.player_index]

	if not (player and player.valid) then
		return
	end

	local entity = player.opened
	if not (entity and entity.valid) then
		return
	end

	Public.hub_set_drop_limit_enabled(entity, event.element.state)

	for _, player2 in pairs(game.connected_players) do
		if player2.valid and player2.opened and player2.opened.valid and player2.opened == entity then
			local gui = player2.gui.relative[GUI_KEY]
			if gui then
				local flow = gui["frame"]["content"]["content-flow"]
				local checkbox = flow["checkbox_flow"]["minimum-drop-count-enabled"]
				local slider = flow["minimum-drop-count-flow"]["minimum-drop-count-slider"]
				local textfield = flow["minimum-drop-count-textfield"]

				checkbox.state = event.element.state
				slider.enabled = event.element.state
				textfield.enabled = event.element.state
			end
		end
	end
end)

script.on_event(defines.events.on_gui_value_changed, function(event)
	if event.element.name ~= "minimum-drop-count-slider" then
		return
	end

	local player = game.connected_players[event.player_index]

	if not (player and player.valid) then
		return
	end

	local entity = player.opened
	if not (entity and entity.valid) then
		return
	end

	Public.hub_set_minimum_drop_count(entity, event.element.slider_value)

	for _, player2 in pairs(game.connected_players) do
		if player2.valid and player2.opened and player2.opened.valid and player2.opened == entity then
			local gui = player2.gui.relative[GUI_KEY]
			if gui then
				local flow = gui["frame"]["content"]["content-flow"]
				local slider = flow["minimum-drop-count-flow"]["minimum-drop-count-slider"]
				local textfield = flow["minimum-drop-count-textfield"]

				slider.slider_value = event.element.slider_value
				textfield.text = tostring(event.element.slider_value)
			end
		end
	end
end)

script.on_event(defines.events.on_gui_text_changed, function(event)
	if event.element.name ~= "minimum-drop-count-textfield" then
		return
	end

	local player = game.connected_players[event.player_index]

	if not (player and player.valid) then
		return
	end

	local entity = player.opened
	if not (entity and entity.valid) then
		return
	end

	local text = event.element.text
	local number = tonumber(text)

	if not number then
		return
	end

	number = math.floor(math.max(1, math.min(10, number)))
	local flow = event.element.parent
	local slider = flow["minimum-drop-count-flow"]["minimum-drop-count-slider"]

	if number ~= slider.slider_value then
		slider.slider_value = number
		if text ~= tostring(number) then
			event.element.text = tostring(number)
		end
	end

	Public.hub_set_minimum_drop_count(entity, number)

	for _, player2 in pairs(game.connected_players) do
		if player2.valid and player2.opened and player2.opened.valid and player2.opened == entity then
			local gui = player2.gui.relative[GUI_KEY]
			if gui then
				local flow2 = gui["frame"]["content"]["content-flow"]
				local slider2 = flow2["minimum-drop-count-flow"]["minimum-drop-count-slider"]
				local textfield2 = flow2["minimum-drop-count-textfield"]

				slider2.slider_value = number
				textfield2.text = tostring(number)
			end
		end
	end
end)

script.on_event(defines.events.on_entity_settings_pasted, function(event)
	local source = event.source
	local destination = event.destination

	if not (source and source.valid and destination and destination.valid) then
		return
	end

	local enabled, minimum_drop_count
	if source.name and source.name == "space-platform-hub" then
		if not storage.hub_settings then
			storage.hub_settings = {}
		end

		if not storage.hub_settings[source.unit_number] then
			storage.hub_settings[source.unit_number] = {}
		end

		local settings = storage.hub_settings[source.unit_number]
		enabled = settings.enabled
		minimum_drop_count = settings.minimum_drop_count
	elseif
		source.name
		and source.name == "entity-ghost"
		and source.ghost_name
		and source.ghost_name == "space-platform-hub"
	then
		local tags = source.tags or {}
		enabled = tags.enabled
		minimum_drop_count = tags.minimum_drop_count
	end

	Public.hub_set_minimum_drop_count(destination, minimum_drop_count)
	Public.hub_set_drop_limit_enabled(destination, enabled)
end)

script.on_event(defines.events.on_player_setup_blueprint, function(event)
	local player = game.connected_players[event.player_index]

	if not (player and player.valid) then
		return
	end

	local blueprint = player.blueprint_to_setup

	if not storage.hub_settings then
		storage.hub_settings = {}
	end

	if blueprint and blueprint.valid_for_read then
		local mapping = event.mapping.get()
		for blueprint_entity_number, entity in pairs(mapping) do
			if entity.name and entity.name == "space-platform-hub" then
				if not storage.hub_settings[entity.unit_number] then
					storage.hub_settings[entity.unit_number] = {}
				end

				local settings = storage.hub_settings[entity.unit_number]
				local tags = blueprint.get_blueprint_entity_tags(blueprint_entity_number) or {}
				tags.enabled = settings.enabled
				tags.minimum_drop_count = settings.minimum_drop_count
				blueprint.set_blueprint_entity_tags(blueprint_entity_number, tags)
			end
		end
	else
		local cursor_stack = player.cursor_stack

		if cursor_stack and cursor_stack.valid_for_read and cursor_stack.is_blueprint then
			local source_entity = event.mapping.get()[1]
			if
				source_entity
				and source_entity.valid
				and source_entity.name
				and source_entity.name == "space-platform-hub"
			then
				if not storage.hub_settings[source_entity.unit_number] then
					storage.hub_settings[source_entity.unit_number] = {}
				end

				local settings = storage.hub_settings[source_entity.unit_number]
				local tags = cursor_stack.get_blueprint_entity_tags(1) or {}
				tags.enabled = settings.enabled
				tags.minimum_drop_count = settings.minimum_drop_count
				cursor_stack.set_blueprint_entity_tags(1, tags)
			end
		end
	end
end)

Public.hub_set_drop_limit_enabled = function(entity, enabled)
	if not storage.hub_settings then
		storage.hub_settings = {}
	end

	if not storage.hub_settings[entity.unit_number] then
		storage.hub_settings[entity.unit_number] = {}
	end

	storage.hub_settings[entity.unit_number].enabled = enabled
end

Public.hub_set_minimum_drop_count = function(entity, minimum_drop_count)
	if not storage.hub_settings then
		storage.hub_settings = {}
	end

	if not storage.hub_settings[entity.unit_number] then
		storage.hub_settings[entity.unit_number] = {}
	end

	storage.hub_settings[entity.unit_number].minimum_drop_count = minimum_drop_count
end

return Public
