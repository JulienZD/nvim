-- Based on https://seankegel.com/neovim-for-php-and-laravel
return {
  {
    -- Add a Treesitter parser for Laravel Blade to provide Blade syntax highlighting.
    'nvim-treesitter/nvim-treesitter',
    config = function(_, opts)
      require('nvim-treesitter').install {
        'blade',
        'php_only',
      }

      vim.filetype.add {
        pattern = {
          ['.*%.blade%.php'] = 'blade',
        },
      }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'blade',
        callback = function()
          vim.treesitter.start()
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'TSUpdate',
        callback = function()
          require('nvim-treesitter.parsers').blade = {
            install_info = {
              url = 'https://github.com/EmranMR/tree-sitter-blade',
              files = { 'src/parser.c' },
              branch = 'main',
            },
            filetype = 'blade',
          }
        end,
      })
    end,
  },
  {
    -- Go-to definition for blade files
    'ricardoramirezr/blade-nav.nvim',
    ft = { 'blade', 'php' },
  },
}
