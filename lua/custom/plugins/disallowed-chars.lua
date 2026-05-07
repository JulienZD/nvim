-- Each entry: codepoint + ASCII replacement.
-- Using codepoints (not literal chars) so invisible characters are visible in source.
local disallowed = {
  -- Dashes
  { code = 0x2014, replacement = '-' }, -- em-dash —
  { code = 0x2013, replacement = '-' }, -- en-dash –
  { code = 0x2212, replacement = '-' }, -- minus sign −
  { code = 0x2012, replacement = '-' }, -- figure dash ‒
  { code = 0x2015, replacement = '-' }, -- horizontal bar ―

  -- Punctuation
  { code = 0x2026, replacement = '...' }, -- ellipsis …
  { code = 0x201C, replacement = '"' }, -- left double quote “
  { code = 0x201D, replacement = '"' }, -- right double quote ”
  { code = 0x2018, replacement = "'" }, -- left single quote ‘
  { code = 0x2019, replacement = "'" }, -- right single quote ’

  -- Bullets / asterisks
  { code = 0x2022, replacement = '*' }, -- bullet •
  { code = 0x2217, replacement = '*' }, -- asterisk operator ∗

  -- Math
  { code = 0x00D7, replacement = 'x' }, -- multiplication ×

  -- Arrows
  { code = 0x2192, replacement = '->' }, -- right arrow →
  { code = 0x2190, replacement = '<-' }, -- left arrow ←
  { code = 0x2194, replacement = '<->' }, -- left-right arrow ↔
  { code = 0x21D2, replacement = '=>' }, -- double right arrow ⇒
  { code = 0x21D0, replacement = '<=' }, -- double left arrow ⇐
  { code = 0x21D4, replacement = '<=>' }, -- double left-right arrow ⇔
  { code = 0x27F6, replacement = '-->' }, -- long right arrow ⟶
  { code = 0x27F5, replacement = '<--' }, -- long left arrow ⟵
  { code = 0x27F7, replacement = '<-->' }, -- long left-right arrow ⟷

  -- Invisible whitespace (replaced with regular space or removed)
  { code = 0x00A0, replacement = ' ' }, -- non-breaking space
  { code = 0x2002, replacement = ' ' }, -- en space
  { code = 0x2003, replacement = ' ' }, -- em space
  { code = 0x2009, replacement = ' ' }, -- thin space
  { code = 0x200B, replacement = '' }, -- zero-width space
  { code = 0x200C, replacement = '' }, -- zero-width non-joiner
  { code = 0x200D, replacement = '' }, -- zero-width joiner
  { code = 0x2060, replacement = '' }, -- word joiner
  { code = 0xFEFF, replacement = '' }, -- BOM / zero-width no-break space
  { code = 0x00AD, replacement = '' }, -- soft hyphen
}

local pattern = (function()
  local parts = {}
  for _, item in ipairs(disallowed) do
    table.insert(parts, string.format([[\%%u%04X]], item.code))
  end
  return table.concat(parts, [[\|]])
end)()

local function set_highlight()
  vim.api.nvim_set_hl(0, 'DisallowedCharWarning', { fg = '#ffffff', bg = '#ff005f', bold = true })
end

vim.api.nvim_create_user_command('NoFancyChars', function()
  for _, item in ipairs(disallowed) do
    pcall(vim.cmd, string.format([[silent! %%s/\%%u%04X/%s/g]], item.code, item.replacement))
  end
end, { desc = 'Replace all disallowed/fancy characters with ASCII equivalents' })

set_highlight()

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = set_highlight,
})

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinNew' }, {
  callback = function()
    -- Defer so plugins like snacks have time to swap in their terminal buffer
    -- before we check the buftype.
    vim.schedule(function()
      if not vim.api.nvim_win_is_valid(vim.api.nvim_get_current_win()) then
        return
      end
      -- Only highlight in regular file buffers (skip terminals, help, quickfix, etc.)
      if vim.bo.buftype ~= '' then
        return
      end
      for _, m in ipairs(vim.fn.getmatches()) do
        if m.group == 'DisallowedCharWarning' then
          return
        end
      end
      vim.fn.matchadd('DisallowedCharWarning', pattern)
    end)
  end,
})

return {}
