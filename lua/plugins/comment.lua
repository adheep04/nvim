return {
  'numToStr/Comment.nvim',
  keys = { "<leader>/" },  -- Update to the new key
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require('Comment').setup({
      toggler = { line = '<leader>/' },  -- New key for toggling
      opleader = { line = '<leader>/' },  -- New key for operator mode
      mappings = { basic = true, extra = false }
    })
  end,
}
