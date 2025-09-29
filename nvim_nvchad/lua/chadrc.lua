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
	},
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
-- }

return M
