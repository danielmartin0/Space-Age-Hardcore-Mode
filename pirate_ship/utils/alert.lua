local Event = require 'utils.event'
local Global = require 'utils.global'
local Gui = require 'utils.gui'
local Task = require 'utils.task_token'
local Color = require 'utils.color_presets'
local SpamProtection = require 'utils.spam_protection'
local Commands = require 'utils.commands'

local pairs = pairs
local next = next

local Public = {}

local active_alerts = {}
local id_counter = { 0 }
local alert_zoom_to_pos = Gui.uid_name()

local on_tick

Global.register(
    { active_alerts = active_alerts, id_counter = id_counter },
    function (tbl)
        active_alerts = tbl.active_alerts
        id_counter = tbl.id_counter
    end
)

local alert_frame_name = Gui.uid_name()
local alert_container_name = Gui.uid_name()
local alert_progress_name = Gui.uid_name()
local close_alert_name = Gui.uid_name()

--- Apply this name to an element to have it close the alert when clicked.
-- Two elements in the same parent cannot have the same name. If you need your
-- own name you can use Public.close_alert(element)
Public.close_alert_name = close_alert_name

local delay_print_alert_token =
    Task.register(
        function (event)
            local text = event.text
            if not text then
                return
            end

            local ttl = event.ttl
            if not ttl then
                ttl = 60
            end

            local sprite = event.sprite
            local color = event.color

            Public.alert_all_players(ttl, text, color, sprite, 1)
        end
    )

Public.set_timeout_in_ticks_alert = function (delay, data)
    if not data then
        return error('Data was not provided', 2)
    end
    if type(data) ~= 'table' then
        return error("Data must be of type 'table'", 2)
    end

    if not delay then
        return error('No delay was provided', 2)
    end

    Task.set_timeout_in_ticks(delay, delay_print_alert_token, data)
end

---Creates a unique ID for a alert message
local function autoincrement()
    local id = id_counter[1] + 1
    id_counter[1] = id
    return id
end

---Attempts to get a alert based on the element, will traverse through parents to find it.
---@param element LuaGuiElement
local function get_alert(element)
    if not element or not element.valid then
        return nil
    end

    if element.name == alert_frame_name then
        return element.parent
    end

    return get_alert(element.parent)
end

--- Closes the alert for the element.
--@param element LuaGuiElement
function Public.close_alert(element)
    local alert = get_alert(element)
    if not alert then
        return
    end

    local data = Gui.get_data(alert)
    if not data then
        return
    end

    active_alerts[data.alert_id] = nil
    Gui.destroy(alert)
end

---Message to a specific player
---@param player LuaPlayer
---@param duration number in seconds
---@param sound string sound to play, nil to not play anything
local function alert_to(player, duration, sound, volume)
    local frame_holder = player.gui.left.add({ type = 'flow' })

    local frame = frame_holder.add({ type = 'frame', name = alert_frame_name, direction = 'vertical' })
    frame.style.width = 300
    frame.style.padding = 3

    local container = frame.add({ type = 'flow', name = alert_container_name, direction = 'horizontal' })
    container.style.horizontally_stretchable = true

    local progressbar = frame.add({ type = 'progressbar', name = alert_progress_name })
    local style = progressbar.style
    style.width = 290
    style.height = 4
    style.color = Color.orange
    progressbar.value = 1 -- it starts full

    local id = autoincrement()
    local tick = game.tick
    if not duration then
        duration = 15
    end

    Gui.set_data(
        frame_holder,
        {
            alert_id = id,
            progressbar = progressbar,
            start_tick = tick,
            end_tick = tick + duration * 60
        }
    )

    if not next(active_alerts) then
        Event.add_removable_nth_tick(2, on_tick)
    end

    active_alerts[id] = frame_holder

    if sound then
        volume = volume or 0.60
        player.play_sound({ path = sound, volume_modifier = volume })
    end

    return container
end

local function zoom_to_pos(event)
    local is_spamming = SpamProtection.is_spamming(event.player, nil, 'Alert Zoom to Pos')
    if is_spamming then
        return
    end
    local player = event.player
    local element = event.element
    local data = Gui.get_data(element)
    if not data then return end

    if player.controller_type == defines.controllers.remote then
        return
    end

    player.set_controller({
        type = defines.controllers.remote,
        position = data.position,
        surface = player.surface,
        zoom = 4
    })
end

local close_alert = Public.close_alert
local function on_click_close_alert(event)
    local is_spamming = SpamProtection.is_spamming(event.player, nil, 'Alert Close')
    if is_spamming then
        return
    end
    close_alert(event.element)
end

Gui.on_click(alert_zoom_to_pos, zoom_to_pos)
Gui.on_click(alert_frame_name, on_click_close_alert)
Gui.on_click(alert_container_name, on_click_close_alert)
Gui.on_click(alert_progress_name, on_click_close_alert)
Gui.on_click(close_alert_name, on_click_close_alert)

