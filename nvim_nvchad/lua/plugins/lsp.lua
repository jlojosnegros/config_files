return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("configs.lsp")
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      local ensure = { "clangd", "rust-analyzer", "starpls", "codelldb", "clang-format" }
      local present = {}
      for _, v in ipairs(opts.ensure_installed) do present[v] = true end
      for _, v in ipairs(ensure) do if not present[v] then table.insert(opts.ensure_installed, v) end end
      return opts
    end,
  },
}
