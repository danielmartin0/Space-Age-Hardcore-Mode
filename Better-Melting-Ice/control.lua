local Public = {}

local PLAYER_CHECK_INTERVAL = 70
local SURFACE_CHECK_FACTOR = 60 * 30

script.on_nth_tick(PLAYER_CHECK_INTERVAL, function()
	if not settings.startup["better-melting-ice-enable-mod"].value then
		return
	end

	for _, surface in pairs(game.surfaces) do
		if surface.valid and surface.planet and surface.planet.name == "aquilo" then
			if not storage.melting_tiles then
				storage.melting_tiles = {}
			end

			if not storage.melting_tiles[surface.index] then
				storage.melting_tiles[surface.index] = {}
			end

			if game.tick % (PLAYER_CHECK_INTERVAL * SURFACE_CHECK_FACTOR) == 0 then
				local melting_ice_tiles = surface.find_tiles_filtered({
					name = { "ice-platform-melting", "ice-smooth-melting" },
				})

				Public.process_melting_ice(surface, melting_ice_tiles, nil)
			else
				for _, player in pairs(game.connected_players) do
					if player.surface and player.surface.valid and player.surface.index == surface.index then
						local search_area = {
							{ player.position.x - 20, player.position.y - 20 },
							{ player.position.x + 20, player.position.y + 20 },
						}

						local melting_ice_tiles = surface.find_tiles_filtered({
							name = { "ice-platform-melting", "ice-smooth-melting" },
							area = search_area,
						})

						Public.process_melting_ice(surface, melting_ice_tiles, PLAYER_CHECK_INTERVAL)
					end
				end
			end
		end
	end
end)

function Public.process_melting_ice(surface, melting_ice_tiles, interval)
	local tiles_to_set = {}

	for _, tile in pairs(melting_ice_tiles) do
		local pos = tile.position
		if not storage.melting_tiles[surface.index][pos.x] then
			storage.melting_tiles[surface.index][pos.x] = {}
		end

		local last_observed_tick = storage.melting_tiles[surface.index][pos.x][pos.y]

		if
			not interval
			or (
				last_observed_tick
				and (game.tick - last_observed_tick >= interval)
				and (game.tick - last_observed_tick < interval * 2)
			)
		then
			tiles_to_set[#tiles_to_set + 1] = { name = "brash-ice", position = pos }

			Public.handle_melting_effects(surface, pos)

			storage.melting_tiles[surface.index][pos.x][pos.y] = nil
		else
			storage.melting_tiles[surface.index][pos.x][pos.y] = game.tick
		end
	end

	if #tiles_to_set > 0 then
		surface.set_tiles(tiles_to_set)
	end
end

function Public.handle_melting_effects(surface, pos)
	local colliding_entities = surface.find_entities_filtered({
		area = {
			left_top = { x = pos.x + 0.2, y = pos.y + 0.2 },
			right_bottom = { x = pos.x + 0.8, y = pos.y + 0.8 },
		},
		collision_mask = "object",
	})

	for _, entity in pairs(colliding_entities) do
		entity.die()
	end

	surface.create_entity({
		name = "water-splash",
		position = { x = pos.x + 0.5, y = pos.y + 0.5 },
	})
end
