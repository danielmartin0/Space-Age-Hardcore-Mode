local POD_DATA = {
	{
		planet = "vulcanus",
		position = { x = -12, y = 0 },
	},
	{
		planet = "gleba",
		position = { x = -23, y = -4 },
	},
	{
		planet = "fulgora",
		position = { x = -17, y = -9 },
	},
}

script.on_event(defines.events.on_player_created, function(e)
	local count = settings.startup["rocs-hardcore-initial-cargo-pods"].value

	if not (count > 0) then
		return
	end

	if storage.tried_giving_starter_pods then
		return
	end

	storage.tried_giving_starter_pods = true

	local player = game.players[e.player_index]
	local surface = player.physical_surface

	local e_name = "cargo-pod-container"

	for _, pod_data in pairs(POD_DATA) do
		local p = surface.find_non_colliding_position(e_name, pod_data.position, 20, 2)

		if not p then
			break
		end

		local pod_entity = surface.create_entity({
			name = e_name,
			position = p,
			force = player.force,
		})

		if not (pod_entity and pod_entity.valid) then
			break
		end

		pod_entity.insert({
			name = "cargo-pod-" .. pod_data.planet,
			count = settings.global["rocs-hardcore-initial-cargo-pods"].value,
		})
	end
end)
