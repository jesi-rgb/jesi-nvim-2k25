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

vim.api.nvim_set_keymap('n', '<leader>fp', ':<C-U>let @+ = expand("%")<CR>', { noremap = true, silent = true, desc = 'Copy relative file path' })

vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- add a comment and test

vim.keymap.set('s', '(', ')')
vim.keymap.set('s', '[', ']')

local builtin = require 'telescope.builtin'
local actions = require 'telescope.actions'
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

local function find_and_split_into_file()
  builtin.find_files {
    attach_mappings = function(_, map)
      -- This is where you handle the selected file
      actions.select_default:replace(function(prompt_bufnr)
        -- Get the selected entry
        local action_state = require 'telescope.actions.state'
        local file = action_state.get_selected_entry().path
        -- Close Telescope window
        require('telescope.actions').close(prompt_bufnr)
        -- Split and open the selected file
        vim.cmd('topleft vsplit ' .. file)
      end)
      return true
    end,
  }
end
-- window management
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>w-', '<C-w>s', { desc = 'Create a window below' })
vim.keymap.set('n', '<leader>wr', find_and_split_into_file, { desc = 'Search and create a buffer to the left' })

vim.keymap.set('n', '<leader>wd', '<CMD>q<Enter>', { desc = 'Delete window' })
vim.keymap.set('n', '<leader>ww', '<C-W><C-W>', { desc = 'Delete window' })

vim.keymap.set('n', '<right>', '<CMD>:vert :res +5<Enter>', { desc = 'Increase window width by 5' })
vim.keymap.set('n', '<left>', '<CMD>:vert :res -5<Enter>', { desc = 'Descrease window width by 5' })

vim.keymap.set('n', '<up>', '<CMD>:res +5<Enter>', { desc = 'Increase window width by 5' })
vim.keymap.set('n', '<down>', '<CMD>:res -5<Enter>', { desc = 'Descrease window width by 5' })

vim.api.nvim_set_keymap('n', '<leader>t', ':lua Switch_theme()<CR>', { noremap = true })
