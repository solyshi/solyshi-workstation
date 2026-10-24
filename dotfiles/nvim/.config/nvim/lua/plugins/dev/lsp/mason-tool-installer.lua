-- Formatters and other non-LSP tools, using mason *package* names (which do not
-- always match the lspconfig names used in mason-lspconfig.lua).
--
-- Everything listed here is referenced by conform's formatters_by_ft, see
-- plugins/dev/util/conform.lua. prettier was configured there but installed
-- nowhere, so format-on-save silently did nothing for css, html, js(x), ts(x),
-- json, jsonc and yaml.
--
-- Deliberately absent:
--   clang-format -- comes from the system clang package at
--                   /usr/bin/clang-format, so it tracks the compiler, not mason.
--   ruff         -- already installed as a mason LSP server, and the
--                   ruff_format / ruff_organize_imports formatters reuse that
--                   same binary.
--   csharpier    -- a `dotnet tool`, and there is no dotnet SDK on this
--                   machine, so mason cannot build it; listing it just made
--                   every startup retry and fail. The matching `cs` entry in
--                   conform is gone too, so C# formatting falls through to
--                   lsp_format = "fallback". Needs a dotnet-sdk package in
--                   install/pkg before it is worth adding back.
return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
    event = "VeryLazy",
    opts = {
        ensure_installed = {
            "prettier",
            "stylua",
        },
        run_on_start = true,
        -- Don't block startup; install in the background on first launch.
        start_delay = 3000,
    },
}
