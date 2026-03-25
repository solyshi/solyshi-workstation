return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    config = function()
        local fzf = require("fzf-lua")
        fzf.register_ui_select({ silent = true })

        -- Keymaps
        -- FUZZY FINDING
        vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Fuzzy Find Files" })
        vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Fuzzy Find Buffers" })
        vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent Files" })

        -- COMMANDS
        vim.keymap.set("n", "<leader>fx", fzf.commands, { desc = "Fuzzy VIM Commands" })
        vim.keymap.set("n", "<leader>fo", fzf.builtin, { desc = "Fuzzy FZF Commands" })

        -- HELP
        vim.keymap.set("n", "<leader>hh", fzf.help_tags, { desc = "Fuzzy Help Tags" })
        vim.keymap.set("n", "<leader>hk", fzf.keymaps, { desc = "Fuzzy Keymaps" })
        vim.keymap.set("n", "<leader>hm", fzf.manpages, { desc = "Fuzzy MAN Pages" })
        vim.keymap.set("n", "<leader>hn", fzf.nvim_options, { desc = "Fuzzy NVIM options" })

        -- SETTINGS / COLORSCHEME
        vim.keymap.set("n", "<leader>sc", fzf.colorschemes, { desc = "Fuzzy Colorschemes" })
        vim.keymap.set("n", "<leader>sC", fzf.awesome_colorschemes, { desc = "Fuzzy Awesome Colorschemes" })

        -- GREP / LIVE GREP
        vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live Grep" })
        vim.keymap.set("n", "<leader>fw", fzf.grep_cword, { desc = "Grep on Cursor" })
        vim.keymap.set("v", "<leader>fv", fzf.grep_visual, { desc = "Grep in Visual Mode" })
        -- DEPRECATED TODO: Update vim.keymap.set("n", "<leader>fG", fzf.live_grep_resume, { desc = "Live Grep Resume" })

        fzf.setup({
            keymap = {
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
            }
        })
    end
}
