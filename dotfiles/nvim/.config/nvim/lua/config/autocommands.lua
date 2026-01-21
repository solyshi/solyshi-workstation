vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({ bufnr = args.buf })
    end,
})

-- Autocmd: cmake-tools Root auf aktuellen Projektordner setzen
local last_cmake_root = nil

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.c", "*.cmake", "*.h", "*.cpp", "*.cxx" },
    callback = function()
        local ok, cmake_tools = pcall(require, "cmake-tools")
        if not ok then return end

        local cwd = vim.fn.getcwd()
        if not cwd or cwd == "" then return end

        if cwd == last_cmake_root then return end
        last_cmake_root = cwd

        vim.defer_fn(function()
            vim.cmd { cmd = "CMakeSelectCwd", args = { cwd } }
            cmake_tools.select_cwd(cwd)
            cmake_tools.select_build_dir(cwd)
            -- Optional: Info ausgeben
            vim.notify("cmake-tools Projekt-Root gesetzt auf: " .. cwd, vim.log.levels.INFO)
        end, 50)
    end,
})
