-- On Neovim 0.11+ this plugin acts as a data package: it ships the per-server
-- `lsp/*.lua` definitions that vim.lsp.config() merges, and nothing here should
-- call its legacy setup(). The empty config is deliberate -- overriding it is
-- what stops lspconfig from also configuring servers the old way.
--
-- Local overrides live in lsp/ and after/lsp/ at the config root; servers are
-- enabled by mason-lspconfig's automatic_enable.
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function() end,
}
