return {
  { -- TODO: Can probably removed once updated to nvim 0.11 (might require a tmux update too?)
    'vimpostor/vim-lumen',
    lazy = false,
    priority = 1010, -- higher prio than tokyonight
    init = function() end,
  },
  {
    -- All colorschemes: `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Load before all other start plugins
    init = function()
      vim.cmd.colorscheme 'tokyonight-storm'

      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
