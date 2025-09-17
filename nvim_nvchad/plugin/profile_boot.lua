pcall(function()
  require("profiles.manager").set("auto")
end)

local map = vim.keymap.set
local desc = function(t) return { desc = t, silent = true } end

-- Selector de perfil y accesos directos
map("n", "<leader>pP", function()
  vim.ui.select({ "cpp", "rust", "auto" }, { prompt = "Selecciona perfil" }, function(choice)
    if choice then require("profiles.manager").set(choice) end
  end)
end, desc("Profiles: Picker"))
map("n", "<leader>p1", function() require("profiles.manager").set("cpp") end,  desc("Perfil: C++"))
map("n", "<leader>p2", function() require("profiles.manager").set("rust") end, desc("Perfil: Rust"))

-- Acciones (en mayúscula)
map("n", "<leader>pB", function() require("profiles.manager").build() end, desc("Build (perfil activo)"))
map("n", "<leader>pT", function() require("profiles.manager").test()  end, desc("Test (perfil activo)"))
map("n", "<leader>pR", function() require("profiles.manager").debug() end, desc("Debug/Run (perfil activo)"))

-- DAP (teclas de función y prefijo 'd')
map("n", "<F5>",  function() require("dap").continue()    end, desc("DAP: Continue"))
map("n", "<F10>", function() require("dap").step_over()   end, desc("DAP: Step Over"))
map("n", "<F11>", function() require("dap").step_into()   end, desc("DAP: Step Into"))
map("n", "<F12>", function() require("dap").step_out()    end, desc("DAP: Step Out"))
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, desc("DAP: Toggle Breakpoint"))
map("n", "<leader>du", function() require("dapui").toggle() end, desc("DAP UI: toggle"))
