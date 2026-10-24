-- File operations on the current buffer's file.
--
-- The previous mappings called `<cmd>:Genghis createNewFile<cr>` and friends.
-- nvim-genghis dropped its `:Genghis` user command -- the plugin is a pure Lua
-- API now (see genghis/init.lua, which only exports setup/navigateToFileInFolder
-- plus an __index that forwards to operations.file / operations.copy). So all
-- five of those mappings were dead: pressing them raised "Not an editor
-- command: Genghis". They are function calls here instead.
--
-- vim.ui.input is provided by snacks.nvim (input = { enabled = true } in
-- core/snacks.lua), which is what makes the prompts usable; trashFile shells
-- out to `gio trash` on Linux.
local function op(name)
    return function() require("genghis")[name]() end
end

return {
    "chrisgrieser/nvim-genghis",
    keys = {
        -- Create / duplicate
        { "<leader>Fn", op("createNewFile"),           desc = "New file (alongside current)" },
        { "<leader>FN", op("createNewFileInFolder"),   desc = "New file (pick folder)" },
        { "<leader>Fc", op("duplicateFile"),           desc = "Duplicate current file" },
        -- Move / rename. Both update LSP import statements where the server
        -- supports workspace/willRenameFiles.
        { "<leader>Fr", op("renameFile"),              desc = "Rename current file" },
        { "<leader>Fm", op("moveToFolderInCwd"),       desc = "Move to folder in cwd" },
        { "<leader>FM", op("moveAndRenameFile"),       desc = "Move and rename (like mv)" },
        -- Destructive / system
        { "<leader>Fd", op("trashFile"),               desc = "Trash current file" },
        { "<leader>Fx", op("chmodx"),                  desc = "chmod +x current file" },
        -- Copy the path in various shapes
        { "<leader>Fp", op("copyFilepath"),            desc = "Copy absolute path" },
        { "<leader>FP", op("copyRelativePath"),        desc = "Copy relative path" },
        { "<leader>Fy", op("copyFilename"),            desc = "Copy filename" },
        -- Visual-line: lifts the selection out into a file of its own.
        { "<leader>Fe", op("moveSelectionToNewFile"),  mode = "x", desc = "Extract selection to new file" },
    },
    opts = {},
}
