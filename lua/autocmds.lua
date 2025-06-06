local function harpoon_component()
  local mark_idx = require('harpoon.mark').get_current_index()
  local total_marks = require('harpoon.mark').get_length()
  if mark_idx == nil then
    return ''
  end

  return string.format('→ %d/%d', mark_idx, total_marks)
end

require('lualine').setup {
  sections = {
    lualine_b = {
      { 'branch', icon = '' },
      { harpoon_component },
    },
    lualine_c = { { 'filename', path = 1 } },
  },
}

local cmp = require 'cmp'
local luasnip = require 'luasnip'

local global_snippets = {
  { trigger = 'shebang', body = '#!/bin sh' },
  { trigger = 'Fr', body = '<Frame>![$2]($1)</Frame>' },
}

local snippets_by_filetype = {
  javascript = {
    { trigger = 'cons', body = 'console.log(${1:log}) $0' },
  },
  typescript = {
    { trigger = 'cons', body = 'console.log(${1:log}) $0' },
  },
  typescriptreact = {
    { trigger = 'cons', body = 'console.log(${1:log}) $0' },
  },
  svelte = {
    { trigger = 'cons', body = 'console.log(${1:log}) $0' },
  },
  -- other filetypes
}

local function get_buf_snips()
  local ft = vim.bo.filetype
  local snips = vim.list_slice(global_snippets)

  if ft and snippets_by_filetype[ft] then
    vim.list_extend(snips, snippets_by_filetype[ft])
  end

  return snips
end

local function register_cmp_source()
  local cmp_source = {}
  local cache = {}
  function cmp_source.complete(_, _, callback)
    local bufnr = vim.api.nvim_get_current_buf()
    if not cache[bufnr] then
      local completion_items = vim.tbl_map(function(s)
        ---@type lsp.CompletionItem
        local item = {
          word = s.trigger,
          label = s.trigger,
          kind = vim.lsp.protocol.CompletionItemKind.Snippet,
          insertText = s.body,
          insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
        }
        return item
      end, get_buf_snips())

      cache[bufnr] = completion_items
    end

    callback(cache[bufnr])
  end

  require('cmp').register_source('snp', cmp_source)
end

register_cmp_source()

cmp.setup {
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'snp' },
    { name = 'luasnip' },
    { name = 'buffer', keyword_length = 1 },
  },
  sorting = {
    priority_weight = 1, -- Optional: Give higher weight to priorities.

    comparators = {
      function(entry1, entry2)
        -- Custom priority logic
        local source_priority = {
          snp = 1, -- Custom snippets
          nvim_lsp = 2, -- Emmet snippets
        }
        local priority1 = source_priority[entry1.source.name] or 100
        local priority2 = source_priority[entry2.source.name] or 100
        if priority1 ~= priority2 then
          return priority1 < priority2
        end
      end,

      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.kind,
    },
  },
}

-- Function to detect system theme and switch between two themes
function Switch_theme()
  -- Detect system theme (example for macOS)
  local theme = vim.fn.system 'defaults read -g AppleInterfaceStyle'
  if theme:lower():match 'dark' then
    -- Load your dark theme
    print 'Switching to dark theme'
    vim.api.nvim_command 'colorscheme github_dark_dimmed'
  else
    -- Load your light theme
    print 'Switching to light theme'
    vim.api.nvim_command 'colorscheme github_light_colorblind'
  end
end
