local M = {}

M.options = {
  -- Saves session automatically on Neovim exit.
  auto_save = false, ---@type boolean

  -- Notifies the user when a session is loaded or saved.
  notify = true, ---@type boolean

  -- The name of the subdirectory in `vim.fn.stdpath('data')`
  -- where the sessions are saved.
  -- If it does not exist, it will be created.
  directory = 'sessions', ---@type string

  -- Overwrites existing session files without confirmation.
  overwrite = true, ---@type boolean

  -- Ignores session saving for the specified filetypes.
  ignored_filetypes = { 'alpha', 'dashboard', 'snacks_dashboard' }, ---@type string[]
}

function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', M.options, opts or {})

  -- TODO: check config values
end

return M
