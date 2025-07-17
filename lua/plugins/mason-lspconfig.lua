return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = { "pylsp", "lua_ls" },
      automatic_installation = true,
    })
  end
}
