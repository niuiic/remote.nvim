local static = require("remote.static")
local core = require("core")

--- write log
---@param config remote.Config
---@param output string
---@param operation string
local log = function(config, output, operation)
	local log_dir = core.file.dir(static.config.config_file)
	if not core.file.file_or_dir_exists(log_dir) then
		core.file.mkdir(log_dir)
	end

	local time = os.date("%Y-%m-%d %H:%M:%S")
	vim.fn.writefile({
		string.format("[%s] %s", time, operation),
		string.format("Config: %s", vim.fn.json_encode(config)),
		string.format("Output: %s", vim.fn.json_encode(output)),
		"",
	}, static.config.log_file, "a")
end

local check_log = function()
	local log_file = static.config.log_file

	if not core.file.file_or_dir_exists(log_file) then
		vim.notify("No log file", vim.log.levels.WARN, {
			title = "Remote",
		})
		return
	end

	vim.cmd("e " .. log_file)
end

return {
	log = log,
	check_log = check_log,
}
