--== Modules ==--
local module_tiers = { "efficiency-module", "efficiency-module-2", "efficiency-module-3" }
for _, module_name in pairs(module_tiers) do
	data.raw["module"][module_name].effect.consumption = data.raw["module"][module_name].effect.consumption
		* settings.startup["rocs-hardcore-efficiency-module-effectiveness-multiplier"].value
end

--== Locomotives ==--
data.raw["locomotive"]["locomotive"].energy_source.effectivity = data.raw["locomotive"]["locomotive"].energy_source.effectivity
	/ settings.startup["rocs-hardcore-locomotive-fuel-spend-multiplier"].value
