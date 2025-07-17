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



