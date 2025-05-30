local Common = require("maps.pirates.common")
local Memory = require("maps.pirates.memory")

for _, force in pairs(game.forces) do
	local crew_id = Common.get_id_from_force_name(force.name)

	if crew_id then
		Memory.set_working_id(crew_id)

		local surface = game.surfaces[Common.current_destination().surface_name]
		if surface then
			local centrifuges = surface.find_entities_filtered({ name = "centrifuge" })
			for _, centrifuge in ipairs(centrifuges) do
				centrifuge.force = Common.lobby_force_name
			end
		end
	end
end
