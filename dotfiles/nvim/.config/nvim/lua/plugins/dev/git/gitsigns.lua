return {
    "lewis6991/gitsigns.nvim",
    event = {
        "BufReadPost",
        "BufNewFile",
    },
    -- These used to be plain vim.keymap.set calls in `init`, which ran on every
    -- startup and built a `<cmd>lua require'gitsigns'...<cr>` string per key.
    -- As `keys` they are lazy-loading triggers instead, and the functions are
    -- resolved at press time rather than parsed as Vimscript.
    keys = {
        { "<leader>gh", function() require("gitsigns").preview_hunk() end,    desc = "Preview hunk" },
        -- next_hunk/prev_hunk are deprecated in favour of nav_hunk(direction),
        -- see gitsigns/actions.lua: `@deprecated use gitsigns.nav_hunk()`.
        { "<leader>gj", function() require("gitsigns").nav_hunk("next") end,  desc = "Next hunk" },
        { "<leader>gk", function() require("gitsigns").nav_hunk("prev") end,  desc = "Previous hunk" },
        { "<leader>gl", function() require("gitsigns").blame_line() end,      desc = "Blame line" },
        { "<leader>gL", function() require("gitsigns").blame() end,           desc = "Blame file" },
        -- stage_hunk is a toggle: pressed on a staged hunk (the thicker signs
        -- from signs_staged) it unstages it again. There is deliberately no
        -- "undo stage" key -- undo_stage_hunk is deprecated in favour of
        -- exactly this behaviour, see actions.lua:434.
        { "<leader>gs", function() require("gitsigns").stage_hunk() end,     desc = "Stage/unstage hunk" },
        { "<leader>gr", function() require("gitsigns").reset_hunk() end,     desc = "Reset hunk" },
        -- Staging/resetting a selection needs the line range, which gitsigns
        -- reads from the '<,'> marks.
        {
            "<leader>gs",
            function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
            mode = "x",
            desc = "Stage/unstage selection",
        },
        {
            "<leader>gr",
            function() require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
            mode = "x",
            desc = "Reset selection",
        },
    },
    opts = {
        signs = {
            add = { text = "│" },
            change = { text = "│" },
            delete = { text = "󰍵" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
            untracked = { text = "│" },
        },
        -- `on_attach = function() end` used to sit here. gitsigns only treats a
        -- *false* return as "don't attach", so an empty stub was a no-op; the
        -- buffer-local keymaps it exists for are set globally above instead.
    },
}
