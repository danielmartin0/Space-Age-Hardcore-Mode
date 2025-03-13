if not mods["Redrawn-Space-Connections"] then
	data.raw["space-connection"]["nauvis-vulcanus"].length = math.floor(
		data.raw["space-connection"]["nauvis-vulcanus"].length
			* settings.startup["planetary-distance-adjustments-nauvis-vulcanus-multiplier"].value
	)
	data.raw["space-connection"]["nauvis-gleba"].length = math.floor(
		data.raw["space-connection"]["nauvis-gleba"].length
			* settings.startup["planetary-distance-adjustments-nauvis-gleba-multiplier"].value
	)
	data.raw["space-connection"]["nauvis-fulgora"].length = math.floor(
		data.raw["space-connection"]["nauvis-fulgora"].length
			* settings.startup["planetary-distance-adjustments-nauvis-fulgora-multiplier"].value
	)
	data.raw["space-connection"]["vulcanus-gleba"].length = math.floor(
		data.raw["space-connection"]["vulcanus-gleba"].length
			* settings.startup["planetary-distance-adjustments-vulcanus-gleba-multiplier"].value
	)
	data.raw["space-connection"]["gleba-fulgora"].length = math.floor(
		data.raw["space-connection"]["gleba-fulgora"].length
			* settings.startup["planetary-distance-adjustments-gleba-fulgora-multiplier"].value
	)
	data.raw["space-connection"]["gleba-aquilo"].length = math.floor(
		data.raw["space-connection"]["gleba-aquilo"].length
			* settings.startup["planetary-distance-adjustments-gleba-aquilo-multiplier"].value
	)
	data.raw["space-connection"]["fulgora-aquilo"].length = math.floor(
		data.raw["space-connection"]["fulgora-aquilo"].length
			* settings.startup["planetary-distance-adjustments-fulgora-aquilo-multiplier"].value
	)
	data.raw["space-connection"]["aquilo-solar-system-edge"].length = math.floor(
		data.raw["space-connection"]["aquilo-solar-system-edge"].length
			* settings.startup["planetary-distance-adjustments-aquilo-solar-system-edge-multiplier"].value
	)
	data.raw["space-connection"]["solar-system-edge-shattered-planet"].length = math.floor(
		data.raw["space-connection"]["solar-system-edge-shattered-planet"].length
			* settings.startup["planetary-distance-adjustments-solar-system-edge-multiplier-shattered-planet"].value
	)
end
