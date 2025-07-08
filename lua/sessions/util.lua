---@class sessions.util
local M = {}

---Returns a directory path as a filename.
--
-- Example:
-- - `/Kong/foo/bar` -> `Kong_foo_bar`
-- - `C:\Kong\foo\bar` -> `C_Kong_foo_bar`
--
---@param dir string
---@return string
function M.get_dir_as_filename(dir)
  -- trim leading and trailing slashes (back slashes)
  local filename = dir:gsub('^[/\\]+', ''):gsub('[/\\]+$', '')
  -- replace `/:\` (also multiple) with an underscore
  filename = filename:gsub('[:/\\]+', '_')
  return filename
end

---Returns the file types of the current buffer in all windows.
---@return string[]
function M.get_window_filetypes()
  return vim.tbl_map(function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype end, vim.api.nvim_list_wins())
end

---Returns the file types for all buffers.
---@return string[]
function M.get_buffer_filetypes()
  return vim.tbl_map(function(buf) return vim.bo[buf].filetype end, vim.api.nvim_list_bufs())
end

return M
