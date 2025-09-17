require "nvchad.mappings"

-- add yours here

-- ~/.config/nvim/lua/mappings.lua
-- Mapa de teclas unificado para Telescope, Git, Formato, Lint, LSP y DAP.
-- Evita conflictos con NvChad usando prefijos: s (search), g (git), c (code).

local map = vim.keymap.set
local opt = function(desc) return { silent = true, noremap = true, desc = desc } end

-- ========= Which-key: registrar grupos (si está disponible) =========
do
  local ok, wk = pcall(require, "which-key")
  if ok and wk.add then
    wk.add({
      { "<leader>s", group = "Search (Telescope)" },
      { "<leader>g", group = "Git" },
      { "<leader>c", group = "Code" },
      { "<leader>d", group = "Debug (DAP)" },
      { "<leader>p", group = "Profiles" },
    })
  elseif ok and wk.register then
    wk.register({
      s = { name = "Search (Telescope)" },
      g = { name = "Git" },
      c = { name = "Code" },
      d = { name = "Debug (DAP)" },
      p = { name = "Profiles" },
    }, { prefix = "<leader>" })
  end
end

-- ========= Telescope =========
local function tb(fn, opts)
  return function()
    local ok, builtin = pcall(require, "telescope.builtin")
    if not ok then return vim.notify("Telescope no cargado", vim.log.levels.WARN) end
    builtin[fn](opts or {})
  end
end

map("n", "<leader>sf", tb("find_files"),   opt("Buscar archivos"))
map("n", "<leader>sg", tb("live_grep"),    opt("Grep en el proyecto"))
map("n", "<leader>sb", tb("buffers"),      opt("Buffers"))
map("n", "<leader>sh", tb("help_tags"),    opt("Ayuda"))
map("n", "<leader>sk", tb("keymaps"),      opt("Keymaps"))
map("n", "<leader>so", tb("oldfiles"),     opt("Archivos recientes"))
map("n", "<leader>sc", tb("commands"),     opt("Comandos"))
map("n", "<leader>sd", tb("diagnostics", { bufnr = 0 }), opt("Diag. del buffer"))
map("n", "<leader>sD", tb("diagnostics"),              opt("Diag. del workspace"))
-- LSP pickers útiles (si hay servidor activo):
map("n", "<leader>sr", tb("lsp_references"), opt("LSP Referencias"))
map("n", "<leader>ss", tb("lsp_document_symbols"), opt("Símbolos del buffer"))
map("n", "<leader>sS", tb("lsp_workspace_symbols"), opt("Símbolos del workspace"))

-- ========= Git (Telescope + Gitsigns) =========
map("n", "<leader>gs", tb("git_status"),   opt("Git status (Telescope)"))
map("n", "<leader>gc", tb("git_commits"),  opt("Commits (Telescope)"))
map("n", "<leader>gC", tb("git_bcommits"), opt("Commits del buffer"))
map("n", "<leader>gb", tb("git_branches"), opt("Branches"))
map("n", "<leader>gS", function()
  local ok, gs = pcall(require, "gitsigns")
  if ok then gs.stage_hunk() else vim.notify("gitsigns no cargado", vim.log.levels.WARN) end
end, opt("Stage hunk"))
map("v", "<leader>gS", function()
  local ok, gs = pcall(require, "gitsigns")
  if ok then gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
  else vim.notify("gitsigns no cargado", vim.log.levels.WARN) end
end, opt("Stage hunk (selección)"))
map("n", "<leader>gR", function()
  local ok, gs = pcall(require, "gitsigns")
  if ok then gs.reset_hunk() else vim.notify("gitsigns no cargado", vim.log.levels.WARN) end
end, opt("Reset hunk"))
map("n", "<leader>gP", function()
  local ok, gs = pcall(require, "gitsigns")
  if ok then gs.preview_hunk() else vim.notify("gitsigns no cargado", vim.log.levels.WARN) end
end, opt("Preview hunk"))
map("n", "<leader>gB", function()
  local ok, gs = pcall(require, "gitsigns")
  if ok then gs.blame_line({ full = true }) else vim.notify("gitsigns no cargado", vim.log.levels.WARN) end
end, opt("Blame línea"))
map("n", "<leader>gd", function()
  local ok, gs = pcall(require, "gitsigns")
  if ok then gs.diffthis() else vim.notify("gitsigns no cargado", vim.log.levels.WARN) end
end, opt("Diff contra HEAD"))
map("n", "]h", function()
  local ok, gs = pcall(require, "gitsigns")
  if ok then gs.next_hunk() else vim.notify("gitsigns no cargado", vim.log.levels.WARN) end
end, opt("Siguiente hunk"))
map("n", "[h", function()
  local ok, gs = pcall(require, "gitsigns")
  if ok then gs.prev_hunk() else vim.notify("gitsigns no cargado", vim.log.levels.WARN) end
end, opt("Hunk anterior"))

