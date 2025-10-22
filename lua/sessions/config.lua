---@class sessions.config
local M = {}

---@class sessions.Config
---@field auto_save? boolean Automatically saves the session on Neovim exit.
---@field directory? string The subdirectory in `vim.fn.stdpath('data')` where the sessions are saved.
---@field ignore_blank? boolean Ignores saving sessions for blank buffers.
---@field ignored_filetypes? table<string, boolean> Ignores session saving for the specified filetypes.
---@field notify? boolean Notifies when a session is loaded, saved or deleted.
---@field overwrite? boolean Overwrites existing session files without confirmation.

---The default options.
---@type sessions.Config
local defaults = {
  auto_save = false,
  directory = 'sessions', -- Will be created if not available.
  ignore_blank = true,
  ignored_filetypes = { -- Will prevent session saving if found.
    alpha = true,
    dashboard = true,
    snacks_dashboard = true,
  },
  notify = true,
  overwrite = true,
}

---The current options. Uses defaults without setup.
---@type sessions.Config
M.options = vim.deepcopy(defaults, true)

---Setups the plugin configuration.
---@param opts sessions.Config The user options.
function M.setup(opts)
  -- Merges the default options with the user options.
  M.options = vim.tbl_deep_extend('force', defaults, opts or {})
end

return M
