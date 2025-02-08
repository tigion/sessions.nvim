local M = {}

M.options = {
  -- The name of the subdirectory in `vim.fn.stdpath('data')`
  -- where the sessions are saved.
  -- If it does not exist, it will be created.
  directory = 'sessions', ---@type string

  -- Overwrites existing session files without confirmation.
  overwrite = true, ---@type boolean
}

function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', M.options, opts or {})

  -- TODO: check config values
end

return M