-- ========= Code (LSP, Formato, Lint, Diags) =========
-- LSP básicos
map("n", "K",  vim.lsp.buf.hover,        opt("LSP: Hover"))
map("n", "gd", vim.lsp.buf.definition,   opt("LSP: Ir a definición"))
map("n", "gD", vim.lsp.buf.declaration,  opt("LSP: Ir a declaración"))
map("n", "gi", vim.lsp.buf.implementation, opt("LSP: Implementaciones"))
map("n", "gr", vim.lsp.buf.references,   opt("LSP: Referencias"))
map("n", "<leader>cr", vim.lsp.buf.rename,     opt("LSP: Rename"))
map("n", "<leader>ca", vim.lsp.buf.code_action, opt("LSP: Code action"))

-- Formato (Conform)
map("n", "<leader>cf", function()
  local ok, conform = pcall(require, "conform")
  if not ok then return vim.notify("conform.nvim no cargado", vim.log.levels.WARN) end
  conform.format({ lsp_fallback = true, async = false, timeout_ms = 2000 })
end, opt("Formatear buffer"))

-- Toggle "format on save" por buffer (si quieres activarlo puntualmente)
map("n", "<leader>cF", function()
  -- Usa una variable de buffer para decidir si formatear al guardar
  vim.b.enable_format_on_save = not vim.b.enable_format_on_save
  local state = vim.b.enable_format_on_save and "ON" or "OFF"
  vim.notify("Format on save: " .. state)
end, opt("Toggle format on save (buffer)"))

-- Autocmd local para respetar el toggle
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    if vim.b.enable_format_on_save then
      local ok, conform = pcall(require, "conform")
      if ok then
        conform.format({ bufnr = args.buf, lsp_fallback = true, timeout_ms = 1000 })
      end
    end
  end,
})

-- Lint (nvim-lint)
map("n", "<leader>cl", function()
  local ok, lint = pcall(require, "lint")
  if not ok then return vim.notify("nvim-lint no cargado", vim.log.levels.WARN) end
  lint.try_lint()
end, opt("Lanzar linter"))
map("n", "<leader>cL", function()
  vim.diagnostic.setloclist({ open = true })
end, opt("Abrir lista de diagnósticos"))

-- Diagnósticos navegación
map("n", "]d", vim.diagnostic.goto_next, opt("Siguiente diagnóstico"))
map("n", "[d", vim.diagnostic.goto_prev, opt("Diagnóstico anterior"))
map("n", "<leader>cd", vim.diagnostic.open_float, opt("Mensajes de la línea"))

-- ========= DAP (ya tienes F5/F10/F11/F12 + <leader>db / <leader>du) =========
-- Añadimos algunos atajos complementarios:
map("n", "<leader>dr", function() require("dap").repl.toggle() end, opt("DAP: Toggle REPL"))
map("n", "<leader>dk", function() require("dap").up() end,       opt("DAP: Stack up"))
map("n", "<leader>dj", function() require("dap").down() end,     opt("DAP: Stack down"))



local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
