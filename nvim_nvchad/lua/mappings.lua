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
      { "<leader>g", group = "Git" },
      { "<leader>c", group = "Code" },
      { "<leader>d", group = "Debug (DAP)" },
      { "<leader>p", group = "Profiles" },
    })
  elseif ok and wk.register then
    wk.register({
      g = { name = "Git" },
      c = { name = "Code" },
      d = { name = "Debug (DAP)" },
      p = { name = "Profiles" },
    }, { prefix = "<leader>" })
  end
end

-- ========= Telescope =========
-- Nota: NvChad ya define <leader>ff (find_files), <leader>fw (live_grep), <leader>fb (buffers), etc.
-- Aquí solo añadimos los que no están en NvChad base o usamos prefijos alternativos para organización

local function tb(fn, opts)
  return function()
    local ok, builtin = pcall(require, "telescope.builtin")
    if not ok then return vim.notify("Telescope no cargado", vim.log.levels.WARN) end
    builtin[fn](opts or {})
  end
end

-- Keymaps adicionales de Telescope (los básicos ya están en NvChad: ff, fw, fb, fh, fo)
map("n", "<leader>fk", tb("keymaps"),      opt("Keymaps"))
map("n", "<leader>fc", tb("commands"),     opt("Comandos"))
map("n", "<leader>fd", tb("diagnostics", { bufnr = 0 }), opt("Diag. del buffer"))
map("n", "<leader>fD", tb("diagnostics"),               opt("Diag. del workspace"))
-- LSP pickers útiles (si hay servidor activo):
map("n", "<leader>fr", tb("lsp_references"),        opt("LSP Referencias"))
map("n", "<leader>fs", tb("lsp_document_symbols"),  opt("Símbolos del buffer"))
map("n", "<leader>fS", tb("lsp_workspace_symbols"), opt("Símbolos del workspace"))

-- Buffer list (alternativa a <leader>fb de NvChad)
map("n", "<leader>bl", tb("buffers"), opt("Lista buffers (Telescope)"))

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

