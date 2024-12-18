return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name)
        local always_hidden_patterns = { '^%.git', '^%.cache', '.DS_Store', '../' }

        for _, pattern in ipairs(always_hidden_patterns) do
          if name:match(pattern) then
            return true
          end
        end

        return false
      end,
    },
  },
  keys = {
    { '-', ':Oil<CR>', desc = 'Open Oil' },
  },
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { 'nvim-tree/nvim-web-devicons' },
}
