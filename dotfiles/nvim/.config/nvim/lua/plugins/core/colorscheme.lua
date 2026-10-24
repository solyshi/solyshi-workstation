return {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    -- The globals have to be set before the colorscheme is sourced, so they go
    -- in `init`; `config` then only has the one line that applies it.
    init = function()
        vim.g.sonokai_enable_italic = true
        vim.g.sonokai_style = "espresso"
    end,
    config = function()
        -- Applied synchronously. This used to be wrapped in
        -- vim.defer_fn(..., 0), which pushes the colorscheme to the next
        -- event-loop tick -- so the first frame rendered with the default
        -- scheme and then repainted, which is the startup flash.
        vim.cmd.colorscheme("sonokai")
    end,
}