-- which-key: añadir grupos adicionales (NvChad ya define algunos)
do
  local ok, wk = pcall(require, "which-key")
  if ok and wk.add then
    wk.add({
      { "<leader>b", group = "Buffers" },
      { "<leader>f", group = "Find (Telescope)" },
      { "<leader>j", group = "Jumps" },
      { "<leader>w", group = "Windows" },
      { "<leader>t", group = "Tabs" },
      { "<leader>D", group = "Diff" },
      { "<leader>S", group = "Search Advanced" },
      { "<leader>R", group = "Recent Files" },
    })
  elseif ok and wk.register then
    wk.register({
      b = { name = "Buffers" },
      f = { name = "Find (Telescope)" },
      j = { name = "Jumps" },
      w = { name = "Windows" },
      t = { name = "Tabs" },
      D = { name = "Diff" },
      S = { name = "Search Advanced" },
      R = { name = "Recent Files" },
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

-- ===================================================================
-- =============== BÚSQUEDA AVANZADA CON VENTANA PERSISTENTE ========
-- ===================================================================

-- Variables para mantener el estado de búsqueda
local search_state = {
  results_buf = nil,
  results_win = nil,
  source_buf = nil,
  current_index = 1,
  matches = {},
  pattern = "",
}

-- Función para limpiar búsquedas anteriores
local function cleanup_search()
  if search_state.results_win and vim.api.nvim_win_is_valid(search_state.results_win) then
    vim.api.nvim_win_close(search_state.results_win, true)
  end
  if search_state.results_buf and vim.api.nvim_buf_is_valid(search_state.results_buf) then
    vim.api.nvim_buf_delete(search_state.results_buf, { force = true })
  end
  search_state.results_buf = nil
  search_state.results_win = nil
  search_state.matches = {}
  search_state.current_index = 1
end

-- Función para crear la ventana de resultados
local function create_results_window(matches, pattern, source_buf)
  cleanup_search()

  if #matches == 0 then
    vim.notify("No se encontraron coincidencias para: " .. pattern, vim.log.levels.WARN)
    return
  end

  -- Crear buffer para resultados
  local results_buf = vim.api.nvim_create_buf(false, true)
  search_state.results_buf = results_buf
  search_state.source_buf = source_buf
  search_state.matches = matches
  search_state.pattern = pattern

  -- Configurar el buffer
  vim.api.nvim_buf_set_option(results_buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(results_buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(results_buf, "swapfile", false)
  vim.api.nvim_buf_set_option(results_buf, "modifiable", true)

  -- Crear contenido del buffer
  local lines = {}
  local source_name = vim.api.nvim_buf_get_name(source_buf)
  local display_name = source_name ~= "" and vim.fn.fnamemodify(source_name, ":t") or "[No Name]"

  table.insert(lines, "=== Resultados de búsqueda: '" .. pattern .. "' en " .. display_name .. " ===")
  table.insert(lines, "Total: " .. #matches .. " coincidencias")
  table.insert(lines, "")
  table.insert(lines, "Navegación: <Enter>=Ir, <C-n>=Siguiente, <C-p>=Anterior, q=Cerrar")
  table.insert(lines, "")

  for i, match in ipairs(matches) do
    local prefix = string.format("%3d: L%d | ", i, match.line)
    table.insert(lines, prefix .. match.text)
  end

  vim.api.nvim_buf_set_lines(results_buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(results_buf, "modifiable", false)

  -- Configurar resaltado
  vim.api.nvim_buf_add_highlight(results_buf, -1, "Title", 0, 0, -1)
  vim.api.nvim_buf_add_highlight(results_buf, -1, "Comment", 1, 0, -1)
  vim.api.nvim_buf_add_highlight(results_buf, -1, "Comment", 3, 0, -1)

  -- Resaltar el patrón en cada línea de resultado
  -- Extraer el patrón original sin la información de case
  local original_pattern = pattern:match("^(.-)%s*%(") or pattern
  local is_case_sensitive = has_uppercase(original_pattern)

  for i, match in ipairs(matches) do
    local line_idx = i + 4  -- Ajustar por las líneas de cabecera
    local text_start = string.len(string.format("%3d: L%d | ", i, match.line))

    -- Buscar todas las ocurrencias del patrón en la línea para resaltado
    local text = match.text
    local start_pos = 1
    while true do
      local match_start, match_end
      if is_case_sensitive then
        match_start, match_end = string.find(text, original_pattern, start_pos, true)
      else
        match_start, match_end = string.find(string.lower(text), string.lower(original_pattern), start_pos, true)
      end

      if not match_start then break end

      vim.api.nvim_buf_add_highlight(
        results_buf, -1, "Search",
        line_idx, text_start + match_start - 1,
        text_start + match_end
      )
      start_pos = match_end + 1
    end
  end

  -- Crear ventana split horizontal en la parte inferior
  local current_win = vim.api.nvim_get_current_win()
  vim.cmd("botright split")
  vim.cmd("resize 15")  -- Altura fija de 15 líneas

  local results_win = vim.api.nvim_get_current_win()
  search_state.results_win = results_win

  vim.api.nvim_win_set_buf(results_win, results_buf)
  vim.api.nvim_buf_set_name(results_buf, "[Búsqueda: " .. pattern .. "]")

  -- Configurar keymaps locales para el buffer de resultados
  local opts_local = { buffer = results_buf, silent = true }

  vim.keymap.set("n", "<CR>", function()
    local cursor = vim.api.nvim_win_get_cursor(results_win)
    local line = cursor[1]
    if line > 5 then  -- Solo líneas con resultados
      local match_idx = line - 5
      if matches[match_idx] then
        search_state.current_index = match_idx
        jump_to_match(matches[match_idx])
      end
    end
  end, opts_local)

  vim.keymap.set("n", "<C-n>", function()
    search_state.current_index = search_state.current_index % #matches + 1
    jump_to_match(matches[search_state.current_index])
    highlight_current_result()
  end, opts_local)

  vim.keymap.set("n", "<C-p>", function()
    search_state.current_index = search_state.current_index - 1
    if search_state.current_index < 1 then
      search_state.current_index = #matches
    end
    jump_to_match(matches[search_state.current_index])
    highlight_current_result()
  end, opts_local)

  vim.keymap.set("n", "q", function()
    cleanup_search()
  end, opts_local)

  vim.keymap.set("n", "r", function()
    refresh_search()
  end, opts_local)

  -- Posicionar cursor en el primer resultado
  vim.api.nvim_win_set_cursor(results_win, {6, 0})  -- Primera línea de resultado

  vim.notify(string.format("Encontradas %d coincidencias de '%s'", #matches, pattern))

  -- Saltar automáticamente al primer resultado
  if matches[1] then
    jump_to_match(matches[1])
  end
end

-- Función para saltar a una coincidencia específica
function jump_to_match(match)
  if not search_state.source_buf or not vim.api.nvim_buf_is_valid(search_state.source_buf) then
    vim.notify("Buffer fuente no válido", vim.log.levels.ERROR)
    return
  end

  -- Encontrar ventana que contenga el buffer fuente
  local source_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == search_state.source_buf and win ~= search_state.results_win then
      source_win = win
      break
    end
  end

  if not source_win then
    -- Crear nueva ventana si no existe
    vim.cmd("wincmd k")  -- Ir a ventana superior
    source_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(source_win, search_state.source_buf)
  end

  -- Saltar a la línea y centrar
  vim.api.nvim_win_set_cursor(source_win, {match.line, match.col - 1})
  vim.api.nvim_win_call(source_win, function()
    vim.cmd("normal! zz")  -- Centrar línea
  end)

  -- Resaltar temporalmente la línea encontrada
  local ns_id = vim.api.nvim_create_namespace("search_highlight")
  vim.api.nvim_buf_clear_namespace(search_state.source_buf, ns_id, 0, -1)
  vim.api.nvim_buf_add_highlight(search_state.source_buf, ns_id, "CursorLine", match.line - 1, 0, -1)

  -- Limpiar resaltado después de 2 segundos
  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(search_state.source_buf) then
      vim.api.nvim_buf_clear_namespace(search_state.source_buf, ns_id, 0, -1)
    end
  end, 2000)
end

-- Función para resaltar el resultado actual en la ventana de resultados
function highlight_current_result()
  if not search_state.results_buf or not vim.api.nvim_buf_is_valid(search_state.results_buf) then
    return
  end

  -- Limpiar resaltados previos
  local ns_id = vim.api.nvim_create_namespace("current_result")
  vim.api.nvim_buf_clear_namespace(search_state.results_buf, ns_id, 0, -1)

  -- Resaltar línea actual
  local line_idx = search_state.current_index + 4  -- Ajustar por cabeceras
  vim.api.nvim_buf_add_highlight(search_state.results_buf, ns_id, "CursorLine", line_idx, 0, -1)

  -- Mover cursor en la ventana de resultados
  if search_state.results_win and vim.api.nvim_win_is_valid(search_state.results_win) then
    vim.api.nvim_win_set_cursor(search_state.results_win, {line_idx + 1, 0})
  end
end

-- Función para refrescar la búsqueda
function refresh_search()
  if not search_state.source_buf or not vim.api.nvim_buf_is_valid(search_state.source_buf) then
    vim.notify("Buffer fuente no válido", vim.log.levels.ERROR)
    return
  end

  local pattern = search_state.pattern
  if pattern == "" then
    vim.notify("No hay patrón de búsqueda activo", vim.log.levels.WARN)
    return
  end

  perform_search(pattern, search_state.source_buf, false)  -- false = no es regex
end

-- Función para detectar si un patrón contiene mayúsculas
local function has_uppercase(pattern)
  return pattern:match("%u") ~= nil
end

-- Función para realizar búsqueda inteligente (smartcase)
local function smart_search(line_text, pattern, col, is_case_sensitive)
  if is_case_sensitive then
    -- Búsqueda sensible a mayúsculas/minúsculas
    return string.find(line_text, pattern, col, true)
  else
    -- Búsqueda insensible a mayúsculas/minúsculas
    return string.find(string.lower(line_text), string.lower(pattern), col, true)
  end
end

-- Función principal de búsqueda
function perform_search(pattern, buffer, is_regex)
  if pattern == "" then
    vim.notify("Patrón vacío", vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
  local matches = {}

  -- Determinar si la búsqueda debe ser case-sensitive (smartcase)
  local is_case_sensitive = is_regex or has_uppercase(pattern)
  local case_info = is_case_sensitive and "(case-sensitive)" or "(case-insensitive)"

  for line_num, line_text in ipairs(lines) do
    local col = 1

    while true do
      local match_start, match_end

      if is_regex then
        -- Para regex, usar la lógica original
        match_start, match_end = string.find(line_text, pattern, col)
      else
        -- Para búsqueda de texto simple, usar smartcase
        match_start, match_end = smart_search(line_text, pattern, col, is_case_sensitive)
      end

      if not match_start then break end

      -- Para case-insensitive, necesitamos obtener el texto original de la coincidencia
      local actual_match_text = string.sub(line_text, match_start, match_end)

      table.insert(matches, {
        line = line_num,
        col = match_start,
        text = line_text,
        match_text = actual_match_text
      })

      col = match_end + 1
    end
  end

  -- Añadir información sobre el tipo de búsqueda al patrón mostrado
  local display_pattern = pattern .. " " .. case_info
  create_results_window(matches, display_pattern, buffer)

  -- Guardar el patrón original (sin la info adicional) para refrescos
  search_state.pattern = pattern
end

-- Keymaps para búsqueda avanzada
map("n", "<leader>Ss", function()
  local current_buf = vim.api.nvim_get_current_buf()
  vim.ui.input({
    prompt = "Buscar texto: ",
    default = vim.fn.expand("<cword>")  -- Palabra bajo el cursor por defecto
  }, function(pattern)
    if pattern and pattern ~= "" then
      perform_search(pattern, current_buf, false)
    end
  end)
end, opt("Búsqueda de texto en buffer"))

map("n", "<leader>Sr", function()
  local current_buf = vim.api.nvim_get_current_buf()
  vim.ui.input({
    prompt = "Buscar regex: ",
  }, function(pattern)
    if pattern and pattern ~= "" then
      perform_search(pattern, current_buf, true)
    end
  end)
end, opt("Búsqueda regex en buffer"))

map("n", "<leader>Sw", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local word = vim.fn.expand("<cword>")
  if word ~= "" then
    -- Búsqueda de palabra completa (con \b en regex)
    local pattern = "\\b" .. vim.fn.escape(word, "\\") .. "\\b"
    perform_search(pattern, current_buf, true)
  else
    vim.notify("No hay palabra bajo el cursor", vim.log.levels.WARN)
  end
end, opt("Buscar palabra completa bajo cursor"))

map("n", "<leader>Sc", function()
  cleanup_search()
end, opt("Cerrar ventana de búsqueda"))

-- Navegación global en búsquedas (funciona desde cualquier ventana)
map("n", "<leader>Sn", function()
  if #search_state.matches > 0 then
    search_state.current_index = search_state.current_index % #search_state.matches + 1
    jump_to_match(search_state.matches[search_state.current_index])
    highlight_current_result()
  else
    vim.notify("No hay búsqueda activa", vim.log.levels.WARN)
  end
end, opt("Siguiente resultado de búsqueda"))

map("n", "<leader>Sp", function()
  if #search_state.matches > 0 then
    search_state.current_index = search_state.current_index - 1
    if search_state.current_index < 1 then
      search_state.current_index = #search_state.matches
    end
    jump_to_match(search_state.matches[search_state.current_index])
    highlight_current_result()
  else
    vim.notify("No hay búsqueda activa", vim.log.levels.WARN)
  end
end, opt("Resultado anterior de búsqueda"))

map("n", "<leader>Si", function()
  if #search_state.matches > 0 then
    local source_name = vim.api.nvim_buf_get_name(search_state.source_buf)
    local display_name = source_name ~= "" and vim.fn.fnamemodify(source_name, ":t") or "[No Name]"
    vim.notify(string.format(
      "Búsqueda: '%s' en %s | Resultado %d/%d",
      search_state.pattern, display_name, search_state.current_index, #search_state.matches
    ))
  else
    vim.notify("No hay búsqueda activa")
  end
end, opt("Info de búsqueda actual"))

map("n", "<leader>SR", function()
  refresh_search()
end, opt("Refrescar búsqueda actual"))

-- ===================================================================
-- =================== BUFFERLINE (NAVEGACIÓN DE BUFFERS) ============
-- ===================================================================

-- Registrar grupo en which-key
do
  local ok, wk = pcall(require, "which-key")
  if ok and wk.add then
    wk.add({
      { "<leader>B", group = "Bufferline" },
    })
  elseif ok and wk.register then
    wk.register({
      B = { name = "Bufferline" },
    }, { prefix = "<leader>" })
  end
end

-- Navegar entre buffers con números (usa B mayúscula para evitar conflicto con tabs)
for i = 1, 9 do
  map("n", "<leader>B" .. i, function()
    require("bufferline").go_to(i, true)
  end, opt("Ir a buffer " .. i))
end

-- Cycle entre buffers (]b y [b son estándar en Neovim)
map("n", "]b", "<cmd>BufferLineCycleNext<cr>", opt("Siguiente buffer (bufferline)"))
map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", opt("Buffer anterior (bufferline)"))

-- Mover buffers de posición
map("n", "<leader>B>", "<cmd>BufferLineMoveNext<cr>", opt("Mover buffer a la derecha"))
map("n", "<leader>B<", "<cmd>BufferLineMovePrev<cr>", opt("Mover buffer a la izquierda"))

-- Seleccionar buffer interactivamente
map("n", "<leader>Bp", "<cmd>BufferLinePick<cr>", opt("Seleccionar buffer interactivamente"))
map("n", "<leader>BC", "<cmd>BufferLinePickClose<cr>", opt("Seleccionar buffer para cerrar"))

-- Cerrar buffers
map("n", "<leader>Bc", "<cmd>BufferLineCloseOthers<cr>", opt("Cerrar otros buffers"))
map("n", "<leader>Bl", "<cmd>BufferLineCloseLeft<cr>", opt("Cerrar buffers a la izquierda"))
map("n", "<leader>Br", "<cmd>BufferLineCloseRight<cr>", opt("Cerrar buffers a la derecha"))

-- Ir al primer/último buffer
map("n", "<leader>Bf", "<cmd>BufferLineGoToBuffer 1<cr>", opt("Ir al primer buffer"))
map("n", "<leader>BL", "<cmd>BufferLineGoToBuffer -1<cr>", opt("Ir al último buffer"))

-- Agrupar buffers (toggle)
map("n", "<leader>Bg", "<cmd>BufferLineGroupToggle<cr>", opt("Toggle agrupación de buffers"))

-- Nota: Los keymaps de navegación básica (<leader>bn, <leader>bp, <leader>bd, etc.)
-- ya existen más arriba en la sección de Buffers y siguen funcionando con cualquier
-- plugin de buffers. Los de bufferline son adicionales y más avanzados.

-- ===================================================================
-- =================== ARCHIVOS RECIENTES POR ÁRBOL =================
-- ===================================================================

-- Cargar módulo de archivos recientes
local recent_files = require("recent_files")

-- Activar tracking automático
recent_files.setup()

-- Mostrar archivos recientes del árbol actual
map("n", "<leader>R", function()
  recent_files.show_recent_files()
end, opt("Archivos recientes (árbol actual)"))
