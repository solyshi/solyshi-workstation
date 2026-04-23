return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        event = "BufRead",
        branch = "main",
        build = ':TSUpdate',
        --- @class TSConfig
        opts = {
            ensure_installed = {
                "asm",
                "bash",
                "c",
                "cpp",
                "css",
                "cmake",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "json5",
                "java",
                "lua",
                "luadoc",
                "markdown",
                "python",
                "regex",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
                "xml",
            }
        },
        config = function(_, opts)
            -- install parsers from opts.ensure_installed
            if opts.ensure_installed and #opts.ensure_installed > 0 then
                require("nvim-treesitter").install(opts.ensure_installed)
                -- register and start parsers for filetypes
                for _, parser in ipairs(opts.ensure_installed) do
                    local filetypes = parser
                    vim.treesitter.language.register(parser, filetypes)

                    vim.api.nvim_create_autocmd({ "FileType" }, {
                        pattern = filetypes,
                        callback = function(event)
                            vim.treesitter.start(event.buf, parser)
                        end,
                    })
                end
            end

            -- Auto install and start parsers for any buffer
            vim.api.nvim_create_autocmd({ "BufRead" }, {
                callback = function(event)
                    local bufnr = event.buf
                    local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

                    -- Skip if no filetype
                    if filetype == "" then
                        return
                    end

                    -- Check if this filetype is already handled by explicit ensure_installed config
                    for _, filetypes in pairs(opts.ensure_installed) do
                        local ft_table = type(filetypes) == "table" and filetypes or { filetypes }
                        if vim.tbl_contains(ft_table, filetype) then
                            return
                        end
                    end

                    -- Get parser name based on ft
                    local parser_name = vim.treesitter.language.get_lang(filetype)
                    if not parser_name then
                        return
                    end

                    -- Try get existing parser
                    local parser_configs = require("nvim-treesitter.parsers")
                    if not parser_configs[parser_name] then
                        return
                    end

                    local parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)
                    if not parser_installed then
                        require("nvim-treesitter").install({ parser_name }):wait(30000)
                    end

                    -- Check again
                    parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)
                    -- Start treesitter
                    if parser_installed then
                        vim.treesitter.start(bufnr, parser_name)
                    end
                end
            })
        end
    }
}
