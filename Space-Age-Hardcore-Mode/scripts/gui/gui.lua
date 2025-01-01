local GuiCommon = require("scripts.gui.common")

local Public = {}

Public.info = require("scripts.gui.info")

script.on_nth_tick(60, function()
	-- We don't currently have GUI that needs updating:
	-- for _, player in pairs(game.connected_players) do
	-- 	Public.update_gui(player)
	-- end
end)

function Public.get_or_create_top_bar(player)
	local flow1, flow2

	flow1 = player.gui.top

	if flow1.roc_gui then
		return flow1.roc_gui
	end

	flow2 = flow1.add({
		type = "flow",
		name = "roc_gui",
		direction = "horizontal",
	})
	flow2.style.height = 60
	flow2.style.left_margin = -1
	flow2.style.top_margin = -1

	return flow2
end

function Public.update_top_bar(player)
	local enable = settings.get_player_settings(player.index)["rocs-hardcore-a-enable-info-gui"].value

	local flow1 = Public.get_or_create_top_bar(player)

	if enable and game.is_multiplayer() and not flow1.roc_gui_button_info then
		Public.create_info_button(player)
	end

	if ((not enable) or not game.is_multiplayer()) and flow1.roc_gui_button_info then
		flow1.roc_gui_button_info.destroy()
		if player.gui.screen["roc_gui_window_info"] then
			player.gui.screen["roc_gui_window_info"].destroy()
		end
	end
end

function Public.create_info_button(player)
	local flow1, flow2

	flow1 = Public.get_or_create_top_bar(player)

	flow2 = GuiCommon.flow_add_floating_sprite_button(flow1, "roc_gui_button_info")
	flow2.caption = { "roc-gui.info-button-caption" }
	flow2.style.font = "debug"
	flow2.tooltip = { "roc-gui.info-button-tooltip" }
	flow2.style.font_color = { r = 1, g = 1, b = 1 }
	flow2.style.hovered_font_color = { r = 1, g = 1, b = 1 }
	flow2.style.clicked_font_color = { r = 1, g = 1, b = 1 }

	-- flow2 = GuiCommon.flow_add_floating_sprite_button(flow1, "roc_gui_button_blah")
	-- flow2.sprite = "utility/spawn_flag"
	-- flow2.style.left_margin = -5

	return flow1
end

script.on_event(defines.events.on_gui_click, function(event)
	if not event then
		return
	end
	if not event.element then
		return
	end
	if not event.element.valid then
		return
	end

	local player = game.players[event.element.player_index]

	local is_button = string.sub(event.element.name, 1, 15) == "roc_gui_button_"
	local button_name = is_button and string.sub(event.element.name, 16, -1)
	local ButtonCode = button_name and Public[button_name]

	if ButtonCode then
		if is_button then
			ButtonCode.toggle_window(player)
			if ButtonCode.full_update then
				ButtonCode.full_update(player)
			end
		elseif ButtonCode.click then
			ButtonCode.click(player, event)
		end
	end
end)

script.on_event(defines.events.on_gui_location_changed, function(event)
	if not event and event.element and event.element.valid then
		return
	end

	local is_window = string.sub(event.element.name, 1, 15) == "roc_gui_window_"
	local window_name = is_window and string.sub(event.element.name, 16, -1)

	if window_name then
		local player = game.players[event.element.player_index]

		GuiCommon.update_gui_memory(player, window_name, "position", event.element.location)
	end
end)

return Public
