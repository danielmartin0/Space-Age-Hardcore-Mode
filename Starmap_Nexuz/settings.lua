-- settings.lua
data:extend({
    {
        type = "int-setting",
        name = "space-connection-gleba-sye-nauvis-ne-length",  -- 第一个连接的设置项
        localised_name = "The distance from Gleba to Nauvis solar system edge-NE",
        setting_type = "startup",  -- 启动时加载
        default_value = 40000,  -- 默认值为 40000
        minimum_value = 1,  -- 最小值
        maximum_value = 148257142,  -- 最大值
        order = "a[space-connection-gleba-sye-nauvis-ne-length]"  -- 排序
    },
    {
        type = "int-setting",
        name = "space-connection-sye-nauvis-ne-sye-nexuz-sw-length",  -- 第二个连接的设置项
        localised_name = "The distance from Nauvis solar system edge-NE to Nexuz solar system edge-SW",
        setting_type = "startup",  -- 启动时加载
        default_value = 60000,  -- 默认值为 60000
        minimum_value = 1,  -- 最小值
        maximum_value = 148257142,  -- 最大值
        order = "b[space-connection-sye-nauvis-ne-sye-nexuz-sw-length]"  -- 排序
    },
    -- 修改为 bool-setting
    {
        type = "bool-setting",  -- 更正这里的类型
        name = "modify_space_connection",
        localised_name = "Use the new interstellar travel route",
        setting_type = "startup",
        default_value = true,
        order = "c"  -- 排序
    }
})
