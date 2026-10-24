return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        picker    = { enabled = false },
        input     = { enabled = true },
        notifier  = { enabled = true },
        dashboard = { enabled = true },
        bigfile   = { enabled = true },
        indent    = { enabled = true },
        terminal  = { enabled = true },
        -- The three below ship with snacks and were already installed, just
        -- never switched on.
        --
        -- scratch: a persistent per-cwd+filetype buffer. Useful for trying a
        -- Lua snippet against the running Neovim without leaving a file behind.
        scratch   = { enabled = true },
        -- gitbrowse: open the current file/line on the forge.
        gitbrowse = { enabled = true },
        -- words: highlights other references to the symbol under the cursor via
        -- LSP document highlight, and makes them navigable.
        words     = { enabled = true },
    },
    keys = {
        { "<leader>tt", function() Snacks.terminal.toggle() end, desc = "Toggle Terminal" },

        -- Scratch buffer. <leader>. is the upstream convention.
        { "<leader>.",  function() Snacks.scratch() end,         desc = "Toggle scratch buffer" },
        { "<leader>S",  function() Snacks.scratch.select() end,  desc = "Select scratch buffer" },

        -- Sits in the Git group next to the octo/neogit mappings. <leader>go is
        -- already taken by octo's "View Repo", so this is gb for "browse".
        {
            "<leader>gb",
            function() Snacks.gitbrowse() end,
            mode = { "n", "x" },
            desc = "Open file/line in browser",
        },

        -- Jump between references to the symbol under the cursor. Both were
        -- unmapped; ]] / [[ are the upstream suggestion and read naturally
        -- alongside the other ]x / [x motions.
        { "]]",         function() Snacks.words.jump(1, true) end,  desc = "Next reference",     mode = { "n", "t" } },
        { "[[",         function() Snacks.words.jump(-1, true) end, desc = "Previous reference", mode = { "n", "t" } },
    },
}
