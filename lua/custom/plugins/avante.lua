---@diagnostic disable: missing-fields

local is_enabled = vim.g.ai_provider == 'copilot'

if is_enabled then
  -- views can only be fully collapsed with the global statusline -- recommended by avante.nvim
  vim.opt.laststatus = 3
end

return {
  'yetone/avante.nvim',
  cond = is_enabled,
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
    instructions_file = '.github/copilot_instructions.md',
    input = {
      provider = 'snacks',
      provider_opts = {
        -- Additional snacks.input options
        title = 'Avante Input',
        icon = ' ',
      },
    },
  },
  config = function(_, opts)
    require('avante').setup(opts)

    -- For some reason avante keeps the default instructions file even if we set it in setup, so
    -- we have to override that here
    if opts.instructions_file then
      require('avante.config').instructions_file = opts.instructions_file
    end
  end,
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
