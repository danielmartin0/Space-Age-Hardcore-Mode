local CHECK_INTERVAL = 300

local standard_fulgora_day_length = prototypes.space_location.fulgora.surface_properties["day-night-cycle"]

script.on_nth_tick(CHECK_INTERVAL, function()
	local surface = game.surfaces["fulgora"]
	if not surface then
		return
	end

	local vary_day_length = settings.global["rocs-hardcore-lightning-day-length-variations"].value
	if not vary_day_length then
		surface.ticks_per_day = standard_fulgora_day_length

		return
	end

	local current_daytime = surface.daytime

	if current_daytime >= CHECK_INTERVAL / surface.ticks_per_day then
		return
	end

	local new_ticks = standard_fulgora_day_length

	local rng = math.random()

	if rng < 0.1 then
		new_ticks = standard_fulgora_day_length * 0.25
	elseif rng < 0.23 then
		new_ticks = standard_fulgora_day_length * 0.75
	elseif rng > 0.92 then
		new_ticks = standard_fulgora_day_length * 1.5
	elseif rng > 0.77 then
		new_ticks = standard_fulgora_day_length * 1.25
	end

	surface.ticks_per_day = new_ticks
end)
