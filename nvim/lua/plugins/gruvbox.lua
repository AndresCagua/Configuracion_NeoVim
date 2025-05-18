return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    -- Opciones de gruvbox (modularizadas)
    local opts = {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = "hard", -- Aquí defines el contraste
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    }

    -- Aplica la configuración
    require("gruvbox").setup(opts)

    -- Establece el colorscheme y fondo
    vim.o.background = "dark" -- o "light" para modo claro
    vim.cmd("colorscheme gruvbox")
  end,
}
