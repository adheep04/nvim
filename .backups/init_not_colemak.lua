-- ██╗███╗   ██╗██╗████████╗██╗     ██╗   ██╗ █████╗
-- ██║████╗  ██║██║╚══██╔══╝██║     ██║   ██║██╔══██╗
-- ██║██╔██╗ ██║██║   ██║   ██║     ██║   ██║███████║
-- ██║██║╚██╗██║██║   ██║   ██║     ██║   ██║██╔══██║
-- ██║██║ ╚████║██║   ██║   ███████╗╚██████╔╝██║  ██║
-- ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   ╚══════╝ ╚═════╝ ╚═╝  ╚═╝

-- Set log level early to reduce noise
vim.lsp.set_log_level('WARN')

-- Leaders - Set these early as they might be needed before plugins load
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- BOOTSTRAP PACKAGE MANAGER ---------------------------------------
-- Bootstrap lazy.nvim package manager (moved up to load earlier)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- HELPER FUNCTIONS ------------------------------------------------
-- Enhanced map function with defaults
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap ~= false
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Normal mode helper
local function n(lhs, rhs, opts)
  map("n", lhs, rhs, opts)
end

-- Simple fold toggle
local function smart_fold_toggle()
  pcall(vim.cmd, 'normal! za')
end

-- Simple recursive unfold
local function recursive_unfold()
  pcall(vim.cmd, 'normal! zO')
end

-- Smart paste function that uses the most recent copy
local function smart_paste(before_cursor)
  -- Get the unnamed register (default yank)
  local unnamed = vim.fn.getreg('"')
  local unnamed_time = vim.fn.getreginfo('"').time or 0
  
  -- Get the clipboard register
  local clipboard = vim.fn.getreg('+')
  local clipboard_time = vim.fn.getreginfo('+').time or 0
  
  -- Determine which paste command to use
  local paste_cmd = before_cursor and 'P' or 'p'
  
  -- Check if both registers are empty
  if unnamed == '' and clipboard == '' then
    vim.notify("Nothing to paste", vim.log.levels.WARN)
    return
  end
  
  -- Use whichever was set more recently
  if clipboard ~= '' and (unnamed == '' or clipboard_time > unnamed_time) then
    vim.cmd('normal! "+' .. paste_cmd)
  elseif unnamed ~= '' then
    vim.cmd('normal! ' .. paste_cmd)
  end
end

-- EDITOR SETTINGS -------------------------------------------------
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

-- Fold visual settings
vim.opt.foldcolumn = '3'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.fillchars = vim.opt.fillchars + {
  fold = " ",
  foldopen = "▾",
  foldclose = "▸",
  foldsep = "│",
}




-- UI HELPERS AND DIAGNOSTICS --------------------------------------
-- Function to configure UI elements, called once after plugins load
local function setup_ui_elements()
   -- Configure LSP handlers
  local handler_opts = { border = "rounded", width = 60 }
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, handler_opts)
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, handler_opts)
  
  -- Customized highlight groups
  vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#2d3149", blend = 70 })
  vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#2d3149", blend = 70 })
  vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#2d3149", blend = 70 })
  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#8b5d65" })
  vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#8b77a0" })
  vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#6a92d7" })
  vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#56b6c2" })
  vim.api.nvim_set_hl(0, "Search", { bg = "#2d3149", fg = "#c0caf5", blend = 30 })
  vim.api.nvim_set_hl(0, "IncSearch", { bg = "#3e68d7", fg = "#c0caf5", bold = true, blend = 30 })
  vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#8094b4", italic = true })
  vim.api.nvim_set_hl(0, "Folded", { fg = "#565f89", bg = "NONE", italic = true })
  vim.api.nvim_set_hl(0, "FoldColumn", { fg = "#565f89", bg = "NONE" })
end

-- STANDARD KEYMAPPINGS --------------------------------------------
-- Disable space in visual mode
map('v', '<Space>', '<Nop>')
n('f', '/')

-- Line manipulation
n('J', ':m .+1<CR>', { desc = 'move line down' })
n('K', ':m .-2<CR>', { desc = 'move line up' })
n('<M-J>', 'yyp', { desc = 'duplicate line down' })
n('<M-K>', 'yyP', { desc = 'duplicate line up' })

-- Standard save/quit
map({ "n" }, "W", ":w<CR>") 
map({ "n" }, "<leader>q", ":q<CR>") 
map({ "n" }, "<leader>Q", ":q!<CR>") 

