local static = require("remote.static")

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
end

return {
	setup = setup,
}
