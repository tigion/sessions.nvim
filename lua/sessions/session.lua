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
function M.exists() return vim.fn.filereadable(M.filepath()) == 1 and true or false end

---Checks if a file type is in the ignore list.
---@return boolean
local function is_ignored_filetype()
  local filetypes = util.get_window_filetypes()
  for _, ft in ipairs(filetypes) do
    if vim.list_contains(config.options.ignored_filetypes, ft) then return true end
  end
  return false
end

---Saves the session for the current working directory.
function M.save()
  -- Don't save session if there is an ignored filetype.
  if is_ignored_filetype() then
    notify.warn('Ignored filetype found, session not saved.')
    return
  end

  local dir = M.directory()
  local filepath = M.filepath()

  -- Checks session directory and creates it if it doesn't exist.
  if
    vim.fn.isdirectory(dir) == 0 -- doesn't exist
      and not vim.fn.mkdir(dir, 'p') -- couldn't create
    or vim.fn.filewritable(dir) ~= 2 -- isn't writable
  then
    notify.error('Failed to create session.\n' .. text.health)
    return
  end

  -- Checks if a session file exists.
  if not config.options.overwrite and M.exists() then
    -- vim.fn.input / vim.ui.input / vim.ui.select
    local input = vim.fn.input('Overwrite existing session? (y/n): ')
    if input ~= 'y' then
      if config.options.notify then notify.info('No session is saved') end
      return
    end
  end

  -- Workaround to ignore nvim-tree, outline or other special windows
  --
  -- TODO: Find a better solution
  --
  local sessionoptions = { manipulate = false, value = '' }
  if vim.o.sessionoptions:find('blank') ~= nil then
    -- manipulate vim.opt.sessionoptions
    sessionoptions.manipulate = true
    sessionoptions.value = 'blank'
    vim.cmd('set sessionoptions-=' .. sessionoptions.value)
  end

  -- Saves the session.
  -- local ok, error = xpcall(function() vim.cmd('mksession ' .. session_filepath) end, debug.traceback)
  local ok, error = pcall(function() vim.cmd('mksession! ' .. filepath) end)
  if ok then
    if config.options.notify then notify.info('Session is saved.') end
  else
    notify.error('mksession: ' .. (error or 'Failed to save session.') .. '\n' .. text.health)
  end

  -- Restores vim.opt.sessionoptions.
  if sessionoptions.manipulate then vim.cmd('set sessionoptions=' .. sessionoptions.value) end
end

---Loads the session for the current working directory.
function M.load()
  local filepath = M.filepath()
  if not M.exists() then
    notify.warn('No session to load.')
    return
  end

  vim.cmd('source ' .. filepath)
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

---Shows infos about the session for the current working directory and the usage.
function M.info() notify.info((M.exists() and 'A' or 'No') .. ' saved session exists.\n' .. text.usage) end

---Shows the usage.
function M.usage() notify.warn(text.usage) end

return M
