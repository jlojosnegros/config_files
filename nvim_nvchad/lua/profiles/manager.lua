local M = { current = "auto" }

local function detect()
  local ft = vim.bo.filetype
  if ft == "rust" then return "rust" end
  if ft == "c" or ft == "cpp" or ft == "objc" or ft == "objcpp" then return "cpp" end
  return "cpp"
end

local profiles = {
  cpp = require("profiles.cpp"),
  rust = require("profiles.rust"),
}

function M.set(name)
  if name == "auto" then name = detect() end
  if not profiles[name] then
    vim.notify("Unknown profile: " .. tostring(name), vim.log.levels.ERROR)
    return
  end
  M.current = name
  vim.g.active_code_profile = name
  vim.notify("Perfil activo: " .. name)
end

function M.get() return M.current end
function M.build() profiles[M.current].build() end
function M.test()  profiles[M.current].test()  end
function M.debug() profiles[M.current].debug() end

vim.api.nvim_create_user_command("Profile", function(opts) M.set(opts.args) end, {
  nargs = 1, complete = function() return { "cpp", "rust", "auto" } end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if M.current == "auto" then
      local newp = detect()
      if newp ~= "auto" then M.set(newp) end
    end
  end,
})

return M
