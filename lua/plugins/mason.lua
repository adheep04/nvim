return {
  "williamboman/mason.nvim",
  cmd = { "Mason", "MasonUpdate" },
  build = ":MasonUpdate",
  config = function()
    require("mason").setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })
    vim.api.nvim_exec_autocmds("User", { pattern = "MasonDone" })
  end
}
