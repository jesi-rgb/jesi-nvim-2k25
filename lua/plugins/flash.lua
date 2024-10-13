return {
  'folke/flash.nvim',
  ---type @Flash.Config
  opts = {},
  search = {
    mode = 'search',
  },
  keys = {
    {
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
  },
}
