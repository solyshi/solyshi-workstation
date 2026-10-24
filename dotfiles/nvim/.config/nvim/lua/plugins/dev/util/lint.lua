-- Linters for filetypes with no LSP that reports diagnostics.
--
-- The motivating case is the install/ tree: bootstrap.sh plus install/lib/*.sh
-- are pure bash and had neither a linter nor a formatter, despite being the
-- code most likely to break a machine. bash-language-server is installed and
-- does offer some shellcheck integration, but only when shellcheck is on PATH
-- *and* only for the open buffer's obvious issues -- running shellcheck
-- directly is explicit and catches more (SC2010, SC2034 and friends).
--
-- shellcheck comes from install/pkg/03-dev-utils.txt, not mason.
--
-- No keymaps: linting is automatic. Diagnostics land in the normal
-- vim.diagnostic store, so <leader>x* (trouble) and <leader>c[lb] already
-- surface them.
return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            -- zsh is deliberately absent: shellcheck cannot parse zsh syntax
            -- and reports the whole file as errors. .zshrc is zsh, so linting
            -- it here would be pure noise.
            sh = { "shellcheck" },
            bash = { "shellcheck" },
        }

        -- try_lint() shells out, so only run it when the linter exists. Without
        -- this a machine that has not run install/ yet gets an error notice on
        -- every save of a shell script.
        local function lint_buf()
            local names = lint._resolve_linter_by_ft(vim.bo.filetype)
            if vim.tbl_isempty(names) then
                return
            end
            for _, name in ipairs(names) do
                local linter = lint.linters[name]
                local cmd = type(linter) == "table" and linter.cmd or nil
                if cmd and vim.fn.executable(cmd) == 0 then
                    return
                end
            end
            lint.try_lint()
        end

        vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
            group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
            callback = lint_buf,
        })

        lint_buf()
    end,
}
