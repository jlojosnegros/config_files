return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function(_, opts)
      opts = opts or {}
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        c   = { "clang-format" },
        cpp = { "clang-format" },
        rust = { "rustfmt" },
        bzl = { "buildifier" },
        starlark = { "buildifier" },
      })
      opts.format_on_save = function(bufnr)
        local max = 300 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if ok and stats and stats.size > max then return end
        return { lsp_fallback = true, timeout_ms = 1000 }
      end
      return opts
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        c   = { "clangtidy" },
        cpp = { "clangtidy" },
        rust = { "clippy" },
        bzl = { "buildifier" },
        starlark = { "buildifier" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function() require("lint").try_lint() end,
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
    config = function() require("configs.dap") end,
  },
  {
    "alexander-born/bazel.nvim",
    ft = { "bzl", "starlark", "bazel" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
  },
}
