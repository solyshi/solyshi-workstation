return {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
        require("colorizer").setup({
          filetypes = {
            "css",
            "javascript",
            html = { mode = "foreground" },
          },
        })
    end
    -- TODO: Enable in specific mode or auto attach everywhere or toggle
}
