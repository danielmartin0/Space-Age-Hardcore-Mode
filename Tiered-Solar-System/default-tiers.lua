local Public = {}

--== Tier meanings ==--
-- Tier -1: Planet remains in its original location
-- Tier 0:  Pre-Nauvis
-- Tier 1:  Nauvis & friends
-- Tier 2:  First steps from Nauvis
-- Tier 3:  Intermediate planets that may reward preparation
-- Tier 4:  More involved planets that may depend on earlier progress
-- Tier 5:  Aquilo and the vanilla endgame
-- Tier 6:  Post-endgame planets and other oddities

Public.fallback_tier = 3.22581 -- Vertically south of the star

Public.default_modded_planet_tiers = {
	akularis = 0.5,
	gerkizia = 0.5,
	quadromire = 0.5,
	mickora = 1,
	vicrox = 1.4,
	froodara = 1.8,
	tchekor = 2,
	nekohaven = 2.5,
	zzhora = 2.5,
	janus = 3,
	ithurice = 3.3,
	corrundum = 3.3,
	terrapalus = 3.5,
	["slp-solar-system-sun"] = 3.8,
	["slp-solar-system-sun2"] = 3.8,
	castra = 4,
	tapatrion = 4,
	tenebris = 4,
	moshine = 4.1,
	cubium = 4.1,
	hexalith = 5,
	maraxsis = 5,
	frozeta = 5.5,
	naufulglebunusilo = 6,
	arrakis = 6,
}

Public.vanilla_planet_tiers = {
	nauvis = 1,
	vulcanus = 1.8,
	fulgora = 2.4,
	gleba = 3.6,
	aquilo = 5,
}

Public.default_modded_location_tiers = {
	secretas = 5.65,
}

Public.vanilla_location_tiers = {
	["shattered-planet"] = 4.83871,
	["solar-system-edge"] = 4.83871,
}

return Public
