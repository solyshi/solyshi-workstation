return {
    "christoomey/vim-tmux-navigator",
    cmd = {
        "TmuxNavigateLeft", "TmuxNavigateDown",
        "TmuxNavigateUp", "TmuxNavigateRight",
    },
    -- Descriptions added: without them these four showed up in which-key and in
    -- the <leader>? cheatsheet as "(no desc)". Outside tmux they still work --
    -- the plugin falls back to a plain window move.
    keys = {
        { "<C-h>", "<cmd>TmuxNavigateLeft<cr>",  desc = "Go to window/tmux pane left" },
        { "<C-j>", "<cmd>TmuxNavigateDown<cr>",  desc = "Go to window/tmux pane down" },
        { "<C-k>", "<cmd>TmuxNavigateUp<cr>",    desc = "Go to window/tmux pane up" },
        { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to window/tmux pane right" },
    },
}
