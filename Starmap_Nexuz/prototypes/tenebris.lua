if mods["tenebris"] or mods["tenebris-prime"] then
    local tenebris = data.raw["planet"]["tenebris"]
    
    if tenebris then
        PlanetsLib:update({
            {
                type = "planet",
                name = "tenebris",
                orbit = {
                    parent = {
                        type = "space-location",
                        name = "nexuz",
                    },
                    distance = 43, --170
                    orientation = 0.9375, --0.0975
                    sprite = {
                        type = "sprite",
                        filename = "__Starmap_Nexuz__/graphics/icons/orbit_Tenebris.png",
                        size = 4096,
                    },
                }
            }
        })
    end
    
    local modify_space_connection = settings.startup["modify_space_connection"].value -- 如果开启新的星际旅行路线，则修改 space-connection
    if modify_space_connection then

        local fulgoratotenebris = data.raw["space-connection"]["fulgora-tenebris"]
        if fulgoratotenebris then
            fulgoratotenebris.from = "sye-nexuz-sw"
        end

        local fulgoratoedge = data.raw["space-connection"]["tenebris-solar-system-edge"]
        if fulgoratoedge then
            data.raw["space-connection"]["tenebris-solar-system-edge"] = nil  -- 删除航线
        end
    end
else
    log("Tenebris planet not found in the Tenebris mod.")
end
