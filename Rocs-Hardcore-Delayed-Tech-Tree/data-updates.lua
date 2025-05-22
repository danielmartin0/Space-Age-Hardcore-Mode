local util = require("util")
local lib = require("lib")
local find = lib.find

if settings.startup["rocs-hardcore-push-back-repair-pack"].value then
	if data.raw.technology["repair-pack"] then
		data.raw.technology["repair-pack"].prerequisites = {
			"logistic-science-pack",
		}
		data.raw.technology["repair-pack"].unit.ingredients = {
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
		}
	end
end

if
	settings.startup["rocs-hardcore-push-back-logistic-system"].value
	and data.raw.technology["logistic-system"]
	and data.raw.technology["logistic-system"].effects
then
	data:extend({
		{
			type = "technology",
			name = "hardcore-active-provider-chests",
			effects = {
				{
					type = "unlock-recipe",
					recipe = "active-provider-chest",
				},
			},
			prerequisites = {
				"agricultural-science-pack",
			},
			icon = "__Rocs-Hardcore-Delayed-Tech-Tree__/graphics/technology/active-provider-chest.png",
			icon_size = 96,
			unit = {
				count = 1000,
				ingredients = {
					{ "automation-science-pack", 1 },
					{ "logistic-science-pack", 1 },
					{ "chemical-science-pack", 1 },
					{ "utility-science-pack", 1 },
					{ "space-science-pack", 1 },
					{ "agricultural-science-pack", 1 },
				},
				time = 60,
			},
		},
	})

	for i = #data.raw.technology["logistic-system"].effects, 1, -1 do
		local effect = data.raw.technology["logistic-system"].effects[i]
		if effect.type == "unlock-recipe" and effect.recipe == "active-provider-chest" then
			table.remove(data.raw.technology["logistic-system"].effects, i)
		end
	end

	data.raw.technology["logistic-system"].prerequisites = {
		"electromagnetic-science-pack",
		"metallurgic-science-pack",
		"agricultural-science-pack",
		"utility-science-pack",
	}
	data.raw.technology["logistic-system"].unit.count = 5000
	data.raw.technology["logistic-system"].unit.ingredients = {
		{ "automation-science-pack", 1 },
		{ "logistic-science-pack", 1 },
		{ "chemical-science-pack", 1 },
		{ "utility-science-pack", 1 },
		{ "space-science-pack", 1 },
		{ "agricultural-science-pack", 1 },
		{ "electromagnetic-science-pack", 1 },
		{ "metallurgic-science-pack", 1 },
	}

	-- Disabled moving tank logistics as it allows you to use tanks as blue chests:
	-- if data.raw.technology["logistic-robotics"] then
	-- 	local has_vehicle_logistics = false

	-- 	for i = #data.raw.technology["logistic-system"].effects, 1, -1 do
	-- 		local effect = data.raw.technology["logistic-system"].effects[i]
	-- 		if effect.type == "vehicle-logistics" and effect.modifier == true then
	-- 			has_vehicle_logistics = true
	-- 			table.remove(data.raw.technology["logistic-system"].effects, i)
	-- 		end
	-- 	end

	-- 	if has_vehicle_logistics then
	-- 		data.raw.technology["logistic-robotics"].effects = data.raw.technology["logistic-robotics"].effects or {}
	-- 		table.insert(data.raw.technology["logistic-robotics"].effects, {
	-- 			type = "vehicle-logistics",
	-- 			modifier = true,
	-- 		})
	-- 	end
	-- end
end

if settings.startup["rocs-hardcore-push-back-cliff-explosives"].value then
	if data.raw.technology["cliff-explosives"] then
		data.raw.technology["cliff-explosives"].prerequisites = {
			"metallurgic-science-pack",
			"explosives",
			"military-science-pack",
			"electromagnetic-science-pack",
			"agricultural-science-pack",
		}
		data.raw.technology["cliff-explosives"].unit.count = 2000
		data.raw.technology["cliff-explosives"].unit.ingredients = {
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
			{ "chemical-science-pack", 1 },
			{ "space-science-pack", 1 },
			{ "metallurgic-science-pack", 1 },
			{ "electromagnetic-science-pack", 1 },
			{ "agricultural-science-pack", 1 },
		}
	end
end

