local Public = {}

Public.fallback_tier = 3 + 1 / 3

--== VANILLA ==--

Public.vanilla_planet_tiers = {
	nauvis = 1,
	vulcanus = 1.8,
	fulgora = 2.2,
	gleba = 3,
	aquilo = 5,
}

Public.vanilla_location_tiers = {
	["shattered-planet"] = 5,
	["solar-system-edge"] = 5,
}

--== MODDED ==--
--Modders are welcome to override these values by including a 'tier' field in the prototype.

Public.default_modded_planet_tiers = {
	akularis = 0.5,
	gerkizia = 0.5,
	quadromire = 0.5,
	lignumis = 0.5,
	mickora = 1,
	terrapalus = 1,
	vicrox = 1.4,
	froodara = 1.8,
	tchekor = 2,
	nekohaven = 2.5,
	zzhora = 2.5,
	janus = 3,
	ithurice = 3.5,
	castra = 4,
	tapatrion = 4,
	corrundum = 4,
	hexalith = 5,
	tenebris = 5,
	maraxsis = 5,
	frozeta = 5.5,
	naufulglebunusilo = 6,
	arrakis = 6,
}

Public.default_modded_location_tiers = {
	secretas = 5.5,
}

return Public
