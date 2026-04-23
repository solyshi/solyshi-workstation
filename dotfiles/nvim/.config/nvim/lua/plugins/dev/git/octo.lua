return {
    "pwntester/octo.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "ibhagwan/fzf-lua",
        "nvim-tree/nvim-web-devicons",
    },
    cmd = "Octo",
    opts = {
        picker = "fzf-lua",
    },
    keys = {
        { "<leader>gi", "<cmd>Octo issue list<cr>",   desc = "List Issues" },
        { "<leader>gI", "<cmd>Octo issue create<cr>", desc = "Create Issue" },
        { "<leader>gp", "<cmd>Octo pr list<cr>",      desc = "List PRs" },
        { "<leader>gP", "<cmd>Octo pr create<cr>",    desc = "Create PR" },
        { "<leader>gR", "<cmd>Octo review start<cr>", desc = "Start Review" },
        { "<leader>go", "<cmd>Octo repo view<cr>",    desc = "View Repo" },
    },
}
