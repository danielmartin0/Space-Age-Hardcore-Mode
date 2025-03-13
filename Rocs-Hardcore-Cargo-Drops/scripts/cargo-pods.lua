local Public = {}

local bad_color = { r = 255, g = 60, b = 60 }
local warn_color = { r = 255, g = 90, b = 54 }
local notify_color = { r = 255, g = 231, b = 46 }

Public.LOCATION_REQUIRED_ITEMS = {
	nauvis = "cargo-pod-nauvis",
	vulcanus = "cargo-pod-vulcanus",
	fulgora = "cargo-pod-fulgora",
	gleba = "cargo-pod-gleba",
	aquilo = "cargo-pod-aquilo",
	default = "cargo-pod-nauvis",
}
script.on_nth_tick(10, function()
	Public.check_cargo_pods()
end)

function Public.check_cargo_pods()
	if not storage.cargo_pods_seen_on_platforms then
		storage.cargo_pods_seen_on_platforms = {}
	end
	if not storage.cargo_pod_failed_whisper_ticks then
		storage.cargo_pod_failed_whisper_ticks = {}
	end
	if not storage.cargo_pod_canceled_whisper_ticks then
		storage.cargo_pod_canceled_whisper_ticks = {}
	end

	for _, force in pairs(game.forces) do
		for _, platform in pairs(force.platforms) do
			if platform and platform.valid and platform.surface and platform.surface.valid then
				local cargo_pods = platform.surface.find_entities_filtered({ type = "cargo-pod" })

				for _, pod in pairs(cargo_pods) do
					if pod and pod.valid and not storage.cargo_pods_seen_on_platforms[pod.unit_number] then
						local pod_contents = pod.get_inventory(defines.inventory.cargo_unit).get_contents()

						local pod_has_contents
						local cargo_pod_in_cargo_pod = nil

						for _, item in pairs(pod_contents) do
							pod_has_contents = true
							if
								item.name == "cargo-pod-nauvis"
								or item.name == "cargo-pod-vulcanus"
								or item.name == "cargo-pod-fulgora"
								or item.name == "cargo-pod-gleba"
								or item.name == "cargo-pod-aquilo"
							then
								cargo_pod_in_cargo_pod = item.name
							end
						end

						local nearby_hubs = platform.surface.find_entities_filtered({
							name = { "space-platform-hub", "cargo-bay" },
							position = pod.position,
							radius = 4,
						})

						local launched_from_platform = #nearby_hubs > 0

						storage.cargo_pods_seen_on_platforms[pod.unit_number] = {
							launched_from_platform = launched_from_platform,
							paid = nil,
							entity = pod,
							pod_has_contents = pod_has_contents,
							player_inside_pod_index = nil, -- yet to fill this field
							platform_index = platform.index,
							platform_surface_index = platform.surface.index,
						}

						if launched_from_platform and cargo_pod_in_cargo_pod then
							Public.destroy_pod_on_platform(pod, platform, cargo_pod_in_cargo_pod)
						else
							local paid = nil
							local reason = nil

							if launched_from_platform then
								local payment_result = Public.attempt_pod_payment(pod, platform, pod_has_contents)

								paid = payment_result.paid
								reason = payment_result.reason
							end

							storage.cargo_pods_seen_on_platforms[pod.unit_number].paid = paid

							if
								launched_from_platform
								and pod_has_contents
								and not paid
								and settings.global["rocs-hardcore-prevent-launching-item-pods-without-protection"].value
							then
								Public.destroy_pod_on_platform(pod, platform, nil, reason == "minimum_drop_count")
							end
						end
					end
				end
			end
		end
	end

	for pod_unit_number, pod_data in pairs(storage.cargo_pods_seen_on_platforms) do
		local pod = pod_data.entity

		if not (pod and pod.valid and pod.procession_tick <= 60 * 60 * 2) then
			storage.cargo_pods_seen_on_platforms[pod_unit_number] = nil
			break
		end

		if not pod_data.launched_from_platform then
			break
		end

		local surface = pod.surface

		if
			surface
			and surface.valid
			and pod_data.platform_surface_index ~= surface.index
			and surface.planet
			and surface.planet.valid
		then
			if (not pod_data.paid) and pod.procession_tick >= 60 * 3.3 then
				if settings.global["rocs-hardcore-cargo-pods-can-carry-construction-robots"].value then
					local pod_contents = pod.get_inventory(defines.inventory.cargo_unit).get_contents()

					local has_construction_robots = false
					local only_construction_robots = true

					for _, item in pairs(pod_contents) do
						if item.name == "construction-robot" then
							has_construction_robots = true
						else
							only_construction_robots = false
							break
						end
					end

					if not (has_construction_robots and only_construction_robots) then
						Public.destroy_pod_in_atmosphere(pod)
					end
				else
					Public.destroy_pod_in_atmosphere(pod)
				end
			end
		end
	end
