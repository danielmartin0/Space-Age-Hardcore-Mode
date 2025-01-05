--== Space Age 2.0.19 formula: ==--
-- data.raw["utility-constants"]["default"]["space_platform_acceleration_expression"] =
-- "(thrust / (1 + weight / 10000000) - ((1500 * speed * speed + 1500 * abs(speed)) * (width * 0.5) + 10000) * sign(speed)) / weight / 60"

--== New formula: ==--

local weight_of_platform_foundation_tiles = 250
local shape_constant = 0.886 -- Approximately (pi/4)^0.5. This value means that circular platforms are unaffected. A shape_constant of 1 would mean square platforms are unaffected.

local replacement_for_width = "(weight / ("
	.. weight_of_platform_foundation_tiles
	.. " * "
	.. shape_constant
	.. ")) ^ 0.5"

if settings.startup["better-platform-drag"].value then
	data.raw["utility-constants"]["default"]["space_platform_acceleration_expression"] = "(thrust / (1 + weight / 10000000) - ((1500 * speed * speed + 1500 * abs(speed)) * ("
		.. replacement_for_width
		.. " * 0.5) + 10000) * sign(speed)) / weight / 60"
end
