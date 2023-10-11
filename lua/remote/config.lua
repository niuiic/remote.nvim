--- collect config with user input
---@param config remote.ConfigPartial | nil
local collect_config = function(config)
	local core = require("core")

	config = config or {}

	for _, field in ipairs({
		"host",
		"user",
		"passwd",
		"path",
	}) do
		if not config[field] then
			vim.ui.input(
				{ title = "Remote", prompt = string.upper(string.sub(field, 1, 2)) .. string.sub(field, 2) .. " :" },
				function(input)
					config[field] = input
				end
			)
		end
	end

	if not config.excludes then
		vim.ui.input({ title = "Remote", prompt = "Files be excluded(split with comma): " }, function(input)
			if not input then
				return
			end
			config.excludes = core.lua.string.split(",")
		end)
	end

	return config
end

--- validate config
---@param config remote.Config
---@return boolean
local validate_config = function(config)
	for _, field in ipairs({
		"host",
		"user",
		"passwd",
		"path",
	}) do
		if not config[field] then
			return false
		end
	end

	return true
end

return {
	collect_config = collect_config,
	validate_config = validate_config,
}
