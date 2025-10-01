-- Plugins para mejorar la navegación y visualización de buffers
return {
  -- Bufferline: Mejor visualización de buffers en la parte superior
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        -- Mostrar números de buffer para saltar rápido con <leader>1-9
        numbers = function(opts)
          return string.format("%s", opts.ordinal)
        end,
        -- Mostrar diagnósticos LSP en los buffers
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        -- Separador visual entre buffers
        separator_style = "slant", -- "slant", "thick", "thin", "padded_slant"
        -- Mostrar iconos de cerrar
        show_buffer_close_icons = true,
        show_close_icon = false,
        -- Agrupar buffers por directorio cuando hay nombres duplicados
        show_buffer_icons = true,
        show_duplicate_prefix = true,
        -- Colores para indicar buffers modificados
        modified_icon = "●",
        -- Offsets para nvim-tree u otros sidebars
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
        },
        -- Hover para mostrar ruta completa
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Los keymaps se definen en lua/mappings.lua para mantener todo centralizado
    end,
  },

  -- Navic: Breadcrumbs de contexto LSP
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = {
      separator = " > ",
      highlight = true,
      depth_limit = 5,
      icons = {
        File = " ",
        Module = " ",
        Namespace = " ",
        Package = " ",
        Class = " ",
        Method = " ",
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = " ",
        Interface = " ",
        Function = " ",
        Variable = " ",
        Constant = " ",
        String = " ",
        Number = " ",
        Boolean = " ",
        Array = " ",
        Object = " ",
        Key = " ",
        Null = " ",
        EnumMember = " ",
        Struct = " ",
        Event = " ",
        Operator = " ",
        TypeParameter = " ",
      },
    },
  },

  -- Navbuddy: Navegador visual de símbolos LSP
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
    event = "LspAttach",
    opts = {
      lsp = { auto_attach = true },
      window = {
        border = "rounded",
        size = "60%",
      },
      -- Iconos (usa los mismos de navic)
      use_default_mappings = true,
    },
    keys = {
      {
        "<leader>cn",
        function()
          require("nvim-navbuddy").open()
        end,
        desc = "Abrir Navbuddy (navegador de símbolos)",
      },
    },
  },
}
