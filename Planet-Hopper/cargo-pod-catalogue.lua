local procession_graphic_catalogue_types = require("__base__/prototypes/planet/procession-graphic-catalogue-types")

local cargo_pod_catalogue = {
	-- POD
	{
		index = procession_graphic_catalogue_types.pod_base,
		sprite = util.sprite_load("__Planet-Hopper__/graphics/0001", {
			priority = "medium",
			scale = 0.5,
		}),
	},
	{
		index = procession_graphic_catalogue_types.pod_open,
		sprite = util.sprite_load("__Planet-Hopper__/graphics/0001", {
			priority = "medium",
			scale = 0.5,
		}),
	},
	{
		index = procession_graphic_catalogue_types.pod_shadow,
		sprite = util.sprite_load("__Planet-Hopper__/graphics/shadow0001", {
			priority = "medium",
			scale = 0.5,
		}),
	},
	-- POD Animated
	{
		index = procession_graphic_catalogue_types.pod_anim_opening,
		animation = util.sprite_load("__Planet-Hopper__/graphics/0001", {
			priority = "medium",
			scale = 0.5,
			frame_count = 1,
		}),
	},
	{
		index = procession_graphic_catalogue_types.pod_anim_landing,
		animation = util.sprite_load("__Planet-Hopper__/graphics/0001", {
			priority = "medium",
			scale = 0.5,
			frame_count = 1,
		}),
	},
	{
		index = procession_graphic_catalogue_types.pod_anim_rotation_closed,
		animation = util.sprite_load("__Planet-Hopper__/graphics/0001", {
			priority = "medium",
			scale = 0.5,
			frame_count = 1,
		}),
	},
	{
		index = procession_graphic_catalogue_types.pod_anim_rotation_open,
		animation = util.sprite_load("__Planet-Hopper__/graphics/0001", {
			priority = "medium",
			scale = 0.5,
			frame_count = 1,
		}),
	},
}
return cargo_pod_catalogue
