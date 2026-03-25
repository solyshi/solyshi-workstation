return {
    'stevearc/overseer.nvim',
    ---@module 'overseer'
    ---@type overseer.SetupOpts
    config = function()
        require("overseer").setup()
    end
}
