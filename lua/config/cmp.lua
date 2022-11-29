vim.o.completeopt = "menuone,noselect"

local cmp = require('cmp')

cmp.setup{
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = require'lspkind'.presets.default[vim_item.kind]
      vim_item.menu = ({
        ultisnips = "[UltiSnips]",
        latex_symbols = "[Latex]",
        nvim_lsp = "[LSP]",
      })[entry.source.name]
      return vim_item
    end
  },
  snippets = {
    expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end
  },
  sources = {
    { name = 'ultisnips' },
    { name = 'latex_symbols' },
    { name = 'nvim_lsp' },
  },
  mapping = {
    ["<Tab>"] = cmp.mapping({
      c = function()
          if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          else
              cmp.complete()
          end
      end,
      i = function(fallback)
          if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
              vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
          else
              fallback()
          end
      end,
      s = function(fallback)
          if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
              vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
          else
              fallback()
          end
      end
  }),
  ["<S-Tab>"] = cmp.mapping({
      c = function()
          if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
          else
              cmp.complete()
          end
      end,
      i = function(fallback)
          if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
          elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
              return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
          else
              fallback()
          end
      end,
      s = function(fallback)
          if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
              return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
          else
              fallback()
          end
      end
  }),
  ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
  ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
  ['<C-n>'] = cmp.mapping({
      c = function()
          if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
              vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
          end
      end,
      i = function(fallback)
          if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
              fallback()
          end
      end
  }),
  ['<C-p>'] = cmp.mapping({
      c = function()
          if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          else
              vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
          end
      end,
      i = function(fallback)
          if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          else
              fallback()
          end
      end
  }),
  ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
  ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
  ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
  ['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
  ['<CR>'] = cmp.mapping({
      i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
      c = function(fallback)
          if cmp.visible() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          else
              fallback()
          end
      end
  }),
  },
}

