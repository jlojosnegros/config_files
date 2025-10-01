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

-- Winbar: Mostrar breadcrumbs (contexto LSP) + nombre del archivo en cada ventana
vim.api.nvim_create_autocmd({ "BufWinEnter", "CursorHold", "InsertLeave" }, {
  callback = function()
    -- Lista de filetypes donde NO queremos winbar
    local winbar_filetype_exclude = {
      "help",
      "startify",
      "dashboard",
      "lazy",
      "neo-tree",
      "neogitstatus",
      "NvimTree",
      "Trouble",
      "alpha",
      "lir",
      "Outline",
      "spectre_panel",
      "toggleterm",
      "DressingSelect",
      "Jaq",
      "harpoon",
      "dap-repl",
      "dap-terminal",
      "dapui_console",
      "dapui_hover",
      "lab",
      "notify",
      "noice",
      "neotest-summary",
      "TelescopePrompt",
      "TelescopeResults",
      "",
    }

    -- No actualizar winbar en ventanas flotantes o pequeñas
    if vim.api.nvim_win_get_config(0).relative ~= "" then
      return
    end

    -- No actualizar si la ventana es muy pequeña
    if vim.api.nvim_win_get_height(0) < 3 then
      return
    end

    if vim.tbl_contains(winbar_filetype_exclude, vim.bo.filetype) then
      vim.wo.winbar = nil
      return
    end

    local file_path = vim.api.nvim_eval_statusline("%f", {}).str
    local modified = vim.bo.modified and " ●" or ""

    -- Intentar obtener breadcrumbs de navic si está disponible
    local ok, navic = pcall(require, "nvim-navic")
    local location = ""
    if ok and navic.is_available() then
      location = navic.get_location()
      if location ~= "" then
        location = location .. " │ "
      end
    end

    vim.wo.winbar = "%#WinBar#" .. location .. "%#WinBarPath#" .. file_path .. modified
  end,
})
