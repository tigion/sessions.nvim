-- Check Neovim version.
if vim.fn.has('nvim-0.10') == 0 then
  vim.notify('The plugin requires Neovim >=0.10', vim.log.levels.ERROR, { title = 'Sessions' })
  return
end

local CHOICES = { 'info', 'save', 'load', 'delete' }

-- Create the Session command with subcommands.
vim.api.nvim_create_user_command('Session', function(input)
  local session = require('sessions.session')
  local actions = {
    info = session.info,
    save = session.save,
    load = session.load,
    delete = session.delete,
  }
  (actions[input.args] or session.usage)()
end, {
  nargs = '?',
  complete = function(arg_lead)
    if arg_lead == '' then return CHOICES end
    return vim.tbl_filter(function(choice) return choice:find(arg_lead, 1, true) == 1 end, CHOICES)
  end,
  desc = 'Session ' .. table.concat(CHOICES, '|'),
})
