local Public = {}

-- Public.offline_player_inventory_preservation_minutes = 10

function Public.init_tech(force)
	local no_landmines = settings.global["rocs-hardcore-landmines-disabled"].value

	if no_landmines then
		force.technologies["land-mine"].enabled = false
		if force.technologies["land-mine"].researched then
			force.technologies["land-mine"].researched = false
		end
	else
		force.technologies["land-mine"].enabled = true
	end
end

return Public
