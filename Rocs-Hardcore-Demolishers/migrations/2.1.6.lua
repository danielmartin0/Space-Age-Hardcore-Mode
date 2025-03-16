for _, force in pairs(game.forces) do
	if
		force.technologies["turbo-transport-belt"]
		and force.technologies["turbo-transport-belt"].researched
		and force.technologies["advanced-casting"]
	then
		force.technologies["advanced-casting"].researched = true
	end
end
