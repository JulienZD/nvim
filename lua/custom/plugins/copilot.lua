return {
  'zbirenbaum/copilot.lua',
  dependencies = {
    'copilotlsp-nvim/copilot-lsp',
  },
  cmd = 'Copilot',
  event = 'InsertEnter',
  opts = {
    suggestion = {
      enabled = vim.g.ai_completions_provider == 'copilot',
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
