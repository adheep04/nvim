return {
  "williamboman/mason.nvim",
  cmd = { "Mason", "MasonUpdate" },
  event = { "BufReadPre", "BufNewFile" },
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
  end
}
