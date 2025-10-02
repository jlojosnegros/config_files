-- ~/.config/nvim/lua/recent_files.lua
-- Módulo para rastrear y mostrar los ficheros recientes por árbol de directorios

local M = {}

-- Estado del módulo
local state = {
  -- Estructura: { [git_root] = { {file=path, timestamp=num}, ... } }
  files_by_tree = {},
  max_files_per_tree = 10,
}

-- Función para obtener la raíz del repositorio git o el directorio actual
local function get_tree_root(filepath)
  if not filepath or filepath == "" then
    return vim.loop.cwd()
  end

  -- Obtener el directorio del archivo
  local dir = vim.fn.fnamemodify(filepath, ":h")

  -- Intentar encontrar la raíz del repositorio git
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel")[1]

  if vim.v.shell_error == 0 and git_root and git_root ~= "" then
    return git_root
  end

  -- Si no está en un repo git, usar el directorio del proyecto
  return dir
end

-- Función para añadir un archivo al historial
function M.track_file(filepath)
  if not filepath or filepath == "" then
    return
  end

  -- Ignorar buffers especiales
  local buftype = vim.api.nvim_buf_get_option(0, "buftype")
  if buftype ~= "" then
    return
  end

  -- Ignorar archivos temporales y de plugins
  if filepath:match("^/tmp/") or filepath:match("lazy%.nvim") or filepath:match("%[.*%]") then
    return
  end

  local tree_root = get_tree_root(filepath)
  local timestamp = os.time()

  -- Inicializar lista si no existe
  if not state.files_by_tree[tree_root] then
    state.files_by_tree[tree_root] = {}
  end

  local files = state.files_by_tree[tree_root]

  -- Eliminar el archivo si ya existe (para actualizarlo)
  for i, entry in ipairs(files) do
    if entry.file == filepath then
      table.remove(files, i)
      break
    end
  end

  -- Añadir al principio
  table.insert(files, 1, {
    file = filepath,
    timestamp = timestamp,
  })

  -- Limitar a max_files_per_tree
  while #files > state.max_files_per_tree do
    table.remove(files)
  end
end

-- Función para obtener los archivos recientes del árbol actual
function M.get_recent_files(tree_root)
  tree_root = tree_root or get_tree_root(vim.api.nvim_buf_get_name(0))
  return state.files_by_tree[tree_root] or {}
end

-- Función para mostrar popup con los archivos recientes
function M.show_recent_files()
  local current_file = vim.api.nvim_buf_get_name(0)
  local tree_root = get_tree_root(current_file)
  local recent_files = M.get_recent_files(tree_root)

  if #recent_files == 0 then
    vim.notify("No hay archivos recientes en este árbol de directorios", vim.log.levels.WARN)
    return
  end

  -- Crear opciones para vim.ui.select similar al buffer picker
  local options = {}
  for i, entry in ipairs(recent_files) do
    local filename = vim.fn.fnamemodify(entry.file, ":t")
    local relative_path = vim.fn.fnamemodify(entry.file, ":~:.")

    -- Calcular tiempo transcurrido
    local elapsed = os.time() - entry.timestamp
    local time_str
    if elapsed < 60 then
      time_str = "ahora"
    elseif elapsed < 3600 then
      time_str = string.format("%dm", math.floor(elapsed / 60))
    elseif elapsed < 86400 then
      time_str = string.format("%dh", math.floor(elapsed / 3600))
    else
      time_str = string.format("%dd", math.floor(elapsed / 86400))
    end

    table.insert(options, {
      display = string.format("%d. %s  (%s) - %s", i, filename, time_str, relative_path),
      file = entry.file,
      index = i,
    })
  end

  -- Obtener nombre del árbol para mostrar
  local tree_display = vim.fn.fnamemodify(tree_root, ":t")
  if tree_display == "" then
    tree_display = tree_root
  end

  -- Usar Telescope si está disponible, sino vim.ui.select
  local ok_telescope, pickers = pcall(require, "telescope.pickers")
  local ok_finders, finders = pcall(require, "telescope.finders")
  local ok_conf, conf = pcall(require, "telescope.config")
  local ok_actions, actions = pcall(require, "telescope.actions")
  local ok_action_state, action_state = pcall(require, "telescope.actions.state")

  if ok_telescope and ok_finders and ok_conf and ok_actions and ok_action_state then
    -- Usar Telescope para mejor UI
    pickers
      .new({}, {
        prompt_title = "Archivos Recientes - " .. tree_display,
        finder = finders.new_table({
          results = options,
          entry_maker = function(entry)
            return {
              value = entry.file,
              display = entry.display,
              ordinal = entry.display,
              index = entry.index,
            }
          end,
        }),
        sorter = conf.values.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if selection then
              vim.cmd("edit " .. vim.fn.fnameescape(selection.value))
            end
          end)
          return true
        end,
      })
      :find()
  else
    -- Fallback a vim.ui.select
    vim.ui.select(options, {
      prompt = "Archivos Recientes (" .. tree_display .. "):",
      format_item = function(item)
        return item.display
      end,
    }, function(choice)
      if choice then
        vim.cmd("edit " .. vim.fn.fnameescape(choice.file))
      end
    end)
  end
end

-- Setup automático para rastrear archivos
function M.setup()
  -- Autocomando para rastrear archivos al abrirlos
  vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
    group = vim.api.nvim_create_augroup("RecentFilesTracker", { clear = true }),
    callback = function()
      local filepath = vim.api.nvim_buf_get_name(0)
      M.track_file(filepath)
    end,
  })
end

return M
