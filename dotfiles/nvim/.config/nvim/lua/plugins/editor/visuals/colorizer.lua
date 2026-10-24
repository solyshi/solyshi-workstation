return {
    "brenoprata10/nvim-highlight-colors",
    -- Needs to be on for the buffer you are reading, not on demand.
    event = { "BufReadPost", "BufNewFile" },
    keys = {
        { "<leader>tc", function() require("nvim-highlight-colors").toggle() end, desc = "Toggle colour swatches" },
    },
    opts = {
        enable_tailwind = true,
        -- 'background' paints the swatch behind the colour code. The
        -- alternatives are 'foreground' and 'virtual'.
        render = "background",
    },
}
