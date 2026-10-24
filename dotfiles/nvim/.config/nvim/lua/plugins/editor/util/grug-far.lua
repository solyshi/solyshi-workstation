-- Project-wide find and replace.
--
-- fzf-lua (<leader>f*) covers finding, but there was nothing for *replacing*
-- across files -- the only substitute mapping was <C-f> in config/remaps.lua,
-- which is :%s on the current buffer.
--
-- grug-far opens a normal, editable buffer: you type into the search/replace
-- fields and the matches update underneath, then <leader>rr syncs the edits to
-- disk. Backed by ripgrep, which is already installed (03-dev-core.txt).
return {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar", "GrugFarWithin" },
    keys = {
        {
            "<leader>rr",
            function()
                require("grug-far").open()
            end,
            desc = "Find & replace (project)",
        },
        {
            "<leader>rw",
            function()
                require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
            end,
            desc = "Find & replace word under cursor",
        },
        {
            "<leader>rf",
            function()
                -- Scope to just this file, as a nicer :%s with live preview.
                require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
            end,
            desc = "Find & replace (current file)",
        },
        {
            "<leader>rr",
            function()
                require("grug-far").open({ visualSelectionUsage = "operate-within-range" })
            end,
            mode = "x",
            desc = "Find & replace within selection",
        },
    },
    opts = {
        -- The default keys collide with nothing here, but spell out the two
        -- that matter so they show up in the buffer header.
        headerMaxWidth = 80,
    },
}
