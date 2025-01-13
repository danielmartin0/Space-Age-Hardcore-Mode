
require "prototypes.cube"




require "prototypes.nexuz"



PlanetsLib:extend({
  {
      type = "space-location",
      name = "nexuz",
      starmap_icon = "__Starmap_Nexuz__/graphics/icons/nexuz_star.png",
      starmap_icon_size = 570,
      orbit = {
          parent = {
              type = "space-location",
              name = "star",
          },
          distance = 200,
          orientation = 0.125,
      },
      sprite_only = true,
      magnitude = 11,
  },
})



require "prototypes.maraxsis"
require "prototypes.tenebris"
require "prototypes.naufulglebunusilo"
require "prototypes.erm_zerg"
require "prototypes.erm_toss"
require "prototypes.terrapalus"
require "prototypes.arrakis"
require "prototypes.Factorio-Tiberium"
require "prototypes.intercontinental-rocketry-forked"




local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

local modify_space_connection = settings.startup["modify_space_connection"].value -- 如果开启新的星际旅行路线，则修改 space-connection
if modify_space_connection then

  data:extend({ 
      {
          type = "space-location", -- 定义一个名为 "solar-system-edge默认恒星系东北边境" 的太空位置
          name = "sye-nauvis-ne", -- 名称标识符，供代码引用
          localised_name = "Nauvis solar system edge-NE",  
          icon = "__space-age__/graphics/icons/solar-system-edge.png", -- 图标路径，用于在界面或地图上显示此位置的图标        
          order = "f[solar-system-edge]", -- 排序字段，用于确定在用户界面中显示的顺序        
          subgroup = "planets", -- 分类子组名称，表明该条目属于 "planets" 子组        
          draw_orbit = false,
          gravity_pull = -10, -- 引力拉力值，负值表示反向引力（可能表示远离中心）        
          distance = 50, -- 距离值，可能表示与中心位置的距离        
          orientation = 0.125, -- 定位的方向，范围通常在 0 到 1 之间，表示在地图或界面上的角度        
          magnitude = 1.0, -- 表示该位置的显著性或重要性，可以影响显示或计算        
          label_orientation = 0.15, -- 标签方向，用于标记的显示位置，通常是一个角度值        
          asteroid_spawn_influence = 1, -- 小行星生成的影响系数，决定生成概率或密度        
          asteroid_spawn_definitions = asteroid_util.spawn_definitions( -- 小行星生成的定义，调用 `asteroid_util` 工具生成特定类型的小行星
              asteroid_util.aquilo_solar_system_edge, -- 指定小行星类型或参数
              0.9 -- 表示生成的权重或密度因子
          )
      }
  })

  data:extend({ 
      {
          type = "space-location", -- 定义一个名为 "solar-system-edge新恒星系西南边境" 的太空位置
          name = "sye-nexuz-sw", -- 名称标识符，供代码引用
          localised_name = "Nexuz solar system edge-SW",  
          icon = "__Starmap_Nexuz__/graphics/icons/nexuz.png",  -- 星球图标路径
          icon_size = 256,  
          order = "f[solar-system-edge]", -- 排序字段，用于确定在用户界面中显示的顺序        
          subgroup = "planets", -- 分类子组名称，表明该条目属于 "planets" 子组    
          draw_orbit = false,    
          gravity_pull = -10, -- 引力拉力值，负值表示反向引力（可能表示远离中心）        
          distance = 129, -- 距离值，可能表示与中心位置的距离        
          orientation = 0.138, -- 定位的方向，范围通常在 0 到 1 之间，表示在地图或界面上的角度        
          magnitude = 1.0, -- 表示该位置的显著性或重要性，可以影响显示或计算        
          label_orientation = 0.15, -- 标签方向，用于标记的显示位置，通常是一个角度值        
          asteroid_spawn_influence = 1, -- 小行星生成的影响系数，决定生成概率或密度        
          asteroid_spawn_definitions = asteroid_util.spawn_definitions( -- 小行星生成的定义，调用 `asteroid_util` 工具生成特定类型的小行星
              asteroid_util.aquilo_solar_system_edge, -- 指定小行星类型或参数
              0.9 -- 表示生成的权重或密度因子
          )
      }
  })

 PlanetsLib:update({
            {
                type = "space-location",
                name = "sye-nexuz-sw",
                orbit = {
                    parent = {
                        type = "space-location",
                        name = "nexuz",
                    },
                    distance = 50,
                    orientation = 0.625,
                    sprite = {
                        type = "sprite",
                        filename = "__Starmap_Nexuz__/graphics/icons/orbit_edge.png",
                        size = 4096,
                    },
                }
            }
        })



  -- 在 data-updates.lua 中定义连接数据
  data:extend {{
    type = "space-connection",  
    name = "gleba-sye-nauvis-ne",  
    subgroup = "planet-connections",  
    icon = "__space-age__/graphics/icons/solar-system-edge.png",  
    from = "gleba",  
    to = "sye-nauvis-ne",  
    order = "h",  
    length = settings.startup["space-connection-gleba-sye-nauvis-ne-length"].value or 40000,  
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
  }}

  data:extend {{
    type = "space-connection",  
    name = "sye-nauvis-ne-sye-nexuz-sw",  
    subgroup = "planet-connections",  
    icon = "__space-age__/graphics/icons/solar-system-edge.png",  
    from = "sye-nauvis-ne",  
    to = "sye-nexuz-sw",  
    order = "h",  
    length = settings.startup["space-connection-sye-nauvis-ne-sye-nexuz-sw-length"].value or 60000,  
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
  }}



  data:extend(
                {
                  {
                      -- 定义一种新技术：发现恒星系系“Nexuz”
                      type = "technology",  -- 表示这是一个技术条目
                      name = "starsystem-discovery-nexuz",  -- 技术的内部名称
                      localised_name = "Solar system discovery Nexuz",  
                      icons = util.technology_icon_constant_planet("__Starmap_Nexuz__/graphics/icons/nexuz.png"),  -- 技术的图标路径
                      icon_size = 256,  -- 图标的大小
                      essential = true,  -- 这项技术是否关键，可能会影响显示或解锁顺序
                      effects = {  -- 技术解锁的效果
                        {
                          type = "unlock-space-location",  -- 解锁空间位置
                          space_location = "sye-nauvis-ne",  -- 指定解锁的行星
                          use_icon_overlay_constant = false  -- 是否使用图标叠加效果
                        },
                        {
                            type = "unlock-space-location",  -- 解锁空间位置
                            space_location = "sye-nexuz-sw",  -- 指定解锁的行星
                            use_icon_overlay_constant = false  -- 是否使用图标叠加效果
                          }
                      },
                      prerequisites = {"rocket-turret", "advanced-asteroid-processing", "asteroid-reprocessing", "electromagnetic-science-pack"},      -- 需要先完成的前置技术
                      unit = {  -- 技术研究的成本
                        count = 4000,  -- 需要的总研究点数
                        ingredients = {  -- 研究所需的科学包
                        {"automation-science-pack", 1},
                        {"logistic-science-pack", 1},
                        {"chemical-science-pack", 1},
                        {"production-science-pack", 1},
                        {"utility-science-pack", 1},
                        {"space-science-pack", 1},
                        {"metallurgic-science-pack", 1},
                        {"agricultural-science-pack", 1},
                        {"electromagnetic-science-pack", 1}
                        },
                        time = 60  -- 每个研究单元所需的时间（秒）
                      }
                  }
                }
              )  
end