-- 引入外部模块 "planet-map-gen"，用于生成星球的地图设置
local planet_map_gen = require("__space-age__/prototypes/planet/planet-map-gen")

-- 定义星球 "arrakis" 的地图生成设置
planet_map_gen.cube = function ()
    return
    {
        -- 定义星球的属性表达式（影响星球表面地形和资源分布的参数）
        property_expression_names =
        {
            elevation = 0,                     -- 海拔高度：此星球的海拔设置为0
            temperature = 100,                 -- 温度：设置为100
            moisture = 0,                      -- 湿度：设置为0
            cliffiness = 0,                    -- 悬崖度：设置为0
            cliff_elevation = 0,               -- 悬崖海拔：设置为0
            -- ["entity:spice-ore:probability"] = "arrakis_spice_ore_probability", -- 可选：香料矿的生成概率
            -- ["entity:spice-ore:richness"] = "arrakis_spice_ore_richness"       -- 可选：香料矿的富集度
        },

        -- 定义星球的小行星或资源生成控制（控制某些资源或实体生成的规则）
        autoplace_controls =
        {
            -- ["spice_ore"] = {},  -- 控制 "spice_ore" 生成规则（此处为空，可能是为了预留空间用于自定义规则）
        },

        -- 定义资源生成设置（详细设置每种资源在星球表面上的分布）
        autoplace_settings =
        {
            -- 设置星球表面的地形（如沙漠区域等）
            ["tile"] = 
            {
                settings =
                {
--[[                     ["sand-1"] = {},  -- 沙丘类型1
                    ["sand-2"] = {},  -- 沙丘类型2
                    ["sand-3"] = {},  -- 沙丘类型3 ]]
                }
            },

            -- 设置星球表面的装饰物（如岩石等）
            ["decorative"] =
            {
                settings =
                {
--[[                     ["medium-sand-rock"] = {},  -- 中等大小的沙岩
                    ["small-sand-rock"] = {}    -- 小型沙岩 ]]
                }
            },

            -- 设置星球上的实体（如矿物、资源等）
            ["entity"] =
            {
                settings =
                {
--[[                     ["spice-ore"] = {},  -- 香料矿的生成设置
 ]]                }
            }
        }
    }
end


data:extend(
    {
        -- 定义星球 "arrakis" 的属性
        {
            type = "planet",               -- 数据类型为 "planet"
            name = "cube1",                -- 星球名称
            localised_name = "?",          -- 星球本地化名称
            icon = "__Starmap_Nexuz__/graphics/icons/cube.png",  -- 星球图标路径
            starmap_icon = "__Starmap_Nexuz__/graphics/icons/cube.png",  -- 星际地图图标路径
            icon_size = 1381,              -- 图标大小
            starmap_icon_size = 1381,      -- 星际地图图标大小
            draw_orbit = false,
            gravity_pull = 10,             -- 星球的重力拉力值
            distance = 1000,               -- 星球距离玩家母星 "Nauvis" 的距离
            orientation = 0.625,           -- 星球的方位角，影响其位置
            magnitude = 10.0,              -- 星球的亮度（或影响力）
            map_gen_settings = planet_map_gen.cube(),  -- 使用模块生成星球的地图设置
            pollutant_type = nil,          -- 星球是否有污染类型（此处无）
            solar_power_in_space = nil,    -- 星球在太空中的太阳能值
            asteroid_spawn_influence = 1,  -- 小行星生成的影响因子
            surface_properties = {         -- 星球表面的具体属性
                ["day-night-cycle"] = 24*60 * minute, -- 星球的昼夜循环时长（10分钟）
                ["magnetic-field"] = 42,          -- 星球的磁场强度
                ["solar-power"] = 0,            -- 星球的太阳能值
                pressure = nil,                   -- 星球表面的气压值
                gravity = 10                       -- 星球表面的重力值
            }
        }
    }
)




local planet = table.deepcopy(data.raw["planet"]["cube1"])
planet.name = "cube2"  
planet.distance = 1035  
planet.orientation = 0.13 
data:extend { planet }