if settings.startup["rocs-hardcore-push-back-kovarex-nuclear-fuel-and-atomic-bomb"].value then
	if data.raw.technology["kovarex-enrichment-process"] then
		data.raw.technology["kovarex-enrichment-process"].prerequisites = {
			"production-science-pack",
			"electromagnetic-science-pack",
			"agricultural-science-pack",
		}
		data.raw.technology["kovarex-enrichment-process"].unit.ingredients = {
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
			{ "chemical-science-pack", 1 },
			{ "production-science-pack", 1 },
			{ "space-science-pack", 1 },
			{ "electromagnetic-science-pack", 1 },
			{ "agricultural-science-pack", 1 },
		}
		data.raw.technology["kovarex-enrichment-process"].unit.count = 2000
	end

	if data.raw.technology["atomic-bomb"] then
		data.raw.technology["atomic-bomb"].unit.ingredients = {
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
			{ "military-science-pack", 1 },
			{ "chemical-science-pack", 1 },
			{ "production-science-pack", 1 },
			{ "utility-science-pack", 1 },
			{ "space-science-pack", 1 },
			{ "electromagnetic-science-pack", 1 },
			{ "agricultural-science-pack", 1 },
		}
	end
end

if settings.startup["rocs-hardcore-push-back-night-vision-equipment"].value then
	if data.raw.technology["night-vision-equipment"] then
		data.raw.technology["night-vision-equipment"].prerequisites = {
			"agricultural-science-pack",
		}
		data.raw.technology["night-vision-equipment"].unit.ingredients = {
			{ "automation-science-pack", 1 },
			{ "logistic-science-pack", 1 },
			{ "chemical-science-pack", 1 },
			{ "space-science-pack", 1 },
			{ "agricultural-science-pack", 1 },
		}
	end
end

local EXCLUDED_TECH_NAMES = {
	["health"] = true,
}

if settings.startup["rocs-hardcore-z-infinite-tech-needs-cryogenic"].value then
	local techs_to_process = {}
	for name, tech in pairs(data.raw.technology) do
		local allow = true

		if EXCLUDED_TECH_NAMES[name] then
			allow = false
		end

		-- If the tech already requires cryoscience, don't split it:
		if allow and tech.unit and tech.unit.ingredients then
			for _, ingredient in pairs(tech.unit.ingredients or {}) do
				if ingredient[1] == "cryogenic-science-pack" then
					allow = false
					break
				end
			end
		end

		-- If there's no lab that could process this tech, don't split it:
		if allow and tech.unit and tech.unit.ingredients then
			local required_inputs = {}
			for _, ingredient in pairs(tech.unit.ingredients) do
				required_inputs[ingredient[1]] = true
			end
			required_inputs["cryogenic-science-pack"] = true

			local lab_found = false
			for _, lab in pairs(data.raw.lab) do
				local can_handle_all = true
				for input_name in pairs(required_inputs) do
					local lab_can_handle = false
					for _, lab_input in ipairs(lab.inputs or {}) do
						if lab_input == input_name then
							lab_can_handle = true
							break
						end
					end
					if not lab_can_handle then
						can_handle_all = false
						break
					end
				end
				if can_handle_all then
					lab_found = true
					break
				end
			end

			if not lab_found then
				allow = false
			end
		end

		if tech.max_level == "infinite" and allow then
			table.insert(techs_to_process, name)
		end
	end

	for _, tech_name in ipairs(techs_to_process) do
		local tech = data.raw.technology[tech_name]
		local second_tech = util.table.deepcopy(tech)
		local third_tech = util.table.deepcopy(tech)

		if tech.name:match("%d+$") then
			local base_name = tech.name:gsub("%d+$", "")
			local current_num = tonumber(tech.name:match("%d+$"))

			second_tech.name = base_name .. (current_num + 1)
			second_tech.max_level = nil
			second_tech.max_level = nil
			second_tech.prerequisites = { tech.name }

			third_tech.name = base_name .. (current_num + 2)
			third_tech.prerequisites = { second_tech.name, "infinite-research" }
		else
			-- local tech_revised = util.table.deepcopy(tech)
			-- tech_revised.name = tech.name .. "-1"

			second_tech.name = tech.name .. "-2"
			second_tech.max_level = nil
			second_tech.max_level = nil
			second_tech.prerequisites = { tech.name }

			third_tech.name = tech.name .. "-3"
			third_tech.prerequisites = { second_tech.name, "infinite-research" }

			-- data.raw.technology[tech_name] = nil
			-- data:extend({ tech_revised })
			-- tech = data.raw.technology[tech_revised.name]
		end

		tech.upgrade = nil
		tech.max_level = nil

		table.insert(third_tech.unit.ingredients, { "cryogenic-science-pack", 1 })

		data:extend({ second_tech, third_tech })
	end
end
