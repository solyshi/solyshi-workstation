-- Zeal offline docs. The three keymaps moved from <leader>z / <leader>Z to
-- <leader>hz / <leader>hZ so that looking something up sits with the rest of
-- Help & docs instead of occupying two top-level leader keys on its own.
local function open_zeal(cmd)
    return function()
        vim.cmd(cmd)
        -- Zeal lives on a Hyprland special workspace, so launching it is not
        -- enough -- the workspace has to be pulled into view as well. The delay
        -- gives the window time to exist before we toggle to it.
        vim.defer_fn(function()
            vim.system({ "hyprctl", "dispatch", "togglespecialworkspace", "zeal" })
        end, 300)
    end
end

return {
    "KabbAmine/zeavim.vim",
    cmd = { "Zeavim", "ZVVisSelection", "ZVKeyDocset", "ZVOperator" },
    keys = {
        { "<leader>hz", open_zeal("Zeavim"),               desc = "Zeal: look up word under cursor" },
        { "<leader>hz", open_zeal("'<,'>ZVVisSelection"),  mode = "x", desc = "Zeal: look up selection" },
        { "<leader>hZ", open_zeal("ZVKeyDocset"),          desc = "Zeal: look up, choosing docset" },
    },
    -- A Vimscript plugin configured through a global, so this has to be set
    -- before the plugin's own code runs -- `init`, not `config`.
    init = function()
        vim.g.zeavim_docsets = {
            ["javascriptreact"] = "javascript,react",
            ["typescriptreact"] = "typescript,react",
            ["python"]          = "python 3",
            ["java"]            = "java",
            ["cpp"]             = "c++",
            ["cmake"]           = "cmake",
            ["lua"]             = "lua 5.4",
            ["sh"]              = "bash",
        }
    end,
}
