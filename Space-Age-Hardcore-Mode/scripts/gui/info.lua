local GuiCommon = require("scripts.gui.common")

local Public = {}

local window_name = "info"

function Public.toggle_window(player)
	local flow, flow2, flow3, flow4, flow5

	if player.gui.screen["roc_gui_window_" .. window_name] then
		player.gui.screen["roc_gui_window_" .. window_name].destroy()
		return
	end

	flow = GuiCommon.new_window(player, window_name)
	flow.caption = { "roc-gui.info-window-heading" }

	flow2 = flow.add({ type = "label", caption = { "roc-gui.info-window-body-1" } })
	flow2.style.font_color = GuiCommon.friendly_font_color
	flow2.style.single_line = false
	flow2.style.font = "default-large"
	flow2.style.top_margin = 4
	flow2.style.bottom_margin = 10
	flow2.style.right_margin = -10

	flow2 = flow.add({
		type = "label",
		caption =
		"[font=scenario-message-dialog]Space Age: Hardcore Mode is a collection of Vanilla+ mods & tweaks that tighten the gameplay of Space Age, removing certain [color=orange]shortcuts[/color] and adding interesting challenge.\n\n[color=orange]Cargo drops[/color] on planets require a new cargo pod item made from materials native to that planet in the platform's hub.\n\nEach planet has slightly tweaked gameplay. Certain research, such as [color=orange]Logistic System[/color], are delayed until Aquilo.[/font]"
	})
	flow2.style.font_color = GuiCommon.friendly_font_color
	flow2.style.single_line = false
	flow2.style.bottom_margin = 1

	flow2 = flow.add({
		type = "flow",
		name = "last_info_flow_1",
		direction = "horizontal",
	})
	flow2.style.top_margin = 10
	flow2.style.bottom_margin = 20

	flow3 = flow2.add({
		type = "flow",
		name = "last_info_flow_2",
		direction = "horizontal",
	})
	flow3.style.horizontally_stretchable = true

	flow4 = flow3.add({
		type = "flow",
		direction = "vertical",
	})
	flow4.style.vertically_stretchable = true
	flow4.style.horizontally_stretchable = true
	flow4.style.vertical_align = "center"
	flow4.style.horizontal_align = "left"

	flow5 = flow4.add({
		type = "label",
		caption =
		"[font=scenario-message-dialog]Suggestions welcome on Discord (follow QR or link on mod portal).[/font]",
	})
	flow5.style.single_line = false
	flow5.style.vertical_align = "center"
	flow5.style.font_color = GuiCommon.friendly_font_color
	flow5.style.single_line = false
	flow5.style.top_margin = 5

	flow4 = flow3.add({
		type = "sprite",
		sprite = "discord_qr_code",
	})
	flow4.style.left_margin = 10

	flow2 = flow.add({ type = "label", caption = { "roc-gui.info-window-body-4" } })
	flow2.style.font_color = GuiCommon.friendly_font_color
	flow2.style.single_line = false
	flow2.style.bottom_margin = 1
	flow2.style.horizontal_align = "center"

	GuiCommon.flow_add_close_button(flow, "roc_gui_button_" .. window_name)
end

-- function Public.full_update(player)
-- 	if Public.regular_update then
-- 		Public.regular_update(player)
-- 	end
-- 	if not player.gui.screen["roc_gui_window_" .. window_name] then
-- 		return
-- 	end
-- end

return Public
