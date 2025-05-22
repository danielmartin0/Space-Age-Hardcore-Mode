local categories_to_check = { "capsule", "item" }

if settings.startup["rocs-hardcore-gleba-spoil-ticks-multiplier"].value then
	local multiplier = settings.startup["rocs-hardcore-gleba-spoil-ticks-multiplier"].value

	for _, category in pairs(categories_to_check) do
		if data.raw[category] then
			for _, item in pairs(data.raw[category]) do
				if item.default_import_location == "gleba" and item.spoil_ticks then
					item.spoil_ticks = item.spoil_ticks * multiplier
				end
			end
		end
	end
end
