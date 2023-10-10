local static = require("remote.static")

--- write log
---@param log string
local write_log = function(log)
	if not static.config.log_file then
		return
	end
	vim.fn.writefile({ log }, static.config.log_file, "a")
end

return { write_log = write_log }
