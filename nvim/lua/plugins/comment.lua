return {
	"numToStr/Comment.nvim",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring", -- Opcional: para comentarios contextuales
	},
	keys = { -- Definición de keymaps (mejor práctica)
		{ "<C-/>", mode = { "n", "v" }, desc = "Toggle comment" },
		{ "<C-_>", mode = { "n", "v" }, desc = "Toggle comment (alternative)" },
		{ "<leader>co", mode = { "n", "v" }, desc = "Toggle comment" },
		{ "<leader>bo", mode = { "n" }, desc = "Toggle block comment" },
	},
	config = function()
		local comment = require("Comment")

		-- Configuración principal
		comment.setup({
			-- Añade espacio después del símbolo de comentario
			padding = true,

			-- Si el cursor debería permanecer en su posición
			sticky = true,

			-- Líneas a ignorar cuando se comenta (regex)
			ignore = "^$",

			-- Configuración de keymaps básicos (pueden ser sobrescritos)
			mappings = {
				basic = true, -- Mapeos básicos (gcc, gbc, etc.)
				extra = false, -- Mapeos extra (no los usaremos)
			},

			-- Integración con treesitter (para comentarios contextuales)
			pre_hook = function(ctx)
				local U = require("Comment.utils")

				-- Determina si es un comentario de línea o de bloque
				local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"

				-- Para integración con nvim-ts-context-commentstring
				if require("ts_context_commentstring.integrations.comment_nvim").calculate_commentstring then
					return require("ts_context_commentstring.integrations.comment_nvim").pre_hook()
				end

				-- Ubicación del cursor
				local location = nil
				if ctx.ctype == U.ctype.block then
					location = require("ts_context_commentstring.utils").get_cursor_location()
				elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
					location = require("ts_context_commentstring.utils").get_visual_start_location()
				end

				return require("ts_context_commentstring.internal").calculate_commentstring({
					key = type,
					location = location,
				})
			end,
		})

		-- Keymaps personalizados
		local api = require("Comment.api")
		local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)

		-- Modo Normal
		vim.keymap.set("n", "<C-/>", api.toggle.linewise.current, { desc = "Toggle current line comment" })
		vim.keymap.set(
			"n",
			"<C-_>",
			api.toggle.linewise.current,
			{ desc = "Toggle current line comment (alternative)" }
		)
		vim.keymap.set("n", "<leader>c", api.toggle.linewise.current, { desc = "Toggle current line comment" })
		vim.keymap.set("n", "<leader>b", api.toggle.blockwise.current, { desc = "Toggle current block comment" })

		-- Modo Visual
		vim.keymap.set("x", "<C-/>", function()
			vim.api.nvim_feedkeys(esc, "nx", false)
			api.toggle.linewise(vim.fn.visualmode())
		end, { desc = "Toggle visual selection comment" })

		vim.keymap.set("x", "<leader>c", function()
			vim.api.nvim_feedkeys(esc, "nx", false)
			api.toggle.linewise(vim.fn.visualmode())
		end, { desc = "Toggle visual selection comment" })

		vim.keymap.set("x", "<leader>b", function()
			vim.api.nvim_feedkeys(esc, "nx", false)
			api.toggle.blockwise(vim.fn.visualmode())
		end, { desc = "Toggle visual block comment" })

		-- Comandos adicionales
		vim.api.nvim_create_user_command("CommentToggle", api.toggle.linewise.current, {})
		vim.api.nvim_create_user_command("BlockCommentToggle", api.toggle.blockwise.current, {})
	end,
}
