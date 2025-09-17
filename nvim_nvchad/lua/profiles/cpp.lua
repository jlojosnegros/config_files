local M = {}

local function run_in_term(cmd)
  local ok, nvterm = pcall(require, "nvterm.terminal")
  if ok then nvterm.send(cmd, "horizontal")
  else
    vim.cmd("botright split | resize 12 | terminal")
    local chan = vim.b.terminal_job_id
    if chan then vim.fn.chansend(chan, cmd .. "\n") end
  end
end

function M.build()
  local ok, bazel = pcall(require, "bazel")
  if ok then bazel.run_here("build") else run_in_term("bazel build //...") end
end

function M.test()
  local ok, bazel = pcall(require, "bazel")
  if ok then bazel.run_here("test") else run_in_term("bazel test //...") end
end

function M.debug()
  local ok, dap = pcall(require, "dap")
  if ok then dap.continue() else vim.notify("nvim-dap no está cargado", vim.log.levels.WARN) end
end

return M
