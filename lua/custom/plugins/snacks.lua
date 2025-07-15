vim.api.nvim_create_autocmd('User', {
  pattern = 'OilActionsPost',
  callback = function(event)
    if event.data.actions.type == 'move' then
      Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
    end
  end,
})

return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      lazygit = {
        enabled = true,
        config = {
          os = {
            editPreset = 'nvim',
          },
        },
      },
      dashboard = {
        enabled = false,
        sections = {
          { section = 'header' },
          { section = 'keys', gap = 1, padding = 1 },
          { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
          {
            pane = 2,
            icon = ' ',
            title = 'Git Status',
            section = 'terminal',
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = 'git branch --show-current',
            height = 1,
            padding = 0,
            indent = 3,
          },
          {
            pane = 2,
            title = '', -- This is just below the Git branch, so we leave the title empty
            section = 'terminal',
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = 'git status --short --renames',
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 1,
          },
          { section = 'startup' },
        },
      },
    },
    keys = {
      {
        '<leader>lg',
        function()
          Snacks.lazygit()
        end,
        desc = '[L]azy[G]it',
      },
      {
        '<leader>.',
        function()
          Snacks.scratch()
        end,
        desc = 'Toggle Scratch Buffer',
      },
    },
  },
}
