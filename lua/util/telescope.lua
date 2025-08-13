local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local make_entry = require 'telescope.make_entry'
local conf = require('telescope.config').values

local M = {}

-- Thanks @tjdevries - https://www.youtube.com/watch?v=xdXE1tOT-qg
M.live_multigrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.fn.getcwd()

  local finder = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == '' then
        return nil
      end

      local pieces = vim.split(prompt, '  ')
      local args = { 'rg' }

      local pattern, glob = pieces[1], pieces[2]
      if pattern then
        table.insert(args, '-e')
        table.insert(args, pattern)
      end

      if glob then
        table.insert(args, '-g')
        table.insert(args, glob)
      end

      return vim
        .iter({
          args,
          { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' },
        })
        :flatten()
        :totable()
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = 'Multi Grep',
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = require('telescope.sorters').empty(),
    })
    :find()
end

local DEFAULT_TIMEOUT = 60000 * 2 -- 2 minutes in milliseconds

-- Automatically close the given picker after the given time (defaults to 2 minutes, as most keymappings are not able
-- to be detected yet to restart the timer)
M.with_auto_close = function(open_picker_callback, timeout)
  return function(...)
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'

    local timer = vim.loop.new_timer()

    -- @type uv_timer_t | nil
    local debounce_timer = nil

    local restart_timer, debounce_timer_ref = require('telescope.debounce').debounce_leading(function()
      timer:stop()

      timer:start(
        timeout or DEFAULT_TIMEOUT,
        0,
        vim.schedule_wrap(function()
          -- Check if picker still exists before closing
          local bufnr = vim.api.nvim_get_current_buf()
          local picker = action_state.get_current_picker(bufnr)
          if picker then
            actions.close(picker.prompt_bufnr)
          end

          timer:close()
          if debounce_timer then
            debounce_timer:close()
          end
        end)
      )
    end, 100)

    debounce_timer = debounce_timer_ref

    restart_timer() -- start when picker opens

    -- Restart timer on any action in normal or insert mode
    vim.defer_fn(function()
      local bufnr = vim.api.nvim_get_current_buf()
      local picker = action_state.get_current_picker(bufnr)

      -- Only act on the picker window
      if not picker then
        return
      end

      -- TODO: Keymappings for the picker window are ignored here, so they aren't handled (e.g. <C-n> or <C-p> to navigate)
      vim.api.nvim_create_autocmd({ 'InsertCharPre', 'TextChangedI', 'CursorMoved', 'CursorMovedI' }, {
        buffer = bufnr,
        callback = function()
          restart_timer()
        end,
      })
    end, 100)

    return open_picker_callback(...)
  end
end

return M
