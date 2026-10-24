return {
    "tris203/precognition.nvim",
    event = "BufReadPost",
    opts = {
        startVisible = false,
        showBlankVirtLine = false,
        highlightColor = { link = "Comment" },
        hints = {
            Caret        = { text = "^", prio = 2 },
            Dollar       = { text = "$", prio = 1 },
            MatchingPair = { text = "%", prio = 5 },
            Zero         = { text = "0", prio = 1 },
            w            = { text = "w", prio = 10 },
            b            = { text = "b", prio = 9 },
            e            = { text = "e", prio = 8 },
            W            = { text = "W", prio = 7 },
            B            = { text = "B", prio = 6 },
            E            = { text = "E", prio = 5 },
        },
    },
    keys = {
        -- <leader>tp was also claimed by triforce's profile window, so one of
        -- the two always lost. Precognition keeps the Toggle slot since it is a
        -- display toggle; triforce moved to <leader>pt.
        { "<leader>tp", function() require("precognition").toggle() end, desc = "Toggle Precognition hints" },
    },
}
