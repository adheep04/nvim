return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  event = "BufReadPost",
  config = function()
    -- Tell Neovim to use ufo's fold settings
    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.foldmethod = "manual"
    vim.opt.fillchars = vim.opt.fillchars + {
      fold = " ",
      eob = " ",
      foldopen = "▾",
      foldclose = "▸",
      foldsep = "│",
    }

    -- Using ufo provider need remap `zR` and `zM`
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

    require('ufo').setup({
      provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
      end
    })
  end
}
