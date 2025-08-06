-- FILETYPE-SPECIFIC SETTINGS --------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    
    -- Python env detection
    if vim.env.VIRTUAL_ENV then
      vim.g.python3_host_prog = vim.env.VIRTUAL_ENV .. "/bin/python"
    end
  end
})
-- MISCELLANEOUS AUTOCMDS -------------------------------------------

-- Add this to auto-convert .ipynb files
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "*.ipynb",
  callback = function()
    vim.cmd(":%!jupytext --to py:percent --output - " .. vim.fn.expand("<afile>"))
    vim.bo.filetype = "python"
  end
})

-- RENDER MARKDOWN AUTOMATICALLY ------------------------------------
vim.api.nvim_create_autocmd({"BufReadPost"}, {
  pattern = {"*.md", "*.markdown"},
  callback = function()
    vim.defer_fn(function()
      vim.cmd("RenderMarkdown")
    end, 10)
  end,
})

-- RESTORE PERFORMANCE SETTINGS ------------------------------------
-- This runs at the end of your config to restore performance settings
vim.defer_fn(function()
  vim.opt.lazyredraw = false
end, 300)

-- Auto save on certain events
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = "*",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    
    -- Skip oil buffers and special buffers
    if vim.bo[buf].buftype ~= "" or vim.bo[buf].filetype == "oil" then
      return
    end
    
    -- Check if buffer is valid for saving
    local valid = vim.api.nvim_buf_is_valid(buf) 
      and vim.bo[buf].buflisted
      and vim.bo[buf].modified 
      and not vim.bo[buf].readonly 
      and vim.fn.expand("%") ~= ""
      and vim.bo[buf].modifiable
    
    if valid then
      vim.cmd("silent! write")
    end
  end,
  nested = true,
})

-- Also save on focus lost
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  pattern = "*",
  callback = function()
    -- Only save normal buffers (not oil or special buffers)
    if vim.bo.buftype == "" and vim.bo.filetype ~= "oil" then
      vim.cmd("silent! wall")
    end
  end,
})


