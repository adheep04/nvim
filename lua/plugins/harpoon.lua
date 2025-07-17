return {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>m", function() require("harpoon.mark").add_file() end, desc = "Mark file with harpoon" },
    { "<leader>M", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon menu" },
    { "<leader>1", function() require("harpoon.ui").nav_file(1) end },
    { "<leader>2", function() require("harpoon.ui").nav_file(2) end },
    { "<leader>3", function() require("harpoon.ui").nav_file(3) end },
    { "<leader>4", function() require("harpoon.ui").nav_file(4) end },
    { "<leader>5", function() require("harpoon.ui").nav_file(5) end },
    { "<leader>6", function() require("harpoon.ui").nav_file(6) end },
    { "<leader>7", function() require("harpoon.ui").nav_file(7) end },
    { "<leader>8", function() require("harpoon.ui").nav_file(8) end },
    { "<leader>9", function() require("harpoon.ui").nav_file(9) end },
  },
  config = function()
    require("harpoon").setup({
      menu = { width = 60 },
      global_settings = { mark_branch = true }
    })
  end
}
