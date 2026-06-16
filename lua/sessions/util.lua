---@class sessions.util
local M = {}

---Returns a filename-friendly string based on the given path.
--
-- Example:
-- - `/Kong/foo/bar` -> `Kong_foo_bar`
-- - `C:\Kong\foo\bar` -> `C_Kong_foo_bar`
--
---@param path string
---@return string
local function get_path_as_filename(path)
  -- Trim leading and trailing slashes (back slashes).
  local filename = path:gsub('^[/\\]+', ''):gsub('[/\\]+$', '')
  -- Replace `/:\` (also multiple) with an underscore.
  filename = filename:gsub('[:/\\]+', '_')
  return filename
end

---Returns a session name based on the given path
---with a hash suffix to avoid name collisions.
---@param path string
---@return string
function M.get_session_name(path)
  local hash = vim.fn.sha256(path):sub(1, 10)
  local filename = get_path_as_filename(path)
  return filename .. '_' .. hash
end

---Returns the file types of viewable buffers in valid windows.
---@return string[]
function M.get_window_filetypes()
  local valid_wins = vim.tbl_filter(function(win) return vim.api.nvim_win_is_valid(win) end, vim.api.nvim_list_wins())
  return vim.tbl_map(function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype end, valid_wins)
end

---Returns the file types of valid buffers.
---@return string[]
function M.get_buffer_filetypes()
  local valid_bufs = vim.tbl_filter(function(buf) return vim.api.nvim_buf_is_valid(buf) end, vim.api.nvim_list_bufs())
  return vim.tbl_map(function(buf) return vim.bo[buf].filetype end, valid_bufs)
end

return M
