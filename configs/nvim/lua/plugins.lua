return {
    { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
    { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
    { 'nvim-tree/nvim-tree.lua' },
    { 'folke/which-key.nvim' },
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    { 'williamboman/mason.nvim' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/nvim-cmp' },
    { 'nvim-lualine/lualine.nvim' },
    { 'lewis6991/gitsigns.nvim' },
}
