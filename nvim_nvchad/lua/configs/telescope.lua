-- ~/.config/nvim/lua/configs/telescope.lua
-- Configuración personalizada de Telescope

local options = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden", -- Mostrar archivos ocultos
      "--glob=!.git/", -- Pero excluir .git
    },
  },

  pickers = {
    find_files = {
      hidden = true, -- Mostrar archivos ocultos
      find_command = {
        "rg",
        "--files",
        "--hidden",
        "--glob=!.git/", -- Excluir .git
      },
    },
    live_grep = {
      additional_args = function()
        return { "--hidden", "--glob=!.git/" }
      end,
    },
  },
}

return options
