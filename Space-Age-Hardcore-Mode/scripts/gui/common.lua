-- local mod_gui = require("__core__.lualib.mod-gui")

local Public = {}

Public.bold_font_color = { 255, 230, 192 }
Public.default_font_color = { 1, 1, 1 }
Public.section_header_font_color = { r = 0.40, g = 0.80, b = 0.60 }
Public.subsection_header_font_color = { 229, 255, 242 }
Public.friendly_font_color = { 246, 230, 255 }
Public.sufficient_font_color = { 66, 220, 124 }
Public.insufficient_font_color = { 1, 0.62, 0.19 }
Public.achieved_font_color = { 227, 250, 192 }

Public.default_window_positions = {
	-- y-positions should avoid overlapping the button in remote view:
	info = { x = 206, y = 260 },
}

function Public.new_window(player, name)
	if not storage.player_gui_memories then
		storage.player_gui_memories = {}
	end

	local gui_memory = storage.player_gui_memories[player.index]
	local flow

	flow = player.gui.screen.add({
		type = "frame",
		name = "roc_gui_window_" .. name,
		direction = "vertical",
	})

	if gui_memory and gui_memory[name] and gui_memory[name].position then
		flow.location = gui_memory[name].position
	else
		flow.location = Public.default_window_positions[name]
	end

	flow.style = "map_details_frame"
	flow.style.minimal_width = 210
	flow.style.natural_width = 210
	flow.style.maximal_width = 390
	flow.style.minimal_height = 80
	flow.style.natural_height = 80
	flow.style.maximal_height = 760
	flow.style.padding = 15

	return flow
end

function Public.update_gui_memory(player, namespace, key, value)
	if not storage.player_gui_memories[player.index] then
		storage.player_gui_memories[player.index] = {}
	end
	local gui_memory = storage.player_gui_memories[player.index]
	if not gui_memory[namespace] then
		gui_memory[namespace] = {}
	end
	gui_memory[namespace][key] = value
end

function Public.flow_add_floating_sprite_button(flow1, button_name, width)
	width = width or 50
	local flow2

	flow2 = flow1.add({
		name = button_name,
		type = "sprite-button",
	})
	flow2.style.height = 50
	flow2.style.width = width

	return flow2
end

function Public.flow_add_section(flow, name, caption)
	local flow2, flow3

	flow2 = flow.add({
		name = name,
		type = "flow",
		direction = "vertical",
	})
	flow2.style.bottom_margin = 5

	flow3 = flow2.add({
		type = "label",
		name = "header",
		caption = caption,
	})
	flow3.style.font = "heading-2"
	flow3.style.font_color = Public.section_header_font_color
	flow3.style.maximal_width = 300
	-- flow3.style.single_line = false

	flow3 = flow2.add({
		name = "body",
		type = "flow",
		direction = "vertical",
	})
	flow3.style.left_margin = 5
	flow3.style.right_margin = 5

	return flow3
end

function Public.flow_add_subpanel(flow, name)
	local flow2

	flow2 = flow.add({
		name = name,
		type = "frame",
		direction = "vertical",
	})
	flow2.style = "tabbed_pane_frame"
	flow2.style.natural_width = 100
	flow2.style.top_padding = -2
	flow2.style.top_margin = -2

	return flow2
end

function Public.flow_add_close_button(flow, close_button_name)
	local flow2, flow3, flow4

	flow2 = flow.add({
		name = "close_button_flow",
		type = "flow",
		direction = "vertical",
	})

	flow3 = flow2.add({ type = "flow", name = "hflow", direction = "horizontal" })
	flow3.style.vertical_align = "center"

	flow4 = flow3.add({ type = "flow", name = "spacing", direction = "horizontal" })
	flow4.style.horizontally_stretchable = true

	flow4 = flow3.add({
		type = "button",
		name = close_button_name,
		caption = { "roc-gui.close_button" },
	})
	flow4.style = "back_button"
	flow4.style.minimal_width = 90
	flow4.style.font = "default-bold"
	flow4.style.height = 28
	flow4.style.horizontal_align = "center"

	return flow3
end

function Public.update_listbox(listbox, table)
	-- pass a table of strings of the form {'locale', unique_id, ...}

	-- remove any that shouldn't be there
	local marked_for_removal = {}
	for index, item in pairs(listbox.items) do
		local exists = false
		for _, i in pairs(table) do
			if tostring(i[2]) == item[2] then
				exists = true
			end
		end
		if exists == false then
			marked_for_removal[#marked_for_removal + 1] = index
		end
	end
	for i = #marked_for_removal, 1, -1 do
		listbox.remove_item(marked_for_removal[i])
	end

	local indexalreadyat
	for _, i in pairs(table) do
		local contained = false
		for index, item in pairs(listbox.items) do
			if tostring(i[2]) == item[2] then
				contained = true
				indexalreadyat = index
			end
		end

		if contained then
			listbox.set_item(indexalreadyat, i)
		else
			listbox.add_item(i)
		end
	end
end

return Public
