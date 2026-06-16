---@class sessions
local M = {}

---Creates or removes the auto-save autocommand based on the enabled state.
---@param enabled boolean
local function create_auto_save_autocmd(enabled)
  local group = vim.api.nvim_create_augroup('sessions_auto_save', { clear = true })

  if not enabled then return end

  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = group,
    callback = function() require('sessions.session').save() end,
  })
end

---Sets up the plugin.
---@param opts? sessions.Config
function M.setup(opts)
  local config = require('sessions.config')

  config.setup(opts)
  create_auto_save_autocmd(config.options.auto_save)
end

function M.exists() return require('sessions.session').exists() end

return M
