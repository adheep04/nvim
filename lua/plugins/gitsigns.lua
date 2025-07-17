return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = " " },
        topdelete = { text = "▔" },
        changedelete = { text = "▎" },
      },
      update_debounce = 200,  -- Increased debounce for better performance
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        
        local utils = require('utils')
        local n = utils.n

        n('<leader>gb', gs.toggle_current_line_blame, { buffer = bufnr, desc = "toggle git blame" })
        n('<leader>gp', gs.preview_hunk, { buffer = bufnr, desc = "preview git hunk" })
        n('<leader>gr', gs.reset_hunk, { buffer = bufnr, desc = "reset git hunk" })
      end,
    })
  end,
}
