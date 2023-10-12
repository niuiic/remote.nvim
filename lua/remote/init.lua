local static = require("remote.static")
local core = require("core")
local config = require("remote.config")
local mount = require("remote.mount")

local connected = false
local cur_config_list = {}

---@return boolean
local connect = vim.schedule_wrap(function()
	if connected then
		vim.notify("Has connected", vim.log.levels.WARN, {
			title = "Remote",
		})
		return false
	end

	local ok, config_list = pcall(config.load_config)
	if not ok then
		vim.notify("Wrong configuration", vim.log.levels.ERROR, {
			title = "Remote",
		})
		return false
	end

	cur_config_list = config_list
	core.lua.list.each(cur_config_list, function(x)
		mount.mount(x)
	end)

	vim.notify("Connected", vim.log.levels.INFO, {
		title = "Remote",
	})

	connected = true

	return true
end)

---@return boolean
local disconnect = vim.schedule_wrap(function()
	if not connected then
		vim.notify("Not connected", vim.log.levels.WARN, {
			title = "Remote",
		})
		return false
	end

	core.lua.list.each(cur_config_list, function(x)
		mount.unmount(x)
	end)

	vim.notify("Disconnected", vim.log.levels.INFO, {
		title = "Remote",
	})

	connected = false

	return true
end)

---@return boolean
local reconnect = function()
	if not connected then
		return connect()
	end

	local ok = disconnect()
	if not ok then
		return false
	end

	return connect()
end

vim.api.nvim_create_autocmd("VimLeave", {
	pattern = "*",
	callback = function()
		if connected and static.config.disconnect_on_leave then
			disconnect()
		end
	end,
})

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
end

return {
	setup = setup,
	connect = connect,
	disconnect = disconnect,
	reconnect = reconnect,
	edit_config = config.edit_config,
}
