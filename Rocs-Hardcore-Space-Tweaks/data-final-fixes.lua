local multiplier = settings.startup["hard-space-connection-length-multiplier"].value

for _, connection in pairs(data.raw["space-connection"] or {}) do
	connection.length = math.ceil((connection.length * multiplier) / 100) * 100
end
