--luacheck: ignore 143
local Gui = require 'utils.gui'
local Global = require 'utils.global'
local Event = require 'utils.event'
local Server = require 'utils.server'
local session = require 'utils.datastore.session_data'
local Config = require 'utils.gui.config'
local SpamProtection = require 'utils.spam_protection'
local Math = require 'utils.math.math'
local Public = {}

local insert = table.insert
local contains = table.contains
local remove_element = table.remove_element

local default_poll_duration = 300 * 60 -- in ticks
local duration_max = 3600 -- in seconds
local duration_step = 15 -- in seconds

local duration_slider_max = duration_max / duration_step
local tick_duration_step = duration_step * 60
local inv_tick_duration_step = 1 / tick_duration_step

local polls = {}
local polls_counter = { 0 }
local running_polls = {}
local no_notify_players = {}
local player_poll_index = {}
local player_create_poll_data = {}

Global.register(
    {
        polls = polls,
        polls_counter = polls_counter,
        running_polls = running_polls,
        no_notify_players = no_notify_players,
        player_poll_index = player_poll_index,
        player_create_poll_data = player_create_poll_data
    },
    function (tbl)
        polls = tbl.polls
        polls_counter = tbl.polls_counter
        running_polls = tbl.running_polls
        no_notify_players = tbl.no_notify_players
        player_poll_index = tbl.player_poll_index
        player_create_poll_data = tbl.player_create_poll_data
    end
)

local main_button_name = Gui.uid_name()
local main_frame_name = Gui.uid_name()
local create_poll_button_name = Gui.uid_name()
local notify_checkbox_name = Gui.uid_name()

local poll_view_back_name = Gui.uid_name()
local poll_view_forward_name = Gui.uid_name()
local poll_view_vote_name = Gui.uid_name()
local poll_view_edit_name = Gui.uid_name()

local create_poll_frame_name = Gui.uid_name()
local create_poll_duration_name = Gui.uid_name()
local create_poll_label_name = Gui.uid_name()
local create_poll_question_name = Gui.uid_name()
local create_poll_answer_name = Gui.uid_name()
local create_poll_add_answer_name = Gui.uid_name()
local create_poll_delete_answer_name = Gui.uid_name()
local create_poll_close_name = Gui.uid_name()
local create_poll_clear_name = Gui.uid_name()
local create_poll_edit_name = Gui.uid_name()
local create_poll_confirm_name = Gui.uid_name()
local create_poll_delete_name = Gui.uid_name()

local function poll_id()
    local count = polls_counter[1] + 1
    polls_counter[1] = count
    return count
end

local function apply_direction_button_style(button)
    local button_style = button.style
    button_style.width = 24
    button_style.height = 24
    button_style.top_padding = 0
    button_style.bottom_padding = 0
    button_style.left_padding = 0
    button_style.right_padding = 0
    button_style.font = 'default-listbox'
end

local function apply_button_style(button)
    local button_style = button.style
    button_style.font = 'default-semibold'
    button_style.height = 26
    button_style.minimal_width = 26
    button_style.top_padding = 0
    button_style.bottom_padding = 0
    button_style.left_padding = 2
    button_style.right_padding = 2
end

local function do_remaining_time(poll, remaining_time_label)
    local end_tick = poll.end_tick
    if end_tick == -1 then
        remaining_time_label.caption = 'Endless Poll.'
        return true
    end

    local ticks = end_tick - game.tick
    if ticks < 0 then
        remaining_time_label.caption = 'Poll Finished.'
        return false
    else
        local time = math.ceil(ticks / 60)
        remaining_time_label.caption = 'Remaining Time: ' .. time
        return true
    end
end

local function send_poll_result_to_discord(poll)
    local result = { 'Poll #', poll.id }

    local created_by_player = poll.created_by
    if created_by_player then
        insert(result, ' Created by ')
        insert(result, created_by_player)
    end

    local edited_by_players = poll.edited_by
    if next(edited_by_players) then
        insert(result, ' Edited by ')
        for pi, _ in pairs(edited_by_players) do
            local p = game.players[pi]
            if p and p.valid then
                insert(result, p.name)
                insert(result, ', ')
            end
        end
        table.remove(result)
    end

    insert(result, '\\n**Question: ')
    insert(result, poll.question)
    insert(result, '**\\n')

    local answers = poll.answers
    local answers_count = #answers
    for i, a in pairs(answers) do
        insert(result, '[')
        insert(result, a.voted_count)
        insert(result, '] - ')
        insert(result, a.text)
        if i ~= answers_count then
            insert(result, '\\n')
        end
    end

    local message = table.concat(result)
    Server.to_discord_embed(message)
end

