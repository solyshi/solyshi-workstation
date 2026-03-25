return {
    "gisketch/triforce.nvim",
    dependencies = { "nvzone/volt" },
    config = function()
        -- Workaround für den E565 Fehler:
        -- Wir packen den Aufruf von Triforce in einen Safe-Context
        local triforce = require("triforce")

        -- Wir "wrappen" vim.notify temporär, falls Triforce es direkt nutzt
        local original_notify = vim.notify
        vim.notify = function(msg, level, opts)
            vim.schedule(function()
                original_notify(msg, level, opts)
            end)
        end

        triforce.setup({
            keymap = {
                show_profile = "<leader>tp",
            }
        })

        -- Nachdem setup durch ist, setzen wir notify zurück (optional)
        -- oder lassen es für alle Plugins safe (empfohlen)
    end
}
