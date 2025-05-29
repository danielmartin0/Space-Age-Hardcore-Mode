local item_sounds = require("__base__.prototypes.item_sounds")
local merge = require("lib").merge
local find = require("lib").find

data:extend({
	{
		type = "recipe",
		name = "planet-hopper-launcher",
		enabled = true,
		ingredients = {
			{
				type = "item",
				name = "steel-plate",
				amount = 10,
			},
			{
				type = "item",
				name = "electronic-circuit",
				amount = 10,
			},
			{
				type = "item",
				name = "pipe",
				amount = 4,
			},
		},
		energy_required = 2,
		results = { {
			type = "item",
			name = "planet-hopper-launcher",
			amount = 1,
		} },
		requester_paste_multiplier = 1,
	},
	{
		type = "item",
		name = "planet-hopper-launcher",
		icon = "__Planet-Hopper__/graphics/icons/planet-hopper-launcher.png",
		icon_size = 64,
		subgroup = "space-interactors",
		order = "a[rocket-silo]-b[planet-hopper-launcher]",
		inventory_move_sound = item_sounds.mechanical_inventory_move,
		pick_sound = item_sounds.mechanical_inventory_pickup,
		drop_sound = item_sounds.mechanical_inventory_move,
		place_result = "planet-hopper-launcher",
		weight = 1 * 1000,
		stack_size = 1,
	},
	{
		type = "recipe-category",
		name = "planet-hopper-launcher",
	},
	{

		type = "recipe",
		name = "planet-hopper-automatic-rocket-parts",
		category = "planet-hopper-launcher",
		energy_required = 3,
		hide_from_player_crafting = true,
		hidden_in_factoriopedia = true,
		ingredients = {},
		results = { {
			type = "item",
			name = "rocket-part",
			amount = 1,
		} },
		allow_productivity = true,
	},
})

local SCALAR_NAMES = {
	"volume",
	"scale",
	"rocket_render_layer_switch_distance",
	"full_render_layer_switch_distance",
	"effects_fade_in_start_distance",
	"effects_fade_in_end_distance",
	"shadow_fade_out_start_ratio",
	"shadow_fade_out_end_ratio",
	"rocket_visible_distance_from_center",
	"rocket_above_wires_slice_offset_from_center",
	"rocket_air_object_slice_offset_from_center",
}
local VECTOR_NAMES = {
	"shift",
	"rocket_initial_offset",
	"rocket_rise_offset",
	"rocket_launch_offset",
	"cargo_attachment_offset",
}
local MATRIX_NAMES = { "collision_box", "selection_box", "hole_clipping_box" }

local SCALE_FACTOR = 4 / 9

local function modify(table)
	local has_filename = false
	for k, v in pairs(table) do
		if k == "filename" then
			has_filename = true
		end
		if find(SCALAR_NAMES, k) then
			table[k] = v * SCALE_FACTOR
		elseif find(VECTOR_NAMES, k) then
			if v.x then
				table[k] = {
					x = v.x * SCALE_FACTOR,
					y = v.y * SCALE_FACTOR,
				}
			else
				table[k] = { v[1] * SCALE_FACTOR, v[2] * SCALE_FACTOR }
			end
		elseif find(MATRIX_NAMES, k) then
			table[k] = {
				{ v[1][1] * SCALE_FACTOR, v[1][2] * SCALE_FACTOR },
				{ v[2][1] * SCALE_FACTOR, v[2][2] * SCALE_FACTOR },
			}
		elseif type(v) == "table" then
			modify(v)
		end
	end

	if has_filename then
		table.tint = { 0.71, 0.89, 0.71, 1 }
	end
end

-- local scalar_names_2 = {
-- 	"flying_speed",
-- 	"flying_acceleration",
-- }
-- local function apply_scale_up(table)
-- 	for k, v in pairs(table) do
-- 		if find(scalar_names_2, k) then
-- 			table[k] = v * 2
-- 		elseif type(v) == "table" then
-- 			apply_scale_up(v)
-- 		end
-- 	end
-- end

local silo_2 = merge(data.raw["rocket-silo"]["rocket-silo"], {
	name = "planet-hopper-launcher",
	icon = "__Planet-Hopper__/graphics/icons/planet-hopper-launcher.png",
	crafting_categories = { "planet-hopper-launcher" },
	icon_size = 64,
	fast_replaceable_group = "nil",
	fixed_recipe = "planet-hopper-automatic-rocket-parts",
	launch_wait_time = 1,
	rocket_rising_delay = 1,
	to_be_inserted_to_rocket_inventory_size = 0,
	rocket_parts_required = 1,
	logistic_trash_inventory_size = 0,
	rocket_entity = "planet-hopper",
	alarm_sound = "nil",
	quick_alarm_sound = "nil",
	minable = {
		mining_time = 0.3,
		result = "planet-hopper-launcher",
	},
	max_health = 1000,
	module_slots = 0,
	energy_usage = "100kW", -- energy usage used when crafting the rocket
	active_energy_usage = "1000kW",
	times_to_blink = 1,
	light_blinking_speed = data.raw["rocket-silo"]["rocket-silo"].light_blinking_speed * 2,
	door_opening_speed = data.raw["rocket-silo"]["rocket-silo"].door_opening_speed * 2,
	energy_source = {
		type = "void",
	},
	surface_conditions = "nil",
})
modify(silo_2)
local lighter_tint = { 0.87, 1, 0.87, 1 }
silo_2.base_day_sprite.filename = "__Planet-Hopper__/graphics/entity/planet-hopper-launcher/06-rocket-silo.png"
silo_2.base_day_sprite.tint = lighter_tint
silo_2.arm_01_back_animation.filename =
	"__Planet-Hopper__/graphics/entity/planet-hopper-launcher/08-rocket-silo-arms-back.png"
