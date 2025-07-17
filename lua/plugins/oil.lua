return {
  "stevearc/oil.nvim",
  keys = { 
    { "e", "<CMD>Oil --float<CR>", desc = "open oil (float)" }
  },
  cmd = "Oil",
  opts = {
    view_options = { show_hidden = true },
    float = {
      padding = 2,
      max_width = 80,
      max_height = 40,
      border = "rounded",
      win_options = { winblend = 10 },
    },
    default_file_explorer = true,
    delete_to_trash = true,
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      -- ["<C-s>"] = "actions.select_vsplit",
      ["<C-s>"] = "actions.select_vsplit",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<C-r>"] = "actions.refresh",
      ["J"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["~"] = "actions.tcd",
      ["g."] = "actions.toggle_hidden",
      ["<leader>c"] = {
        desc = 'Copy filepath to system clipboard',
        callback = function ()
          require('oil.actions').copy_entry_path.callback()
          vim.fn.setreg("+", vim.fn.getreg(vim.v.register))
        end,
      },
    },
    columns = { "icon", "size" },
    watch_for_changes = true,
    case_insensitive = true,
  },
}
