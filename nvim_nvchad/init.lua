vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- === Python 3 provider: habilitarlo y fijar intérprete ===
-- Use el Python del venv para el provider de Neovim
-- Be sure to install thid before:
-- # 1) Asegura Python/pip
-- sudo dnf install -y python3 python3-pip
--
-- # 2)  crea un venv dedicado para Neovim
-- python3 -m venv ~/.venvs/neovim
-- ~/.venvs/neovim/bin/python -m pip install --upgrade pip
-- ~/.venvs/neovim/bin/pip install pynvim
vim.g.loaded_python3_provider = nil  -- anula cualquier "0" que haya puesto NvChad/core
vim.g.python3_host_prog = vim.fn.expand("~/.venvs/neovim/bin/python")

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)

vim.schedule(function()
  if vim.g.loaded_python3_provider == 0 then
    vim.g.loaded_python3_provider = nil
  end
end)
