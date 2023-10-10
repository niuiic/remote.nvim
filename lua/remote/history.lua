local static = require("remote.static")

--- read history from file
---@return Remote.Config[] | nil
local read_history = function()
	local core = require("core")
	local history_file = static.config.history_file
	local history
	if history_file and core.file.file_or_dir_exists(history_file) then
		local content = vim.fn.readfile(history_file)
		if content then
			history = core.lua.list.map(content, function(x)
				return vim.fn.json_decode(x)
			end)
		end
	end
	return history
end

--- record remote file info
---@param config Remote.Config
local record_history = function(config)
	local core = require("core")

	local history_file = static.config.history_file
	if not history_file then
		return
	end

	local history
	if core.file.file_or_dir_exists(history_file) then
		history = read_history()
	end

	if not history then
		history = { config }
	else
		table.insert(history, config)
	end

	vim.fn.writefile(
		core.lua.list.map(history, function(x)
			return vim.fn.json_encode(x)
		end),
		history_file
	)
end

--- select config from history
---@param cb fun(config: Remote.Config)
local select_from_history = function(cb)
	local core = require("core")

	local history = read_history()
	if not history then
		vim.notify("No history found.", vim.log.levels.WARN, {
			title = "Remote",
		})
		return
	end

	local config_list = core.lua.list.map(history, function(x, i)
		local info = string.format("%s %s@%s:%s", i, x.user, x.host, x.path)
		if x.excludes then
			info = string.format(
				"%s(excludes %s)",
				info,
				core.list.reduce(x.excludes, function(prev_res, y)
					return prev_res .. ", " .. y
				end, "")
			)
		end
		return info
	end)
	vim.ui.select(config_list, { prompt = "Select one config" }, function(choice)
		if not choice then
			return
		end
		local index = tonumber(string.sub(choice, 1, 2))
		local config = history[index]
		cb(config)
	end)
end

return {
	record_history = record_history,
	select_from_history = select_from_history,
}
