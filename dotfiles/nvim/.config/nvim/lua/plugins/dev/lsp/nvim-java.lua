return {
    'nvim-java/nvim-java',
    ft = { 'java', 'groovy' },
    config = function()
        require('java').setup()

        -- Resolve the project root from the build file so multi-module
        -- projects attach at the top level instead of per-module.
        local java_root = function(bufnr)
            return vim.fs.root(bufnr, {
                'build.gradle',
                'build.gradle.kts',
                'pom.xml',
            })
        end

        -- vim.lsp.enable(name, enable) takes a *boolean* second argument, not a
        -- config table (see runtime/lua/vim/lsp.lua: `function lsp.enable(name,
        -- enable)`). The old call passed { root_dir = ... }, which only read as
        -- truthy, so root_dir was silently discarded. It has to go through
        -- vim.lsp.config() instead.
        for _, server in ipairs({ 'jdtls', 'gradle_ls', 'groovyls' }) do
            vim.lsp.config(server, { root_dir = java_root })
            vim.lsp.enable(server)
        end
    end,
}
