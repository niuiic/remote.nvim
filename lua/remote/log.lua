local static = require("remote.static")

--- write log
---@param log string
---@param level "ERROR" | "WARN" | "INFO"
local write_log = function(log, level)
	if not static.config.log_file then
		return
	end
	vim.fn.writefile({ string.format("[%s]: %s", level, log) }, static.config.log_file, "a")
end

return { write_log = write_log }
