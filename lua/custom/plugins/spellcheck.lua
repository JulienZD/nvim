vim.o.spell = true

vim.o.spelllang = 'en,nl'

return {
  'ravibrock/spellwarn.nvim',
  event = 'VeryLazy',
  config = true,
  opts = {
    suggest = true,
  },
}
