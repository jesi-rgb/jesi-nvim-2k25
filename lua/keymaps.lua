local harpoon_ui = require 'harpoon.ui'
local harpoon_mark = require 'harpoon.mark'

vim.keymap.set('n', '<leader>gd', ':Git diff<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gs', ':Git status<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>b', harpoon_ui.toggle_quick_menu)
vim.keymap.set('n', '<leader>j', harpoon_mark.add_file, { desc = 'Add file to Harpoons buffer' })
vim.keymap.set('n', 'ga', harpoon_ui.nav_next)

vim.keymap.set('v', 'y', 'ygv<Esc>') -- move cursor to the end of yanked text
-- vim.keymap.set("n", "p", "gp<Esc>") -- move cursor to the end of pasted text, normal mode
-- vim.keymap.set("v", "p", "gp<Esc>") -- move cursor to the end of pasted text, visual mode
vim.keymap.set('n', '<leader>ef', '<CMD>Ex<CR>', { desc = 'Go back to file explorer' })

vim.keymap.set('n', '<leader>gb', '<CMD>Git blame<CR>')
vim.keymap.set('n', '<leader>gaa', '<CMD>Git add .<CR>')
vim.keymap.set('n', '<leader>gp', '<CMD>Git push<CR>')
vim.keymap.set('n', '<leader>gg', '<CMD>G<CR>')
vim.keymap.set('n', '<leader>gm', '<CMD>Git commit<CR>')

vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- add a comment and test

vim.keymap.set('s', '(', ')')
vim.keymap.set('s', '[', ']')

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- local opts = { noremap = true, silent = true }
-- vim.keymap.set("v", "(", ":s/\\%V\\(.*\\)\\%V/(\\1)/<CR>", opts)
-- vim.keymap.set("v", "[", ":s/\\%V\\(.*\\)\\%V/[\\1]/<CR>", opts)
-- vim.keymap.set("v", "{", ":s/\\%V\\(.*\\)\\%V/{\\1}/<CR>", opts)

vim.keymap.set('n', 'j', function()
  if vim.fn.line '.' == vim.fn.line '$' then
    return '<C-e>'
  end
  return 'gj'
end, { expr = true })
