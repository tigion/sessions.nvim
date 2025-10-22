local config = require('sessions.config')
local session = require('sessions.session')
local notify = require('sessions.notify')

---@class sessions
local M = {}

---Creates the needed user commands.
local function create_user_commands()
  -- NOTE: - `:h nvim_create_user_command`
  --       - https://tui.ninja/neovim/customizing/user_commands/creating/

  -- Creates the `Session` command.
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
    complete = function(arg_lead)
      local choices = { 'info', 'save', 'load', 'delete' }
      table.sort(choices)
      if arg_lead == '' then return choices end
      return vim.tbl_filter(function(choice) return string.find(choice, arg_lead) == 1 end, choices)
    end,
    desc = 'Session info|save|load|delete',
  })
end

---Creates the needed autocommands.
local function create_auto_commands()
  local group = vim.api.nvim_create_augroup('nvim-sessions_group', {})

  -- Creates autocommand to save session on Neovim exit if auto_save is enabled.
  if config.options.auto_save == true then
    vim.api.nvim_create_autocmd('VimLeavePre', {
      group = group,
      callback = function() session.save() end,
    })
  end
end

---Sets up the plugin.
---@param opts sessions.Config
function M.setup(opts)
  -- check neovim version
  if vim.fn.has('nvim-0.10') == 0 then
    notify.error('nvim-sessions requires Neovim >= 0.10')
    return
  end

  -- Sets up the plugin configuration.
  config.setup(opts)

  -- Creates the user and auto commands.
  create_user_commands()
  create_auto_commands()
end

M.exists = session.exists

return M
