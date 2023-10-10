local config = {
	history_file = vim.fn.stdpath("data") .. "/remote-history",
	log_file = vim.fn.stdpath("data") .. "/remote-log",
}

return {
	config = config,
}
