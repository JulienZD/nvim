vim.filetype.add {
  pattern = {
    ['.*%.component%.html'] = 'htmlangular',
  },
}

-- Temporary override containing the fix from https://github.com/dlvandenberg/tree-sitter-angular/pull/85
vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    require('nvim-treesitter.parsers').angular = {
      install_info = {
        url = 'https://github.com/JulienZD/tree-sitter-angular',
      },
      filetype = 'htmlangular',
    }
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'htmlangular',
  callback = function()
    vim.treesitter.start()
  end,
})

return {}
