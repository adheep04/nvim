return {
  "gioele/vim-autoswap",
  event = "BufReadPre",
  init = function()
    vim.g.autoswap_detect_tmux = 1  -- Optional: jump to correct tmux pane
  end,
}
