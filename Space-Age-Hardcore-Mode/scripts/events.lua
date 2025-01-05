local Gui = require("scripts.gui.gui")
local Common = require("scripts.common")

local Public = {}

-- local notify_color = { r = 255, g = 231, b = 46 }

script.on_event(defines.events.on_player_joined_game, function(event)
	local player = game.get_player(event.player_index)

	Gui.update_top_bar(player)

	if
		game.tick < 1
		and settings.get_player_settings(event.player_index)["rocs-hardcore-a-enable-info-gui"].value
		and game.is_multiplayer()
	then
		Gui.info.toggle_window(player)
	end

	Common.init_tech(player.force)

	-- player.force.set_ammo_damage_modifier(
	-- 	"shotgun-shell",
	-- 	(settings.startup["rocs-hardcore-bonus-shotgun-damage-percent"].value / 100)
	-- )
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
	Gui.update_top_bar(game.players[event.player_index])
end)

script.on_event(defines.events.on_force_created, function(event)
	Common.init_tech(event.force)
end)

script.on_configuration_changed(function()
	for _, force in pairs(game.forces) do
		Common.init_tech(force)
	end

	for _, player in pairs(game.connected_players) do
		Gui.update_top_bar(player)
	end
end)

-- script.on_event(defines.events.on_player_respawned, function(event)
-- 	local no_starting_items = settings.global["rocs-hardcore-no-starting-items"].value

-- 	if no_starting_items then
-- 		local player = game.players[event.player_index]

-- 		player.clear_items_inside()
-- 	end
-- end)

-- script.on_event(defines.events.on_research_finished, function(event)
-- 	local research = event.research
-- 	local force = research.force

-- 	for _, e in ipairs(research.prototype.effects) do
-- 		local type = e.type
-- 		local category = e.ammo_category

-- 		if type == "ammo-damage" and category == "shotgun-shell" then
-- 			local factor = (settings.startup["rocs-hardcore-bonus-shotgun-damage-percent"].value / 100)

-- 			local tech_modifier = e.modifier
-- 			local extra_tech_modifier = factor * tech_modifier

-- 			local current = force.get_ammo_damage_modifier(category)

-- 			force.set_ammo_damage_modifier(category, current + extra_tech_modifier)
-- 		end
-- 	end
-- end)

return Public
