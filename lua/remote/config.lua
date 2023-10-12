local static = require("remote.static")

--- validate config
---@param config remote.Config
---@return boolean
local valid_config = function(config)
	for _, field in ipairs({
		"host",
		"user",
		"passwd",
		"remote_dir",
		"mount_point",
	}) do
		if not config[field] then
			return false
		end
	end

	return true
end

--- edit config file
local edit_config = function()
	local core = require("core")

	local config_file = static.config.config_file
	local config_dir = core.file.dir(config_file)

	if not core.file.file_or_dir_exists(config_dir) then
		core.file.mkdir(config_dir)
	end
	if not core.file.file_or_dir_exists(config_file) then
		vim.fn.writefile({}, config_file)
	end

	vim.cmd("e " .. config_file)
end

--- load config list from config file
---@return remote.Config[]
local load_config = function()
	local core = require("core")

	local config_file = static.config.config_file
	local config_list = {}

	if not core.file.file_or_dir_exists(config_file) then
		error("no config file")
	end

	local text = core.lua.list.reduce(vim.fn.readfile(config_file), function(prev_res, x)
		return prev_res .. "\n" .. x
	end, "")
	config_list = vim.fn.json_decode(text)

	core.lua.list.each(config_list, function(config)
		if not valid_config(config) then
			error("not a valid config")
		end
	end)

	return config_list
end

return {
	edit_config = edit_config,
	load_config = load_config,
}
