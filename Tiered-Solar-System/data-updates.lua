if mods["naufulglebunusilo"] then
	if data.raw["space-connection"]["fulgora-naufulglebunusilo"] then
		data.raw["space-connection"]["fulgora-naufulglebunusilo"] = nil
	end
end

data.raw.planet.nauvis.orientation = 0.85

data.raw.planet.vulcanus.orientation = 0.66
data.raw.planet.fulgora.orientation = 0.66
data.raw.planet.fulgora.label_orientation = 0.15
data.raw.planet.gleba.orientation = 0.5
data.raw.planet.gleba.label_orientation = 0.1

if data.raw["space-connection"]["nauvis-gleba"] then
	data.raw["space-connection"]["nauvis-gleba"] = nil
end

data.raw.planet.aquilo.orientation = 0.36
data.raw.planet.aquilo.label_orientation = 0.375
data.raw.planet.aquilo.distance = 45 -- from 35
data.raw["space-location"]["solar-system-edge"].distance = 75 -- from 50
data.raw["space-location"]["shattered-planet"].distance = 160 -- from 80

if mods["tenebris"] then
	local tenebris = data.raw["planet"]["tenebris"]

	if tenebris then
		tenebris.orientation = 0.27
		tenebris.distance = 52 -- from 30
		tenebris.label_orientation = 0.5
		tenebris.draw_orbit = false
	end

	data.raw["space-connection"]["fulgora-tenebris"] = nil
end

if mods["maraxsis"] then
	local maraxsis = data.raw["planet"]["maraxsis"]

	if maraxsis then
		maraxsis.orientation = 0.25
		maraxsis.label_orientation = 0.25
		maraxsis.draw_orbit = false
	end

	local trench = data.raw["planet"]["maraxsis-trench"]

	if trench then
		trench.orientation = 0.235
		trench.label_orientation = 0.95
		trench.distance = 14.6 -- from 15.6
		trench.draw_orbit = false
	end

	data.raw["space-connection"]["fulgora-maraxsis"] = nil
end

if mods["naufulglebunusilo"] then
	local naufulglebunusilo = data.raw["planet"]["naufulglebunusilo"]

	if naufulglebunusilo then
		naufulglebunusilo.orientation = 0.1
		naufulglebunusilo.draw_orbit = false
	end
end

if mods["naufulglebunusilo"] and mods["tenebris"] and mods["maraxsis"] then
	data.raw["space-connection"]["aquilo-naufulglebunusilo"] = nil
end

if mods["erm_zerg"] then
	local char = data.raw.planet.char
	if char then
		char.orientation = 0.26
		char.distance = 10
		char.draw_orbit = false

		data.raw["space-connection"]["nauvis-char"] = nil
	end
end

if mods["erm_toss"] then
	local aiur = data.raw.planet.aiur
	if aiur then
		aiur.orientation = 0.6
		aiur.distance = 30
		aiur.draw_orbit = false

		data.raw["space-connection"]["nauvis-aiur"] = nil
	end
end

if mods["terrapalus"] then
	local terrapalus = data.raw.planet.terrapalus
	if terrapalus then
		terrapalus.distance = 22
		terrapalus.orientation = 0.5
	end
end

if mods["Cerys-Moon-of-Fulgora"] then
	data.raw.planet.cerys.orientation = 0.668
end
