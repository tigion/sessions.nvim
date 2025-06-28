local config = require('sessions.config')
local session = require('sessions.session')
local notify = require('sessions.notify')

local M = {}

---Setups the plugin.
---@param opts sessions.Config
function M.setup(opts)
  -- check neovim version
  if vim.fn.has('nvim-0.10') == 0 then
    notify.error('nvim-sessions requires Neovim >= 0.10')
    return
  end

  -- Setups the plugin configuration.
  require('sessions.config').setup(opts)

  -- Creates the `Session` commands.
  --
  -- NOTE: - `:h nvim_create_user_command`
  --       - https://tui.ninja/neovim/customizing/user_commands/creating/
  --
  vim.api.nvim_create_user_command('Session', function(input)
    if input.args == 'info' then
      session.info()
    elseif input.args == 'save' then
      session.save()
    elseif input.args == 'load' then
      session.load()
    elseif input.args == 'delete' then
      session.delete()
    else
      session.usage()
    end
  end, {
    nargs = '?',
    complete = function(ArgLead)
      local choices = { 'info', 'save', 'load', 'delete' }
      table.sort(choices)
      if ArgLead == '' then return choices end
      return vim.tbl_filter(function(choice) return string.find(choice, ArgLead) == 1 end, choices)
    end,
    desc = 'Session info|save|load|delete',
  })

  local group = vim.api.nvim_create_augroup('nvim-sessions_group', {})

  -- Creates autocommand to save session on Neovim exit if auto_save is enabled.
  if config.options.auto_save == true then
    vim.api.nvim_create_autocmd('VimLeavePre', {
      group = group,
      -- pattern = '*',
      callback = function() session.save() end,
    })
  end
end

M.exists = session.exists

return M
