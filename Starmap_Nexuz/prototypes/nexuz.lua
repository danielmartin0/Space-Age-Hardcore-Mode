
PlanetsLib:extend({ --添加背景
  {
      type = "space-location",
      name = "nexuz-background",
      starmap_icon = "__Starmap_Nexuz__/graphics/icons/starmap_background_nexuz.png",
      starmap_icon_size = 4096,
      orbit = {
          parent = {
              type = "space-location",
              name = "star",
          },
          distance = 200,
          orientation = 0.125,
      },
      sprite_only = true,
      magnitude = 120,
  },
}) 
 

--[[ 
  PlanetsLib:extend({ --添加背景
  {
      type = "space-location",
      name = "nexuz-background",
      starmap_icon = "__Starmap_Nexuz__/graphics/icons/debug.png",
      starmap_icon_size = 1,
      orbit = {
          parent = {
              type = "space-location",
              name = "nexuz",
          },
          distance = 0,
          orientation = 0,
          sprite = {
            type = "sprite",
            filename = "__Starmap_Nexuz__/graphics/icons/debug.png",
            size = 4096,
        },
      },
      sprite_only = true,
      magnitude = 1,
  },
}) 
 ]]