if mods["maraxsis"] then
    local maraxsis = data.raw["planet"]["maraxsis"]
    
    if maraxsis then
        PlanetsLib:update({
            {
                type = "planet",
                name = "maraxsis",
                orbit = {
                    parent = {
                        type = "space-location",
                        name = "nexuz",
                    },
                    distance = 18.75,  --165
                    orientation = 0.7185, --0.12
                    sprite = {
                        type = "sprite",
                        filename = "__Starmap_Nexuz__/graphics/icons/orbit_Maraxsis.png",
                        size = 4096,
                    },
                }
            }
        })
    else
        log("Maraxsis planet not found in the Maraxsis mod.")
    end

    local modify_space_connection = settings.startup["modify_space_connection"].value -- 如果开启新的星际旅行路线，则修改 space-connection
    if modify_space_connection then

--[[         local maraxsis_trench = data.raw["planet"]["maraxsis-trench"]  --如果有深海星球
        if maraxsis_trench then
                maraxsis_trench.orientation = 0.119
                maraxsis_trench.distance = 164
                maraxsis_trench.draw_orbit = false
                maraxsis_trench.label_orientation = 0.7
                maraxsis_trench.starmap_icon = "__Starmap_Nexuz__/graphics/icons/maraxsis-trench.png"
        end ]]
    
        local vulcanustomaraxsis = data.raw["space-connection"]["vulcanus-maraxsis"]
        if vulcanustomaraxsis then
            vulcanustomaraxsis.from = "sye-nexuz-sw"
        end

        local fulgoratomaraxsis = data.raw["space-connection"]["fulgora-maraxsis"]
        if fulgoratomaraxsis then
            -- 如果有这个航线，删除或者禁用它
            data.raw["space-connection"]["fulgora-maraxsis"] = nil  -- 删除航线
        end

    end        
end