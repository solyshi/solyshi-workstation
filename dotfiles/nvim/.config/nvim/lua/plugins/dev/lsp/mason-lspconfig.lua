return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
        local ok_mason, mason_lspconfig = pcall(require, "mason-lspconfig")

        mason_lspconfig.setup({
            ensure_installed = {
                "ts_ls",
                "asm_lsp",
                "bashls",
                "clangd",
                "neocmake",
                "omnisharp",
                "cssls",
                "gradle_ls",
                "groovyls",
                "html",
                "jsonls",
                "lua_ls",
                "pyright",
                "tailwindcss",
                "rust_analyzer",
                "lemminx",
                "eslint",
                "stylua",
                "emmet_language_server",
            },
            automatic_enable = {
                exclude = { "jdtls", "groovyls", "gradle_ls" },
            },
        })
    end,
}
