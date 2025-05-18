return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	version = "^3.5.0", -- Especifica versión compatible
	event = "BufReadPost",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		-- Configuración básica de indentación (obligatoria)
		indent = {
			char = "│", -- Carácter: '│', '▏', '┊', '⏐'
			tab_char = "│",
			highlight = "IblIndent",
			smart_indent_cap = true,
		},

		-- Configuración opcional de scope
		scope = {
			enabled = true,
			show_start = true,
			show_end = false,
			highlight = "IblScope",
			char = "┊",
			-- Configuración avanzada de scope como tabla
			include = {
				node_type = {
					["*"] = {
						"class",
						"function",
						"method",
						"block",
					},
				},
			},
		},

		-- Exclusión de archivos (formato correcto)
		exclude = {
			filetypes = {
				"help",
				"dashboard",
				"neo-tree",
				"Trouble",
				"lazy",
				"mason",
				"toggleterm",
				"alpha",
			},
			buftypes = {
				"terminal",
				"nofile",
				"quickfix",
				"prompt",
			},
		},
	},
	config = function(_, opts)
		-- 1. Configurar highlights personalizados (seguro)
		vim.api.nvim_set_hl(0, "IblIndent", { fg = "#4B5263", nocombine = true })
		vim.api.nvim_set_hl(0, "IblScope", { fg = "#5C6370", nocombine = true })

		-- 2. Aplicar configuración con validación
		local ok, ibl = pcall(require, "ibl")
		if not ok then
			vim.notify("Error cargando indent-blankline.nvim", vim.log.levels.ERROR)
			return
		end

		ibl.setup(opts)

		-- 3. Comando toggle mejorado
		vim.api.nvim_create_user_command("IBLToggle", function()
			vim.g.indent_blankline_enabled = not vim.g.indent_blankline_enabled
			ibl.setup({ enabled = vim.g.indent_blankline_enabled })
			vim.notify("Indent guides " .. (vim.g.indent_blankline_enabled and "ON" or "OFF"))
		end, { desc = "Toggle indent guides" })
	end,
}
