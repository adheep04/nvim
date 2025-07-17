local utils = require('utils')
local map = utils.map
local n = utils.n

-- COLEMAK KEYMAPPINGS ---------------------------------------------
-- Disable space in visual mode
map('v', '<Space>', '<Nop>')

-- Colemak navigation
map({ "n", "v", "o" }, "j", "h") 
map({ "n", "v", "o" }, "k", "j") 
map({ "n", "v", "o" }, "l", "k") 
map({ "n", "v", "o" }, ";", "l") 
map({ "n", "v", "o" }, "f", "/", { silent = false })

-- Line manipulation
n('K', ':m .+1<CR>', { desc = 'move line down' })
n('L', ':m .-2<CR>', { desc = 'move line up' })
n('<M-K>', 'yyp', { desc = 'duplicate line down' })
n('<M-L>', 'yyP', { desc = 'duplicate line up' })

-- Swap s and v functionality
map({ "n" }, "s", "v")
map({ "n" }, "v", "s")
map({ "n" }, "S", "V")
map({ "n" }, "V", "S")

-- Swap 'a' and 'i' functionality
map({ "n" }, "a", "i") 
map({ "n" }, "i", "a")
map({ "n" }, "A", "I") 
map({ "n" }, "I", "A")

map({ "n" }, "W", ":w<CR>") 
map({ "n" }, "<leader>q", ":q<CR>") 
map({ "n" }, "<M-Q>", ":q!<CR>") 

-- Visual mode: move selected lines
map('v', 'K', ":m '>+1<CR>gv=gv", { desc = 'move selection down' })
map('v', 'L', ":m '<-2<CR>gv=gv", { desc = 'move selection up' })

-- Copy/paste
n('<leader>C', ':%y+<CR>', { desc = 'copy whole buffer to clipboard' })
n('<leader>p', '"+P', { desc = 'paste' })
map({ "i" }, "<C-p>", '"+P') 
map('x', '<leader>y', function()
  vim.cmd('normal! y')
  -- Append new yank to + register with a newline
  local old = vim.fn.getreg('+')
  local new = vim.fn.getreg('"')
  vim.fn.setreg('+', old .. '\n' .. new)
end, { silent = true })
map('v', 'C', '"+y')
-- copy fold
n('cf', 'zaV"+yza', { desc = 'Copy fold content and close fold' })

-- Quick editing
map('n', '<leader>w', 'viw', { desc = 'Select inner word (Visual mode)' })
n('<C-z>', "u", { desc = 'undo' })
n('<leader>;', "i", { desc = 'insert mode' })
n('<C-S-d>', ':Twilight<CR>', { desc = 'Toggle Twilight' })
n('<C-c>', ':ColorizerToggle<CR>', { desc = 'Toggle Colorizer' })

n('zl', 'zk', { desc = 'next fold' })
n('zk', 'zj', { desc = 'previous fold' })
n('<leader>z', 'zMzvzz', { desc = 'focus current fold (close others)' })
n('<leader>F', function() pcall(vim.cmd, 'normal! zO') end, { desc = 'recursively open fold at cursor' })
n('<leader>f', function() pcall(vim.cmd, 'normal! za') end, { desc = 'toggle fold at cursor (smart, skip comments)' })


-- Custom <Esc> behavior for command-line search
vim.keymap.set('c', '<Esc>', function()
  -- Check if the command line is active and is a search command
  if vim.fn.getcmdtype() == '/' or vim.fn.getcmdtype() == '?' then
    -- Check if we actually typed something to search for
    if vim.fn.getcmdline() ~= '' then
      -- Simulate pressing Enter ('<CR>') to confirm the search at the current 'incsearch' location.
      -- The 't' mode in feedkeys ensures terminal codes like <CR> are interpreted correctly.
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 't', false)
      -- Immediately execute :nohlsearch to clear the highlight.
      vim.cmd('nohlsearch')
    else
      -- If we typed '/' or '?' then immediately '<Esc>', just cancel normally (like Ctrl-C).
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, true, true), 't', false)
    end
  else
    -- For any other command type (like :), cancel normally with Ctrl-C
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, true, true), 't', false)
  end
end, { desc = "Confirm incsearch pos & nohl, or cancel cmdline" })

-- esc (capsloc) to close all open windows
n('<Esc>', function()
  vim.cmd('nohlsearch')
  pcall(vim.cmd, 'close')
  vim.defer_fn(function()
    local windows_to_check = vim.api.nvim_list_wins()
    for i = #windows_to_check, 1, -1 do -- Iterate backwards when closing windows in a loop
      local winid = windows_to_check[i]
      if vim.api.nvim_win_is_valid(winid) then
        local config = vim.api.nvim_win_get_config(winid)
        -- Check if it's a floating window (not an external window like a web browser popup)
        if config and config.relative ~= "" and not config.external then
          vim.api.nvim_win_close(winid, false) -- Attempt to close the float
          -- 'false' means don't force close (e.g., if it's has unsaved changes, though unlikely for these floats)
        end
      end
    end
  end, 20)
end, { desc = 'clear highlights and close floats' })