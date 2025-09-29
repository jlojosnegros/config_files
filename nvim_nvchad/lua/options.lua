require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
--
--
--
local opt = vim.opt

-- Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- Appearence
opt.colorcolumn = "100"
opt.signcolumn = "yes"
-- opt.scrolloff = 30

-- Split separators - Make them more visible
opt.fillchars = {
  vert = "│",      -- Separador vertical más visible
  horiz = "─",     -- Separador horizontal
  horizup = "┴",   -- Conexión horizontal hacia arriba
  horizdown = "┬", -- Conexión horizontal hacia abajo
  vertleft = "┤",  -- Conexión vertical izquierda
  vertright = "├", -- Conexión vertical derecha
  verthoriz = "┼", -- Intersección
}
