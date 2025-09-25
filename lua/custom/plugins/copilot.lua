return {
  'zbirenbaum/copilot.lua',
  dependencies = {
    'copilotlsp-nvim/copilot-lsp',
  },
  cond = vim.g.ai_provider == 'copilot',
  cmd = 'Copilot',
  event = 'InsertEnter',
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
    },
    panel = { enabled = false },
    nes = {
      enabled = false,
      keymap = {
        accept_and_goto = '<leader>p',
        accept = false,
        dismiss = '<Esc>',
      },
    },
  },
}
