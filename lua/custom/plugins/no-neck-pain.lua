return {
  'shortcuts/no-neck-pain.nvim',
  version = '*',
  opts = {
    buffers = {
      right = {
        enabled = false,
      },
    },
    mappings = {
      enabled = true,
      toggle = '<Leader>np',
    },
    autocmds = {
      enableOnVimEnter = vim.g.is_large_screen and 'safe' or false,
    },
  },
}
