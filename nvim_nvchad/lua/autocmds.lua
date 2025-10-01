require "nvchad.autocmds"

-- Adjuntar nvim-navic a los LSP servers para breadcrumbs
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.documentSymbolProvider then
      local ok, navic = pcall(require, "nvim-navic")
      if ok then
        navic.attach(client, args.buf)
      end
    end
  end,
})
