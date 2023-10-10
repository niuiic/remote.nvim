local static = require("remote.static")

--- whether config a equals config b
---@param a Remote.Config
---@param b Remote.Config
---@return boolean
local is_same_config = function(a, b)
	local core = require("core")

	if a.host ~= b.host then
		return false
	end

	if a.user ~= b.user then
		return false
	end

	if a.passwd ~= b.passwd then
		return false
	end

	if a.path ~= b.path then
		return false
	end

	if a.excludes and not b.excludes then
		return false
	end

	if not a.excludes and b.excludes then
		return false
	end

	if not a.excludes and not b.excludes then
		return true
	end

	if table.maxn(a.excludes) ~= table.maxn(b.excludes) then
		return false
	end

	if
		not core.lua.list.reduce(a.excludes, function(prev_res, x)
			return prev_res and core.lua.list.includes(b.excludes, function(y)
				return x == y
			end)
		end, true)
	then
		return false
	end

	return true
end

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
	elseif not core.lua.list.includes(history, function(x)
		return is_same_config(x, config)
	end) then
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

--- edit history file
local edit_history = function()
	local core = require("core")
	local history_file = static.config.history_file
	if not history_file or not core.file.file_or_dir_exists(history_file) then
		vim.notify("No history found.", vim.log.levels.WARN, {
			title = "Remote",
		})
		return
	end
	vim.cmd("e " .. history_file)
end

return {
	record_history = record_history,
	select_from_history = select_from_history,
	edit_history = edit_history,
}
