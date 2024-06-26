# remote.nvim

Edit remote files with local neovim configuration.

**Edit them as local directories.**

**No other dependencies required for remote machine except ssh.**

[More neovim plugins](https://github.com/niuiic/awesome-neovim-plugins)

## Usage

<img src="https://github.com/niuiic/assets/blob/main/remote.nvim/usage.gif" />

First add a configuration.

Here is an example.

```json
[
  {
    "host": "localhost",
    "user": "user",
    "passwd": "passwd",
    "remote_dir": "/home/niuiic/Documents/projects/nvim/remote.nvim",
    "mount_point": "remote.nvim",
    "options": ["-p", 22]
  },
  {
    "host": "10.10.11.12",
    "user": "user",
    "passwd": "passwd",
    "remote_dir": "/home/niuiic/Documents/projects/nvim/remote2.nvim",
    "mount_point": "remote2.nvim"
  }
]
```

> `remote_dir` and `mount_point` should be directories. `options` will be passed to `sshfs`.

Then you can connect to remote directory with `require("remote").connect()`.

Avaliable functions.

| function    | desc                              |
| ----------- | --------------------------------- |
| connect     | connect to the remote directories |
| disconnect  | disconnect                        |
| reconnect   | reconnect                         |
| edit_config | edit configuration                |
| check_log   | check log file                    |

## Dependencies

- [sshfs](https://github.com/libfuse/sshfs)
- [sshpass](https://sourceforge.net/projects/sshpass)
- umount
- [niuiic/core.nvim](https://github.com/niuiic/core.nvim)

> All dependencies are only required locally.

## Config

Here is the default configuration.

```lua
{
	config_file = ".nvim/remote.json",
	log_file = ".nvim/remote.log",
	unmount = function(path)
		return "umount " .. path
	end,
	disconnect_on_leave = true,
	---@type fun(config: remote.Config)
	on_each_to_connect = function() end,
	---@type fun(config: remote.Config)
	on_each_connected = function() end,
	---@type fun(config: remote.Config)
	on_each_to_disconnect = function() end,
	---@type fun(config: remote.Config)
	on_each_disconnected = function() end,
}

---@class remote.Config
---@field host string
---@field user string
---@field passwd string
---@field remote_dir string
---@field mount_point string
---@field options string[] | nil
```

## Troubleshooting

- Remote directories were not mounted/unmounted correctly

Check log file, sshfs command may failed for some reason.

- Remote directories were not updated

Check the document of sshfs.

- Neovim is stuck

Someting wrong with ssh, cancel the task with `<C-c>` and check you configuration.

- Failed to unmount directories

It may not be possiable to unmount the directories if ssh is unable to connect to the remote machine. You can modify the `unmount` option in configuration to force umount and avoid stuck process. (This always require root privileges, so it's an option.)
