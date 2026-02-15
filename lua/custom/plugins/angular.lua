vim.filetype.add {
  pattern = {
    ['.*%.component%.html'] = 'htmlangular',
  },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'htmlangular',
  callback = function()
    vim.treesitter.start()
  end,
})

return {}
