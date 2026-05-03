require('mason').setup()
local lspconfig = require('lspconfig')

lspconfig.pyright.setup({})
lspconfig.gopls.setup({
    settings = { gopls = { gofumpt = true, staticcheck = true } },
})
lspconfig.lua_ls.setup({})

vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})
