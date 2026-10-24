-- Keymap cheatsheet in a floating window, bound to <leader>?.
--
-- Everything is read out of the live keymap table at open time rather than kept
-- in a hand-written list, so it cannot drift from what is actually mapped. A
-- mapping shows up here as soon as it has a `desc`.
--
-- Note lazy.nvim's `keys` specs register real mappings up front (they just load
-- the plugin on first press), so lazy-loaded plugins appear without having been
-- loaded yet.

local M = {}

-- Leader-prefix groups, in display order. Keep in sync with the which-key
-- groups in plugins/core/which-key.lua.
local GROUPS = {
    { key = "f", title = "Find" },
    { key = "F", title = "File operations" },
    { key = "c", title = "Code / LSP" },
    { key = "x", title = "Diagnostics & lists" },
    { key = "g", title = "Git" },
    { key = "t", title = "Toggle" },
    { key = "p", title = "Plugins" },
    { key = "h", title = "Help & docs" },
    { key = "n", title = "Neovim tips" },
    { key = "s", title = "Settings" },
}

local MODE_LABEL = { n = "n", x = "v", v = "v", i = "i", o = "o", t = "t" }

--- Mappings that are noise in a personal cheatsheet.
local function is_noise(lhs, desc)
    -- Neovim's own default mappings describe themselves as ":help X-default"
    -- (Y, &, v_#, i_CTRL-U ...). They are stock Vim behaviour, not config.
    if desc:match("^:help ") then
        return true
    end
    -- The stock [q/]q/[b/]b/... family describes itself as the bare Ex command
    -- it wraps. Useful to know, but it is a documented block of 20-odd
    -- mappings, not something worth scrolling past every time.
    if desc:match("^:%a+$") then
        return true
    end
    -- <Plug> targets are indirection for other mappings, never pressed.
    if lhs:match("^<Plug>") then
        return true
    end
    -- The lua-function names Neovim uses as descs for its gr* LSP defaults
    -- duplicate the <leader>c group, which has readable descriptions.
    if desc:match("^vim%.lsp%.") then
        return true
    end
    return false
end

--- Collect every mapping that carries a description.
--- @return table<string, {lhs:string, desc:string, modes:table<string,boolean>}>
local function collect()
    local by_lhs = {}

    for _, mode in ipairs({ "n", "x", "i", "o", "t" }) do
        for _, m in ipairs(vim.api.nvim_get_keymap(mode)) do
            if m.desc and m.desc ~= "" and not is_noise(m.lhs, m.desc) then
                local entry = by_lhs[m.lhs]
                if not entry then
                    entry = { lhs = m.lhs, desc = m.desc, modes = {} }
                    by_lhs[m.lhs] = entry
                end
                entry.modes[MODE_LABEL[mode] or mode] = true
            end
        end
    end

    return by_lhs
end

--- Render the leader key as "<leader>" instead of a bare space.
local function pretty(lhs)
    local leader = vim.g.mapleader or "\\"
    if lhs:sub(1, #leader) == leader then
        return "<leader>" .. lhs:sub(#leader + 1)
    end
    return lhs
end

local function mode_suffix(modes)
    local list = vim.tbl_keys(modes)
    table.sort(list)
    -- Plain normal-mode mappings are the common case; don't label them.
    if #list == 1 and list[1] == "n" then
        return ""
    end
    return " [" .. table.concat(list, ",") .. "]"
end

--- Build the display lines plus the highlight ranges to apply.
local function build_lines()
    local all = collect()
    local leader = vim.g.mapleader or "\\"

    -- Bucket by leader group; anything else goes to "Other".
    local buckets, used = {}, {}
    for _, g in ipairs(GROUPS) do
        buckets[g.key] = {}
    end

    for lhs, entry in pairs(all) do
        if lhs:sub(1, #leader) == leader then
            local group = lhs:sub(#leader + 1, #leader + 1)
            if buckets[group] then
                table.insert(buckets[group], entry)
                used[lhs] = true
            end
        end
    end

    local other = {}
    for lhs, entry in pairs(all) do
        if not used[lhs] then
            table.insert(other, entry)
        end
    end

    local function by_lhs(a, b)
        return a.lhs < b.lhs
    end

    local lines, highlights = {}, {}
    local function add(text, hl)
        table.insert(lines, text)
        if hl then
            table.insert(highlights, { line = #lines - 1, hl = hl })
        end
    end

    local function section(title, entries)
        if #entries == 0 then
            return
        end
        table.sort(entries, by_lhs)
        add("")
        add("  " .. title, "Title")
        for _, e in ipairs(entries) do
            add(("    %-22s %s%s"):format(pretty(e.lhs), e.desc, mode_suffix(e.modes)))
        end
    end

    add("")
    add("  Keymap cheatsheet", "Title")
    add("  " .. ("─"):rep(60), "Comment")

    for _, g in ipairs(GROUPS) do
        section(("%s  (<leader>%s)"):format(g.title, g.key), buckets[g.key])
    end
    section("Other", other)

    add("")
    add("  q / <Esc> to close", "Comment")
    add("")

    return lines, highlights
end

function M.open()
    local lines, highlights = build_lines()

    local width = 0
    for _, l in ipairs(lines) do
        width = math.max(width, vim.fn.strdisplaywidth(l))
    end
    width = math.min(width + 2, math.floor(vim.o.columns * 0.9))
    local height = math.min(#lines, math.floor(vim.o.lines * 0.8))

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local ns = vim.api.nvim_create_namespace("cheatsheet")
    for _, h in ipairs(highlights) do
        vim.hl.range(buf, ns, h.hl, { h.line, 0 }, { h.line, -1 })
    end

    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = "cheatsheet"

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2) - 1,
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " Keymaps ",
        title_pos = "center",
    })

    vim.wo[win].cursorline = true
    vim.wo[win].wrap = false

    for _, key in ipairs({ "q", "<Esc>" }) do
        vim.keymap.set("n", key, function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
        end, { buffer = buf, nowait = true, silent = true })
    end
end

vim.api.nvim_create_user_command("Cheatsheet", M.open, { desc = "Keymap cheatsheet" })
vim.keymap.set("n", "<leader>?", M.open, { desc = "Keymap cheatsheet" })

return M
