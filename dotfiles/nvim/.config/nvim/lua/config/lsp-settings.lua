vim.diagnostic.config({
    -- virtual_lines = true, -- this gets messy on large code base with tons of errors
    -- Select either virtual lines or text below otherwise it gets messy
    virtual_text = {
        spacing = 4,
        prefix = "●",
    },

    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        -- border comes from the global winborder option (config/options.lua).
        source = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})

-- Advertise blink.cmp's completion capabilities to every server.
--
-- This used to sit inside an Lsp.start() helper that nothing ever called, so
-- servers silently fell back to Neovim's built-in defaults. Those do cover
-- snippetSupport and resolveSupport, but not blink's extras such as
-- completionList.itemDefaults. Servers themselves are started by
-- mason-lspconfig's `automatic_enable`, not from here.
vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities({
        general = { positionEncodings = { "utf-16" } },
    }),
})

-- LSP keymaps, grouped under <leader>c (Code). Diagnostic *lists* live under
-- <leader>x instead, see plugins/dev/util/trouble.lua.
local key_mappings = {
    -- Navigation
    { "<leader>cd", "<cmd>FzfLua lsp_definitions<CR>",     "Go to definition" },
    { "<leader>cD", "<cmd>FzfLua lsp_declarations<CR>",    "Go to declaration" },
    { "<leader>cR", "<cmd>FzfLua lsp_references<CR>",      "References" },
    { "<leader>ci", "<cmd>FzfLua lsp_implementations<CR>", "Implementations" },
    { "<leader>ct", "<cmd>FzfLua lsp_typedefs<CR>",        "Type definitions" },

    -- Actions
    {
        "<leader>ca",
        function()
            require("fzf-lua").lsp_code_actions({})
        end,
        "Code actions",
    },
    { "<leader>cr", vim.lsp.buf.rename, "Rename symbol" },
    {
        "<leader>cf",
        function()
            require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        "Format buffer",
    },
    { "<leader>cq", "<cmd>LspRestart<CR>", "Restart LSP" },

    -- Diagnostics
    { "<leader>cb", "<cmd>FzfLua lsp_document_diagnostics<CR>", "Buffer diagnostics (fzf)" },
    {
        "<leader>cl",
        function()
            vim.diagnostic.open_float()
        end,
        "Line diagnostics",
    },
    {
        "[d",
        function()
            vim.diagnostic.jump({ count = -1, float = true })
        end,
        "Previous diagnostic",
    },
    {
        "]d",
        function()
            vim.diagnostic.jump({ count = 1, float = true })
        end,
        "Next diagnostic",
    },

    -- Docs
    {
        "K",
        function()
            vim.lsp.buf.hover()
        end,
        "Hover documentation",
    },

    -- Toggle
    {
        "<leader>tD",
        function()
            vim.diagnostic.enable(not vim.diagnostic.is_enabled())
        end,
        "Toggle diagnostics",
    },
}

for _, mapping in ipairs(key_mappings) do
    vim.keymap.set("n", mapping[1], mapping[2], {
        noremap = true,
        silent = true,
        desc = mapping[3],
    })
end
