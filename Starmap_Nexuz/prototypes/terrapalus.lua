if mods["terrapalus"] then  
    local modify_space_connection = settings.startup["modify_space_connection"].value -- 如果开启新的星际旅行路线，则修改 space-connection
    if modify_space_connection then
        local terrapalus = data.raw["planet"]["terrapalus"]
        
        if terrapalus then
            terrapalus.orientation = 0.185
            terrapalus.distance = 21
        end
    end    
else
    log("Terrapalus planet not found in the Terrapalus mod.")
end
