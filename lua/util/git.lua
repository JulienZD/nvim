local M = {}

function M.get_branch_name()
  local branches = vim.fn.systemlist 'git branch --show-current'
  return branches[1]
end

function M.get_ticket_id()
  local branch_name = M.get_branch_name()
  -- Branch names are feature/XX-1234-some-description
  local ticket_id = string.match(branch_name, '/(%w+-%d+)')
  return ticket_id
end

return M
