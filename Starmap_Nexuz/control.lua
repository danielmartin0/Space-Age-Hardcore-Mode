-- 在 control.lua 中处理事件
script.on_init(function()
    -- 初始化 global 数据表


    -- 获取设置中的长度值
    local gleba_to_nauvis_length = settings.startup["space-connection-gleba-sye-nauvis-ne-length"].value or 40000
    local nauvis_to_nexuz_length = settings.startup["space-connection-sye-nauvis-ne-sye-nexuz-sw-length"].value or 60000
    local modify_space_connection = settings.startup["modify_space_connection"].value

    -- 打印设置值（调试用）
    log("Gleba to Nauvis length: " .. gleba_to_nauvis_length)
    log("Nauvis to Nexuz length: " .. nauvis_to_nexuz_length)
    log("Modify space connection enabled: " .. tostring(modify_space_connection))

    -- 如果设置启用新的星际旅行路线，进行相关修改


    -- 其他的初始化操作，可以根据需要添加
end)

-- 注册其他事件（例如玩家加入、设置改变等）
script.on_event(defines.events.on_player_joined_game, function(event)
    -- 在玩家加入时进行处理
    -- 可以在这里加入与玩家相关的处理逻辑
end)