-- Visual mode: move selected lines
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'move selection up' })

-- Copy/paste
n('<leader>C', ':%y+<CR>', { desc = 'copy whole buffer to clipboard' })
n('<leader>p', '"+P', { desc = 'paste' })
n('p', function() smart_paste(false) end, { desc = 'paste most recent copy' })
n('P', function() smart_paste(true) end, { desc = 'paste most recent copy (before cursor)' })
map({ "i" }, "<C-p>", '"+P') 
map('x', '<leader>y', function()
  -- Yank visual selection to unnamed register
  vim.cmd('normal! y')
  -- Append new yank to + register with a newline
  local old = vim.fn.getreg('+')
  local new = vim.fn.getreg('"')
  vim.fn.setreg('+', old .. '\n' .. new)
end, { silent = true })
map('v', 'C', '"+y')
-- copy fold
n('cf', 'zaV"+yza', { desc = 'Copy fold content and close fold' })

-- Quick editing
map('n', '<leader>w', 'viw', { desc = 'Select inner word (Visual mode)' })
n('<C-z>', "u", { desc = 'undo' })
n('<leader>i', "i", { desc = 'insert mode' })

-- Fold keymaps
n('zR', '<cmd>set foldlevel=99<CR>', { desc = 'open all folds' })
n('zM', '<cmd>set foldlevel=0<CR>', { desc = 'close all folds' })
n('<leader>z', 'zMzvzz', { desc = 'focus current fold (close others)' })
n('<leader>F', recursive_unfold, { desc = 'recursively open fold at cursor' })
n('<leader>f', smart_fold_toggle, { desc = 'toggle fold at cursor (smart, skip comments)' })




