---@class sessions.util
local M = {}

---Converts a path to a filename-safe string.
---
---Trims leading/trailing separators and replaces path separators
---and colons with underscores.
---
-- Example:
-- - `/Kong/foo/bar` -> `Kong_foo_bar`
-- - `C:\Kong\foo\bar` -> `C_Kong_foo_bar`
---@param path string
---@return string filename
local function path_to_filename(path)
  -- Trim leading/trailing path separators (`/` or `\`).
  local filename = path:gsub('^[/\\]+', ''):gsub('[/\\]+$', '')
  -- Replace path separators and `:` (including mixed sequences)
  -- with a single underscore.
  filename = filename:gsub('[:/\\]+', '_')
  return filename
end

---Generates a unique session name for the given path.
---
---Combines a filename-safe version of the path with a SHA256 hash to ensure
---uniqueness across different paths.
---
-- Example:
-- - `/Kong/foo/bar` -> `Kong_foo_bar_2f1b9ef130`
-- - `/Kong/foo_bar` -> `Kong_foo_bar_f09ba38b95`
---@param path string
---@return string
function M.session_name_for_path(path)
  local filename = path_to_filename(path)
  local hash = vim.fn.sha256(path):sub(1, 10)
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
