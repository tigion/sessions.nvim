local config = require('sessions.config')
local notify = require('sessions.notify')
local util = require('sessions.util')

local text = {
  usage = 'Usage: `:Session info|save|load|delete`',
  health = 'Run `:checkhealth sessions` to check the health of the plugin.',
}

---@class sessions.session
local M = {}

---Returns the global directory path where session files are stored.
---@return string
function M.directory() return vim.fn.stdpath('data') .. '/' .. config.options.directory end

---Returns the filename of the session for the current working directory.
---@return string
function M.filename()
  local filename = util.get_dir_as_filename(vim.fn.getcwd())
  return filename .. '.session.vim'
end

---Returns the full path of the session file for the current working directory.
---@return string
function M.filepath() return M.directory() .. '/' .. M.filename() end

---Checks if the session file for the current working directory exists.
---@return boolean
function M.exists() return vim.fn.filereadable(M.filepath()) == 1 end

---Checks if an ignored file type is found.
---@return boolean, string|nil -- Returns true and the filetype if an ignored filetype is found, otherwise false.
local function is_ignored_filetype()
  local filetypes = util.get_window_filetypes()
  for _, ft in ipairs(filetypes) do
    if config.options.ignored_filetypes[ft] then return true, ft end
  end
  return false
end

---Creates the session file for the current working directory.
---@param filepath string -- The full path of the session file.
local function create_session_file(filepath)
  local session_opts = {}
  if config.options.ignore_blank then
    -- Workaround part 1/2: Ignores nvim-tree, outline or other special windows.
    --                      Remove `blank` temporary from session options.
    session_opts = { current = vim.opt.sessionoptions:get(), values = { 'blank' } }
    for idx, value in ipairs(session_opts.values) do
      if not vim.tbl_contains(session_opts.current, value) then table.remove(session_opts.values, idx) end
    end
    if #session_opts.values > 0 then vim.opt.sessionoptions:remove(session_opts.values) end
  end

  -- Creates the session file.
  local ok, error = pcall(function() vim.cmd('mksession! ' .. vim.fn.fnameescape(filepath)) end)
  if ok then
    if config.options.notify then notify.info('Session is saved.') end
  else
    notify.error('mksession: ' .. (error or 'Failed to save session.') .. '\n' .. text.health)
  end

  if config.options.ignore_blank then
    -- Workaround part 2/2: Restores vim.opt.sessionoptions.
    if #session_opts.values > 0 then vim.opt.sessionoptions:append(session_opts.values) end
  end
end

---Saves the session.
function M.save()
  -- Don't save session if there is an ignored filetype.
  local is_ignored, filetype = is_ignored_filetype()
  if is_ignored then
    notify.warn('Ignored filetype `' .. filetype .. '` found, session not saved.')
    return
  end

  local session_dir = M.directory()
  local session_filepath = M.filepath()

  -- Checks session directory and creates it if it doesn't exist.
  if vim.fn.isdirectory(session_dir) == 0 and not vim.fn.mkdir(session_dir, 'p') then
    -- Session directory doesn't exist and couldn't be created.
    notify.error('Failed to create session.\nSession directory is not creatable.\n' .. text.health)
    return
  elseif vim.fn.filewritable(session_dir) ~= 2 then
    -- Session directory isn't writable.
    notify.error('Failed to create session.\nSession directory is not writable.\n' .. text.health)
    return
  end

  -- Creates the session file and checks if it can be overwritten.
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

---Loads the session for the current working directory.
function M.load()
  local filepath = M.filepath()
  if not M.exists() then
    notify.warn('No session to load.')
    return
  end

  vim.cmd('source ' .. vim.fn.fnameescape(filepath))
  if config.options.notify then notify.info('Session is loaded.') end
end

---Deletes the session for the current working directory.
function M.delete()
  if not M.exists() then
    notify.warn('No session to delete.')
    return
  end

  local filepath = M.filepath()
  if vim.fn.delete(filepath) == 0 then
    if config.options.notify then notify.info('Session is deleted.') end
  else
    notify.error('Failed to delete session.\n' .. text.health)
  end
end

---Shows info about the session for the current working directory and the usage.
function M.info() notify.info((M.exists() and 'A' or 'No') .. ' saved session exists.\n' .. text.usage) end

---Shows the usage.
function M.usage() notify.warn(text.usage) end

return M
