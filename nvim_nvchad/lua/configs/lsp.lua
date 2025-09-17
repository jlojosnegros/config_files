local nvlsp = require("nvchad.configs.lspconfig")
nvlsp.defaults()

vim.lsp.config('clangd', {
  cmd = { 'clangd',
   '--background-index',
   '--clang-tidy',
   '--header-insertion=iwyu', -- <<- options: never, iwyu, insert. iwyu (include-what-you-need) no tan permisiva como "insert"
   -- "--header-insertion-decorators", -- opcional: añade comentarios con el origen del include
   },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  root_markers = { 'compile_commands.json', '.clangd', 'WORKSPACE', 'WORKSPACE.bazel', 'MODULE.bazel', '.git' },
})

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      cargo = { allFeatures = true },
      check = { command = "clippy" },
      inlayHints = { locationLinks = false },
    },
  },
  root_markers = { 'Cargo.toml', '.git' },
})

vim.lsp.config('starpls', {
  filetypes = { 'bzl', 'starlark', 'bazel' },
  root_markers = { 'WORKSPACE', 'WORKSPACE.bazel', '.git' },
})

vim.lsp.enable({ 'clangd', 'rust_analyzer', 'starpls' })
