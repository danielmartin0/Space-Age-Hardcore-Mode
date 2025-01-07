local util = require("util")

if settings.startup["rocs-hardcore-push-back-repair-pack"].value then
	data.raw.technology["repair-pack"].prerequisites = {
		"logistic-science-pack",
	}
	data.raw.technology["repair-pack"].unit.ingredients = {
		{ "automation-science-pack", 1 },
		{ "logistic-science-pack", 1 },
	}
end

if settings.startup["rocs-hardcore-push-back-logistic-system"].value then
	data.raw.technology["logistic-system"].prerequisites = {
		"carbon-fiber",
	}
	data.raw.technology["logistic-system"].unit.count = 5000
	data.raw.technology["logistic-system"].unit.ingredients = {
		{ "automation-science-pack", 1 },
		{ "logistic-science-pack", 1 },
		{ "chemical-science-pack", 1 },
		{ "utility-science-pack", 1 },
		{ "space-science-pack", 1 },
		{ "agricultural-science-pack", 1 },
	}

	if data.raw.recipe["requester-chest"] then
		data.raw.recipe["requester-chest"].ingredients = {
			{ type = "item", name = "steel-chest", amount = 1 },
			{ type = "item", name = "electronic-circuit", amount = 3 },
			{ type = "item", name = "advanced-circuit", amount = 1 },
			{ type = "item", name = "carbon-fiber", amount = 1 },
		}
	end

	if data.raw.recipe["buffer-chest"] then
		data.raw.recipe["buffer-chest"].ingredients = {
			{ type = "item", name = "steel-chest", amount = 1 },
			{ type = "item", name = "electronic-circuit", amount = 3 },
			{ type = "item", name = "advanced-circuit", amount = 1 },
			{ type = "item", name = "carbon-fiber", amount = 1 },
		}
	end
end

if settings.startup["rocs-hardcore-push-back-cliff-explosives"].value then
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

if settings.startup["rocs-hardcore-push-back-kovarex-nuclear-fuel-and-atomic-bomb"].value then
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

if settings.startup["rocs-hardcore-z-infinite-tech-needs-cryogenic"].value then
	local excluded_techs = {
		["health"] = true,
	}

	local techs_to_process = {}
	for name, tech in pairs(data.raw.technology) do
		if tech.max_level == "infinite" and not excluded_techs[name] then
			table.insert(techs_to_process, name)
		end
	end

	for _, tech_name in ipairs(techs_to_process) do
		local tech = data.raw.technology[tech_name]
		local new_tech = util.table.deepcopy(tech)

		if tech.name:match("%d+$") then
			new_tech.name = tech.name:gsub("%d+$", function(n)
				return tonumber(n) + 1
			end)
		else
			-- If the original name has no number, add "-1" to the original and "-2" to the clone
			local tech_revised = util.table.deepcopy(tech)
			tech_revised.name = tech.name .. "-1"
			data:extend({ tech_revised })
			data.raw.technology[tech_name] = nil

			new_tech.name = tech.name .. "-2"

			tech = data.raw.technology[tech_revised.name]
		end

		tech.upgrade = nil
		tech.max_level = nil

		new_tech.prerequisites = { tech.name, "infinite-research" }

		local has_cryo = false
		for _, ingredient in pairs(tech.unit.ingredients or {}) do
			if ingredient[1] == "cryogenic-science-pack" then
				has_cryo = true
				break
			end
		end

		if not has_cryo then
			table.insert(new_tech.unit.ingredients, { "cryogenic-science-pack", 1 })
		end

		data:extend({ new_tech })
	end
end
