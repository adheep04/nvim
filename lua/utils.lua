
local M = {}

-- Enhanced map function with defaults
function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap ~= false
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Normal mode helper
function M.n(lhs, rhs, opts)
  M.map("n", lhs, rhs, opts)
end

return M
