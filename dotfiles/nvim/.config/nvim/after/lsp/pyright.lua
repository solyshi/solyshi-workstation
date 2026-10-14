-- Prefer the uv/git project root over the nearest pyproject.toml,
-- so workspace members (e.g. apps/api) resolve to the repo root.
local function project_root(bufnr)
    return vim.fs.root(bufnr, { "uv.lock", ".git" })
        or vim.fs.root(bufnr, { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "pyrightconfig.json" })
end

return {
    root_dir = function(bufnr, on_dir)
        on_dir(project_root(bufnr))
    end,

    -- Use <root>/.venv if it exists, otherwise pyright's default (python on PATH).
    before_init = function(_, config)
        local python = config.root_dir and (config.root_dir .. "/.venv/bin/python")
        if python and vim.uv.fs_stat(python) then
            config.settings = config.settings or {}
            config.settings.python = vim.tbl_deep_extend("force", config.settings.python or {}, { pythonPath = python })
        end
    end,
}