silo_2.arm_01_back_animation.tint = lighter_tint
silo_2.arm_02_right_animation.filename =
	"__Planet-Hopper__/graphics/entity/planet-hopper-launcher/08-rocket-silo-arms-right.png"
silo_2.arm_02_right_animation.tint = lighter_tint
silo_2.arm_03_front_animation.filename =
	"__Planet-Hopper__/graphics/entity/planet-hopper-launcher/13-rocket-silo-arms-front.png"
silo_2.arm_03_front_animation.tint = lighter_tint
silo_2.base_front_sprite.filename = "__Planet-Hopper__/graphics/entity/planet-hopper-launcher/14-rocket-silo-front.png"
silo_2.base_front_sprite.tint = lighter_tint

local rocket_2 = merge(data.raw["rocket-silo-rocket"]["rocket-silo-rocket"], {
	name = "planet-hopper",
	cargo_pod_entity = "planet-hopper-pod",
	inventory_size = 1,
	shadow_slave_entity = "planet-hopper-shadow",
	rising_speed = data.raw["rocket-silo-rocket"]["rocket-silo-rocket"].rising_speed * 3,
	engine_starting_speed = data.raw["rocket-silo-rocket"]["rocket-silo-rocket"].engine_starting_speed * 3,
})
modify(rocket_2)

local rocket_shadow_2 = merge(data.raw["rocket-silo-rocket-shadow"]["rocket-silo-rocket-shadow"], {
	name = "planet-hopper-shadow",
})
modify(rocket_shadow_2)

local ROCKET_SHIFT = -2.52
local function apply_shift(table)
	for _, v in pairs(table) do
		if v.index and v.index >= 100 and v.index < 200 then
			if v.sprite then
				v.sprite.shift = v.sprite.shift or { 0, 0 }
				v.sprite.shift = { v.sprite.shift[1], v.sprite.shift[2] + ROCKET_SHIFT }
			end

			if v.animation then
				v.animation.shift = v.animation.shift or { 0, 0 }
				v.animation.shift = { v.animation.shift[1], v.animation.shift[2] + ROCKET_SHIFT }
			end
		end
	end
end

local cargo_pod_2 = merge(data.raw["cargo-pod"]["cargo-pod"], {
	name = "planet-hopper-pod",
	inventory_size = 1,
	spawned_container = "planet-hopper-container",
})
modify(cargo_pod_2)
apply_shift(cargo_pod_2.procession_graphic_catalogue)

local cargo_pod_container_2 = merge(data.raw["temporary-container"]["cargo-pod-container"], {
	name = "planet-hopper-container",
	dying_explosion = "planet-hopper-container-explosion",
	remains_when_mined = { "planet-hopper-container-explosion" },
})
modify(cargo_pod_container_2)

local cargo_pod_container_explosion_2 = merge(data.raw["explosion"]["cargo-pod-container-explosion"], {
	name = "planet-hopper-container-explosion",
	created_effect = {
		type = "direct",
		action_delivery = {
			type = "delayed",
			delayed_trigger = "planet-hopper-container-explosion-delay",
		},
	},
})
modify(cargo_pod_container_explosion_2)

local cargo_pod_container_explosion_delay_2 =
	merge(data.raw["delayed-active-trigger"]["cargo-pod-container-explosion-delay"], {
		name = "planet-hopper-container-explosion-delay",
		action = {
			{
				type = "direct",
				action_delivery = {
					type = "instant",
					source_effects = {
						{
							type = "create-entity",
							entity_name = "planet-hopper-container-remnants",
						},
					},
				},
			},
		},
	})
modify(cargo_pod_container_explosion_delay_2)

local cargo_pod_container_remnants_2 = merge(data.raw["corpse"]["cargo-pod-container-remnants"], {
	name = "planet-hopper-container-remnants",
})
modify(cargo_pod_container_remnants_2)

data:extend({
	silo_2,
	rocket_2,
	cargo_pod_2,
	rocket_shadow_2,
	cargo_pod_container_2,
	cargo_pod_container_explosion_2,
	cargo_pod_container_explosion_delay_2,
	cargo_pod_container_remnants_2,
})

local function accept_cargo_pod_2(table)
	for k, v in pairs(table) do
		if k == "receiving_cargo_units" and find(v, "cargo-pod") and not find(table, "planet-hopper-pod") then
			v[#v + 1] = "planet-hopper-pod"
		elseif type(v) == "table" then
			accept_cargo_pod_2(v)
		end
	end
end
for _, v in pairs(data.raw["space-platform-hub"]) do
	accept_cargo_pod_2(v)
end
for _, v in pairs(data.raw["cargo-bay"]) do
	accept_cargo_pod_2(v)
end
