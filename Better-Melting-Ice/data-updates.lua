local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")

if settings.startup["better-melting-ice-enable-mod"].value then
	data.raw.tile["ice-platform"].thawed_variant = "ice-platform-melting"
	data.raw.tile["ice-platform"].collision_mask = tile_collision_masks.ground()

	data.raw.tile["ice-smooth"].thawed_variant = "ice-smooth-melting"
	data.raw.tile["ice-smooth"].collision_mask = tile_collision_masks.ground()
end
