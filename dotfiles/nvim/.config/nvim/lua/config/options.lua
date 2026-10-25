local opt = vim.opt

-- Left Column
opt.number = true -- Display line numbers
opt.relativenumber = true -- Relative numbers
opt.numberwidth = 2 -- Width of line number column
opt.signcolumn = "yes" -- Always show sign column
opt.wrap = false -- Display lines as single lines
opt.scrolloff = 10 -- Number of lines to keep above/beyond cursor
opt.sidescrolloff = 8 -- Number of lines to keep left/right of cursor

-- Tab/Spacing behavior
opt.expandtab = true -- Convert tabs to spaces
opt.shiftwidth = 4 -- Number of spaces for each indent
opt.tabstop = 4 -- Number of spaces for a tab char
opt.softtabstop = 4 -- Number of spaces for tab key
opt.smartindent = true -- Enable smart indentation
opt.breakindent = true -- Preserve indentation on wrapped lines
opt.backup = false -- Disable backup files
opt.clipboard = "unnamedplus" -- System clipboard access

-- Over SSH, copy via OSC 52 so yanks reach the client's clipboard.
-- Needed explicitly: tmux inherits WAYLAND_DISPLAY from Hyprland, so nvim
-- would otherwise pick wl-copy and yank into the remote desktop's clipboard.
if vim.env.SSH_TTY then
    local osc52 = require("vim.ui.clipboard.osc52")
    -- Paste reads the unnamed register instead of asking the terminal: reading
    -- the clipboard via OSC 52 needs a permission prompt in kitty and can
    -- stall. Pasting from the Mac goes through Cmd+V anyway.
    local function paste()
        return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
    end
    vim.g.clipboard = {
        name = "OSC 52",
        copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
        paste = { ["+"] = paste, ["*"] = paste },
    }
end

opt.showmode = false -- Hide mode display
opt.splitbelow = true -- Force splits below
opt.splitright = true -- Force splits to the right
opt.termguicolors = true -- Enable Term GUI Colors
opt.undofile = true -- Enable persistent undo
opt.updatetime = 100 -- Faster completion
opt.writebackup = false -- Don't write a temp backup before overwriting a file
opt.cursorline = true -- Highlight currentline
opt.swapfile = false -- Disable creation of swapfile

-- Searching Behaviour
opt.hlsearch = true -- Highlight all matches in search
opt.ignorecase = true -- Ignore case in search
opt.smartcase = true -- Match case if explicitly stated

-- Live preview of :s/:g/:sort as you type, plus a scratch split listing every
-- match in the file. Pairs with the <C-f> :%s mapping in config/remaps.lua,
-- which previously gave no feedback until the substitution was committed.
opt.inccommand = "split"

-- Default border for every float that does not ask for its own. Replaces the
-- border = "rounded" that was repeated at each call site (diagnostic floats,
-- LSP hover, the <leader>? cheatsheet). mason.nvim keeps its explicit setting,
-- since its ui.border option defaults to "none" rather than deferring here.
opt.winborder = "rounded"

-- Keep the text visually still when a split opens or closes above the current
-- window -- noticeable with trouble.nvim and the quickfix list (<leader>x*).
opt.splitkeep = "screen"

-- linematch aligns changed lines within a hunk instead of diffing the hunk as
-- one block, which makes diffview's output much easier to read. Neovim 0.12
-- already enables it as linematch:40, so this only raises the hunk-size
-- ceiling. It has to replace rather than append: a plain :append left both
-- linematch:40 and linematch:60 in the list.
opt.diffopt = vim.tbl_filter(function(v)
    return not v:match("^linematch:")
end, vim.opt.diffopt:get())
opt.diffopt:append("linematch:60")

-- Prompt to save instead of erroring on :q with unsaved changes.
opt.confirm = true

-- Cap the completion menu so blink.cmp cannot cover most of the buffer.
opt.pumheight = 10

-- stack: <C-o>/<C-i> behave like a browser's back/forward rather than
-- overwriting the jumplist from the middle. view: restore the cursor and scroll
-- position of the window when jumping back.
opt.jumpoptions = "stack,view"

vim.filetype.add({
    extension = {
        fxml = "xml",
    },
})
