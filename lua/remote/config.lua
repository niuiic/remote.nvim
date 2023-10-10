--- collect config with user input
---@param config Remote.ConfigPartial | nil
local collect_config = function(config)
	config = config or {}
	if not config.host then
		vim.ui.input({ title = "Remote", prompt = "Host: " }, function(input)
			config.host = input
		end)
	end

	if not config.user then
		vim.ui.input({ title = "Remote", prompt = "User: " }, function(input)
			config.user = input
		end)
	end

	if not config.passwd then
		vim.ui.input({ title = "Remote", prompt = "Password: " }, function(input)
			config.passwd = input
		end)
	end

	if not config.path then
		vim.ui.input({ title = "Remote", prompt = "Target path: " }, function(input)
			config.path = input
		end)
	end

	if not config.excludes then
		vim.ui.input({ title = "Remote", prompt = "Files be excluded(split with comma): " }, function(input)
			config.excludes = input
		end)
	end

	return config
end

--- validate config
---@param config Remote.Config
---@return boolean
local validate_config = function(config)
	if not config.host then
		return false
	end

	if not config.user then
		return false
	end

	if not config.path then
		return false
	end

	return true
end

return {
	collect_config = collect_config,
	validate_config = validate_config,
}
