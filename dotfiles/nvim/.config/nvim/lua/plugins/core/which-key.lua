return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- Group labels are registered in `config` below rather than through
            -- opts.spec, so they sit next to the comment explaining the layout.
        },
        keys = {
            {
                -- Moved off <leader>? , which is now the full keymap cheatsheet
                -- (config/cheatsheet.lua). This one only lists *buffer-local*
                -- mappings, which is a much narrower thing and belongs in Help.
                "<leader>hw",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer-local keymaps (which-key)",
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)

            -- One group per leader prefix. config/cheatsheet.lua uses the same
            -- set of prefixes and titles, so keep the two in step when adding
            -- a new group.
            wk.add({
                { "<leader>f", group = "Find" },
                { "<leader>F", group = "File operations" },
                { "<leader>c", group = "Code / LSP" },
                { "<leader>x", group = "Diagnostics & lists" },
                { "<leader>r", group = "Replace" },
                { "<leader>g", group = "Git" },
                { "<leader>t", group = "Toggle" },
                { "<leader>p", group = "Plugins" },
                { "<leader>h", group = "Help & docs" },
                { "<leader>n", group = "Neovim tips" },
                { "<leader>s", group = "Settings" },
                -- A "<leader>b / Build System" group used to be declared here
                -- with nothing under it: its only consumer was cmake-tools,
                -- which was in the tree with `enabled = false` and has been
                -- removed. An empty group shows up as a dead-end submenu.
            })
        end,
    },
}
