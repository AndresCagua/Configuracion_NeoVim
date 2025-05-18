return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" }, -- Carga solo cuando se necesita
	dependencies = {
		"nvim-lua/plenary.nvim", -- Necesario para funciones asíncronas
	},
	opts = {
		-- Configuración de signos en el gutter
		signs = {
			add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
			change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
			delete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
			topdelete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
			changedelete = {
				hl = "GitSignsChange",
				text = "▎",
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
			untracked = { hl = "GitSignsAdd", text = "┆", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		},

		-- Configuración para cambios staged
		signs_staged = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "┆" },
		},

		-- Opciones de visualización
		signcolumn = true, -- Mostrar columna de signos siempre
		numhl = false, -- Usar number highlight
		linehl = false, -- No usar line highlight por defecto
		watch_gitdir = {
			interval = 1000,
			follow_files = true,
		},
		attach_to_untracked = true,
		current_line_blame = false, -- Puede activarse con toggle
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			delay = 1000,
			ignore_whitespace = false,
		},
		current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil, -- Usar formateador por defecto
		max_file_length = 40000,
		preview_config = {
			border = "single",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},

		-- Mapeos recomendados (se pueden personalizar)
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			-- Navegación entre cambios
			vim.keymap.set("n", "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, buffer = bufnr, desc = "Next git hunk" })

			vim.keymap.set("n", "[c", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, buffer = bufnr, desc = "Previous git hunk" })

			-- Acciones
			vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
			vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
			vim.keymap.set("v", "<leader>hs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { buffer = bufnr, desc = "Stage visual selection" })
			vim.keymap.set("v", "<leader>hr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { buffer = bufnr, desc = "Reset visual selection" })
			vim.keymap.set("n", "<leader>hS", gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
			vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo stage hunk" })
			vim.keymap.set("n", "<leader>hR", gs.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
			vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
			vim.keymap.set("n", "<leader>hb", function()
				gs.blame_line({ full = true })
			end, { buffer = bufnr, desc = "Blame line" })
			vim.keymap.set(
				"n",
				"<leader>tb",
				gs.toggle_current_line_blame,
				{ buffer = bufnr, desc = "Toggle line blame" }
			)
			vim.keymap.set("n", "<leader>hd", gs.diffthis, { buffer = bufnr, desc = "Diff against index" })
			vim.keymap.set("n", "<leader>hD", function()
				gs.diffthis("~")
			end, { buffer = bufnr, desc = "Diff against last commit" })
			vim.keymap.set("n", "<leader>td", gs.toggle_deleted, { buffer = bufnr, desc = "Toggle deleted" })

			-- Text object
			vim.keymap.set(
				{ "o", "x" },
				"ih",
				":<C-U>Gitsigns select_hunk<CR>",
				{ buffer = bufnr, desc = "Git hunk text object" }
			)
		end,
	},
	config = function(_, opts)
		-- Definir highlights personalizados
		vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#98C379", bg = "NONE" })
		vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#E5C07B", bg = "NONE" })
		vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#E06C75", bg = "NONE" })

		-- Cargar y configurar gitsigns
		require("gitsigns").setup(opts)

		-- Comandos personalizados
		vim.api.nvim_create_user_command("GitsignsToggle", function()
			require("gitsigns").toggle_signs()
			vim.notify("GitSigns " .. (require("gitsigns").get_config().signs and "enabled" or "disabled"))
		end, { desc = "Toggle git signs" })
	end,
}
