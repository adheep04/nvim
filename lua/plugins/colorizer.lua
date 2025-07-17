return {
  "norcalli/nvim-colorizer.lua",
  event = "VeryLazy", -- Load the plugin before reading a buffer
  config = function()
    require("colorizer").setup({
      user_default_options = {
        RGB = true, -- Highlight #RGB hex codes
        RRGGBB = true, -- Highlight #RRGGBB hex codes
        names = true, -- Highlight "Name" codes like "red" or "blue"
        RRGGBBAA = false, -- Disable #RRGGBBAA hex codes
        AARRGGBB = false, -- Disable 0xAARRGGBB hex codes
        rgb_fn = true, -- Highlight CSS rgb() and rgba() functions
        hsl_fn = false, -- Disable CSS hsl() and hsla() functions
        css = false, -- Disable all CSS features (can be enabled if needed)
        css_fn = false, -- Disable all CSS *functions*
        mode = "background", -- Set the display mode to highlight the background
        tailwind = false, -- Disable Tailwind colors (enable if you use Tailwind CSS)
        virtualtext = "■", -- Character to use for virtual text (if mode is set to virtualtext)
        always_update = false, -- Update colors even if the buffer is not focused
      },
      filetypes = { "*" },
    })
  end,
}
