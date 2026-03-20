local highlight_groups = {
    "Normal",
    "NonText",
    "LineNr",
    "Folded",
    "EndOfBuffer",
    "SignColumn"
}

for _, group in ipairs(highlight_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
end
