vim.diagnostic.config({
    -- virtual_lines = true, -- this gets messy on large code base with tons of errors
    -- Select either virtual lines or text below otherwise it gets messy
    virtual_text = {
        spacing = 4,
        prefix = "●", -- This is fine as a string
    },

    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
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

-- define common keybindings
local key_mappings = {
    { "<leader>cR", "<cmd>FzfLua lsp_references<CR>",      "Show LSP references" },
    { "<leader>cD", "<cmd>FzfLua lsp_declarations<CR>",    "Go to declaration" },
    { "<leader>cd", "<cmd>FzfLua lsp_definitions<CR>",     "Show LSP definitions" },
    { "<leader>ci", "<cmd>FzfLua lsp_implementations<CR>", "Show LSP implementations" },
    { "<leader>ct", "<cmd>FzfLua lsp_typedefs<CR>",        "Show LSP type definitions" },
    {
        "<leader>ca",
        function()
            require("fzf-lua").lsp_code_actions({})
        end,
        "Code actions",
    },
    { "<leader>cr", vim.lsp.buf.rename,                         "Smart rename" },
    { "<leader>cb", "<cmd>FzfLua lsp_document_diagnostics<CR>", "Show buffer diagnostics" },
    {
        "<leader>cl",
        function()
            vim.diagnostic.open_float({ border = "rounded" })
        end,
        "Show line diagnostics",
    },
    {
        "[d",
        function()
            vim.diagnostic.jump({ count = -1, float = true })
        end,
        "Go to previous diagnostic",
    },
    {
        "]d",
        function()
            vim.diagnostic.jump({ count = 1, float = true })
        end,
        "Go to next diagnostic",
    },
    {
        "K",
        function()
            vim.lsp.buf.hover({ border = "rounded" })
        end,
        "Show documentation",
    },
    { "<leader>cq", ":LspRestart<CR>", "Restart LSP" },
    {
        "<leader>tD",
        function()
            local is_enabled = vim.diagnostic.is_enabled()
            vim.diagnostic.enable(not is_enabled)
        end,
        "Toggle Diagnostics for this repo",
    },
}
-- set all keybindings
for _, mapping in ipairs(key_mappings) do
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", mapping[1], mapping[2], vim.tbl_extend("force", opts, { desc = mapping[3] }))
end

local servers = {
    -- lspconfigName
    "asm_lsp",
    "bashls",
    "cssls", -- with  vscode-langservers-extracted
    "clangd",
    "neocmake",
    "emmet_language_server", -- with default-npm-packages
    "eslint",                -- with vscode-langservers-extracted
    "html",                  -- with  vscode-langservers-extracted
    "jsonls",                -- with  vscode-langservers-extracted
    "lua_ls",                -- lsp/formatter
    "ts_ls",                 -- "typescript-language-server"
    "yamlls",                -- "yaml-language-server",
    "pyright",
    "ruff",
    "rust_analyzer",
    "lemminx"
}

local Lsp = {}

local function init()
    -- populate list of servers from lsp/*.lua configs
    local config_files = vim.api.nvim_get_runtime_file('lsp/*.lua', true)

    for _, config_file in ipairs(config_files) do
        local name = config_file:match("([^/]*)%.lua$")

        if name and (name:len() > 0) then
            if not vim.tbl_contains(table, name) then
                table.insert(servers, name)
            end
        end
    end

    return Lsp
end

-- enables and starts clients relevant to the filetype of the current buffer
function Lsp.start()
    for _, name in ipairs(servers) do
        local filetypes = vim.lsp.config[name] and vim.lsp.config[name].filetypes

        if filetypes and vim.tbl_contains(filetypes, vim.bo.filetype) then
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            vim.lsp.config("*", {
                capabilities = capabilities,
            })
            vim.lsp.enable(name)
        end
    end
end

-- stops and disables clients connected to the current buffer
function Lsp.stop()
    local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })

    for _, client in ipairs(clients) do
        vim.lsp.enable(client.name, false)
    end
end

-- toggle LSP for the file type of the current buffer
function Lsp.toggle()
    -- clients active for the current buffer
    local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })

    if vim.tbl_isempty(clients) then
        Lsp.start()
    else
        Lsp.stop()
    end
end

return init()
