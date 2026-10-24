-- Language *servers* only. Formatters and other CLI tools go in
-- mason-tool-installer.lua; mason-lspconfig can only resolve names that map to
-- an LSP server, which is why "stylua" used to sit in this list doing nothing.
--
-- This is also what actually starts the servers: automatic_enable calls
-- vim.lsp.enable() for everything installed, minus the exclusions below.
return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
        ensure_installed = {
            "asm_lsp",
            "bashls",
            "clangd",
            "cssls",
            "emmet_language_server",
            "eslint",
            "html",
            "jsonls",
            "lemminx",
            "lua_ls",
            "neocmake",
            "omnisharp",
            "pyright",
            "ruff",
            "rust_analyzer",
            "tailwindcss",
            "ts_ls",
            "yamlls",
        },
        automatic_enable = {
            -- Started by nvim-java instead, which sets its own root_dir.
            exclude = { "jdtls", "groovyls", "gradle_ls" },
        },
    },
}
