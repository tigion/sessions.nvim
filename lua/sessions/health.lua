local session = require('sessions.session')
local util = require('sessions.util')

-- stylua: ignore start
local start = vim.health.start -- Starts a new report or section.
local ok    = vim.health.ok    -- Reports a success message.
local warn  = vim.health.warn  -- Reports a warning.
local info  = vim.health.info  -- Reports an informational message.
local error = vim.health.error -- Reports an error.
-- stylua: ignore end

---@class sessions.health
local M = {}

---Checks if a directory exists and is writable, reporting the result.
---@param name string
---@param path string
---@param missing_report fun(msg:string)
---@param note? string
---@return boolean
local function check_directory(name, path, missing_report, note)
  local location = '\nLocation: `' .. path .. '`'

  -- Check if the directory exists.
  if not util.is_directory(path) then
    missing_report(name .. ' does not exist' .. location .. (note or ''))
    return false
  end

  -- Check if the directory is writable.
  if util.is_writable_directory(path) then
    ok(name .. ' is writable' .. location)
  else
    error(name .. ' is not writable' .. location)
  end

  return true
end

---Checks the data directory.
local function check_data_directory()
  local data_dir = vim.fn.stdpath('data')
  check_directory('Data directory', data_dir, error)
end

---Checks the session directory.
---@return boolean True if the session directory exists, false otherwise.
local function check_session_directory()
  local session_dir = session.directory()
  local note = '\nThis is normal if no sessions have been saved yet.'
  return check_directory('Session directory', session_dir, warn, note)
end

---Checks the session file for the current working directory.
local function check_current_session()
  local message = 'Session file for current working directory'
  local file = '\nFile: `' .. session.filename() .. '`'
  local note = '\nThis is normal if no session has been saved yet.'

  -- Check if the session file exists.
  if not util.is_file(session.filepath()) then
    info(message .. ' does not exist' .. file .. note)
    return
  end

  -- Check if the session file is readable.
  if session.exists() then
    ok(message .. ' exists' .. file)
  else
    error(message .. ' is not readable' .. file)
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
