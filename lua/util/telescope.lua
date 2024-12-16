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

return M
