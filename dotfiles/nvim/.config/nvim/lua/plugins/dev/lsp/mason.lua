return {
    -- The williamboman/* org moved; mason-org/* is the canonical home now.
    "mason-org/mason.nvim",
    cmd = {
        "Mason",
        "MasonInstall",
        "MasonUpdate",
        "MasonUninstall",
        "MasonUninstallAll",
        "MasonLog",
    },
    keys = {
        { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = {
        ui = {
            -- Was `vim.g.border_enabled and "rounded" or "none"`, but
            -- border_enabled is never set anywhere, so this always ended up
            -- "none". Rounded matches the LSP hover and diagnostic floats.
            border = "rounded",
            check_outdated_packages_on_open = false,
            icons = {
                package_pending = " ",
                package_installed = " ",
                package_uninstalled = " ",
            },
        },
        registries = {
            "github:nvim-java/mason-registry",
            "github:mason-org/mason-registry",
        },
    },
}
