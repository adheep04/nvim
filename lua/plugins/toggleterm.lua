return {
  "akinsho/toggleterm.nvim",
  keys = { 
    { ",", function()
      vim.cmd("ToggleTerm")
      -- Small delay to ensure terminal is open, then enter insert mode
      vim.defer_fn(function()
        if vim.bo.buftype == 'terminal' then
          vim.cmd('startinsert')
        end
      end, 50)
    end, mode = "n", desc = "Toggle terminal and enter terminal mode" }
  },
  cmd = { "ToggleTerm", "TermExec" },
  config = function()
    require("toggleterm").setup({
      size = 20,
      open_mapping = false,
      hide_numbers = false,
      direction = "float",
      float_opts = {
        border = "curved",
        winblend = 0,
      },
      close_on_exit = true,
      shell = vim.o.shell, 
      env = {
        TERM = "xterm-kitty"
      },
    })

    -- Make it easier to exit terminal mode
    vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  end
}