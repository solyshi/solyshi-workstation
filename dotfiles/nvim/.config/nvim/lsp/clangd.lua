-- Note this replaces nvim-lspconfig's `cmd` outright rather than merging into
-- it, so every flag clangd should get has to be listed here.
return {
    cmd = {
        "clangd",
        "--all-scopes-completion",
        "--suggest-missing-includes",
        "--clang-tidy",
        "--offset-encoding=utf-16",
        "--header-insertion=never",
        -- Let clangd read a project-local .clangd file.
        "--enable-config",
        -- A literal "--query-driver=<list-of-white-listed-complers>" used to be
        -- passed here, i.e. the unfilled template text straight from the docs.
        -- Only add --query-driver back with a real glob, e.g.
        -- --query-driver=/usr/bin/arm-none-eabi-*, when cross-compiling.
    },
    -- "h" is not a Neovim filetype: .h files resolve to c or cpp depending on
    -- content, so listing it here never matched anything.
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
}
