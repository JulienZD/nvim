return {
  'zbirenbaum/copilot.lua',
  dependencies = {
    'copilotlsp-nvim/copilot-lsp',
  },
  cmd = 'Copilot',
  event = 'InsertEnter',
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
    },
    panel = { enabled = false },
    nes = {
      enabled = true,
      keymap = {
        accept_and_goto = '<leader>p',
        accept = false,
        dismiss = '<Esc>',
      },
    },
  },
}
