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
  local data_dir = vim.fn.stdpath('data')
  local message = 'Data directory'
  local message_location = '\nLocation: `' .. data_dir .. '`'

  -- Checks if it exists.
  if vim.fn.isdirectory(data_dir) ~= 1 then
    error(message .. ' does not exist' .. message_location)
    return
  end

  -- Checks if it is writable.
  if vim.fn.filewritable(data_dir) == 2 then
    ok(message .. ' is writable' .. message_location)
  else
    error(message .. ' is not writable' .. message_location)
  end
end

---Checks the session directory.
---@return boolean True if the session directory exists, false otherwise.
local function check_session_directory()
  local session_dir = session.directory()
  local message = 'Session directory'
  local message_location = '\nLocation: `' .. session_dir .. '`'
  local message_note = '\nThis is normal if no sessions have been saved yet.'

  -- Checks if it exists.
  if vim.fn.isdirectory(session_dir) ~= 1 then
    warn(message .. ' does not exist' .. message_location .. message_note)
    return false
  end

  -- Checks if it is writable.
  if vim.fn.filewritable(session_dir) == 2 then
    ok(message .. ' exists and is writable' .. message_location)
  else
    error(message .. ' exists, but is not writable' .. message_location)
  end

  return true
end

---Checks the session file for the current working directory.
local function check_current_session()
  local filename = session.filename()
  local message = 'Session file for current working directory'
  local message_file = '\nFile: `' .. filename .. '`'
  local message_note = '\nThis is normal if no session has been saved yet.'

  -- Shows if the session file exists.
  if session.exists() then
    ok(message .. ' exists' .. message_file)
  else
    info(message .. ' does not exist' .. message_file .. message_note)
  end
end

---Checks the session files.
local function check_sessions()
  local session_dir = session.directory()
  local expr = '*.session.vim'

  -- Shows the count of session files.
  local session_files = vim.fn.globpath(session_dir, expr, true, true)
  local count = #session_files
  info('Found ' .. count .. ' session file' .. (count ~= 1 and 's' or '') .. ' in the session directory.')
end

---Checks the health of the plugin.
function M.check()
  start('sessions.nvim')
  check_data_directory()
  if check_session_directory() then
    check_current_session()
    check_sessions()
  end
end

return M
