if mods["planet-arrakis"] then
    -- 获取 Arrakis 星球
    local arrakis = data.raw["planet"]["arrakis"]
    
    if arrakis then
        PlanetsLib:update({
            {
                type = "planet",
                name = "arrakis",
                orbit = {
                    parent = {
                        type = "space-location",
                        name = "nexuz",
                    },
                    distance = 12.43,  --164
                    orientation = 0.64, --0.133
                    sprite = {
                        type = "sprite",
                        filename = "__Starmap_Nexuz__/graphics/icons/orbit_Arrakis.png",
                        size = 4096,
                    },
                }
            }
        })
    else
        log("Arrakis planet data not found in the 'planet-arrakis' mod.")
    end

    -- 获取是否启用新的星际旅行路线设置
    local modify_space_connection = settings.startup["modify_space_connection"].value

    -- 如果开启新的星际旅行路线，则修改 space-connection
    if modify_space_connection then
        local nauvistoarrakis = data.raw["space-connection"]["nauvis-arrakis"]
        if nauvistoarrakis then
            nauvistoarrakis.from = "sye-nexuz-sw"
        else
            log("Space connection 'nauvis-arrakis' not found.")
        end
    else
        log("New interstellar travel route is disabled. No modification to space-connection.")
    end
else
    log("Planet Arrakis mod not found.")
end
