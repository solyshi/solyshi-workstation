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
                "fish_lsp",
                "gradle_ls",
                "groovyls",
                "html",
                "jsonls",
                "lua_ls",
                "pyright",
                "tailwindcss",
                "rust_analyzer"
            },
            automatic_enable = {
                exclude = { "jdtls" },
            },
        })
    end,
}
