-- The following is also set in the environment, but it doesn't reload properly when detaching the monitor and
-- restarting nvim
local is_oled_screen = vim.fn.system 'system_profiler SPDisplaysDataType | grep -q "MO27Q28G"' == 0

local M = {}

if not is_oled_screen then
  return M
end

-- delayed execution to ensure all plugins are loaded
vim.schedule(function()
  -- Hide vertical split lines
  vim.opt.fillchars:append 'vert: '

  -- Remove the virtual hard wrap column, as it is static content
  local virt_column_shown = false

  local virt_column = require 'virt-column'
  virt_column.update { enabled = virt_column_shown }

  -- Register a keymap to toggle the virt-column plugin
  vim.keymap.set('n', '<leader>tc', function()
    virt_column_shown = not virt_column_shown
    virt_column.update { enabled = virt_column_shown }
    vim.cmd 'redraw!' -- redraw to ensure the change is visible immediately
  end, {
    desc = '[T]oggle Virtual [C]olumn',
    noremap = true,
    silent = true,
  })

  -- Disable statusline, as it is static content
  vim.g.ministatusline_disable = true
  vim.opt.laststatus = 0
end)

return M
