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

function Public.update_nauvis_night()
	local nauvis = game.surfaces["nauvis"]
	if nauvis and nauvis.valid then
		if settings.global["rocs-hardcore-nauvis-darker-nights"].value then
			nauvis.brightness_visual_weights = { 0.85, 0.85, 0.85 }
			nauvis.min_brightness = 0.05
		else
			nauvis.brightness_visual_weights = { 0, 0, 0 }
			nauvis.min_brightness = 0.15
		end
	end
end

return Public
