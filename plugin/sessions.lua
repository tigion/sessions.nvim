-- Check Neovim version.
if vim.fn.has('nvim-0.10') == 0 then
  vim.notify('The plugin requires Neovim >=0.10', vim.log.levels.ERROR, { title = 'Sessions' })
  return
end

-- Create the user command for managing sessions.
vim.api.nvim_create_user_command('Session', function(input)
  local session = require('sessions.session')
  local subcmd = input.args
  if subcmd == 'info' then
    session.info()
  elseif subcmd == 'save' then
    session.save()
  elseif subcmd == 'load' then
    session.load()
  elseif subcmd == 'delete' then
    session.delete()
  else
    session.usage()
  end
end, {
  nargs = '?',
  complete = function(arg_lead)
    local choices = { 'info', 'save', 'load', 'delete' }
    if arg_lead == '' then return choices end
    return vim.tbl_filter(function(choice) return choice:find(arg_lead, 1, true) == 1 end, choices)
  end,
  desc = 'Manage sessions',
})