local function redraw_poll_viewer_content(data)
    local poll_viewer_content = data.poll_viewer_content
    local remaining_time_label = data.remaining_time_label
    local poll_index = data.poll_index
    local player = poll_viewer_content.gui.player

    data.vote_buttons = nil
    Gui.remove_data_recursively(poll_viewer_content)
    poll_viewer_content.clear()

    local poll = polls[poll_index]
    if not poll then
        return
    end

    local answers = poll.answers

    local created_by_player = poll.created_by
    local created_by_text
    if created_by_player then
        created_by_text = ' Created by ' .. created_by_player
    else
        created_by_text = ''
    end

    local top_flow = poll_viewer_content.add { type = 'flow', direction = 'vertical' }
    top_flow.add { type = 'label', caption = table.concat { 'Poll #', poll.id, created_by_text } }

    local edited_by_players = poll.edited_by
    if next(edited_by_players) then
        local edit_names = { 'Edited by ' }
        for pi, _ in pairs(edited_by_players) do
            local p = game.get_player(pi)
            if p and p.valid then
                insert(edit_names, p.name)
                insert(edit_names, ', ')
            end
        end

        table.remove(edit_names)
        local edit_text = table.concat(edit_names)

        local top_flow_label = top_flow.add { type = 'label', caption = edit_text, tooltip = edit_text }
        top_flow_label.style.single_line = false
        top_flow_label.style.horizontally_stretchable = false
    end

    local poll_enabled = do_remaining_time(poll, remaining_time_label)

    local question_flow = poll_viewer_content.add { type = 'table', column_count = 2 }
    if player.admin and not poll.created_by_script then
        local edit_button =
            question_flow.add
            {
                type = 'sprite-button',
                name = poll_view_edit_name,
                sprite = 'utility/rename_icon',
                tooltip = 'Edit Poll.'
            }

        local edit_button_style = edit_button.style
        edit_button_style.width = 26
        edit_button_style.height = 26
    end

    local question_label = question_flow.add { type = 'label', caption = poll.question }
    question_label.style.minimal_height = 32
    question_label.style.single_line = false
    question_label.style.font = 'heading-2'
    question_label.style.font_color = { r = 0.98, g = 0.66, b = 0.22 }
    question_label.style.top_padding = 4
    question_label.style.left_padding = 4
    question_label.style.right_padding = 4
    question_label.style.bottom_padding = 4

    local grid = poll_viewer_content.add { type = 'table', column_count = 2 }

    local vote_buttons = {}
    for i, a in pairs(answers) do
        local vote_button_flow = grid.add { type = 'flow' }
        local vote_button =
            vote_button_flow.add
            {
                type = 'button',
                name = poll_view_vote_name,
                caption = a.voted_count,
                enabled = poll_enabled
            }

        local vote_button_style = vote_button.style
        vote_button_style.height = 24
        vote_button_style.width = 26
        vote_button_style.font = 'default-small'
        vote_button_style.top_padding = 0
        vote_button_style.bottom_padding = 0
        vote_button_style.left_padding = 0
        vote_button_style.right_padding = 0

        Gui.set_data(vote_button, { answer = a, data = data })
        vote_buttons[i] = vote_button

        local label = grid.add { type = 'label', caption = a.text }
        label.style.single_line = false
        label.style.minimal_height = 24
        label.style.font = 'default-semibold'
        label.style.font_color = { r = 0.95, g = 0.95, b = 0.95 }
        label.style.left_padding = 4
        label.style.right_padding = 4
        label.style.bottom_padding = 4
    end

    data.vote_buttons = vote_buttons
end

