-- *** *** --
--*** HELPERS ***--
-- *** *** --

-- local function check_admin(cmd)
-- 	local player = game.players[cmd.player_index]

-- 	if player and player.valid then
-- 		if player.admin then
-- 			return true
-- 		else
-- 			player.print({ "roc-commands.cmd_error_not_admin" }, { color = { r = 255, g = 51, b = 51 } })
-- 			return false
-- 		end
-- 	end
-- end

-- local function check_mod_creator(cmd)
-- 	local player = game.players[cmd.player_index]

-- 	if player and player.valid then
-- 		if player.admin and player.name == "thesixthroc" then
-- 			return true
-- 		else
-- 			player.print({ "roc-commands.cmd_error_not_mod_creator" }, { color = { r = 255, g = 51, b = 51 } })
-- 			return false
-- 		end
-- 	end
-- end

-- @UNUSED. Is this code old?
-- local function check_trusted(cmd)
-- 	local Session = require 'utils.datastore.session_data'
-- 	local player = game.players[cmd.player_index]
-- 	local trusted = Session.get_trusted_table()
-- 	if not trusted[player.name] then...
-- 	return true
-- end

-- -- *** *** --
-- --*** COMMANDS ***--
-- -- *** *** --

-- commands.add_command("set_info_1", "Mod creator command used to update the info text on the Comfy server", function(cmd)
-- 	local player = game.get_player(cmd.player_index)

-- 	if check_mod_creator(cmd) then
-- 		local target_string = cmd.parameter

-- 		if target_string then
-- 			player.print("Overriding info_window_1_text to: " .. target_string)

-- 			storage.info_window_1_text = target_string
-- 		else
-- 			player.print("Please provide a target string.")
-- 		end
-- 	end
-- end)
-- commands.add_command("set_info_2", "Mod creator command used to update the info text on the Comfy server", function(cmd)
-- 	local player = game.get_player(cmd.player_index)

-- 	if check_mod_creator(cmd) then
-- 		local target_string = cmd.parameter

-- 		if target_string then
-- 			player.print("Overriding info_window_2_text to: " .. target_string)

-- 			storage.info_window_2_text = target_string
-- 		else
-- 			player.print("Please provide a target string.")
-- 		end
-- 	end
-- end)
-- commands.add_command("set_info_3", "Mod creator command used to update the info text on the Comfy server", function(cmd)
-- 	local player = game.get_player(cmd.player_index)

-- 	if check_mod_creator(cmd) then
-- 		local target_string = cmd.parameter

-- 		if target_string then
-- 			player.print("Overriding info_window_3_text to: " .. target_string)

-- 			storage.info_window_3_text = target_string
-- 		else
-- 			player.print("Please provide a target string.")
-- 		end
-- 	end
-- end)
