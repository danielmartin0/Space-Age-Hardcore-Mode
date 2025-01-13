if mods["factorissimo-2-notnotmelon"] then
    for _, planet in pairs(data.raw.planet) do
        if planet.name ~= "factory-travel-surface" then
            local factory_floor_name = planet.name .. "-factory-floor"
            local factory_floor = data.raw["planet"][factory_floor_name]

            if factory_floor then
                factory_floor.distance = planet.distance - (2.5 * (factory_floor.magnitude or 1))
                factory_floor.orientation = planet.orientation
                factory_floor.starmap_icon = "__factorissimo-2-notnotmelon__/graphics/starmap/factory-floor-" .. math.floor((planet.orientation or 0) * 64 + 32) % 64 .. ".png"
            end
        end
    end
end