end

script.on_event(defines.events.on_cargo_pod_finished_ascending, function(event)
	if event.launched_by_rocket then
		return
	end

	local pod = event.cargo_pod
	local pod_data = storage.cargo_pods_seen_on_platforms[pod.unit_number]

	if pod_data then
		pod_data.player_inside_pod_index = event.player_index
	end
end)

function Public.attempt_pod_payment(pod, platform, pod_has_contents)
	if not (platform.space_location and platform.space_location.valid and platform.space_location.name) then
		return { paid = false }
	end

	if pod_has_contents then
		if storage.hub_settings and storage.hub_settings[platform.hub.unit_number] then
			local settings = storage.hub_settings[platform.hub.unit_number]
			if settings.enabled and settings.minimum_drop_count then
				local pod_inventory = pod.get_inventory(defines.inventory.cargo_unit)
				local filled_stacks = 10 - pod_inventory.count_empty_stacks()
				if filled_stacks < settings.minimum_drop_count then
					return { paid = false, reason = "minimum_drop_count" }
				end
			end
		end
	end

	local planet_name = platform.space_location.name
	local required_item = Public.LOCATION_REQUIRED_ITEMS[planet_name] or Public.LOCATION_REQUIRED_ITEMS.default

	if settings.global["rocs-hardcore-cargo-pods-can-carry-construction-robots"].value then
		local pod_contents = pod.get_inventory(defines.inventory.cargo_unit).get_contents()

		local has_construction_robots = false
		local only_construction_robots = true

		for _, item in pairs(pod_contents) do
			if item.name == "construction-robot" then
				has_construction_robots = true
			else
				only_construction_robots = false
				break
			end
		end

		if has_construction_robots and only_construction_robots then
			return { paid = true }
		end
	end

	local hub = platform.hub
	if not (hub and hub.valid) then
		return { paid = false }
	end

	local hub_inventory = hub.get_inventory(defines.inventory.hub_main)
	if not (hub_inventory and hub_inventory.valid) then
		return { paid = false }
	end

	local available_count = 0
	for _, quality in pairs(prototypes.quality) do
		available_count = available_count
			+ hub_inventory.get_item_count({ name = required_item, quality = quality.name })
	end

	if available_count < 1 then
		return { paid = false, reason = "cost" }
	end

	for _, quality in pairs(prototypes.quality) do
		if hub_inventory.get_item_count({ name = required_item, quality = quality.name }) > 0 then
			hub_inventory.remove({
				name = required_item,
				count = 1,
				quality = quality,
			})
			break
		end
	end

	platform.surface.print({
		"rocs-hardcore-cargo-drops.cargo-pod-paid",
		"[space-platform=" .. platform.index .. "]",
		"[item=" .. required_item .. "]",
	}, { color = notify_color })

	return { paid = true }
end