local function update_alert(id, frame, tick)
    if not frame.valid then
        active_alerts[id] = nil
        return
    end

    local data = Gui.get_data(frame)
    if not data then
        return
    end

    local end_tick = data.end_tick

    if tick > end_tick then
        Gui.destroy(frame)
        active_alerts[data.alert_id] = nil
    else
        local limit = end_tick - data.start_tick
        local current = end_tick - tick
        data.progressbar.value = current / limit
    end
end

on_tick =
    Task.register(
        function (event)
            if not next(active_alerts) then
                Event.remove_removable_nth_tick(2, on_tick)
                return
            end

            local tick = event.tick

            for id, frame in pairs(active_alerts) do
                update_alert(id, frame, tick)
            end
        end
    )

---Message a specific player, template is a callable that receives a LuaGuiElement
---to add contents to and a player as second argument.
---@param player LuaPlayer
---@param duration number
---@param template function
---@param sound string|nil sound to play, nil to not play anything
function Public.alert_player_template(player, duration, template, sound, volume)
    sound = sound or 'utility/new_objective'
    local container = alert_to(player, duration, sound, volume)
    if container then
        template(container, player)
    end
end

---Message all players of the given force, template is a callable that receives a LuaGuiElement
---to add contents to and a player as second argument.
---@param force LuaForce
---@param duration number
---@param template function
---@param sound string sound to play, nil to not play anything
function Public.alert_force_template(force, duration, template, sound)
    sound = sound or 'utility/new_objective'
    local players = force.connected_players
    for i = 1, #players do
        local player = players[i]
        template(alert_to(player, duration, sound), player)
    end
end

---Message all players, template is a callable that receives a LuaGuiElement
---to add contents to and a player as second argument.
---@param duration number
---@param template function
---@param sound string|nil sound to play, nil to not play anything
function Public.alert_all_players_template(duration, template, sound)
    sound = sound or 'utility/new_objective'
    local players = game.connected_players
    for i = 1, #players do
        local player = players[i]
        template(alert_to(player, duration, sound), player)
    end
end

---Message all players at a given location
---@param player LuaPlayer
---@param message string|table
---@param color string|table|nil
function Public.alert_all_players_location(player, message, color, duration)
    local length = duration or 15
    Public.alert_all_players_template(
        length,
        function (container)
            local sprite =
                container.add {
                    type = 'sprite-button',
                    name = alert_zoom_to_pos,
                    sprite = 'utility/search_icon',
                    style = 'slot_button'
                }

            Gui.set_data(sprite, player.position)

            local label =
                container.add {
                    type = 'label',
                    name = Public.close_alert_name,
                    caption = message
                }
            local label_style = label.style
            label_style.single_line = false
            label_style.font_color = color or Color.comfy
        end
    )
end

---Message to a specific player
---@param player LuaPlayer
---@param duration number
---@param message string|table
---@param color string|table|nil
function Public.alert_player(player, duration, message, color, sprite, volume)
    Public.alert_player_template(
        player,
        duration,
        function (container)
            container.add {
                type = 'sprite-button',
                sprite = sprite or 'achievement/you-are-doing-it-right',
                style = 'slot_button'
            }
            local label = container.add({ type = 'label', name = close_alert_name, caption = message })
            label.style.single_line = false
            label.style.font_color = color or Color.comfy
        end,
        nil,
        volume
    )
end

---Message to a specific player as warning
---@param player LuaPlayer
---@param duration number
---@param message string|table
---@param color string|table|nil
function Public.alert_player_warning(player, duration, message, color)
    Public.alert_player_template(
        player,
        duration,
        function (container)
            container.add {
                type = 'sprite-button',
                sprite = 'achievement/golem',
                style = 'slot_button'
            }
            local label = container.add({ type = 'label', name = close_alert_name, caption = message })
            label.style.single_line = false
            label.style.font_color = color or Color.comfy
        end
    )
end

---Message to all players of a given force
---@param force LuaForce
---@param duration number
---@param message string|table
function Public.alert_force(force, duration, message)
    local players = force.connected_players
    for i = 1, #players do
        local player = players[i]
        Public.alert_player(player, duration, message)
    end
end

---Message to all players
---@param duration number
---@param message string|table
---@param color string|table|nil
function Public.alert_all_players(duration, message, color, sprite, volume)
    local players = game.connected_players
    for i = 1, #players do
        local player = players[i]
        Public.alert_player(player, duration, message, color, sprite, volume)
    end
end

Commands.new('notify_all_players', 'Usable only for admins - sends an alert message to all players!')
    :add_parameter('message', false, 'string')
    :callback(
        function (player, message)
            local comfy = '[color=blue]' .. player.name .. ':[/color] \n'
            message = comfy .. message
            Public.alert_all_players_location(player, message)
        end
    )

Commands.new('notify_player', 'Usable only for admins - sends an alert message to a player!')
    :add_parameter('player', false, 'player-online')
    :add_parameter('message', false, 'string')
    :callback(
        function (player, target_player, message)
            if target_player then
                local comfy = '[color=blue]' .. player.name .. ':[/color] \n'
                message = comfy .. message
                Public.alert_player_warning(target_player, 15, message)
            end
        end
    )


return Public
