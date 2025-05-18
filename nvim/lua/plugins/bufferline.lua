return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = {
		"moll/vim-bbye", -- Para cerrar buffers sin afectar ventanas
		"nvim-tree/nvim-web-devicons", -- Iconos de archivos
	},
	config = function()
		require("bufferline").setup({
			options = {
				-- Configuración básica
				mode = "buffers", -- "buffers" | "tabs"
				themable = true, -- Permite personalizar highlights
				numbers = "none", -- "none" | "ordinal" | "buffer_id" | "both"

				-- Comandos con mouse
				close_command = "Bdelete! %d", -- Cerrar buffer (usa vim-bbye)
				right_mouse_command = "Bdelete! %d", -- Clic derecho = cerrar
				left_mouse_command = "buffer %d", -- Clic izquierdo = cambiar buffer
				middle_mouse_command = nil, -- Clic medio = nada (puede configurarse)

				-- Iconos
				buffer_close_icon = "󰅖", -- Icono para cerrar buffers
				modified_icon = "●", -- Icono para buffers modificados
				close_icon = "", -- Icono de cierre general
				left_trunc_marker = "", -- Marcador de truncamiento izquierdo
				right_trunc_marker = "", -- Marcador de truncamiento derecho

				-- Visualización
				max_name_length = 30, -- Longitud máxima del nombre
				max_prefix_length = 30, -- Prefijo para buffers duplicados
				tab_size = 21, -- Ancho de cada pestaña
				color_icons = true, -- Iconos con color según tipo de archivo
				show_buffer_icons = true, -- Mostrar iconos de buffers
				show_buffer_close_icons = true, -- Mostrar íconos de cierre
				show_close_icon = true, -- Mostrar ícono de cierre general

				-- Comportamiento
				persist_buffer_sort = true, -- Mantener orden personalizado
				separator_style = { "│", "│" }, -- Estilo del separador: "thick" | "thin" | "slant"
				enforce_regular_tabs = true, -- Forzar tamaño regular
				always_show_bufferline = true, -- Mostrar siempre (incluso con 1 buffer)
				sort_by = "insert_at_end", -- "id" | "extension" | "directory" | "insert_after_current"

				-- Diagnósticos (LSP)
				diagnostics = "nvim_lsp", -- "nvim_lsp" | "coc"
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local icon = level:match("error") and " " or " "
					return icon .. count
				end,

				-- Grupos de buffers
				groups = {
					items = {
						require("bufferline.groups").builtin.pinned:with({ icon = "" }), -- Buffers anclados
						{
							name = "Tests",
							matcher = function(buf)
								return buf.name:match("%_test")
							end,
						}, -- Archivos de test
						require("bufferline.groups").builtin.ungrouped, -- Resto de buffers
					},
				},

				-- Pestañas especiales
				custom_areas = {
					right = function()
						return {
							{ text = " " .. os.date("%H:%M") }, -- Reloj en la esquina derecha
						}
					end,
				},
			},

			-- Personalización de colores
			highlights = {
				buffer_selected = {
					bold = true,
					italic = false,
				},
				separator = {
					fg = "#434C5E",
					bg = "NONE",
				},
				indicator_selected = {
					fg = "#8FBCBB",
				},
			},
		})

		-- Atajos de teclado
		local map = vim.keymap.set
		local opts = { noremap = true, silent = true }

		-- Navegación básica
		map("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", opts)
		map("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", opts)

		-- Acceso rápido a buffers (1-9)
		for i = 1, 9 do
			map("n", "<leader>" .. i, function()
				require("bufferline").go_to_buffer(i)
			end, opts)
		end

		-- Comandos útiles
		map("n", "<leader>bp", "<Cmd>BufferLinePick<CR>", { desc = "Seleccionar buffer interactivo" })
		map("n", "<leader>bc", "<Cmd>BufferLinePickClose<CR>", { desc = "Cerrar buffer seleccionado" })
		map("n", "<leader>bt", "<Cmd>BufferLineTogglePin<CR>", { desc = "Anclar/desanclar buffer" })
		map("n", "<leader>b]", "<Cmd>BufferLineMoveNext<CR>", { desc = "Mover buffer a la derecha" })
		map("n", "<leader>b[", "<Cmd>BufferLineMovePrev<CR>", { desc = "Mover buffer a la izquierda" })

		-- Navegación alternativa
		map("n", "<leader>bn", "<Cmd>BufferLineCycleNext<CR>", { desc = "Siguiente buffer" })
		map("n", "<leader>bp", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Buffer anterior" })
	end,
}
