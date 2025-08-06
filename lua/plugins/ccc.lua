return {
  'uga-rosa/ccc.nvim',
  event = "BufEnter", -- Load on buffer enter
  config = function()
    require('ccc').setup({
      highlighter = {
        auto_enable = true,  -- This is the key setting!
        lsp = true,
      },
    })
  end
}
