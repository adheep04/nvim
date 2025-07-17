-- return {
--   "mbbill/undotree",
--   cmd = { "UndotreeToggle" },
--   keys = {
--     {
--       "<leader>u",
--       function()
--         vim.cmd.UndotreeToggle()
--         -- Your clever function to focus the undotree window
--         if vim.bo.filetype ~= "undotree" then
--           for _, win in ipairs(vim.api.nvim_list_wins()) do
--             if vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "filetype") == "undotree" then
--               vim.api.nvim_set_current_win(win)
--               break
--             end
--           end
--         end
--       end,
--       desc = "Toggle Undotree and focus",
--     },
--   },
--   config = false, -- No longer need the config function
-- }

-- In your plugins list
return {
  "mbbill/undotree",
  cmd = { "UndotreeToggle" },
  keys = {
    -- Use a direct command mapping instead of a Lua function
    { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
  },
}
