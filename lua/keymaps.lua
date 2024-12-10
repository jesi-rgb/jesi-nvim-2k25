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

-- copilot stuff
-- create a new window for copilot

-- local chat = require 'CopilotChat'
-- vim.keymap.set('n', '<leader>gl', '<cmd>CopilotChat<CR>', { desc = 'Open copilot panel' })
--
-- vim.keymap.set('v', '<leader>ge', '<cmd>CopilotChatExplain<CR>', { desc = 'Explain selection' })
-- vim.keymap.set('v', '<leader>gf', '<cmd>CopilotChatFix<CR>', { desc = 'Explain selection' })

function Ask_copilot_with_selection()
  -- Get the selected text range
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, '<'))
  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, '>'))

  -- Adjust `end_col` if it's set to the maximum value
  if end_col == 2147483647 then
    end_col = #vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, false)[1]
  end

  -- Convert `start_row` and `end_row` to 0-based indexing for the API,
  -- but avoid going out of bounds on `start_row`
  local start_row_zero_based = start_row - 1
  local end_row_zero_based = end_row - 1

  local lines = vim.api.nvim_buf_get_lines(0, start_row_zero_based, end_row, false)
  lines[#lines] = lines[#lines]:sub(1, end_col) -- Trim the last line to the correct column
  local selected_text = table.concat(lines, '\n')
  -- Debug: Print the selected text
  print('Selected text:', selected_text)

  -- Prompt the user to enter a question
  vim.ui.input({ prompt = 'Ask Copilot: ' }, function(question)
    if not question or question == '' then
      return
    end

    -- Debug: Print the question
    local prompt = 'The user asked you this question: "'
      .. question
      .. '" and here is the selected text: '
      .. selected_text
      .. ". Please respond exclusively to the question with new code, without any kind of format, as close to the original as possible, making minimal changes that resemble the coding style of the user. Respond exclusively with code, no yapping and no explanations. Respond as if your answer could literally be pasted in place of the user's code without any problem."

    -- Call Copilot with the selected text and custom question
    chat.ask(prompt, {
      input_text = selected_text,
      prompt = "Your task is to respond exclusively with new code. Respond as if your answer could literally be pasted in place of the user's code without any problem.",
      window = {
        layout = 'float',
        height = 3,
        row = 1,
      },
      callback = function(response)
        -- Replace selected text with the response
        chat.close()
        -- vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, true, { response })

        print(start_row_zero_based, start_col, end_row_zero_based, end_col)
        vim.api.nvim_buf_set_lines(0, start_row_zero_based, end_row, false, {})

        -- Paste the response at the starting position
        vim.api.nvim_win_set_cursor(0, { start_row, start_col + 1 }) -- Move cursor to start of selection
        vim.api.nvim_paste(response, true, -1)

        print 'lmao'
      end,
    })
  end)
end

local function ask_copilot()
  -- Get the selected text range
  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))

  print(cursor_col, cursor_row)

  -- Prompt the user to enter a question
  vim.ui.input({ prompt = 'Ask Copilot: ' }, function(question)
    if not question or question == '' then
      return
    end

    -- Debug: Print the question
    print('Question:', question)
    local prompt = 'The user asked you this question: "'
      .. question
      .. ". Please respond exclusively to the question with new code, without any kind of format, as close to the original as possible, making minimal changes that resemble the coding style of the user. Respond exclusively with code, no yapping and no explanations. Respond as if your answer could literally be pasted in place of the user's code without any problem."

    -- Call Copilot with the selected text and custom question
    chat.ask(prompt, {
      prompt = "Your task is to respond exclusively with new code. Respond as if your answer could literally be pasted in place of the user's code without any problem.",
      window = {
        layout = 'float',
        height = 4,
      },
      callback = function(response)
        chat.close()
        -- Replace selected text with the response
        print('Yeah:', response)
        -- get how many rows the response has

        local response_lines = vim.split(response, '\n')
        local end_row = cursor_row + #response_lines

        vim.api.nvim_paste(response, true, 1)
      end,
    })
  end)
end

-- Set the keymap to call the function in visual mode
-- Keymap to ask GitHub Copilot with the current selection
vim.keymap.set('v', '<leader>i', ':<C-u>lua Ask_copilot_with_selection()<CR>', { noremap = true, silent = true, desc = 'Invoke GitHub Copilot' })
vim.keymap.set('n', '<leader>i', ask_copilot, { noremap = true, silent = true, desc = 'Invoke GitHub Copilot' })