function Public.destroy_pod_on_platform(pod, platform, cargo_pod_in_cargo_pod, due_to_minimum_drop_count)
	local hub = platform.hub
	if hub and hub.valid then
		local pod_inventory = pod.get_inventory(defines.inventory.cargo_unit)
		local hub_inventory = hub.get_inventory(defines.inventory.hub_main)

		if pod_inventory and hub_inventory then
			for _, item in pairs(pod_inventory.get_contents()) do
				hub_inventory.insert(item)
			end
		end
	end

	if not due_to_minimum_drop_count then
		if cargo_pod_in_cargo_pod then
			for _, player in pairs(game.connected_players) do
				if
					player.valid
					and player.surface
					and player.surface.valid
					and player.surface.index == platform.surface.index
				then
					local whisper_hash = platform.index .. "-" .. player.name

					local last_whisper_tick = storage.cargo_pod_canceled_whisper_ticks[whisper_hash]

					if (not last_whisper_tick) or (game.tick - last_whisper_tick >= 60 * 10) then
						player.print({
							"rocs-hardcore-cargo-drops.cargo-pod-canceled",
							"[space-platform=" .. platform.index .. "]",
							"[item=" .. cargo_pod_in_cargo_pod .. "]",
						}, { color = warn_color })

						storage.cargo_pod_canceled_whisper_ticks[whisper_hash] = game.tick
					end
				end
			end
		elseif platform.space_location and platform.space_location.valid and platform.space_location.name then
			local planet_name = platform.space_location.name
			local required_item = Public.LOCATION_REQUIRED_ITEMS[planet_name] or Public.LOCATION_REQUIRED_ITEMS.default

			for _, player in pairs(game.connected_players) do
				if
					player.valid
					and player.surface
					and player.surface.valid
					and player.surface.index == platform.surface.index
				then
					local whisper_hash = platform.index .. "-" .. planet_name .. "-" .. player.name

					local last_whisper_tick = storage.cargo_pod_failed_whisper_ticks[whisper_hash]

					if (not last_whisper_tick) or (game.tick - last_whisper_tick >= 60 * 10) then
						player.print({
							"rocs-hardcore-cargo-drops.cargo-pod-failure",
							"[space-platform=" .. platform.index .. "]",
							"[item=" .. required_item .. "]",
						}, { color = warn_color })

						storage.cargo_pod_failed_whisper_ticks[whisper_hash] = game.tick
					end
				end
			end
		end
	end

	local pod_unit_number = pod.unit_number

	pod.destroy()

	storage.cargo_pods_seen_on_platforms[pod_unit_number] = nil
end

function Public.destroy_pod_in_atmosphere(pod)
	local pod_unit_number = pod.unit_number

	local planet_name = pod.surface.planet.name

	pod.surface.create_entity({
		name = "fusion-reactor-explosion",
		position = pod.position,
	})

	local pod_contents = pod.get_inventory(defines.inventory.cargo_unit).get_contents()
	local pod_contents_string = { "" }
	local seen_items = {}
	for i, item in pairs(pod_contents) do
		if not seen_items[item.name] then
			seen_items[item.name] = true

			if i > 1 then
				pod_contents_string[#pod_contents_string + 1] = ", "
			end
			pod_contents_string[#pod_contents_string + 1] = "[item=" .. item.name .. "]"
		end
	end

	local player_inside_pod_index = storage.cargo_pods_seen_on_platforms[pod_unit_number].player_inside_pod_index

	if not player_inside_pod_index then
		if pod.force and pod.force.valid then
			pod.force.print({
				"rocs-hardcore-cargo-drops.cargo-pod-burned-up-items",
				"[space-platform=" .. storage.cargo_pods_seen_on_platforms[pod_unit_number].platform_index .. "]",
				pod_contents_string,
				"[planet=" .. planet_name .. "]",
			}, { color = bad_color })
		end
	end

	pod.destroy()

	if player_inside_pod_index then
		local player = game.players[player_inside_pod_index]

		if player.valid then
			local surface = player.surface

			player.play_sound({ path = "cargo-pod-explosion", volume_modifier = 0.5 })

			if surface and surface.valid then
				local character = player.character

				if character and character.valid and character.position then
					local non_colliding_position =
						surface.find_non_colliding_position("character", character.position, 50, 2)

					player.teleport(non_colliding_position or { x = 0, y = 0 })

					character.die()

					player.ticks_to_respawn = 0
				end

				local respawn_position = { x = 0, y = 0 }

				local cargo_landing_pads = surface.find_entities_filtered({ name = "cargo-landing-pad" })

				if #cargo_landing_pads > 0 then
					respawn_position = cargo_landing_pads[1].position
				end

				local non_colliding_position =
					surface.find_non_colliding_position("character", respawn_position, 32, 0.5)

				player.teleport(non_colliding_position or respawn_position)
			end

			if player.force and player.force.valid then
				player.force.print({
					"rocs-hardcore-cargo-drops.cargo-pod-burned-up-player",
					player.name,
					"[planet=" .. planet_name .. "]",
				}, { color = bad_color })
			end

			if settings.global["rocs-hardcore-z-cargo-drops-destroy-weapons-and-armor"].value then
				player.clear_items_inside()
			end
		end
	end

	storage.cargo_pods_seen_on_platforms[pod_unit_number] = nil
end

return Public
