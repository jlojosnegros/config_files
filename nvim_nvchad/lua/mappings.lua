-- ~/.config/nvim/lua/mappings.lua
require "nvchad.mappings"

-- add yours here

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
map("n", "<leader>sD", tb("diagnostics"),               opt("Diag. del workspace"))
-- LSP pickers útiles (si hay servidor activo):
map("n", "<leader>sr", tb("lsp_references"),        opt("LSP Referencias"))
map("n", "<leader>ss", tb("lsp_document_symbols"),  opt("Símbolos del buffer"))
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

-- LazyGit en ventana flotante desde la raíz del repositorio
map("n", "<leader>lg", function()
  -- Buscar la raíz del repositorio git
  local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  if vim.v.shell_error ~= 0 then
    vim.notify("No estás en un repositorio git", vim.log.levels.WARN)
    return
  end

  -- Configuración de la ventana flotante
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Crear buffer para el terminal
  local buf = vim.api.nvim_create_buf(false, true)

  -- Configurar opciones del buffer
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "filetype", "lazygit")

  -- Crear ventana flotante
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " LazyGit ",
    title_pos = "center"
  })

  -- Configurar opciones de la ventana
  vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal,FloatBorder:FloatBorder")

  -- Comando para ejecutar lazygit
  local cmd = string.format("cd '%s' && lazygit", git_root)

  -- Ejecutar lazygit en el terminal flotante
  vim.fn.termopen(cmd, {
    on_exit = function()
      -- Cerrar la ventana cuando lazygit termine
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end
  })

  -- Entrar en modo terminal automáticamente
  vim.cmd("startinsert")

  -- Keymap para cerrar con Esc en modo normal dentro del terminal
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { silent = true, noremap = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { silent = true, noremap = true })
end, opt("Abrir LazyGit (flotante)"))
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
map("n", "K",  vim.lsp.buf.hover,           opt("LSP: Hover"))
map("n", "gd", vim.lsp.buf.definition,      opt("LSP: Ir a definición"))
map("n", "gD", vim.lsp.buf.declaration,     opt("LSP: Ir a declaración"))
map("n", "gi", vim.lsp.buf.implementation,  opt("LSP: Implementaciones"))
map("n", "gr", vim.lsp.buf.references,      opt("LSP: Referencias"))
map("n", "<leader>cr", vim.lsp.buf.rename,       opt("LSP: Rename"))
map("n", "<leader>ca", vim.lsp.buf.code_action,  opt("LSP: Code action"))

-- Formato (Conform) - buffer completo (modo normal)
map("n", "<leader>cf", function()
  local ok, conform = pcall(require, "conform")
  if not ok then return vim.notify("conform.nvim no cargado", vim.log.levels.WARN) end
  conform.format({ lsp_fallback = true, async = false, timeout_ms = 2000 })
end, opt("Formatear buffer"))

-- === Formato de selección robusto (visual) =====================
local function format_visual_range()
  -- Obtiene marcas de selección visual
  local s = vim.fn.getpos("'<") -- {bufnum, lnum, col, off}
  local e = vim.fn.getpos("'>")

  local s_line = math.max(s[2] - 1, 0)
  local s_char = math.max(s[3] - 1, 0)
  local e_line = math.max(e[2] - 1, 0)
  local e_char = math.max(e[3] - 1, 0)

  -- Selección invertida -> normalizar
  if (e_line < s_line) or (e_line == s_line and e_char < s_char) then
    s_line, e_line = e_line, s_line
    s_char, e_char = e_char, s_char
  end

  -- Detecta modo visual para ajustar columnas
  local vmode = vim.fn.visualmode()  -- 'v' (car), 'V' (línea), or Ctrl-V (bloque)
  if vmode == "V" or vmode == "\022" then
    -- En selección por líneas o bloque, formatea líneas completas
    s_char = 0
    e_char = 1e9
  else
    -- Asegurar que las columnas están dentro del rango de la línea
    local buf = 0
    local s_txt = vim.api.nvim_buf_get_lines(buf, s_line, s_line + 1, true)[1] or ""
    local e_txt = vim.api.nvim_buf_get_lines(buf, e_line, e_line + 1, true)[1] or ""
    local s_max = math.max(vim.fn.strchars(s_txt), 0)
    local e_max = math.max(vim.fn.strchars(e_txt), 0)
    if s_char > s_max then s_char = s_max end
    if e_char > e_max then e_char = e_max end
  end

  local range_tbl = {
    start = { line = s_line, character = s_char },
    ["end"] = { line = e_line, character = e_char },
  }

  -- 1) Intenta Conform con rango
  local ok_conform, conform = pcall(require, "conform")
  if ok_conform then
    local ok_run, err = pcall(function()
      conform.format({
        lsp_fallback = true,
        timeout_ms = 2000,
        range = range_tbl,
      })
    end)
    if ok_run then return end
    -- Si Conform falló por rango, cae a LSP
    vim.notify("Conform (rango) falló, usando LSP: " .. tostring(err), vim.log.levels.DEBUG)
  end

  -- 2) Fallback a LSP range-format
  local ok_lsp = pcall(vim.lsp.buf.format, {
    timeout_ms = 2000,
    range = range_tbl,
  })
  if not ok_lsp then
    vim.notify("No se pudo formatear el rango (Conform y LSP fallaron)", vim.log.levels.WARN)
  end
