return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- Deliberately eager. register_ui_select() below takes over vim.ui.select
    -- for the whole session, and snacks' picker is disabled (core/snacks.lua),
    -- so if fzf only loaded on one of its own keys then every other plugin's
    -- vim.ui.select -- LSP code actions, genghis' folder picker -- would get
    -- the plain built-in list until the first <leader>f press.
    --
    -- `keys` is still listed: lazy.nvim registers those descriptions up front,
    -- which is what makes them show up in which-key and the <leader>?
    -- cheatsheet, and it keeps them out of `config`.
    lazy = false,
    keys = {
        -- Files & buffers
        { "<leader>ff", "<cmd>FzfLua files<cr>",            desc = "Find files" },
        { "<leader>fb", "<cmd>FzfLua buffers<cr>",          desc = "Find buffers" },
        { "<leader>fr", "<cmd>FzfLua oldfiles<cr>",         desc = "Recent files" },
        -- Grep
        { "<leader>fg", "<cmd>FzfLua live_grep<cr>",        desc = "Live grep" },
        { "<leader>fw", "<cmd>FzfLua grep_cword<cr>",       desc = "Grep word under cursor" },
        { "<leader>fv", "<cmd>FzfLua grep_visual<cr>",      mode = "x", desc = "Grep selection" },
        -- grep_last re-runs the previous search pattern; resume reopens the
        -- previous picker with its position and query intact. The old config
        -- labelled grep_last "Live Grep Resume", which is the other one.
        { "<leader>fG", "<cmd>FzfLua grep_last<cr>",        desc = "Repeat last grep" },
        { "<leader>fR", "<cmd>FzfLua resume<cr>",           desc = "Resume last picker" },
        -- Commands
        { "<leader>fx", "<cmd>FzfLua commands<cr>",         desc = "Vim commands" },
        { "<leader>fo", "<cmd>FzfLua builtin<cr>",          desc = "All fzf-lua pickers" },

        -- Help & docs. Grouped under <leader>h with which-key's buffer-local
        -- list (hw) and the Zeal lookups (hz/hZ).
        { "<leader>hh", "<cmd>FzfLua help_tags<cr>",        desc = "Help tags" },
        { "<leader>hk", "<cmd>FzfLua keymaps<cr>",          desc = "Search keymaps" },
        { "<leader>hm", "<cmd>FzfLua manpages<cr>",         desc = "Man pages" },
        { "<leader>hn", "<cmd>FzfLua nvim_options<cr>",     desc = "Neovim options" },

        -- Settings
        { "<leader>sc", "<cmd>FzfLua colorschemes<cr>",     desc = "Colorschemes (installed)" },
        { "<leader>sC", "<cmd>FzfLua awesome_colorschemes<cr>", desc = "Colorschemes (browse)" },
    },
    config = function()
        local fzf = require("fzf-lua")

        fzf.setup({
            keymap = {
                -- C-j/C-k to move, C-n/C-p for query history, in both the
                -- Lua-side ("builtin") previewer bindings and the fzf process.
                builtin = {
                    ["<C-j>"] = "down",
                    ["<C-k>"] = "up",
                    ["<C-n>"] = "next-history",
                    ["<C-p>"] = "prev-history",
                },
                fzf = {
                    ["ctrl-j"] = "down",
                    ["ctrl-k"] = "up",
                },
            },
        })

        -- After setup, so the ui.select wrapper picks up the keymap config.
        fzf.register_ui_select({ silent = true })
    end,
}
