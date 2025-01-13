if mods["intercontinental-rocketry-forked"] then
    -- 定义一个包含默认星球名称的表
    local planets = {"nauvis", "vulcanus", "gleba", "fulgora", "aquilo"}

    -- 如果检测到某些特定的模组（mods）被加载，则将这些模组定义的星球添加到 planets 表中
    if mods["naufulglebunusilo"] then -- 如果加载了名为 "naufulglebunusilo" 的模组
        table.insert(planets, "naufulglebunusilo") -- 添加到 planets 表中
    end
    if mods["tenebris"] then -- 如果加载了名为 "tenebris" 的模组
        table.insert(planets, "tenebris")
    end
    if mods["terrapalus"] then -- 如果加载了名为 "terrapalus" 的模组
        table.insert(planets, "terrapalus")
    end
    if mods["Factorio-Tiberium"] then -- 如果加载了名为 "Factorio-Tiberium" 的模组
        table.insert(planets, "tiber")
    end

    -- 定义可用的星球位置标记
    Available_Planet_Locations = {"alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta", "theta", "iota", "kappa", "lambda", "mu", "nu", "xi", "omicron", "pi", "rho", "sigma", "tau", "upsilon"}

    -- 初始化 2D 星球位置、种子偏移和方向修正
    Planet_Locations_2d = {}
    Planet_Locations_seed_offset = {}
    Planet_Locations_orientation_mod = {}

    -- 遍历可用的星球位置
    for i, planet_location in ipairs(Available_Planet_Locations) do
        Planet_Locations_seed_offset[i] = math.random(2^32) -- 为每个位置生成一个随机种子偏移值

        -- 计算方向修正值
        local j = ((i - 1) - (i - 1) % 2) / 2
        local sign = (i % 2 == 0) and -1 or 1
        Planet_Locations_orientation_mod[i] = sign * (0.5 + j / 2)

        -- 为每个星球创建位置映射
        for _, value in ipairs(planets) do
            if i == 1 then
                Planet_Locations_2d[value] = {}
            end
            if i <= settings.startup["irf-setting-planets-selection-" .. value].value then
                table.insert(Planet_Locations_2d[value], planet_location)
            end
        end
    end

    -- 遍历所有星球并生成子星球
    for i, planet in ipairs(planets) do
        local old_planet = data.raw["planet"][planet] -- 获取原始星球数据



        -- 为每个位置创建新的子星球
        for j, planet_location in ipairs(Planet_Locations_2d[planet]) do
            local new_planet = table.deepcopy(data.raw["planet"][planet]) -- 复制原始星球数据
            new_planet.localised_name = {"", {"space-location-name." .. planet}, " ", {"subplanet-name." .. planet_location}} -- 设置本地化名称
            new_planet.localised_description = {"", {"space-location-name." .. planet}, ", ", {"subplanet-description." .. planet_location}} -- 设置本地化描述
            new_planet.draw_orbit = false -- 禁止绘制轨道
            new_planet.name = old_planet.name .. "-" .. planet_location -- 设置新星球的唯一名称
            new_planet.magnitude = old_planet.magnitude / 1.5 -- 调整幅度
            new_planet.hidden_in_factoriopedia = true -- 隐藏星球信息

            -- 计算新星球的方向
            new_planet.distance = old_planet.distance
            new_planet.map_seed_offset = Planet_Locations_seed_offset[j]
            new_planet.orientation = math.abs((old_planet.orientation + new_planet.magnitude * Planet_Locations_orientation_mod[j] / old_planet.distance) % 1.0)
            new_planet.label_orientation = new_planet.orientation

            -- 将新星球和连接扩展到游戏数据中
            data:extend({new_planet, new_connection})

            -- 更新上一个星球引用
            if j % 2 == 1 then
                prevPlanet1 = new_planet.name
            else
                prevPlanet2 = new_planet.name
            end
        end
    end
end