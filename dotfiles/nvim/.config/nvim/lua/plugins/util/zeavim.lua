return {
    {
        'KabbAmine/zeavim.vim',
        config = function()
            vim.g.zeavim_docsets = {
                ['javascriptreact'] = 'javascript,react',
                ['typescriptreact'] = 'typescript,react',
                ['python']          = 'python 3',
                ['java']            = 'java',
                ['cpp']             = 'c++',
                ['cmake']           = 'cmake',
                ['lua']             = 'lua 5.4',
                ['sh']              = 'bash',
            }

            vim.keymap.set("n", "<leader>z", function()
                vim.cmd("Zeavim")
                vim.defer_fn(function()
                    vim.fn.system("hyprctl dispatch togglespecialworkspace zeal")
                end, 300)
            end, { desc = "Zeal Suche (Wort)" })

            vim.keymap.set("v", "<leader>z", function()
                vim.cmd("'<,'>ZVVisSelection")
                vim.defer_fn(function()
                    vim.fn.system("hyprctl dispatch togglespecialworkspace zeal")
                end, 300)
            end, { desc = "Zeal Suche (Auswahl)" })

            vim.keymap.set("n", "<leader>Z", function()
                vim.cmd("ZVKeyDocset")
                vim.defer_fn(function()
                    vim.fn.system("hyprctl dispatch togglespecialworkspace zeal")
                end, 300)
            end, { desc = "Zeal Suche (Manuell)" })
        end
    }
}
