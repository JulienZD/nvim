local git_util = require 'util.git'

local function keyword_snippet(keyword)
  return s(
    keyword,
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
