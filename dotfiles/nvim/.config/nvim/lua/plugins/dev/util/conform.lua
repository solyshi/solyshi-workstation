return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    -- `opts = {}` used to sit alongside a `config` that called setup() with a
    -- completely different table. lazy.nvim passes opts to config as the second
    -- argument, which this ignored, so the empty table was dead weight. The
    -- real config is the opts table now.
    --
    -- The <leader>cf manual-format mapping lives in config/lsp-settings.lua
    -- with the other code actions.
    opts = {
        format_on_save = {
            timeout_ms = 5000,
            -- Fall back to the LSP's own formatter for filetypes with no
            -- entry below (and when a listed formatter is not installed).
            lsp_format = "fallback",
        },
        formatters_by_ft = {
            -- clang-format comes from the system clang package, not mason, so
            -- it tracks the compiler version.
            c = { "clang-format" },
            cpp = { "clang-format" },
            css = { "prettier" },
            html = { "prettier" },
            javascript = { "prettier" },
            javascriptreact = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            json = { "prettier" },
            jsonc = { "prettier" },
            yaml = { "prettier" },
            lua = { "stylua" },
            -- shfmt from install/pkg/03-dev-utils.txt, not mason. Paired with
            -- shellcheck in dev/util/lint.lua -- the install/ tree is all bash
            -- and had no formatter. zsh is left out: shfmt cannot parse it, and
            -- .zshrc is zsh.
            sh = { "shfmt" },
            bash = { "shfmt" },
            -- Two passes: sort imports, then format.
            python = { "ruff_organize_imports", "ruff_format" },
            -- There is no `cs` entry. It mapped to csharpier, which is a
            -- `dotnet tool` and so uninstallable without a dotnet SDK; C# files
            -- fall through to lsp_format = "fallback" above.
        },
        formatters = {
            ["clang-format"] = {
                -- Prefer a project .clang-format; LLVM style only if none
                -- exists. Matches the --enable-config flag passed to clangd
                -- in lsp/clangd.lua so the two agree on style.
                prepend_args = { "-style=file", "-fallback-style=LLVM" },
            },
            prettier = {
                -- Only run where the project actually opts in via a prettier
                -- config file, so prettier's defaults are never imposed on a
                -- repo that has its own conventions.
                require_cwd = true,
            },
        },
    },
}
