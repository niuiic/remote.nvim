# remote.nvim

Edit remote files with local neovim configuration.

**Edit them as local directories.**

**No other dependencies required for remote machine except ssh.**

## Usage

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

Then you can connect to remote directory with `require("remote").connect()`.

Avaliable functions.

| function    | desc                              |
| ----------- | --------------------------------- |
| connect     | connect to the remote directories |
| disconnect  | disconnect                        |
| reconnect   | reconnect                         |
| edit_config | edit configuration                |

## Dependencies

- [sshfs](https://github.com/libfuse/sshfs)
- [sshpass](https://sourceforge.net/projects/sshpass)
- [niuiic/core.nvim](https://github.com/niuiic/core.nvim)

> All dependencies are only required locally.

## Config

Here is the default configuration.

```lua
{
	config_file = ".nvim/remote.json",
	log_file = ".nvim/remote.log",
	disconnect_on_leave = true,
	remove_mount_point_on_disconnect = true,
}
```

## Troubleshooting

- Remote directories were not mounted/unmounted correctly

Check log file, sshfs command may failed for some reason.

- Remote directories were not updated

Check the document of sshfs.
