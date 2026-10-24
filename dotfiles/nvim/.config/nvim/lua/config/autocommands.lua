vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        -- vim.highlight is a deprecated alias for vim.hl since 0.11, see
        -- runtime/lua/vim/_core/editor.lua -> _defer_deprecated_module.
        vim.hl.on_yank()
    end,
})

-- Format-on-save lives in conform's own `format_on_save` option, see
-- plugins/dev/util/conform.lua. A hand-rolled BufWritePre autocmd used to sit
-- here as well, which meant every write got formatted twice.
