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
      markdown = { "prettier" },
    })

    -- Respeta toggles global/buffer:
    --   vim.g.disable_autoformat = true        -> desactiva para todos
    --   vim.b[bufnr].disable_autoformat = true -> desactiva solo ese buffer
    opts.format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      -- evita archivos muy grandes
      local max = 300 * 1024 -- 300 KB
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
        markdown = { "markdownlint-cli2" },
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
    enabled = false,
    ft = { "bzl", "starlark", "bazel" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
    -- 👇 Esto se ejecuta ANTES de cargar bazel.nvim cuando se cumpla el ft,
    -- garantizando que el provider Python3 esté habilitado y con el venv correcto.
    init = function()
      -- Fuerza habilitar provider (por si algún módulo lo deshabilitó antes)
      vim.g.loaded_python3_provider = nil
      -- Asegura la ruta del venv que ya tienes
      vim.g.python3_host_prog = vim.fn.expand("~/.venvs/neovim/bin/python")

      -- 🚫 Señal para no cargar el Vimscript heredado
      -- Muchos plugins siguen esta convención; bazel.nvim la respeta.
      vim.g.loaded_bazel_vim = 1
      vim.g.loaded_bazel = 1
    end,
  },
}
