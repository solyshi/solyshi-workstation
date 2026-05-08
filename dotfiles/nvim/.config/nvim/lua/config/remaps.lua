vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- Disable arrow keys in normal mode
map("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
map("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
map("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Fast search and replace
map('n', '<C-f>', 'viw"-y:%s/<C-r>-/<C-r>-/g<Left><Left>');
-- map('v', '<C-f>', '"-y:%s/<C-r>-/<C-r>-/g<Left><Left>');
map('v', '<C-f>', '"-y:%s/<C-r>-/<C-r>-/g<Left><Left>');

-- Clear Search highlights
map("n", "<C-c>",
    function()
        vim.cmd([[nohls]])
        return "<C-c>"
    end, { expr = true })
map("n", "<Esc>",
    function()
        vim.cmd([[nohls]])
        return "<Esc>"
    end, { expr = true })

-- The above borks up the cmdline window, so temporarily restore default behaviour
vim.api.nvim_create_autocmd("CmdwinEnter", {
    callback = function()
        map("n", "<C-c>", "<C-c>", { buffer = 0 })
        map("n", "<Esc>", "<Esc>", { buffer = 0 })
    end,
})

-- Scroll by 10 lines
map({ "n", "x" }, "<c-e>", '@="10<c-v><c-e>"<cr>', { silent = true })
map({ "n", "x" }, "<c-y>", '@="10<c-v><c-y>"<cr>', { silent = true })

-- Select all
map("n", "<leader>a", "ggVG");
