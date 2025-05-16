require('mason').setup({
    ui = {
        border = "rounded"
    }
})

require("mason-lspconfig").setup {
    ensure_installed = {
        "vimls",
        'eslint',
        'rust_analyzer',
        -- 'pylsp',
        'pyright',
        'ruff',
        'dockerls',
        'docker_compose_language_service',
        'bashls',
        'html',
        'jsonls',
        'ltex',
        'marksman',
        'yamlls',
        'helm_ls',
        'clangd',
        'ts_ls',
        'lua_ls'
    },
    automatic_enable = true
}
