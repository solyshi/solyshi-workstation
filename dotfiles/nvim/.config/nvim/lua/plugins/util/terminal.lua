return {
    {
      "luxvim/nvim-luxterm",
      config = function()
          vim.keymap.set("n", "<leader>tt", "<cmd>:LuxtermToggle<cr>", { desc = "Toggle Terminal" })
        require("luxterm").setup({
          -- Optional configuration
          manager_width = 0.8,
          manager_height = 0.8,
          preview_enabled = true,
          auto_hide = true,
        })
      end
    },

}
