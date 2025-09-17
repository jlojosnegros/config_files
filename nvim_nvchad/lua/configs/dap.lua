local dap = require("dap")
local dapui = require("dapui")
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"]  = function() dapui.close() end

local ok, mason_registry = pcall(require, "mason-registry")
if ok then
  local codelldb = mason_registry.get_package("codelldb")
  if codelldb:is_installed() then
    local install_path = codelldb:get_install_path()
    local adapter = install_path .. "/extension/adapter/codelldb"
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = { command = adapter, args = { "--port", "${port}" } },
    }
  end
end

local function choose_exe()
  return vim.fn.input("Path to executable: ", vim.loop.cwd() .. "/", "file")
end

dap.configurations.cpp = {
  {
    name = "Launch file (codelldb)",
    type = "codelldb",
    request = "launch",
    program = choose_exe,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
  {
    name = "Attach to process (codelldb)",
    type = "codelldb",
    request = "attach",
    pid = require("dap.utils").pick_process,
    args = {},
  },
}
dap.configurations.c = dap.configurations.cpp

dap.configurations.rust = {
  {
    name = "Launch cargo binary (codelldb)",
    type = "codelldb",
    request = "launch",
    program = function()
      local guess = vim.loop.cwd() .. "/target/debug/"
      return vim.fn.input("Binary (cargo build first): ", guess, "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
}