-- PLUGIN DEFINITIONS ----------------------------------------------
local plugins = {
  -- Theme (non-lazy loaded since needed at startup)
  { 
    "folke/tokyonight.nvim", 
    name = "tokyonight", 
    priority = 1000,
    lazy = false,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = false,
        styles = {
          comments = { italic = true },
          keywords = { bold = true },
        },
        on_colors = function(colors)
          colors.comment = "#565f89" -- darker muted gray for comments
        end,
      })
      
      -- Set colorscheme
      vim.cmd("colorscheme tokyonight-night")
      
      -- Set up UI elements after colorscheme is loaded
      setup_ui_elements()
    end
  },

  -- Icons (lazy-loaded as dependency)
  { "nvim-tree/nvim-web-devicons", lazy = true },
  
   -- Undo history visualization
  {
    "mbbill/undotree",
    keys = { "<leader>u" },
    cmd = { "UndotreeToggle" },
    config = function()
      local function undotreeToggleWithFocus()
        vim.cmd.UndotreeToggle()
        if vim.bo.filetype ~= "undotree" then
          for _, win in pairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_buf_get_option(buf, "filetype") == "undotree" then
              vim.api.nvim_set_current_win(win)
              break
            end
          end
        end
      end

      n("<leader>u", undotreeToggleWithFocus, { desc = "toggle undotree with focus" })
    end
  },

  -- Treesitter syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "vim", "query" },
        highlight = { enable = true },
        indent = { enable = true },
      })

      -- Enable Treesitter folding
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },

  -- Telescope fuzzy finder
  {
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
      n('F', builtin.find_files, { desc = 'telescope find files' })
      n('G', builtin.live_grep, { desc = 'telescope live grep' })
    end
  },

  {
    "gioele/vim-autoswap",
    event = "BufReadPre",
    init = function()
      vim.g.autoswap_detect_tmux = 1  -- Optional: jump to correct tmux pane
    end,
  },

  -- File explorer (oil)
  {
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
        ["<C-s>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["-"] = "actions.parent",
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
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    keys = { "<leader>j", "<leader>k", "<leader>J", "<leader>K" },
    config = function()
      require("neoscroll").setup({
        easing_function = "quadratic",
        hide_cursor = true,
        stop_eof = true,
        -- performance_mode = true,  -- Added for better performance
      })

      n('<leader>j', function() 
        require('neoscroll').scroll(10, { duration = 150, easing = 'quadratic' }) 
      end, { desc = 'scroll down fast' })

      n('<leader>k', function() 
        require('neoscroll').scroll(-10, { duration = 150, easing = 'quadratic' }) 
      end, { desc = 'scroll up fast' })

      n('<leader>J', function() 
        require('neoscroll').scroll(vim.wo.scroll, { duration = 150, easing = 'quadratic' }) 
      end, { desc = 'scroll down page' })

      n('<leader>K', function() 
        require('neoscroll').scroll(-vim.wo.scroll, { duration = 150, easing = 'quadratic' }) 
      end, { desc = 'scroll up page' })
    end,
  },
  
  -- Comment toggling
  {
    'numToStr/Comment.nvim',
    keys = { "<leader>/" },  -- Update to the new key
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('Comment').setup({
        toggler = { line = '<leader>/' },  -- New key for toggling
        opleader = { line = '<leader>/' },  -- New key for operator mode
        mappings = { basic = true, extra = false }
      })
    end,
  },

  -- Auto-pair brackets and quotes
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function() require('nvim-autopairs').setup({}) end,
  },

 -- LSP configuration (for Python and other languages) - Streamlined
  {
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
  },
  
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "pylsp", "ruff" },
        automatic_installation = true,
      })
    end
  },

  -- Simplified LSP setup
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre *.py", "BufReadPre *.lua" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Get capabilities from cmp-nvim-lsp (cached)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Configure Python LSP (pylsp instead of pyright)
      require("lspconfig").pylsp.setup {
        before_init = function(_, config)
          if vim.env.VIRTUAL_ENV then
            config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
              pylsp = {
                plugins = {
                  jedi = {
                    environment = vim.env.VIRTUAL_ENV .. "/bin/python"
                  }
                }
              }
            })
          elseif vim.g.python3_host_prog then
            config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
              pylsp = {
                plugins = {
                  jedi = {
                    environment = vim.g.python3_host_prog
                  }
                }
              }
            })
          end
        end,
        settings = {
          pylsp = {
            plugins = {
              -- Disable linters we don't want
              pycodestyle = { enabled = false },
              flake8 = { enabled = false },
              autopep8 = { enabled = false },
              mccabe = { enabled = false },
              pyflakes = { enabled = false },
              -- Use ruff for linting if you have it installed
              ruff = { enabled = true },
              -- Jedi for completion and hover
              jedi_completion = { 
                enabled = true,
                include_params = true,
                fuzzy = true
              },
              jedi_hover = { enabled = true },
              jedi_references = { enabled = true },
              jedi_signature_help = { enabled = true },
              jedi_symbols = { enabled = true, all_scopes = true },
            }
          }
        },
        capabilities = capabilities,
      }

      -- Configure ruff_lsp
      require("lspconfig").ruff.setup {
        capabilities = capabilities,
      }
      
      -- LSP mappings (consolidated)
      n('gd', vim.lsp.buf.definition, { desc = 'go to definition' })
      n('gr', vim.lsp.buf.references, { desc = 'go to references' })
      n('hd', vim.lsp.buf.hover, { desc = 'hover documentation' })
      n('<leader>rn', vim.lsp.buf.rename, { desc = 'rename symbol' })
      n('<leader>ca', vim.lsp.buf.code_action, { desc = 'code action' })
      n('<leader>ds', function() vim.lsp.buf.document_symbol() end, { desc = 'document symbol' })
      n('<leader>dj', vim.diagnostic.goto_next, { desc = 'next diagnostic' })
      n('<leader>dk', vim.diagnostic.goto_prev, { desc = 'previous diagnostic' })
      n('<leader>D', function()
        vim.diagnostic.open_float({
          focusable = false,
          close_events = { "BufLeave", "BufHidden", "InsertEnter"},
          border = "rounded",
          scope = "cursor",
        })
      end, { desc = 'show diagnostics (manual close with Esc)' })
    end
  },
  
  -- Completion framework
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Only load VSCode snippets for filetypes we use
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { "python", "lua" },
      })

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp', max_item_count = 10 },
          { name = 'luasnip', max_item_count = 5 },
          { name = 'buffer', max_item_count = 3 },
          { name = 'path', max_item_count = 3 },
        }),
        formatting = {
          format = function(entry, vim_item)
            vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, 30)
            return vim_item
          end
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = { enabled = true },
        },
        performance = {
          max_view_entries = 10,
          debounce = 200,
          throttle = 50,         
  },

      })

      -- Cmdline completions (simplified)
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {{ name = 'buffer', max_item_count = 5 }}
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {{ name = 'path', max_item_count = 5 }, { name = 'cmdline', max_item_count = 5 }}
      })
    end
  },

  {
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
  },

  -- toggleterm
  {
    "akinsho/toggleterm.nvim",
    keys = { 
      { "t", function()
        vim.cmd("ToggleTerm")
        -- Small delay to ensure terminal is open, then enter insert mode
        vim.defer_fn(function()
          if vim.bo.buftype == 'terminal' then
            vim.cmd('startinsert')
          end
        end, 50)
      end, mode = "n", desc = "Toggle terminal and enter terminal mode" }
    },
    cmd = { "ToggleTerm", "TermExec" },
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = false,
        hide_numbers = false,
        direction = "float",
        float_opts = {
          border = "curved",
          winblend = 0,
        },
        close_on_exit = true,
        shell = vim.o.shell, 
        env = {
          TERM = "xterm-kitty"
        },
      })

      -- Make it easier to exit terminal mode
      vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
    end
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "▁" },
          topdelete = { text = "▔" },
          changedelete = { text = "▎" },
        },
        update_debounce = 200,  -- Increased debounce for better performance
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          
          n('<leader>gb', gs.toggle_current_line_blame, { buffer = bufnr, desc = "toggle git blame" })
          n('<leader>gp', gs.preview_hunk, { buffer = bufnr, desc = "preview git hunk" })
          n('<leader>gr', gs.reset_hunk, { buffer = bufnr, desc = "reset git hunk" })
        end,
      })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    config = function()
      -- Tell Neovim to use ufo's fold settings
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

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
}

