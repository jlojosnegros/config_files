-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "catppuccin",
  transparency = false,

	hl_override = {
		Comment = { italic = true },
		["@comment"] = { italic = true },

    -- Split separators más visibles
    WinSeparator = { fg = "light_grey", bg = "NONE" },  -- Separadores de ventana
    VertSplit = { fg = "light_grey", bg = "NONE" },     -- Separadores verticales (fallback)

    -- Bordes de ventanas flotantes más visibles
    FloatBorder = { fg = "nord_blue", bg = "NONE" },
    NormalFloat = { bg = "darker_black" },

    -- Winbar (breadcrumbs + filename en cada ventana)
    WinBar = { fg = "light_grey", bg = "NONE" },
    WinBarPath = { fg = "blue", bg = "NONE", bold = true },
	},
}

-- M.nvdash = { load_on_startup = true }

-- Deshabilitar tabufline de NvChad porque usamos bufferline.nvim
M.ui = {
  tabufline = {
    enabled = false,
  },
}

return M
