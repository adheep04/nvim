return {
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

    -- Centralized function for LSP keymaps
    -- This will be attached to each language server
    local on_attach = function(client, bufnr)
      local function buf_map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = bufnr
        opts.noremap = opts.noremap ~= false
        opts.silent = opts.silent ~= false
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- All your LSP keymaps go here
      buf_map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
      buf_map('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
      buf_map('n', 'hd', vim.lsp.buf.hover, { desc = 'Hover documentation' })
      buf_map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
      buf_map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
      buf_map('n', '<leader>ds', vim.lsp.buf.document_symbol, { desc = 'Document symbol' })
      buf_map('n', '<leader>dk', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
      buf_map('n', '<leader>dl', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
      buf_map('n', '<leader>D', function()
        vim.diagnostic.open_float({
          focusable = false,
          close_events = { "BufLeave", "BufHidden", "InsertEnter" },
          border = "rounded",
          scope = "cursor",
        })
      end, { desc = 'Show diagnostics' })
    end

    -- Configure Python LSP (pylsp)
    require("lspconfig").pylsp.setup({
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
      end,
      capabilities = capabilities,
      before_init = function(_, config)
        if vim.env.VIRTUAL_ENV then
          config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
            pylsp = {
              plugins = {
                jedi = {
                  environment = vim.env.VIRTUAL_ENV .. "/bin/python",
                },
              },
            },
          })
        elseif vim.g.python3_host_prog then
          config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
            pylsp = {
              plugins = {
                jedi = {
                  environment = vim.g.python3_host_prog,
                },
              },
            },
          })
        end
      end,
      settings = {
        pylsp = {
          plugins = {
            pycodestyle = { enabled = false },
            flake8 = { enabled = false },
            autopep8 = { enabled = false },
            mccabe = { enabled = false },
            pyflakes = { enabled = false },
            ruff = { enabled = true },
            jedi_completion = {
              enabled = true,
              include_params = true,
              fuzzy = true,
            },
            jedi_hover = { enabled = true },
            jedi_references = { enabled = true },
            jedi_signature_help = { enabled = true },
            jedi_symbols = { enabled = true, all_scopes = true },
          },
        },
      },
    })

    -- (Recommended) Configure Lua LSP for editing your config
    require('lspconfig').lua_ls.setup({
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
      end, -- Re-use the same keymaps
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            -- Make the language server aware of Neovim globals
            globals = { 'vim' },
          }
        }
      }
    })
  end,
}
