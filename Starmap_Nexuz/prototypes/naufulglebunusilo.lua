if mods["naufulglebunusilo"] then
    local naufulglebunusilo = data.raw["planet"]["naufulglebunusilo"]
    
    if naufulglebunusilo then
        PlanetsLib:update({
            {
                type = "planet",
                name = "naufulglebunusilo",
                orbit = {
                    parent = {
                        type = "space-location",
                        name = "nexuz",
                    },
                    distance = 47,  --203
                    orientation = 0.046, --0.147
                    sprite = {
                        type = "sprite",
                        filename = "__Starmap_Nexuz__/graphics/icons/starmap_startrails_nexuz_Naufulglebunusilo.png",
                        size = 4096,
                        scale = 1,
                        shift = {110, -130},
                    },
                }
            }
        })
    end

    local modify_space_connection = settings.startup["modify_space_connection"].value -- 如果开启新的星际旅行路线，则修改 space-connection
    if modify_space_connection then

        local aquilotonaufulglebunusilo = data.raw["space-connection"]["aquilo-naufulglebunusilo"]
        if aquilotonaufulglebunusilo then
            aquilotonaufulglebunusilo.from = "sye-nexuz-sw"
        end
        local fulgoratonaufulglebunusilo = data.raw["space-connection"]["fulgora-naufulglebunusilo"]

        if fulgoratonaufulglebunusilo then
            -- 如果有这个航线，删除或者禁用它
            data.raw["space-connection"]["fulgora-naufulglebunusilo"] = nil  -- 删除航线
        end
    end
else
            log("Naufulglebunusilo planet not found in the Naufulglebunusilo mod.")
end