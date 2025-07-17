return {
  "karb94/neoscroll.nvim",
  event = "WinScrolled",
  keys = { "<leader>k", "<leader>l", "<leader>K", "<leader>L" },
  config = function()
    require("neoscroll").setup({
      easing_function = "quadratic",
      hide_cursor = true,
      stop_eof = true,
      -- performance_mode = true,  -- Added for better performance
    })

    local utils = require('utils')
    local n = utils.n

    n('<leader>k', function() 
      require('neoscroll').scroll(15, { duration = 150, easing = 'quadratic' }) 
    end, { desc = 'scroll down fast' })

    n('<leader>l', function() 
      require('neoscroll').scroll(-15, { duration = 150, easing = 'quadratic' }) 
    end, { desc = 'scroll up fast' })

    n('<leader>K', function() 
      require('neoscroll').scroll(vim.wo.scroll, { duration = 150, easing = 'quadratic' }) 
    end, { desc = 'scroll down page' })

    n('<leader>L', function() 
      require('neoscroll').scroll(-vim.wo.scroll, { duration = 150, easing = 'quadratic' }) 
    end, { desc = 'scroll up page' })
  end,
}
