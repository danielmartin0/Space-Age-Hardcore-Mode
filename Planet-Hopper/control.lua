script.on_event(defines.events.on_script_trigger_effect, function(event)
	if event.effect_id ~= "planet-hopper-clear-rocket-inventory" then
		return
	end

	local entity = event.target_entity
	if not entity or not entity.valid then
		return
	end

	local cargo_pod = entity.cargo_pod
	if not cargo_pod or not cargo_pod.valid then
		return
	end

	local inv = cargo_pod.get_inventory(defines.inventory.cargo_unit)
	if not inv or not inv.valid then
		return
	end

	inv.clear()
end)
