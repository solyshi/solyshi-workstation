local opt = vim.opt

-- Left Column
opt.number = true         -- Display line numbers
opt.relativenumber = true -- Relative numbers
opt.numberwidth = 2       -- Width of line number column
opt.signcolumn = "yes"    -- Always show sign column
opt.wrap = false          -- Display lines as single lines
opt.scrolloff = 10        -- Number of lines to keep above/beyond cursor
opt.sidescrolloff = 8     -- Number of lines to keep left/right of cursor

-- Tab/Spacing behavior
opt.expandtab = true          -- Convert tabs to spaces
opt.shiftwidth = 4            -- Number of spaces for each indent
opt.tabstop = 4               -- Number of spaces for a tab char
opt.softtabstop = 4           -- Number of spaces for tab key
opt.smartindent = true        -- Enable smart indentation opt.breakindent = true		
opt.backup = false            -- Disable backup files
opt.clipboard = "unnamedplus" -- System clipboard access
opt.encoding = "UTF-8"        -- Set file encoding
opt.showmode = false          -- Hide mode display
opt.splitbelow = true         -- Force splits below
opt.splitright = true         -- Force splits to the right
opt.termguicolors = true      -- Enable Term GUI Colors
opt.undofile = true           -- Enable persistent undo
opt.updatetime = 100          -- Faster completion
opt.writebackup = false       -- Prevent editing of files beeing edited elsewhere
opt.cursorline = true         -- Highlight currentline
opt.swapfile = false          -- Disable creation of swapfile

-- Searching Behaviour
opt.hlsearch = true   -- Highlight all matches in search
opt.ignorecase = true -- Ignore case in search
opt.smartcase = true  -- Match case if explicitly stated
