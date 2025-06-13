local find = require("lib").find

local function accept_planet_hopper_pod(table)
	for k, v in pairs(table) do
		if k == "receiving_cargo_units" and type(v) == "table" then
			v[#v + 1] = "planet-hopper-pod"
		elseif type(v) == "table" then
			accept_planet_hopper_pod(v)
		end
	end
end

for _, v in pairs(data.raw["cargo-landing-pad"] or {}) do
	accept_planet_hopper_pod(v)
end
