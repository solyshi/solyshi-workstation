return {
    'nvim-java/nvim-java',
    config = function()
        require('java').setup()
        local java_root = function(bufnr)
            return vim.fs.root(bufnr, {
                'build.gradle',
                'build.gradle.kts',
                'pom.xml',
            })
        end
        vim.lsp.enable('jdtls', { root_dir = java_root })
        vim.lsp.enable('gradle_ls', { root_dir = java_root })
        vim.lsp.enable('groovyls', { root_dir = java_root })
    end,
}
