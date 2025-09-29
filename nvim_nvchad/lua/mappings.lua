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
map("n", "<leader>bl", tb("buffers"),      opt("Buffers"))
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

-- which-key: añade grupos nuevos (Buffers / Jumps / Windows / Tabs / Diff) SIN tocar lo anterior
do
  local ok, wk = pcall(require, "which-key")
  if ok and wk.add then
    wk.add({
      { "<leader>b", group = "Buffers" },
      { "<leader>j", group = "Jumps" },
      { "<leader>w", group = "Windows" },
      { "<leader>t", group = "Tabs" },
      { "<leader>D", group = "Diff" },
    })
  elseif ok and wk.register then
    wk.register({
      b = { name = "Buffers" },
      j = { name = "Jumps" },
      w = { name = "Windows" },
      t = { name = "Tabs" },
      D = { name = "Diff" },
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

-- ===================================================================
-- ================== GESTIÓN DE VENTANAS (SPLITS) ==================
-- ===================================================================

-- Crear splits
map("n", "<leader>wv", ":vsplit<CR>",        opt("Split vertical"))
map("n", "<leader>wh", ":split<CR>",         opt("Split horizontal"))

-- Navegación entre ventanas
map("n", "<leader>ww", "<C-w>w",             opt("Siguiente ventana"))
map("n", "<leader>wj", "<C-w>j",             opt("Ventana abajo"))
map("n", "<leader>wk", "<C-w>k",             opt("Ventana arriba"))
map("n", "<leader>wl", "<C-w>l",             opt("Ventana derecha"))
map("n", "<leader>wJ", "<C-w>h",             opt("Ventana izquierda"))

-- Navegación alternativa con Ctrl (más rápida)
map("n", "<C-h>", "<C-w>h",                  opt("Ir a ventana izquierda"))
map("n", "<C-j>", "<C-w>j",                  opt("Ir a ventana abajo"))
map("n", "<C-k>", "<C-w>k",                  opt("Ir a ventana arriba"))
map("n", "<C-l>", "<C-w>l",                  opt("Ir a ventana derecha"))

-- Redimensionar ventanas
map("n", "<leader>w=", "<C-w>=",             opt("Igualar tamaño de ventanas"))
map("n", "<leader>w+", ":resize +5<CR>",     opt("Aumentar altura"))
map("n", "<leader>w-", ":resize -5<CR>",     opt("Disminuir altura"))
map("n", "<leader>w>", ":vertical resize +5<CR>", opt("Aumentar ancho"))
map("n", "<leader>w<", ":vertical resize -5<CR>", opt("Disminuir ancho"))

-- Gestión de ventanas
map("n", "<leader>wc", "<C-w>c",             opt("Cerrar ventana actual"))
map("n", "<leader>wo", "<C-w>o",             opt("Cerrar otras ventanas (solo actual)"))
map("n", "<leader>wx", ":close<CR>",         opt("Cerrar ventana"))
map("n", "<leader>wm", function()
  -- Toggle maximize: si hay más de una ventana, maximiza; si no, restaura
  if #vim.api.nvim_list_wins() > 1 then
    vim.cmd("only")  -- Maximizar
  else
    vim.cmd("vsplit") -- Restaurar con split vertical
  end
end, opt("Toggle maximizar ventana"))

-- Mover ventanas de posición
map("n", "<leader>wH", "<C-w>H",             opt("Mover ventana a la izquierda"))
map("n", "<leader>wK", "<C-w>K",             opt("Mover ventana arriba"))
map("n", "<leader>wL", "<C-w>L",             opt("Mover ventana a la derecha"))
map("n", "<leader>wM", "<C-w>J",             opt("Mover ventana abajo"))

-- Rotar ventanas
map("n", "<leader>wr", "<C-w>r",             opt("Rotar ventanas hacia abajo/derecha"))
map("n", "<leader>wR", "<C-w>R",             opt("Rotar ventanas hacia arriba/izquierda"))

-- Cambiar orientación de splits
map("n", "<leader>wT", "<C-w>T",             opt("Mover ventana a nueva pestaña"))
map("n", "<leader>ws", function()
  -- Cambiar de horizontal a vertical o viceversa
  local win_width = vim.api.nvim_win_get_width(0)
  local win_height = vim.api.nvim_win_get_height(0)
  if win_width > win_height * 2 then
    vim.cmd("wincmd K")  -- Cambiar a horizontal
  else
    vim.cmd("wincmd H")  -- Cambiar a vertical
  end
end, opt("Cambiar orientación del split"))

-- Toggle estilos de separadores
map("n", "<leader>wS", function()
  local current_vert = vim.opt.fillchars:get().vert
  if current_vert == "│" then
    -- Cambiar a separadores más gruesos
    vim.opt.fillchars = {
      vert = "┃",      -- Separador vertical grueso
      horiz = "━",     -- Separador horizontal grueso
      horizup = "┻",   -- Conexión gruesa
      horizdown = "┳",
      vertleft = "┫",
      vertright = "┣",
      verthoriz = "╋",
    }
    vim.notify("Separadores gruesos activados")
  elseif current_vert == "┃" then
    -- Cambiar a separadores de doble línea
    vim.opt.fillchars = {
      vert = "║",      -- Separador vertical doble
      horiz = "═",     -- Separador horizontal doble
      horizup = "╩",
      horizdown = "╦",
      vertleft = "╣",
      vertright = "╠",
      verthoriz = "╬",
    }
    vim.notify("Separadores dobles activados")
  else
    -- Volver a separadores normales
    vim.opt.fillchars = {
      vert = "│",
      horiz = "─",
      horizup = "┴",
      horizdown = "┬",
      vertleft = "┤",
      vertright = "├",
      verthoriz = "┼",
    }
    vim.notify("Separadores normales activados")
  end
end, opt("Toggle estilo de separadores"))

-- ===================================================================
-- =================== GESTIÓN DE PESTAÑAS (TABS) ===================
-- ===================================================================

-- Crear y navegar pestañas
map("n", "<leader>tn", ":tabnew<CR>",        opt("Nueva pestaña"))
map("n", "<leader>tc", ":tabclose<CR>",      opt("Cerrar pestaña actual"))
map("n", "<leader>to", ":tabonly<CR>",       opt("Cerrar otras pestañas"))
map("n", "<leader>tm", ":tabmove<CR>",       opt("Mover pestaña al final"))

-- Navegación entre pestañas
map("n", "<leader>tj", ":tabnext<CR>",       opt("Siguiente pestaña"))
map("n", "<leader>tk", ":tabprevious<CR>",   opt("Pestaña anterior"))
map("n", "<leader>tl", ":tablast<CR>",       opt("Última pestaña"))
map("n", "<leader>tf", ":tabfirst<CR>",      opt("Primera pestaña"))

-- Navegación rápida con números
map("n", "<leader>t1", "1gt",                opt("Ir a pestaña 1"))
map("n", "<leader>t2", "2gt",                opt("Ir a pestaña 2"))
map("n", "<leader>t3", "3gt",                opt("Ir a pestaña 3"))
map("n", "<leader>t4", "4gt",                opt("Ir a pestaña 4"))
map("n", "<leader>t5", "5gt",                opt("Ir a pestaña 5"))
map("n", "<leader>t6", "6gt",                opt("Ir a pestaña 6"))
map("n", "<leader>t7", "7gt",                opt("Ir a pestaña 7"))
map("n", "<leader>t8", "8gt",                opt("Ir a pestaña 8"))
map("n", "<leader>t9", "9gt",                opt("Ir a pestaña 9"))

-- Navegación alternativa con Alt (más rápida)
map("n", "<A-j>", ":tabnext<CR>",            opt("Siguiente pestaña (Alt)"))
map("n", "<A-k>", ":tabprevious<CR>",        opt("Pestaña anterior (Alt)"))
map("n", "<A-n>", ":tabnew<CR>",             opt("Nueva pestaña (Alt)"))
map("n", "<A-c>", ":tabclose<CR>",           opt("Cerrar pestaña (Alt)"))

-- Listar pestañas con Telescope
map("n", "<leader>tL", function()
  -- Lista personalizada de pestañas con información detallada
  local tabs = {}
  for i = 1, vim.fn.tabpagenr('$') do
    local tab_wins = vim.fn.tabpagewinnr(i, '$')
    local tab_buf = vim.fn.tabpagebuflist(i)[vim.fn.tabpagewinnr(i)]
    local buf_name = vim.fn.bufname(tab_buf)
    local buf_modified = vim.fn.getbufvar(tab_buf, '&modified') == 1

    local display_name = buf_name ~= "" and vim.fn.fnamemodify(buf_name, ":t") or "[No Name]"
    if buf_modified then display_name = display_name .. " [+]" end

    table.insert(tabs, {
      text = string.format("Tab %d: %s (%d windows)", i, display_name, tab_wins),
      value = i,
    })
  end

  vim.ui.select(tabs, {
    prompt = "Seleccionar pestaña:",
    format_item = function(item) return item.text end,
  }, function(choice)
    if choice then
      vim.cmd("tabnext " .. choice.value)
    end
  end)
end, opt("Listar pestañas"))

-- Información de pestañas
map("n", "<leader>ti", function()
  local current_tab = vim.fn.tabpagenr()
  local total_tabs = vim.fn.tabpagenr('$')
  local tab_wins = vim.fn.tabpagewinnr(current_tab, '$')
  local buf_name = vim.fn.bufname()
  local display_name = buf_name ~= "" and vim.fn.fnamemodify(buf_name, ":t") or "[No Name]"

  vim.notify(string.format(
    "Pestaña %d de %d | %d ventanas | Buffer: %s",
    current_tab, total_tabs, tab_wins, display_name
  ))
end, opt("Info de pestaña actual"))

-- ===================================================================
-- ==================== COMPARACIÓN DE ARCHIVOS ====================
-- ===================================================================

-- Variables para mantener estado de diff
local diff_state = {
  is_active = false,
  buffers = {},
}

-- Función para resetear el modo diff
local function reset_diff()
  if diff_state.is_active then
    for _, buf in ipairs(diff_state.buffers) do
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("diffoff")
        end)
      end
    end
    diff_state.is_active = false
    diff_state.buffers = {}
    vim.notify("Modo diff desactivado")
  end
end

-- Diff entre buffer actual y otro archivo
map("n", "<leader>Df", function()
  reset_diff()

  -- Usar Telescope para seleccionar el archivo a comparar
  local ok, builtin = pcall(require, "telescope.builtin")
  if not ok then
    vim.notify("Telescope no disponible", vim.log.levels.ERROR)
    return
  end

  local current_buf = vim.api.nvim_get_current_buf()
  local current_file = vim.api.nvim_buf_get_name(current_buf)

  if current_file == "" then
    vim.notify("El buffer actual no tiene archivo asociado", vim.log.levels.WARN)
    return
  end

  builtin.find_files({
    prompt_title = "Seleccionar archivo para comparar con: " .. vim.fn.fnamemodify(current_file, ":t"),
    attach_mappings = function(prompt_bufnr, map_local)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      map_local("i", "<CR>", function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if selection then
          -- Abrir el archivo seleccionado en split vertical
          vim.cmd("vsplit " .. selection.path)
          local new_buf = vim.api.nvim_get_current_buf()

          -- Activar diff en ambos buffers
          vim.api.nvim_buf_call(current_buf, function() vim.cmd("diffthis") end)
          vim.api.nvim_buf_call(new_buf, function() vim.cmd("diffthis") end)

          diff_state.is_active = true
          diff_state.buffers = { current_buf, new_buf }
          vim.notify("Diff activado entre archivos")
        end
      end)

      return true
    end,
  })
end, opt("Diff con archivo seleccionado"))

-- Diff entre dos archivos desde cero
map("n", "<leader>DD", function()
  reset_diff()

  local ok, builtin = pcall(require, "telescope.builtin")
  if not ok then
    vim.notify("Telescope no disponible", vim.log.levels.ERROR)
    return
  end

  local files_selected = {}

  -- Función para seleccionar el primer archivo
  local function select_first_file()
    builtin.find_files({
      prompt_title = "Seleccionar PRIMER archivo para comparar",
      attach_mappings = function(prompt_bufnr, map_local)
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        map_local("i", "<CR>", function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if selection then
            files_selected[1] = selection.path
            select_second_file()
          end
        end)

        return true
      end,
    })
  end

  -- Función para seleccionar el segundo archivo
  function select_second_file()
    builtin.find_files({
      prompt_title = "Seleccionar SEGUNDO archivo (comparar con: " .. vim.fn.fnamemodify(files_selected[1], ":t") .. ")",
      attach_mappings = function(prompt_bufnr, map_local)
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        map_local("i", "<CR>", function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if selection then
            files_selected[2] = selection.path

            -- Abrir ambos archivos en splits y activar diff
            vim.cmd("edit " .. files_selected[1])
            local buf1 = vim.api.nvim_get_current_buf()

            vim.cmd("vsplit " .. files_selected[2])
            local buf2 = vim.api.nvim_get_current_buf()

            -- Activar diff
            vim.api.nvim_buf_call(buf1, function() vim.cmd("diffthis") end)
            vim.api.nvim_buf_call(buf2, function() vim.cmd("diffthis") end)

            diff_state.is_active = true
            diff_state.buffers = { buf1, buf2 }

            vim.notify(string.format("Diff entre: %s vs %s",
              vim.fn.fnamemodify(files_selected[1], ":t"),
              vim.fn.fnamemodify(files_selected[2], ":t")
            ))
          end
        end)

        return true
      end,
    })
  end

  select_first_file()
end, opt("Diff entre dos archivos nuevos"))

-- Diff del buffer actual con una versión anterior (si es un archivo git)
map("n", "<leader>Dg", function()
  reset_diff()

  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    vim.notify("El buffer actual no tiene archivo asociado", vim.log.levels.WARN)
    return
  end

  -- Verificar si estamos en un repo git
  local git_check = vim.fn.system("git rev-parse --is-inside-work-tree")
  if vim.v.shell_error ~= 0 then
    vim.notify("No estás en un repositorio git", vim.log.levels.WARN)
    return
  end

  -- Obtener lista de commits que modificaron este archivo
  local log_cmd = string.format("git log --oneline -10 --follow -- %s", vim.fn.shellescape(current_file))
  local commits = vim.fn.systemlist(log_cmd)

  if #commits == 0 then
    vim.notify("No se encontraron commits para este archivo", vim.log.levels.WARN)
    return
  end

  -- Usar vim.ui.select para elegir el commit
  local commit_items = {}
  for _, commit_line in ipairs(commits) do
    local hash = commit_line:match("^(%w+)")
    local message = commit_line:match("^%w+%s+(.+)")
    table.insert(commit_items, {
      text = string.format("%s: %s", hash:sub(1, 7), message),
      hash = hash,
    })
  end

  vim.ui.select(commit_items, {
    prompt = "Seleccionar commit para comparar:",
    format_item = function(item) return item.text end,
  }, function(choice)
    if choice then
      local current_buf = vim.api.nvim_get_current_buf()

      -- Crear un buffer temporal con la versión del commit
      local temp_content = vim.fn.system(string.format(
        "git show %s:%s",
        choice.hash,
        vim.fn.fnamemodify(current_file, ":.")
      ))

      if vim.v.shell_error ~= 0 then
        vim.notify("Error al obtener contenido del commit", vim.log.levels.ERROR)
        return
      end

      -- Crear split y buffer temporal
      vim.cmd("vsplit")
      local temp_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_win_set_buf(0, temp_buf)

      -- Configurar el buffer temporal
      local lines = vim.split(temp_content, "\n")
      vim.api.nvim_buf_set_lines(temp_buf, 0, -1, false, lines)
      vim.api.nvim_buf_set_option(temp_buf, "filetype", vim.api.nvim_buf_get_option(current_buf, "filetype"))
      vim.api.nvim_buf_set_option(temp_buf, "readonly", true)
      vim.api.nvim_buf_set_option(temp_buf, "modifiable", false)
      vim.api.nvim_buf_set_name(temp_buf, string.format("[%s] %s", choice.hash:sub(1, 7), vim.fn.fnamemodify(current_file, ":t")))

      -- Activar diff
      vim.api.nvim_buf_call(current_buf, function() vim.cmd("diffthis") end)
      vim.api.nvim_buf_call(temp_buf, function() vim.cmd("diffthis") end)

      diff_state.is_active = true
      diff_state.buffers = { current_buf, temp_buf }

      vim.notify(string.format("Diff con commit %s", choice.hash:sub(1, 7)))
    end
  end)
end, opt("Diff con versión de git"))

-- Navegación entre diferencias
map("n", "<leader>Dn", "]c", opt("Siguiente diferencia"))
map("n", "<leader>DP", "[c", opt("Diferencia anterior"))

-- Aplicar/obtener cambios (solo funciona en modo diff)
map("n", "<leader>Do", "do", opt("Obtener cambio (diff obtain)"))
map("n", "<leader>Dp", "dp", opt("Poner cambio (diff put)"))

-- Actualizar diff
map("n", "<leader>Du", ":diffupdate<CR>", opt("Actualizar diff"))

-- Desactivar diff
map("n", "<leader>Dq", function()
  reset_diff()
end, opt("Salir del modo diff"))

-- Toggle diff del buffer actual
map("n", "<leader>Dt", function()
  if vim.wo.diff then
    vim.cmd("diffoff")
    vim.notify("Diff desactivado para este buffer")
  else
    vim.cmd("diffthis")
    vim.notify("Diff activado para este buffer")
  end
end, opt("Toggle diff en buffer actual"))

-- Información del estado diff
map("n", "<leader>Di", function()
  if diff_state.is_active then
    local buffer_names = {}
    for _, buf in ipairs(diff_state.buffers) do
      if vim.api.nvim_buf_is_valid(buf) then
        local name = vim.api.nvim_buf_get_name(buf)
        table.insert(buffer_names, name ~= "" and vim.fn.fnamemodify(name, ":t") or "[No Name]")
      end
    end
    vim.notify("Diff activo entre: " .. table.concat(buffer_names, " vs "))
  else
    vim.notify("No hay diff activo")
  end
end, opt("Info del estado diff"))
