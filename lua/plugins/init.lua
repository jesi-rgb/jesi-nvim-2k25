-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {}
    end,
  },
  {
    'L3MON4D3/LuaSnip',
  },
  { 'tpope/vim-fugitive' },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    opts = { disable_background = true },
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    opts = { flavour = 'auto' },
  },

  { 'ThePrimeagen/harpoon' },

  {
    'Exafunction/codeium.vim',
  },

  { 'evanleck/vim-svelte' },
  { 'nvim-lualine/lualine.nvim' },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
  },
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
  },
}
