local config = require('sessions.config')
local notify = require('sessions.notify')
local util = require('sessions.util')

local text = {
  usage = 'Usage: `:Session info|save|load|delete`',
  health = 'Run `:checkhealth sessions` to check the health of the plugin.',
}

---@class sessions.session
local M = {}

--- Returns the global directory path where session files are stored.
---@return string
function M.directory() return vim.fn.stdpath('data') .. '/' .. config.options.directory end

--- Returns the filename of the session for the current working directory.
---@return string
function M.filename()
  local session_name = util.session_name_for_path(vim.fn.getcwd())
  return session_name .. '.session.vim'
end

--- Returns the full path of the session file for the current working directory.
---@return string
function M.filepath() return M.directory() .. '/' .. M.filename() end

--- Checks if the session file for the current working directory
--- exists and is readable.
---@return boolean
function M.exists() return util.is_readable_file(M.filepath()) end

--- Checks if an ignored file type is found.
---@return boolean, string|nil -- Returns true and the filetype if an ignored filetype is found, otherwise false.
local function is_ignored_filetype()
  local filetypes = util.get_window_filetypes()
  for _, ft in ipairs(filetypes) do
    if config.options.ignored_filetypes[ft] then return true, ft end
  end
  return false
end

--- Creates the session file for the current working directory
--- by executing the `:mksession` command.
---@param filepath string -- The full path of the session file.
local function create_session_file(filepath)
  local had_blank = false

  -- Remove 'blank' from sessionoptions if ignore_blank is enabled and is currently set.
  if config.options.ignore_blank then
    had_blank = vim.tbl_contains(vim.opt.sessionoptions:get(), 'blank')
    if had_blank then vim.opt.sessionoptions:remove('blank') end
  end

  -- Create the session file by executing the mksession command.
  local ok, err = pcall(function() vim.cmd({ cmd = 'mksession', bang = true, args = { filepath } }) end)

  -- Restore 'blank' to sessionoptions if it was removed.
  if had_blank then vim.opt.sessionoptions:append('blank') end

  if ok then
    if config.options.notify then notify.info('Session is saved.') end
  else
    notify.error('mksession: ' .. (err or 'Failed to save session.') .. '\n' .. text.health)
  end
end

--- Saves the session for the current working directory.
function M.save()
  -- Don't save session if there is an ignored filetype.
  local is_ignored, filetype = is_ignored_filetype()
  if is_ignored then
    notify.warn('Ignored filetype `' .. filetype .. '` found, session not saved.')
    return
  end

  local session_dir = M.directory()

  -- Check session directory and create it if it doesn't exist.
  if not util.is_directory(session_dir) and not vim.fn.mkdir(session_dir, 'p') then
    notify.error('Failed to create session.\nSession directory is not creatable.\n' .. text.health)
    return
  elseif not util.is_writable_directory(session_dir) then
    notify.error('Failed to create session.\nSession directory is not writable.\n' .. text.health)
    return
  end

  local session_filepath = M.filepath()

  -- Create the session file and check if it can be overwritten.
  if not config.options.overwrite and M.exists() then
    vim.ui.input({ prompt = 'Overwrite existing session? (y/N): ' }, function(input)
      if not input or input ~= 'y' then
        if config.options.notify then notify.info('Session not saved') end
        return
      end
      create_session_file(session_filepath)
    end)
  else
    create_session_file(session_filepath)
  end
end

--- Loads the session for the current working directory.
function M.load()
  if not M.exists() then
    notify.warn('No session to load.')
    return
  end

  -- Source the session file.
  local ok, err = pcall(function() vim.cmd({ cmd = 'source', args = { M.filepath() } }) end)
  if ok then
    if config.options.notify then notify.info('Session is loaded.') end
  else
    notify.error('source: ' .. (err or 'Failed to source session.') .. '\n' .. text.health)
  end
end

--- Deletes the session for the current working directory.
function M.delete()
  if not M.exists() then
    notify.warn('No session to delete.')
    return
  end

  if vim.fn.delete(M.filepath()) == 0 then
    if config.options.notify then notify.info('Session is deleted.') end
  else
    notify.error('Failed to delete session.\n' .. text.health)
  end
end

--- Shows info about the session for the current working directory and the usage.
function M.info() notify.info((M.exists() and 'A' or 'No') .. ' saved session exists.\n' .. text.usage) end

--- Shows the usage.
function M.usage() notify.warn(text.usage) end

return M
