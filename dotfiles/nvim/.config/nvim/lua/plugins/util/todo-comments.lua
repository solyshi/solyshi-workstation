return {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    -- Highlighting has to be live for every buffer, so this loads on read
    -- rather than on a keypress. VeryLazy also worked, but deferred the
    -- highlights until after the first buffer had already been drawn.
    event = { "BufReadPost", "BufNewFile" },
    -- <leader>ft used to be set from inside `config`, i.e. it only existed once
    -- the plugin had loaded. As a `keys` entry it is registered up front.
    keys = {
        { "<leader>ft", "<cmd>TodoFzfLua<cr>",                               desc = "Find TODOs" },
        { "]t",         function() require("todo-comments").jump_next() end, desc = "Next TODO comment" },
        { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous TODO comment" },
    },
    -- `config` calling setup() by hand is equivalent to `opts` here, but opts
    -- is mergeable from other specs and skips the boilerplate.
    opts = {
        keywords = {
            GROUP = { icon = " ", color = "hint" },
            HERE = { icon = " ", color = "here" },
        },
        colors = { here = "#fdf5a4" },
        highlight = { multiline = true },
    },
}
