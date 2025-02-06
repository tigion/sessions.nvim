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

return M
