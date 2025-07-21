---@diagnostic disable: missing-fields
-- views can only be fully collapsed with the global statusline -- recommended by avante.nvim
vim.opt.laststatus = 3

return {
  'yetone/avante.nvim',
  build = 'make',
  event = 'VeryLazy',
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    mappings = {
      focus = '<leader>aF',
    },
    provider = 'copilot',
    input = {
      provider = 'snacks',
      provider_opts = {
        -- Additional snacks.input options
        title = 'Avante Input',
        icon = ' ',
      },
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'folke/snacks.nvim', -- for input provider
    'nvim-tree/nvim-web-devicons',
    'zbirenbaum/copilot.lua',
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'Avante' },
      },
      ft = { 'Avante' },
    },
  },
}