local function update_poll_viewer(data)
    local back_button = data.back_button
    local forward_button = data.forward_button
    local poll_index_label = data.poll_index_label
    local poll_index = data.poll_index

    if #polls == 0 then
        poll_index = 0
    else
        poll_index = Math.clamp(poll_index, 1, #polls)
    end

    data.poll_index = poll_index

    if poll_index == 0 then
        poll_index_label.caption = 'No Polls'
    else
        poll_index_label.caption = table.concat { 'Poll ', poll_index, ' / ', #polls }
    end

    back_button.enabled = poll_index > 1
    forward_button.enabled = poll_index < #polls

    redraw_poll_viewer_content(data)
end

local function draw_main_frame(_, player)
    local trusted = session.get_trusted_table()
    local main_frame, inside_frame = Gui.add_main_frame_with_toolbar(player, 'left', main_frame_name, nil, main_button_name, 'Polls')

    local poll_viewer_top_flow = inside_frame.add { type = 'table', column_count = 5 }
    poll_viewer_top_flow.style.horizontal_spacing = 0

    local back_button = poll_viewer_top_flow.add { type = 'button', name = poll_view_back_name, caption = '◀' }
    apply_direction_button_style(back_button)

    local forward_button = poll_viewer_top_flow.add { type = 'button', name = poll_view_forward_name, caption = '▶' }
    apply_direction_button_style(forward_button)

    local poll_index_label = poll_viewer_top_flow.add { type = 'label' }
    poll_index_label.style.left_padding = 8

    local spacer = poll_viewer_top_flow.add { type = 'flow' }
    spacer.style.horizontally_stretchable = true

    local remaining_time_label = poll_viewer_top_flow.add { type = 'label' }

    local poll_viewer_content = inside_frame.add { type = 'scroll-pane' }
    poll_viewer_content.style.maximal_height = 480
    poll_viewer_content.style.width = 274

    local poll_index = player_poll_index[player.index] or #polls

    local data =
    {
        back_button = back_button,
        forward_button = forward_button,
        poll_index_label = poll_index_label,
        poll_viewer_content = poll_viewer_content,
        remaining_time_label = remaining_time_label,
        poll_index = poll_index
    }

    Gui.set_data(main_frame, data)
    Gui.set_data(back_button, data)
    Gui.set_data(forward_button, data)

    update_poll_viewer(data)

    local bottom_flow = inside_frame.add { type = 'flow', direction = 'horizontal' }

    local left_flow = bottom_flow.add { type = 'flow' }
    left_flow.style.horizontal_align = 'left'
    left_flow.style.horizontally_stretchable = true

    local right_flow = bottom_flow.add { type = 'flow' }
    right_flow.style.horizontal_align = 'right'

    local config = Config.get('gui_config')

    if (trusted[player.name] or player.admin) or config.poll_trusted == false then
        local create_poll_button = right_flow.add { type = 'button', name = create_poll_button_name, caption = 'Create Poll' }
        apply_button_style(create_poll_button)
    else
        local create_poll_button =
            right_flow.add
            {
                type = 'button',
                caption = 'Create Poll',
                enabled = false,
                tooltip = 'Sorry, you need to be trusted to create polls.'
            }
        apply_button_style(create_poll_button)
    end
end

local function remove_create_poll_frame(create_poll_frame, player_index)
    local data = Gui.get_data(create_poll_frame)
    if not data then
        return
    end

    data.edit_mode = nil
    player_create_poll_data[player_index] = data

    Gui.remove_data_recursively(create_poll_frame)
    create_poll_frame.destroy()
end

local function remove_main_frame(main_frame, left, player)
    local player_index = player.index
    local data = Gui.get_data(main_frame)
    player_poll_index[player_index] = data.poll_index

    Gui.remove_data_recursively(main_frame)
    main_frame.destroy()

    local create_poll_frame = left[create_poll_frame_name]
    if create_poll_frame and create_poll_frame.valid then
        remove_create_poll_frame(create_poll_frame, player_index)
    end
end

local function toggle(event)
    local is_spamming = SpamProtection.is_spamming(event.player, nil, 'Toggle Poll')
    if is_spamming then
        return
    end

    local left = event.player.gui.left
    local main_frame = left[main_frame_name]

    if main_frame then
        remove_main_frame(main_frame, left, event.player)
    else
        Gui.clear_all_active_frames(event.player)
        draw_main_frame(left, event.player)
    end
end

local function update_duration(slider)
    local slider_data = Gui.get_data(slider)
    local label = slider_data.duration_label
    local value = slider.slider_value

    value = math.floor(value)

    slider_data.data.duration = value * tick_duration_step

    if value == 0 then
        label.caption = 'Endless Poll.'
    else
        label.caption = value * duration_step .. ' sec.'
    end
end

local function redraw_create_poll_content(data)
    local grid = data.grid
    local answers = data.answers

    Gui.remove_data_recursively(grid)
    grid.clear()

    grid.add { type = 'flow' }
    grid.add
    {
        type = 'label',
        caption = 'Duration:',
        tooltip = 'Pro tip: Use mouse wheel or arrow keys for more fine control.'
    }

    local duration_flow = grid.add { type = 'flow', direction = 'horizontal' }
    local duration_slider =
        duration_flow.add
        {
            type = 'slider',
            name = create_poll_duration_name,
            minimum_value = 0,
            maximum_value = duration_slider_max,
            value = math.floor(data.duration * inv_tick_duration_step)
        }
    duration_slider.style.width = 100

    data.duration_slider = duration_slider

    local duration_label = duration_flow.add { type = 'label' }

    Gui.set_data(duration_slider, { duration_label = duration_label, data = data })

    update_duration(duration_slider)

    grid.add { type = 'flow' }
    local question_label = grid.add({ type = 'flow' }).add { type = 'label', name = create_poll_label_name, caption = 'Question:' }

    local question_textfield = grid.add({ type = 'flow' }).add { type = 'textfield', name = create_poll_question_name, text = data.question }
    question_textfield.style.width = 170

    Gui.set_data(question_label, question_textfield)
    Gui.set_data(question_textfield, data)

    local edit_mode = data.edit_mode
    for count, answer in pairs(answers) do
        local delete_flow = grid.add { type = 'flow' }

        local delete_button
        if edit_mode or count ~= 1 then
            delete_button =
                delete_flow.add
                {
                    type = 'sprite-button',
                    name = create_poll_delete_answer_name,
                    sprite = 'utility/trash',
                    tooltip = 'Delete answer field.'
                }
            delete_button.style.height = 26
            delete_button.style.width = 26
        else
            delete_flow.style.height = 26
            delete_flow.style.width = 26
        end

        local label_flow = grid.add { type = 'flow' }
        local label =
            label_flow.add
            {
                type = 'label',
                name = create_poll_label_name,
                caption = table.concat { 'Answer #', count, ':' }
            }

        local textfield_flow = grid.add { type = 'flow' }

        local textfield = textfield_flow.add { type = 'textfield', name = create_poll_answer_name, text = answer.text }
        textfield.style.width = 170
        Gui.set_data(textfield, { answers = answers, count = count })

        if delete_button then
            Gui.set_data(delete_button, { data = data, count = count })
        end

        Gui.set_data(label, textfield)
    end
end

local function draw_create_poll_frame(parent, player, previous_data)
    previous_data = previous_data or player_create_poll_data[player.index]

    local edit_mode
    local question
    local answers
    local duration
    local title_text
    local confirm_text
    local confirm_name
    if previous_data then
        edit_mode = previous_data.edit_mode

        question = previous_data.question

        answers = {}
        for i, a in pairs(previous_data.answers) do
            answers[i] = { text = a.text, source = a }
        end

        duration = previous_data.duration
    else
        question = ''
        answers = { { text = '' }, { text = '' }, { text = '' } }
        duration = default_poll_duration
    end

    if edit_mode then
        title_text = 'Edit Poll #' .. previous_data.id
        confirm_text = 'Edit Poll'
        confirm_name = create_poll_edit_name
    else
        title_text = 'New Poll'
        confirm_text = 'Create Poll'
        confirm_name = create_poll_confirm_name
    end

    local frame = parent.add { type = 'frame', name = create_poll_frame_name, caption = title_text, direction = 'vertical' }
    frame.style.maximal_width = 320

    local scroll_pane = frame.add { type = 'scroll-pane', vertical_scroll_policy = 'always' }
    scroll_pane.style.maximal_height = 250
    scroll_pane.style.maximal_width = 300
    scroll_pane.style.padding = 3

    local grid = scroll_pane.add { type = 'table', column_count = 3 }

    local data =
    {
        frame = frame,
        grid = grid,
        question = question,
        answers = answers,
        duration = duration,
        previous_data = previous_data,
        edit_mode = edit_mode
    }

    Gui.set_data(frame, data)

    redraw_create_poll_content(data)

    local add_answer_button =
        scroll_pane.add
        {
            type = 'button',
            name = create_poll_add_answer_name,
            caption = 'Add Answer'
        }
    apply_button_style(add_answer_button)
    Gui.set_data(add_answer_button, data)

    local bottom_flow = frame.add { type = 'flow', direction = 'horizontal' }

    local left_flow = bottom_flow.add { type = 'flow' }
    left_flow.style.horizontal_align = 'left'
    left_flow.style.horizontally_stretchable = true

    local close_button = left_flow.add { type = 'button', name = create_poll_close_name, caption = 'Close' }
    apply_button_style(close_button)
    Gui.set_data(close_button, frame)

    local clear_button = left_flow.add { type = 'button', name = create_poll_clear_name, caption = 'Clear' }
    apply_button_style(clear_button)
    Gui.set_data(clear_button, data)

    local right_flow = bottom_flow.add { type = 'flow' }
    right_flow.style.horizontal_align = 'right'

    if edit_mode then
        local delete_button = right_flow.add { type = 'button', name = create_poll_delete_name, caption = 'Delete' }
        apply_button_style(delete_button)
        Gui.set_data(delete_button, data)
    end

    local confirm_button = right_flow.add { type = 'button', name = confirm_name, caption = confirm_text }
    apply_button_style(confirm_button)
    Gui.set_data(confirm_button, data)
end

local function show_new_poll(poll_data)
    local message = table.concat { poll_data.created_by, ' has created a new Poll #', poll_data.id, ': ', poll_data.question }

    for _, p in pairs(game.connected_players) do
        local left = p.gui.left
        local frame = left[main_frame_name]
        if no_notify_players[p.index] then
            if frame and frame.valid then
                local data = Gui.get_data(frame)
                update_poll_viewer(data)
            end
        else
            p.print(message)

            if frame and frame.valid then
                local data = Gui.get_data(frame)
                data.poll_index = #polls
                update_poll_viewer(data)
            else
                player_poll_index[p.index] = nil
                draw_main_frame(left, p)
            end
        end
    end
end

local function create_poll(event)
    local is_spamming = SpamProtection.is_spamming(event.player, nil, 'Create Poll Confirm')
    if is_spamming then
        return
    end
    local player = event.player
    local data = Gui.get_data(event.element)

    if not data then
        return
    end

    local frame = data.frame
    local question = data.question

    if not question:find('%S') then
        event.player.print('Sorry, the poll needs a question.')
        return
    end

    local answers = {}
    for _, a in pairs(data.answers) do
        local text = a.text
        if text:find('%S') then
            local index = #answers + 1
            answers[index] = { text = text, index = index, voted_count = 0 }
        end
    end

    if #answers < 1 then
        player.print('Sorry, the poll needs at least one answer.')
        return
    end

    player_create_poll_data[player.index] = nil

    local tick = game.tick
    local duration = data.duration
    local end_tick

    if duration == 0 then
        end_tick = -1
    else
        end_tick = tick + duration
    end

    local name = ''
    if event.player and event.player.valid then
        name = event.player.name
    end

    local poll_data =
    {
        id = poll_id(),
        question = question,
        answers = answers,
        voters = {},
        start_tick = tick,
        end_tick = end_tick,
        duration = duration,
        created_by = name,
        edited_by = {}
    }

    insert(polls, poll_data)
    insert(running_polls, poll_data)

    show_new_poll(poll_data)
    send_poll_result_to_discord(poll_data)

    Gui.remove_data_recursively(frame)
    frame.destroy()
end

local function update_vote(answer, direction)
    local count = answer.voted_count + direction
    answer.voted_count = count

    return tostring(count)
end

local function vote(event)
    local is_spamming = SpamProtection.is_spamming(event.player, nil, 'Poll Vote')
    if is_spamming then
        return
    end
    local player_index = event.player_index
    local voted_button = event.element
    local button_data = Gui.get_data(voted_button)
    local answer = button_data.answer

    local poll_index = button_data.data.poll_index
    local poll = polls[poll_index]

    local voters = poll.voters

    local previous_vote_answer = voters[player_index]
    if previous_vote_answer == answer then
        return
    end

    local vote_index = answer.index

    voters[player_index] = answer

    local previous_vote_button_count
    local previous_vote_index
    if previous_vote_answer then
        previous_vote_button_count = update_vote(previous_vote_answer, -1)
        previous_vote_index = previous_vote_answer.index
    end

    local vote_button_count = update_vote(answer, 1)

    for _, p in pairs(game.connected_players) do
        local frame = p.gui.left[main_frame_name]
        if frame and frame.valid then
            local data = Gui.get_data(frame)

            if data.poll_index == poll_index then
                local vote_buttons = data.vote_buttons
                if previous_vote_answer then
                    local vote_button = vote_buttons[previous_vote_index]
                    vote_button.caption = previous_vote_button_count
                end

                local vote_button = vote_buttons[vote_index]
                vote_button.caption = vote_button_count
            end
        end
    end
end

local function player_joined(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then
        return
    end

    if Gui.get_mod_gui_top_frame() then
        local button =
            Gui.add_mod_button(
                player,
                {
                    type = 'sprite-button',
                    name = main_button_name,
                    sprite = 'item/programmable-speaker',
                    tooltip = 'Let your question be heard!',
                    style = Gui.button_style
                }
            )
        if button then
            button.style.font_color = { 165, 165, 165 }
            button.style.font = 'default-semibold'
            button.style.minimal_height = 36
            button.style.maximal_height = 36
            button.style.minimal_width = 40
            button.style.padding = -2
        end
    else
        if player.gui.top[main_button_name] ~= nil then
            local frame = player.gui.top[main_frame_name]
            if frame and frame.valid then
                local data = Gui.get_data(frame)
                update_poll_viewer(data)
            end
        else
            local b =
                player.gui.top.add
                {
                    type = 'sprite-button',
                    name = main_button_name,
                    sprite = 'item/programmable-speaker',
                    tooltip = 'Let your question be heard!',
                    style = Gui.button_style
                }
            b.style.maximal_height = 38
        end
    end
end

local function poll_complete(poll)
    local end_tick = poll.end_tick
    if end_tick == -1 then
        return false
    end

    local ticks = end_tick - game.tick
    return ticks < 0
end

local function tick()
    for _, p in pairs(game.connected_players) do
        local frame = p.gui.left[main_frame_name]
        if frame and frame.valid then
            local data = Gui.get_data(frame)
            local poll = polls[data.poll_index]
            if poll then
                local poll_enabled = do_remaining_time(poll, data.remaining_time_label)

                if not poll_enabled then
                    for _, v in pairs(data.vote_buttons) do
                        v.enabled = poll_enabled
                    end
                end
            end
        end
        local player_index = p.index
        local tbl = player_create_poll_data[player_index]
        if tbl then
            for _, element in pairs(tbl) do
                if type(element) == 'table' then
                    if not element.valid then
                        player_create_poll_data[player_index] = nil
                    end
                end
            end
        end
    end

    if not running_polls or not next(running_polls) then
        return
    end

    for i = #running_polls, 1, -1 do
        local poll = running_polls[i]
        if poll_complete(poll) then
            table.remove(running_polls, i)
            send_poll_result_to_discord(poll)

            local message = table.concat { 'Poll finished: Poll #', poll.id, ': ', poll.question }
            for _, p in pairs(game.connected_players) do
                if not no_notify_players[p.index] then
                    p.print(message)
                end
            end
        end
    end
end

Event.add(defines.events.on_player_joined_game, player_joined)
Event.add(defines.events.on_player_created, player_joined)
Event.on_nth_tick(60, tick)

Gui.on_click(main_button_name, toggle)

Gui.on_click(
    create_poll_button_name,
    function (event)
        local is_spamming = SpamProtection.is_spamming(event.player, nil, 'Create Poll')
        if is_spamming then
            return
        end
        local player = event.player
        local left = player.gui.left
        local frame = left[create_poll_frame_name]
        if frame and frame.valid then
            remove_create_poll_frame(frame, player.index)
        else
            draw_create_poll_frame(left, player)
        end
    end
)

Gui.on_click(
    poll_view_edit_name,
    function (event)
        local is_spamming = SpamProtection.is_spamming(event.player, nil, 'Poll View Edit')
        if is_spamming then
            return
        end
        local player = event.player
        local left = player.gui.left
        local frame = left[create_poll_frame_name]

        if frame and frame.valid then
            Gui.remove_data_recursively(frame)
            frame.destroy()
        end

        local main_frame = left[main_frame_name]
        local frame_data = Gui.get_data(main_frame)
        local poll = polls[frame_data.poll_index]

        poll.edit_mode = true
        draw_create_poll_frame(left, player, poll)
    end
)

Gui.on_value_changed(
    create_poll_duration_name,
    function (event)
        update_duration(event.element)
    end
)

Gui.on_click(
    create_poll_delete_answer_name,
    function (event)
        local is_spamming = SpamProtection.is_spamming(event.player, nil, 'Create Poll Delete Answer')
        if is_spamming then
            return
        end
        local button_data = Gui.get_data(event.element)
        if not button_data then
            return
        end
        local data = button_data.data

        if not data then
            return
        end

        table.remove(data.answers, button_data.count)
        redraw_create_poll_content(data)
    end
)

Gui.on_click(
    create_poll_label_name,
    function (event)
        local is_spamming = SpamProtection.is_spamming(event.player, nil, 'Create Poll Label Name')
        if is_spamming then
            return
        end
        local textfield = Gui.get_data(event.element)
        if not textfield then
            return
        end

        if textfield and textfield.valid then
            textfield.focus()
        end
    end
)

Gui.on_text_changed(
    create_poll_question_name,
    function (event)
        local textfield = event.element
        local data = Gui.get_data(textfield)

        if not data then
            return
        end

        if textfield and textfield.valid then
            if string.len(textfield.text) >= 50 then
                textfield.text = ''
                return
            end
            data.question = textfield.text
        end
    end
)

Gui.on_text_changed(
    create_poll_answer_name,
    function (event)
        local textfield = event.element
        local data = Gui.get_data(textfield)

        if not data then
            return
        end

        if textfield and textfield.valid then
            if string.len(textfield.text) >= 50 then
                textfield.text = ''
                return
            end
            data.answers[data.count].text = textfield.text
        end
    end
)

Gui.on_click(
    create_poll_add_answer_name,
    function (event)
        local is_spamming = SpamProtection.is_spamming(event.player, nil, 'Create Poll Add Answer')
        if is_spamming then
            return
        end
        local data = Gui.get_data(event.element)

        if not data then
            return
        end

        if data and #data.answers > 10 then
            return
        end

        insert(data.answers, { text = '' })
        redraw_create_poll_content(data)
    end
)

Gui.on_click(
    create_poll_close_name,
    function (event)
        local is_spamming = SpamProtection.is_spamming(event.player, nil, 'Create Poll Close')
        if is_spamming then
            return
        end
        local frame = Gui.get_data(event.element)
        if frame and frame.valid then
            remove_create_poll_frame(frame, event.player_index)
        end
    end
)

Gui.on_click(
    create_poll_clear_name,
    function (event)
        local is_spamming = SpamProtection.is_spamming(event.player, nil, 'Create Poll Clear')
        if is_spamming then
            return
        end
        local data = Gui.get_data(event.element)
        if not data then
            return
        end

        local slider = data.duration_slider
        slider.slider_value = math.floor(default_poll_duration * inv_tick_duration_step)
        update_duration(slider)

        data.question = ''

        local answers = data.answers
        for i = 1, #answers do
            answers[i].text = ''
        end

        redraw_create_poll_content(data)
    end
)

Gui.on_click(create_poll_confirm_name, create_poll)

Gui.on_click(
    create_poll_delete_name,
    function (event)
        local is_spamming = SpamProtection.is_spamming(event.player, nil, 'Create Poll Delete')
        if is_spamming then
            return
        end
        local player = event.player
        local data = Gui.get_data(event.element)
        if not data then
            return
        end

        local frame = data.frame
        local poll = data.previous_data

        Gui.remove_data_recursively(frame)
        frame.destroy()

        player_create_poll_data[player.index] = nil

        local removed_index
        for i, p in pairs(polls) do
            if p == poll then
                table.remove(polls, i)
                remove_element(running_polls, p)
                removed_index = i
                break
            end
        end

        if not removed_index then
            return
        end

        local message = table.concat { player.name, ' has deleted Poll #', poll.id, ': ', poll.question }

        for _, p in pairs(game.connected_players) do
            if not no_notify_players[p.index] then
                p.print(message)
            end

            local main_frame = p.gui.left[main_frame_name]
            if main_frame and main_frame.valid then
                local main_frame_data = Gui.get_data(main_frame)
                local poll_index = main_frame_data.poll_index

                if removed_index < poll_index then
                    main_frame_data.poll_index = poll_index - 1
                end

                update_poll_viewer(main_frame_data)
                toggle(event)
            end
        end
    end
)

Gui.on_click(
    create_poll_edit_name,
    function (event)
        local is_spamming = SpamProtection.is_spamming(event.player, nil, 'Create Poll Edit')
        if is_spamming then
            return
        end
        local player = event.player
        local data = Gui.get_data(event.element)
        if not data then
            return
        end

        local frame = data.frame
        local poll = data.previous_data

        local new_question = data.question
        if not new_question:find('%S') then
            player.print('Sorry, the poll needs a question.')
            return
        end

        local new_answer_set = {}
        local new_answers = {}
        for _, a in pairs(data.answers) do
            if a.text:find('%S') then
                local source = a.source
                local index = #new_answers + 1
                if source then
                    new_answer_set[source] = a
                    source.text = a.text
                    source.index = index
                    new_answers[index] = source
                else
                    new_answers[index] = { text = a.text, index = index, voted_count = 0 }
                end
            end
        end

        if not next(new_answers) then
            player.print('Sorry, the poll needs at least one answer.')
            return
        end

        Gui.remove_data_recursively(frame)
        frame.destroy()

        local player_index = player.index

        player_create_poll_data[player_index] = nil

        local old_answers = poll.answers
        local voters = poll.voters
        for _, a in pairs(old_answers) do
            if not new_answer_set[a] then
                for pi, a2 in pairs(voters) do
                    if a == a2 then
                        voters[pi] = nil
                    end
                end
            end
        end

        poll.question = new_question
        poll.answers = new_answers
        poll.edited_by[player_index] = true

        local start_tick = game.tick
        local duration = data.duration
        local end_tick

        if duration == 0 then
            end_tick = -1
        else
            end_tick = start_tick + duration
        end

        poll.start_tick = start_tick
        poll.end_tick = end_tick
        poll.duration = duration

        local poll_index
        for i, p in pairs(polls) do
            if poll == p then
                poll_index = i
                break
            end
        end

        if not poll_index then
            insert(polls, poll)
            insert(running_polls, poll)
            poll_index = #polls
            ---@diagnostic disable-next-line: undefined-global
        elseif not contains(running_polls, poll) then
            insert(running_polls, poll)
        end

        local message = table.concat { player.name, ' has edited Poll #', poll.id, ': ', poll.question }

        for _, p in pairs(game.connected_players) do
            local main_frame = p.gui.left[main_frame_name]

            if no_notify_players[p.index] then
                if main_frame and main_frame.valid then
                    local main_frame_data = Gui.get_data(main_frame)
                    update_poll_viewer(main_frame_data)
                end
            else
                p.print(message)
                if main_frame and main_frame.valid then
                    local main_frame_data = Gui.get_data(main_frame)
                    main_frame_data.poll_index = poll_index
                    update_poll_viewer(main_frame_data)
                else
                    draw_main_frame(p.gui.left, p)
                end
            end
        end
    end
)

Gui.on_checked_state_changed(
    notify_checkbox_name,
    function (event)
        local player_index = event.player_index
        local checkbox = event.element

        local new_state
        if checkbox.state then
            new_state = nil
        else
            new_state = true
        end

        no_notify_players[player_index] = new_state
    end
)

local function do_direction(event, sign)
    local count
    if event.shift then
        count = #polls
    else
        local button = event.button
        if button == defines.mouse_button_type.right then
            count = 5
        else
            count = 1
        end
    end

    count = count * sign

    local data = Gui.get_data(event.element)
    data.poll_index = data.poll_index + count
    update_poll_viewer(data)
end

Gui.on_click(
    poll_view_back_name,
    function (event)
        local is_spamming = SpamProtection.is_spamming(event.player, nil, 'Poll View Back')
        if is_spamming then
            return
        end
        do_direction(event, -1)
    end
)

Gui.on_click(
    poll_view_forward_name,
    function (event)
        local is_spamming = SpamProtection.is_spamming(event.player, nil, 'Poll View Forward')
        if is_spamming then
            return
        end
        do_direction(event, 1)
    end
)

Gui.on_click(poll_view_vote_name, vote)

function Public.reset()
    for k, _ in pairs(polls) do
        polls[k] = nil
    end
    for k, _ in pairs(player_poll_index) do
        player_poll_index[k] = nil
    end
    for k, _ in pairs(player_create_poll_data) do
        player_create_poll_data[k] = nil
    end
    for _, p in pairs(game.connected_players) do
        local main_frame = p.gui.left[main_frame_name]
        if main_frame and main_frame.valid then
            local main_frame_data = Gui.get_data(main_frame)
            update_poll_viewer(main_frame_data)
            remove_main_frame(main_frame, p.gui.left, p)
        end
    end
end

function Public.get_no_notify_players()
    return no_notify_players
end

function Public.validate(data)
    if type(data) ~= 'table' then
        return false, 'argument must be of type table'
    end

    local question = data.question
    if type(question) ~= 'string' or question == '' then
        return false, 'field question must be a non empty string.'
    end

    local answers = data.answers
    if type(answers) ~= 'table' then
        return false, 'answers field must be an array.'
    end

    if #answers == 0 then
        return false, 'answer array must contain at least one entry.'
    end

    for _, a in pairs(answers) do
        if type(a) ~= 'string' or a == '' then
            return false, 'answers must be a non empty string.'
        end
    end

    local duration = data.duration
    local duration_type = type(duration)
    if duration_type == 'number' then
        if duration < 0 then
            return false, 'duration cannot be negative, set duration to 0 for endless poll.'
        end
    elseif duration_type ~= 'nil' then
        return false, 'duration must be of type number or nil'
    end

    return true
end

--[[ local d = {
    question = 'What is your favorite color?',
    answers = { 'Red', 'Green', 'Blue' },
    duration = 5
}

local Poll = require 'utils.gui.poll' Poll.poll(d) ]]

function Public.poll(data)
    local suc, error = Public.validate(data)
    if not suc then
        return false, error
    end

    local answers = {}
    for index, a in pairs(data.answers) do
        if a ~= '' then
            insert(answers, { text = a, index = index, voted_count = 0 })
        end
    end

    local duration = data.duration
    if duration then
        duration = duration * 60
    else
        duration = default_poll_duration
    end

    local start_tick = game.tick
    local end_tick
    if duration == 0 then
        end_tick = -1
    else
        end_tick = start_tick + duration
    end

    local id = poll_id()

    local name = nil
    if game.player and game.player.valid then
        name = game.player.name
    end

    local poll_data =
    {
        id = id,
        question = data.question,
        answers = answers,
        voters = {},
        start_tick = start_tick,
        end_tick = end_tick,
        duration = duration,
        created_by = name or '<server>',
        created_by_script = true,
        edited_by = {}
    }

    insert(polls, poll_data)
    insert(running_polls, poll_data)


    show_new_poll(poll_data)
    send_poll_result_to_discord(poll_data)

    return true, id
end

function Public.poll_result(id)
    if type(id) ~= 'number' then
        return 'poll-id must be a number'
    end

    for _, poll_data in pairs(polls) do
        if poll_data.id == id then
            local result = { 'Question: ', poll_data.question, ' Answers: ' }
            local answers = poll_data.answers
            local answers_count = #answers
            local winning_answer = nil

            for i, a in pairs(answers) do
                insert(result, '( [')
                insert(result, a.voted_count)
                insert(result, '] - ')
                insert(result, a.text)
                insert(result, ' )')

                if not winning_answer or a.voted_count > winning_answer.voted_count then
                    winning_answer = a
                end

                if i ~= answers_count then
                    insert(result, ', ')
                end
            end

            return table.concat(result), winning_answer
        end
    end

    return table.concat { 'poll #', id, ' not found' }
end

function Public.send_poll_result_to_discord(id)
    if type(id) ~= 'number' then
        Server.to_discord_embed('poll-id must be a number')
        return
    end

    for _, poll_data in pairs(polls) do
        if poll_data.id == id then
            send_poll_result_to_discord(poll_data)
            return
        end
    end

    local message = table.concat { 'poll #', id, ' not found' }
    Server.to_discord_embed(message)
end

function Public.poll_complete(id)
    if type(id) ~= 'number' then
        return 'poll-id must be a number'
    end

    for _, poll_data in pairs(polls) do
        if poll_data.id == id then
            return poll_complete(poll_data)
        end
    end
end

Public.main_button_name = main_button_name

return Public
