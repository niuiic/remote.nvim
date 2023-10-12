local static = require("remote.static")
local core = require("core")

--- write log
---@param config remote.Config
---@param output string
local log = function(config, output)
	local log_dir = core.file.dir(static.config.config_file)
	if not core.file.file_or_dir_exists(log_dir) then
		core.file.mkdir(log_dir)
	end

	local time = os.date("%Y-%m-%d %H:%M:%S")
	vim.fn.writefile({
		string.format("[%s] Config: %s", time, vim.fn.json_encode(config)),
		string.format("[%s] Output: %s", time, vim.fn.json_encode(output)),
		"",
	}, static.config.log_file, "a")
end

return log
