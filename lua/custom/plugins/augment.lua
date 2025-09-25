local function get_git_root()
  local git_root = vim.fn.system 'git rev-parse --show-toplevel 2>/dev/null'
  if vim.v.shell_error == 0 then
    return vim.trim(git_root)
  end

  -- No git root, don't provide any workspace folder, as I don't want to give it access to everything
  return nil
end

local is_enabled = vim.g.ai_provider == 'augment'

if is_enabled then
  vim.g.augment_workspace_folders = { get_git_root() }
end

return {
  'augmentcode/augment.vim',
  cond = is_enabled,
  event = 'VeryLazy',
  -- lazy.nvim still registers keymaps even if the plugin is not loaded, so they have to be conditionally set
  keys = is_enabled and {
    {
      '<A-l>',
      '<cmd>call augment#Accept()<CR>',
      desc = 'Accept Augment suggestion',
      mode = 'i',
    },
  } or nil,
}
