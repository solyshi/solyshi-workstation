return {
    "xiyaowong/transparent.nvim",
    -- Must NOT be lazy-loaded. The enabled flag is persisted to
    -- stdpath("data")/transparent_cache and re-applied by an autocmd that
    -- plugin/transparent.vim registers on VimEnter/ColorScheme/FileType. If the
    -- plugin is only pulled in by a key or command, that autocmd never gets
    -- registered and a saved "enabled" state silently does nothing at startup.
    -- Upstream says so outright: "Avoid lazy-loading this plugin to ensure the
    -- highlight-clearing logic is triggered."
    lazy = false,
    keys = {
        { "<leader>tr", "<cmd>TransparentToggle<cr>", desc = "Toggle transparent background" },
    },
    -- The upstream README's default `groups` list, the two empty extra/exclude
    -- tables and the empty `on_clear` stub used to be copied in here verbatim
    -- via a `config` function. Passing values identical to the defaults does
    -- nothing, and setup() is optional for this plugin, so there is nothing
    -- left to configure.
    --
    -- Floats are deliberately left opaque: upstream recommends against
    -- clearing NormalFloat because overlapping transparent windows blend into
    -- each other and become unreadable.
    opts = {},
}
