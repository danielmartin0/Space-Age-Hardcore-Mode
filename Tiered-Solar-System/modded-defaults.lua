local Public = {}

--== Tier meanings ==--
-- Tier 0:  Pre-Nauvis
-- Tier 1:  Nauvis & friends
-- Tier 2:  First steps from Nauvis
-- Tier 3:  Intermediate planets that may reward preparation
-- Tier 4:  Difficult planets that aren't part of the endgame
-- Tier 5:  Aquilo and the vanilla endgame
-- Tier 6:  Post-endgame planets and other oddities
-- Tier -1: Planet is placed in its original location

Public.fallback_tier = 3.22581 -- Vertically south of the star

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
	cubium = 3.3,
	janus = 3.1,
	ithurice = 3.5,
	castra = 4,
	tapatrion = 4,
	corrundum = 4,
	tenebris = 4,
	hexalith = 5,
	maraxsis = 5,
	frozeta = 5.5,
	naufulglebunusilo = 6,
	arrakis = 6,
}

Public.default_modded_location_tiers = {
	secretas = 5.65,
}

-- For vanilla tiers, see vanilla.lua or the mod portal homepage.

return Public
