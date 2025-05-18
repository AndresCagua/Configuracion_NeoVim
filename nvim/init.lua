-- Instalación de lazy.nvim (sintaxis corregida)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then -- Usa vim.loop.fs_stat
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Configuración de plugins
--local opts = {}  -- Opciones de lazy.nvim
require("vim-options")
require("lazy").setup("plugins") -- Función corregida (setup, no setup_plugins)

-- Function to check if a file exists
local function file_exists(file)
	local f = io.open(file, "r")
	if f then
		f:close()
		return true
	else
		return false
	end
end

-- Path to the session file
local session_file = ".session.vim"

-- Check if the session file exists in the current directory
if file_exists(session_file) then
	-- Source the session file
	vim.cmd("source " .. session_file)
end
