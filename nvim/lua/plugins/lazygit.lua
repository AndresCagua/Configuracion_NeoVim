return {
	"kdheepak/lazygit.nvim",
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		{
			"<leader>gg",
			function()
				-- Verificación mejorada del PATH para ZSH
				local lazygit_path = vim.fn.trim(vim.fn.system('zsh -c "which lazygit"'))
				if lazygit_path ~= "" and vim.fn.executable(lazygit_path) == 1 then
					vim.g.lazygit_binary_path = lazygit_path
					vim.cmd("LazyGit")
					vim.cmd("hi LazyGitFloat guibg=NONE guifg=NONE")
					vim.cmd("setlocal winhl=NormalFloat:LazyGitFloat")
				else
					vim.notify("lazygit no encontrado. Verifica tu instalación.", vim.log.levels.ERROR)
					print("\nSolución para ZSH users:")
					print("1. Añade esto a tu ~/.zshrc:")
					print("   export PATH=$PATH:$HOME/go/bin")
					print("2. Ejecuta: source ~/.zshrc")
					print("3. Verifica con: which lazygit")
				end
			end,
			desc = "LazyGit (root dir)",
		},
		{
			"<leader>gc",
			function()
				if vim.fn.executable(vim.g.lazygit_binary_path or "lazygit") == 1 then
					vim.cmd("LazyGitCurrentFile")
				end
			end,
			desc = "LazyGit (current file)",
		},
		{ "<leader>gf", "<cmd>LazyGitFilter<cr>",            desc = "LazyGit (filter)" },
		{ "<leader>gF", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit (filter current file)" },
		{ "<leader>gl", "<cmd>LazyGitLog<cr>",               desc = "LazyGit (log)" },
	},
	config = function()
		-- Configuración mejorada del PATH
		local lazygit_path = vim.fn.trim(vim.fn.system('zsh -c "which lazygit"'))
		if lazygit_path ~= "" and vim.fn.executable(lazygit_path) == 1 then
			vim.g.lazygit_binary_path = lazygit_path
		else
			-- Ruta por defecto común para instalaciones con Go
			local default_path = "/home/andres/go/bin/lazygit"
			if vim.fn.executable(default_path) == 1 then
				vim.g.lazygit_binary_path = default_path
			else
				vim.notify("lazygit no encontrado. Algunas funciones no estarán disponibles.", vim.log.levels.WARN)
			end
		end

		-- Configuración de ventana flotante
		vim.g.lazygit_floating_window_winblend = 5
		vim.g.lazygit_floating_window_scaling_factor = 0.9
		vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
		vim.g.lazygit_floating_window_use_plenary = 1

		-- Comportamiento
		vim.g.lazygit_use_neovim_remote = 1
		vim.g.lazygit_use_custom_config_file_path = 0
		vim.g.lazygit_config_file_path = ""
		vim.g.lazygit_dont_attach_to_default_keymaps = 1
		vim.g.lazygit_close_on_exit = 1

		-- Integración con Telescope
		if pcall(require, "telescope") then
			require("telescope").load_extension("lazygit")
		end

		-- Autocomandos mejorados
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "lazygit",
			callback = function()
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false
				vim.opt_local.winhl = "NormalFloat:LazyGitFloat"

				-- Keymaps dentro de lazygit
				vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, desc = "Close LazyGit" })
				vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = true })
			end,
		})

		-- Comandos personalizados
		vim.api.nvim_create_user_command("LazyGitLog", function()
			if vim.fn.executable(vim.g.lazygit_binary_path or "lazygit") == 1 then
				vim.cmd("LazyGit --log")
			end
		end, { desc = "Open LazyGit log view" })

		-- Highlight personalizado
		vim.api.nvim_set_hl(0, "LazyGitFloat", { bg = "NONE" })

		-- Comando para verificar instalación
		vim.api.nvim_create_user_command("LazyGitCheck", function()
			local path = vim.g.lazygit_binary_path or "lazygit"
			if vim.fn.executable(path) == 1 then
				print("lazygit encontrado en: " .. path)
				print("Versión: " .. vim.fn.trim(vim.fn.system(path .. " --version")))
			else
				print("lazygit NO encontrado. Ruta probada: " .. path)
			end
		end, { desc = "Check lazygit installation" })
	end,
}

