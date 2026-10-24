return {
    "windwp/nvim-ts-autotag",
    -- Only does anything in markup, and needs a treesitter parser for the
    -- buffer. The aliases table in config/plugin.lua maps these filetypes onto
    -- its html / typescriptreact tag configs.
    ft = {
        "html", "xml", "markdown", "php", "htmldjango",
        "javascript", "javascriptreact", "typescript", "typescriptreact",
        "vue", "astro", "svelte", "eruby", "handlebars",
    },
    -- enable_close / enable_rename / enable_close_on_slash were spelled out
    -- here with a "-- Defaults" comment, and they were indeed all three already
    -- the defaults (see Opts in nvim-ts-autotag/config/plugin.lua:146).
    --
    -- The nesting under an inner `opts` key was correct and is kept: the flat
    -- form is the legacy layout and makes setup() emit a deprecation warning.
    opts = {},
}