-- LAZY PLUGIN MANAGER SETUP ---------------------------------------
require("lazy").setup(plugins, {
  defaults = { 
    lazy = true,
  },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = false },  -- Disable update checking
  change_detection = { enabled = false },  -- Disable change detection
  performance = {
    cache = { enabled = true },
    reset_packpath = true,
    rtp = {
      reset = true,
      disabled_plugins = {
        "gzip", "matchit", "netrwPlugin", 
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})

-- Custom <Esc> behavior for command-line search
vim.keymap.set('c', '<Esc>', function()
  -- Check if the command line is active and is a search command
  if vim.fn.getcmdtype() == '/' or vim.fn.getcmdtype() == '?' then
    -- Check if we actually typed something to search for
    if vim.fn.getcmdline() ~= '' then
      -- Simulate pressing Enter ('<CR>') to confirm the search at the current 'incsearch' location.
      -- The 't' mode in feedkeys ensures terminal codes like <CR> are interpreted correctly.
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 't', false)
      -- Immediately execute :nohlsearch to clear the highlight.
      vim.cmd('nohlsearch')
    else
      -- If we typed '/' or '?' then immediately '<Esc>', just cancel normally (like Ctrl-C).
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, true, true), 't', false)
    end
  else
    -- For any other command type (like :), cancel normally with Ctrl-C
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, true, true), 't', false)
  end
end, { desc = "Confirm incsearch pos & nohl, or cancel cmdline" })

-- esc (capsloc) to close all open windows
n('<Esc>', function()
  vim.cmd('nohlsearch')
  pcall(vim.cmd, 'close')
  vim.defer_fn(function()
    local windows_to_check = vim.api.nvim_list_wins()
    for i = #windows_to_check, 1, -1 do -- Iterate backwards when closing windows in a loop
      local winid = windows_to_check[i]
      if vim.api.nvim_win_is_valid(winid) then
        local config = vim.api.nvim_win_get_config(winid)
        -- Check if it's a floating window (not an external window like a web browser popup)
        if config and config.relative ~= "" and not config.external then
          vim.api.nvim_win_close(winid, false) -- Attempt to close the float
          -- 'false' means don't force close (e.g., if it has unsaved changes, though unlikely for these floats)
        end
      end
    end
  end, 20)
end, { desc = 'clear highlights and close floats' })

-- FILETYPE-SPECIFIC SETTINGS --------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    
    -- Python env detection
    if vim.env.VIRTUAL_ENV then
      vim.g.python3_host_prog = vim.env.VIRTUAL_ENV .. "/bin/python"
    end
  end
})
-- MISCELLANEOUS AUTOCMDS -------------------------------------------

-- Add this to auto-convert .ipynb files
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "*.ipynb",
  callback = function()
    vim.cmd(":%!jupytext --to py:percent --output - " .. vim.fn.expand("<afile>"))
    vim.bo.filetype = "python"
  end
})

-- RESTORE PERFORMANCE SETTINGS ------------------------------------
-- This runs at the end of your config to restore performance settings
vim.defer_fn(function()
  vim.opt.lazyredraw = false
end, 300)
