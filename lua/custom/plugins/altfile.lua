local feathersjs_mappings = {
  -- Files in src/services/*/
  {
    pattern = '(.*/services)/(.*)/([a-zA-Z-_]*).*.ts$',
    target = {
      {
        target = '/%1/%2/%3.controller.ts',
        context = 'controller',
      },
      {
        target = '/%1/%2/%3.class.ts',
        context = 'controller',
      },
      {
        target = '/%1/%2/%3.hooks.ts',
        context = 'hooks',
      },
      {
        target = '/%1/%2/%3.service.ts',
        context = 'service',
      },
      {
        target = 'src/models/%3.model.ts',
        context = 'model',
      },
    },
  },
  -- Files in src/models/
  {
    pattern = '.*/models/([a-zA-Z-_]*).model.ts$',
    target = {
      {
        target = 'src/services/%1/%1.service.ts',
        context = 'service',
      },
      {
        target = 'src/services/%1/%1.hooks.ts',
        context = 'hooks',
      },
      {
        target = 'src/services/%1/%1.controller.ts',
        context = 'controller',
      },
      {
        target = 'src/services/%1/%1.class.ts',
        context = 'controller',
      },
    },
  },
}

return {
  'rgroli/other.nvim',
  config = function()
    local mappings = vim.deepcopy(feathersjs_mappings)

    if vim.g.is_angular_project then
      table.insert(mappings, 'angular')
    end

    require('other-nvim').setup {
      mappings = mappings,
      showMissingFiles = false,
      rememberBuffers = false,
    }

    vim.keymap.set('n', '<leader>af', ':Other<CR>', { desc = '[A]lternate [f]ile' })
  end,
}
