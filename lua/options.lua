-- Performance settings
vim.opt.lazyredraw = true
vim.opt.shadafile = "NONE"            -- Disable shada file during startup
vim.g.matchparen_timeout = 20
vim.g.matchparen_insert_timeout = 20

-- Basic visual and behavioral settings
vim.opt.termguicolors = true
vim.opt.laststatus = 2
vim.opt.showcmd = true
vim.opt.cursorline = true
vim.opt.updatetime = 500
vim.opt.mouse = "nv"
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.list = false
vim.opt.breakindent = true
-- vim.opt.breakindentopt = "shift:1"

-- Create swap directory
local swapdir = vim.fn.stdpath('state') .. '/swap//'
if vim.fn.isdirectory(swapdir) == 0 then
  vim.fn.mkdir(swapdir, "p")
end
vim.opt.directory = swapdir

-- Create undo directory and setup
local undodir = vim.fn.stdpath("data") .. "/undodir"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undofile = true

-- Files and buffers
vim.opt.autowrite = true
vim.opt.autoread = true

-- Line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Indentation (default)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

-- Scrolling
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "nosplit"

-- Python environment detection (simplified)
vim.g.python3_host_prog = vim.fn.exepath('python3')
