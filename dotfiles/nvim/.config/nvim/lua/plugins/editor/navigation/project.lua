return {
  'DrKJeff16/project.nvim',
  dependencies = { -- OPTIONAL
    'ibhagwan/fzf-lua',
  },
  config = function()
      local project = require("project")

      -- Keymaps
      vim.keymap.set("n", "<leader>ps", "<cmd>:ProjectFzf<cr>", { desc = "Switch Project FZF" })
      vim.keymap.set("n", "<leader>pa", "<cmd>:ProjectAdd<cr>", { desc = "Add Project" })
      vim.keymap.set("n", "<leader>ph", "<cmd>:ProjectHistory<cr>", { desc = "Project History" })
      vim.keymap.set("n", "<leader>pc", "<cmd>:ProjectConfig<cr>", { desc = "Project Config" })
      vim.keymap.set("n", "<leader>pd", "<cmd>:ProjectDelete<cr>", { desc = "Delete a Project" })

      project.setup({
          show_hidde = true,
          fzf_lua = {
              enabled = true,
          }
      })
  end
}
