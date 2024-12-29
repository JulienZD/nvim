local git_util = require 'util.git'

local function keyword_snippet(keyword)
  return s(
    {
      trig = keyword,
      -- Add a custom marker to the description, so we can detect it and sort the snippet higher
      -- blink.cmp doesn't respect the priority of snippets, so we need to do this manually
      desc = 'Adds the keyword with the ticket id if available\n__CUSTOM_SNIPPET__',
    },
    f(function()
      local ticket_id = git_util.get_ticket_id()

      local output = string.upper(keyword)
      if ticket_id then
        output = output .. '(' .. ticket_id .. ')'
      end

      output = output .. ': '

      return output
    end, {})
  )
end

return vim.tbl_extend('force', vim.tbl_map(keyword_snippet, { 'todo', 'fixme' }), {})
