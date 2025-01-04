local util = require("util")
local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")

if settings.startup["better-melting-ice-enable-mod"].value then
	local ice_smooth_melting = util.table.deepcopy(data.raw.tile["ice-smooth"])
	ice_smooth_melting.name = "ice-smooth-melting"
	ice_smooth_melting.collision_mask = tile_collision_masks.ground()
	ice_smooth_melting.frozen_variant = "ice-smooth"

	local ice_platform_melting = util.table.deepcopy(data.raw.tile["ice-platform"])
	ice_platform_melting.name = "ice-platform-melting"
	ice_platform_melting.collision_mask = tile_collision_masks.ground()
	ice_platform_melting.frozen_variant = "ice-platform"

	data:extend({ ice_smooth_melting, ice_platform_melting })
end
