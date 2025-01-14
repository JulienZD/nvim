return {
  'stevearc/quicker.nvim',
  event = 'FileType qf',
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {
    edit = {
      -- Enable editing the quickfix like a normal buffer
      enabled = true,
      -- This doesn't seem to be working, it just creates a quickfix-<n> file, but no changes are applied
      autosave = true,
    },
  },
}