end

-- Visual mode: <leader>cf -> formatear solo la selección
vim.keymap.set("v", "<leader>cf", format_visual_range, { silent = true, desc = "Formatear selección" })


-- === Toggles para format-on-save (Conform respeta estos flags en su opts.format_on_save) ===
map("n", "<leader>cF", function()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
  vim.notify("Format on save (buffer): " .. (vim.b.disable_autoformat and "OFF" or "ON"))
end, opt("Toggle format on save (buffer)"))

map("n", "<leader>cG", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify("Format on save (global): " .. (vim.g.disable_autoformat and "OFF" or "ON"))
end, opt("Toggle format on save (global)"))

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
map("n", "<leader>dr", function() require("dap").repl.toggle() end, opt("DAP: Toggle REPL"))
map("n", "<leader>dk", function() require("dap").up() end,       opt("DAP: Stack up"))
map("n", "<leader>dj", function() require("dap").down() end,     opt("DAP: Stack down"))

-- ==== extras que tenías al final ====
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- ===================================================================
-- =================== AÑADIDOS DE NAVEGACIÓN ========================
-- ===================================================================

-- which-key: añade grupos nuevos (Buffers / Jumps) SIN tocar lo anterior
do
  local ok, wk = pcall(require, "which-key")
  if ok and wk.add then
    wk.add({
      { "<leader>b", group = "Buffers" },
      { "<leader>j", group = "Jumps" },
    })
  elseif ok and wk.register then
    wk.register({
      b = { name = "Buffers" },
      j = { name = "Jumps" },
    }, { prefix = "<leader>" })
  end
end

-- Buffers
map("n", "<leader>bn", ":bnext<CR>",         opt("Siguiente buffer"))
map("n", "<leader>bp", ":bprevious<CR>",     opt("Buffer anterior"))
map("n", "<leader>bd", ":bdelete<CR>",       opt("Cerrar buffer actual"))
map("n", "<leader>bo", ":%bd|e#|bd#<CR>",    opt("Cerrar otros buffers (deja el actual)"))
map("n", "<leader>bb", "<C-^>",              opt("Alternar con último buffer"))

-- Jumps (jumplist)
map("n", "<leader>jb", "<C-o>",              opt("Volver (jumplist back)"))
map("n", "<leader>jf", "<C-i>",              opt("Adelante (jumplist fwd)"))
map("n", "<leader>jj", tb("jumplist"),       opt("Ver jumplist (Telescope)"))

-- LSP con “memoria”: guarda la posición previa y luego salta
local function with_prev_mark(fn)
  return function(...)
    pcall(vim.cmd, "normal! m'") -- mark ' = posición previa
    return fn(...)
  end
end
map("n", "<leader>jd", with_prev_mark(vim.lsp.buf.definition),     opt("Ir a definición (guardar vuelta)"))
map("n", "<leader>jD", with_prev_mark(vim.lsp.buf.declaration),    opt("Ir a declaración (guardar vuelta)"))
map("n", "<leader>ji", with_prev_mark(vim.lsp.buf.implementation), opt("Ir a implementación (guardar vuelta)"))
map("n", "<leader>jt", with_prev_mark(vim.lsp.buf.type_definition),opt("Ir a type definition (guardar vuelta)"))

-- Centrar la línea actual en la ventana (no mueve el cursor en el archivo)
map("n", "<leader>zm", "zz",                 opt("Centrar línea (middle)"))
map("n", "<leader>zt", "zt",                 opt("Línea arriba (top)"))
map("n", "<leader>zb", "zb",                 opt("Línea abajo (bottom)"))
