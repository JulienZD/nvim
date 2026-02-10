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
    -- init = function()
    --   vim.cmd.colorscheme 'tokyonight-storm'
    --
    --   vim.cmd.hi 'Comment gui=none'
    -- end,
  },
  {
    'bluz71/vim-moonfly-colors',
    name = 'moonfly',
    lazy = false,
    priority = 1000,
    init = function()
      -- Hide ~ on empty lines, otherwise they're shown all along the left side of buffers
      vim.opt.fillchars = { eob = ' ' }

      -- FIXME: This should only apply when nvim is in dark mode, as it breaks the moonfly light mode theme
      require('moonfly').custom_colors {
        bg = '#000000',
        grey15 = '#000000', -- dropbar.nvim background
        grey16 = '#080808', -- splits background
      }

      vim.cmd.colorscheme 'moonfly'

      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
