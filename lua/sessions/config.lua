---@class sessions.config
local M = {}

---@class sessions.Config
---Whether to save session automatically on Neovim exit.
---@field auto_save? boolean
---Whether to notify the user when a session is loaded or saved.
---@field notify? boolean
---The name of the subdirectory in `vim.fn.stdpath('data')`
---where the sessions are saved.
---If it does not exist, it will be created.
---@field directory? string
---Whether to overwrite existing session files without confirmation.
---@field overwrite? boolean
---Ignores session saving for the specified filetypes.
---@field ignored_filetypes? string[]

---@type sessions.Config
local defaults = {
  auto_save = false,
  notify = true,
  directory = 'sessions',
  overwrite = true,
  ignored_filetypes = { 'alpha', 'dashboard', 'snacks_dashboard' },
}

-- NOTE: Sets the default options without the setup function.
--       A deep copy of the defaults is needed to avoid modifying the defaults.
--       - M.options = defaults
--       - M.options = vim.deepcopy(defaults, true)

---The configuration options for the plugin.
---@type sessions.Config
M.options = vim.deepcopy(defaults, true)

---Setups the plugin with the user-provided options.
---@param opts sessions.Config
function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', defaults, opts or {})

  -- TODO: check config values
end

return M
