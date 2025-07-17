return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = "Telescope",
  keys = { 'F', 'G' },
  config = function()
    require('telescope').setup({
      defaults = {
        layout_strategy = 'horizontal',
        layout_config = { preview_width = 0.55 },
        file_ignore_patterns = { "node_modules", ".git/" },
        set_env = { COLORTERM = "truecolor" },
      }
    })
    
    local builtin = require('telescope.builtin')
    local utils = require('utils')

      local n = utils.n

      n('F', builtin.find_files, { desc = 'telescope find files' })
      n('G', builtin.live_grep, { desc = 'telescope live grep' })
  end
}
