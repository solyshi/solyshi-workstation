return {
    {
        'nvim-treesitter/nvim-treesitter',
        -- lazy = false and event = "BufRead" were both set; lazy = false wins
        -- and the event was simply ignored. Loading eagerly is what we want,
        -- since highlighting should be up before the first buffer renders.
        lazy = false,
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
            local ts = require("nvim-treesitter")

            -- Install the pinned parser set. This is async; parsers that are
            -- already present are skipped, so it is cheap on later startups.
            if opts.ensure_installed and #opts.ensure_installed > 0 then
                ts.install(opts.ensure_installed)
            end

            -- Start treesitter for any buffer whose language has a parser.
            --
            -- The previous version also called
            -- vim.treesitter.language.register(parser, parser) for every entry,
            -- which only ever registered a language under its own name. That is
            -- a no-op for "c" or "lua" and plain wrong for entries that are not
            -- filetypes at all ("jsdoc", "luadoc", "vimdoc", "json5", "regex")
            -- or whose filetype differs from the parser name ("tsx" is the
            -- parser for the typescriptreact filetype). Neovim already ships
            -- those mappings, so get_lang below is enough.
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
                callback = function(event)
                    local bufnr = event.buf
                    local filetype = vim.bo[bufnr].filetype
                    if filetype == "" then
                        return
                    end

                    -- get_lang never returns nil for a non-empty filetype: it
                    -- falls back to `ft_to_lang[ft] or ft` (see
                    -- runtime/lua/vim/treesitter/language.lua:45). So for an
                    -- ad-hoc scratch filetype like "cheatsheet" this hands back
                    -- "cheatsheet", and the real check has to be whether a
                    -- parser for that name exists.
                    local lang = vim.treesitter.language.get_lang(filetype)
                    if not lang then
                        return
                    end

                    -- Already installed: start immediately.
                    --
                    -- language.add() returns true when the parser is loadable
                    -- and nil + message otherwise. The previous version tested
                    -- `pcall(vim.treesitter.get_parser, ...)` instead, but
                    -- get_parser *returns* nil + message rather than raising,
                    -- so the pcall always succeeded and execution always fell
                    -- through to vim.treesitter.start() -- which does assert,
                    -- and threw "Parser could not be created for buffer N and
                    -- language X" on every parser-less filetype.
                    if vim.treesitter.language.add(lang) then
                        pcall(vim.treesitter.start, bufnr, lang)
                        return
                    end

                    -- Not installed yet. Install in the background and start
                    -- when it lands, so opening the file never blocks.
                    --
                    -- This used to be install(...):wait(30000), which froze the
                    -- editor for up to 30 seconds while a parser compiled.
                    if not vim.tbl_contains(ts.get_available(), lang) then
                        return
                    end

                    ts.install({ lang }):await(function(err)
                        if err then
                            return
                        end
                        -- The callback can run off the main loop, so defer any
                        -- API calls.
                        vim.schedule(function()
                            if not vim.api.nvim_buf_is_valid(bufnr) then
                                return
                            end
                            -- Filetype may have changed while compiling.
                            if vim.bo[bufnr].filetype == filetype then
                                pcall(vim.treesitter.start, bufnr, lang)
                            end
                        end)
                    end)
                end,
            })
        end
    }
}
