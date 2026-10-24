-- Add/delete/replace surrounding brackets, quotes and tags.
--
-- Same nvim-mini family as mini.animate in editor/visuals/cursor.lua, so this
-- adds no new ecosystem.
--
-- Prefix is `gs`, not mini.surround's default `s`. Both were free, but bare `s`
-- is the builtin substitute-character operator, which is genuinely useful and
-- would be shadowed. `gs` only shadows the builtin `gs` (:sleep), which has no
-- real interactive use. So:
--
--   gsa  add         gsaiw"  ->  surround inner word with quotes
--   gsd  delete      gsd"    ->  remove surrounding quotes
--   gsr  replace     gsr"'   ->  change " to '
--   gsf / gsF        jump to next/previous surrounding
--   gsn              update the number of surroundings to operate on
return {
    "nvim-mini/mini.surround",
    version = "*",
    keys = {
        { "gsa", desc = "Add surrounding", mode = { "n", "x" } },
        { "gsd", desc = "Delete surrounding" },
        { "gsr", desc = "Replace surrounding" },
        { "gsf", desc = "Find surrounding (right)" },
        { "gsF", desc = "Find surrounding (left)" },
        { "gsh", desc = "Highlight surrounding" },
        { "gsn", desc = "Update n lines" },
    },
    opts = {
        mappings = {
            add = "gsa",
            delete = "gsd",
            replace = "gsr",
            find = "gsf",
            find_left = "gsF",
            highlight = "gsh",
            update_n_lines = "gsn",
            -- Defaults for these two are `suffix`-style additions to the above
            -- and are left off: they bind bare brackets in visual mode.
            suffix_last = "",
            suffix_next = "",
        },
    },
}
