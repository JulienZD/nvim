return {
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets',
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip').filetype_extend('javascript', { 'jsdoc' })
            require('luasnip').filetype_extend('typescript', { 'tsdoc' })

            require('luasnip.loaders.from_vscode').lazy_load()
            require('luasnip.loaders.from_lua').lazy_load {
              paths = {
                './lua/snippets',
              },
            }
          end,
        },
      },
    },
  },
  version = 'v0.12.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'super-tab',
      -- Also allow enter to be used to accept
      ['<CR>'] = { 'accept', 'fallback' },
    },
    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },
    snippets = {
      preset = 'luasnip',
    },
    fuzzy = {
      sorts = {
        'exact',
        'score',
        'sort_text',
        -- Custom sorter to promote our own snippets to the very top, as blink demotes snippets by default
        ---@param a blink.cmp.CompletionItem
        ---@param b blink.cmp.CompletionItem
        function(a, b)
          local OWN_SNIPPET_MARKER = '__CUSTOM_SNIPPET__'

          for _, item in ipairs { a, b } do
            if item.kind == require('blink.cmp.types').CompletionItemKind.Snippet then
              ---@type string
              ---@diagnostic disable-next-line: assign-type-mismatch
              local documentation = item.documentation and item.documentation.value or item.documentation or ''

              if documentation:find(OWN_SNIPPET_MARKER) then
                return true
              end
            end
          end
        end,
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    completion = {
      menu = {
        auto_show = function(ctx)
          local is_cmdline = ctx.mode == 'cmdline'
          local is_search = vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())

          return not is_cmdline and not is_search
        end,
      },
      accept = { auto_brackets = { enabled = true } },
      trigger = {
        -- Don't show completion menu when typing these characters
        show_on_blocked_trigger_characters = { ' ', '\n', '\t', "'", '"', '`', '/', '-', '(', '{', '[', ',' },
      },
      documentation = {
        auto_show = true,
      },
    },
  },
  experimental = { signature = true },
  opts_extend = { 'sources.default' },
}
