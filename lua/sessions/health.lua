local session = require('sessions.session')

---@class sessions.health
local M = {}

-- stylua: ignore start
local start = vim.health.start -- Starts a new report or section.
local ok    = vim.health.ok    -- Reports a success message.
local warn  = vim.health.warn  -- Reports a warning.
local info  = vim.health.info  -- Reports an informational message.
local error = vim.health.error -- Reports an error.
-- stylua: ignore end

---Checks the data directory.
local function check_data_directory()
  local data_dir = vim.fn.stdpath('data') .. '' -- add `.. ''` to prevent  Lua Diagnostics `string|string[]` warning
  local message = 'Data directory `' .. data_dir .. '`'

  -- check if exists
  if vim.fn.isdirectory(data_dir) ~= 1 then
    error(message .. ' does not exist')
    return
  end

  -- check if writable
  if vim.fn.filewritable(data_dir) == 2 then
    ok(message .. ' is writable')
  else
    error(message .. ' is not writable')
  end
end

---Checks the session directory.
local function check_session_directory()
  local session_dir = session.directory()
  local message = 'Session directory `' .. session_dir .. '`'

  -- check if exists
  if vim.fn.isdirectory(session_dir) ~= 1 then
    warn(message .. ' does not exist' .. '\n' .. 'This is normal if no sessions have been saved yet.')
    return
  end

  -- check if writable
  if vim.fn.filewritable(session_dir) == 2 then
    ok(message .. ' is writable')
  else
    error(message .. ' is not writable')
  end
end

---Checks the session files.
local function info_sessions()
  local session_dir = session.directory()
  local expr = '*.session.vim'

  -- get count of session files
  local session_files = vim.fn.globpath(session_dir, expr, true, true)
  local count = #session_files
  info('Session files: ' .. count)
end

---Checks the session file for the current working directory.
local function info_session()
  local session_filepath = session.filepath()
  local filename = vim.fs.basename(session_filepath)

  -- check if session file exists and is readable
  if vim.fn.filereadable(session_filepath) == 1 then
    info('Session file `' .. filename .. '` for current working directory exists')
  else
    info('No session file for current working directory')
  end
end

---Checks the health of the plugin.
function M.check()
  start('nvim-sessions')
  check_data_directory()
  check_session_directory()
  info_sessions()
  info_session()
end

return M
