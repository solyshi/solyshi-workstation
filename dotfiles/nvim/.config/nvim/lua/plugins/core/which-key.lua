return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
        config = function()
            local wk = require("which-key")

            wk.add({
                { "<leader>f", group = "Find" },
                { "<leader>F", group = "Files" },
                { "<leader>t", group = "Tools" },
                { "<leader>h", group = "Help" },
                { "<leader>s", group = "Settings" },
                { "<leader>c", group = "Code" },
                { "<leader>n", group = "Neovim Tips" },
                { "<leader>b", group = "Build System" },
                { "<leader>g", group = "Git" },
            })
        end
    }
}
