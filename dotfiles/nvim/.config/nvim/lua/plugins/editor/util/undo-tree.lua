return {
    "jiaoshijie/undotree",
    dependencies = { "nvim-lua/plenary.nvim" },
    ---@module 'undotree.collector'
    ---@type UndoTreeCollector.Opts
    opts = {},
    keys = {
        -- Was a top-level <leader>u. Moved under Toggle, where the rest of the
        -- "show me a panel" bindings live.
        { "<leader>tu", function() require("undotree").toggle() end, desc = "Toggle undo tree" },
    },
}
