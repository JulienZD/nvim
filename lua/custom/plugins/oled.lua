local is_oled_screen = vim.env.OLED_SCREEN == '1' or vim.env.OLED_SCREEN == 'true'

local M = {}

if not is_oled_screen then
  return M
end

-- delayed execution to ensure all plugins are loaded
vim.schedule(function()
  -- Hide vertical split lines
  vim.opt.fillchars:append 'vert: '

  -- Remove the virtual hard wrap column, as it is static content
  require('virt-column').update { enabled = false }

  -- Disable statusline, as it is static content
  vim.g.ministatusline_disable = true
  vim.opt.laststatus = 0
end)

return M
