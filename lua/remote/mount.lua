local core = require("core")
local log = require("remote.log").log

--- mount remote dir
---@param config remote.Config
local mount = function(config)
	if not core.file.file_or_dir_exists(config.mount_point) then
		core.file.mkdir(config.mount_point)
	end

	if not core.file.empty_dir(config.mount_point) then
		vim.notify("Mount point '" .. config.mount_point .. "' is not an empty directory", vim.log.levels.ERROR, {
			title = "Remote",
		})
		return
	end

	local command = string.format(
		[[sshfs -o ssh_command="sshpass -p %s ssh" %s@%s:%s %s]],
		config.passwd,
		config.user,
		config.host,
		config.remote_dir,
		config.mount_point
	)
	if config.options then
		core.lua.list.each(config.options, function(option)
			command = command .. " " .. option
		end)
	end

	local result = vim.api.nvim_exec2("!" .. command, {
		output = true,
	})
	log(config, result.output, "Mount")
end

--- unmount remote dir
---@param config remote.Config
local unmount = function(config)
	if not core.file.file_or_dir_exists(config.mount_point) then
		return
	end

	local result = vim.api.nvim_exec2("!umount " .. config.mount_point, {
		output = true,
	})
	log(config, result.output, "Unmount")
end

return {
	mount = mount,
	unmount = unmount,
}
