return {
	"williamboman/mason.nvim",
	cmd = {
		"Mason",
		"MasonInstall",
		"MasonInstallAll",
		"MasonUpdate",
		"MasonUninstall",
		"MasonUninstallAll",
		"MasonLog",
	},
	keys = {
		{ "<leader>tm", "<cmd>Mason<cr>", desc = "Mason" },
	},
	opts = {
		ui = {
			border = vim.g.border_enabled and "rounded" or "none",
			check_outdated_packages_on_open = false,
			icons = {
				package_pending = " ",
				package_installed = " ",
				package_uninstalled = " ",
			},
		},
		registries = {
			"github:nvim-java/mason-registry",
			"github:mason-org/mason-registry",
		},
	},
}
