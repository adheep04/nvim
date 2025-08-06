-- Extension handlers
local file_handlers = {
  zip = function(path, name, dir)
    local folder = vim.fn.fnamemodify(name, ":r")
    local extract_path = dir .. folder
    print("Extracting " .. name .. " to " .. folder .. "/...")
    vim.fn.jobstart(string.format("7z x %s -o%s -y", vim.fn.shellescape(path), vim.fn.shellescape(extract_path)), {
      on_exit = function(_, code)
        print(code == 0 and "Successfully extracted to " .. folder .. "/" or "Failed to extract " .. name)
        if code == 0 then vim.defer_fn(require("oil.actions").refresh.callback, 100) end
      end
    })
  end,
  exe = function(path, name)
    print("Running " .. name .. " with Wine...")
    vim.fn.jobstart({"setsid", "wine", path})
    print("Opened " .. name)
  end,
  png = function(path, name)
    print("Opening " .. name)
    vim.fn.jobstart({"setsid", "kitty", "--title", "float-image", "kitten", "icat", "--hold", path})
    print("Opened " .. name)
  end,
  jar = function(path, name)
    print("Opening " .. name)
    vim.fn.jobstart({"setsid", "java", "-jar", path})
    print("Opened " .. name)
  end,
  ipynb = function(path, name)
    print("Opening " .. name .. " in Zen Browser...")

    -- Command for a Firefox-based browser like Zen Browser
    local browser_cmd = "'zen --new-window %s'"
    local jupyter_cmd = "jupyter nbclassic --browser=" .. browser_cmd .. " " .. vim.fn.shellescape(path)
    local final_cmd = "source ~/envs/base/bin/activate && " .. jupyter_cmd

    vim.fn.jobstart({"setsid", "bash", "-c", final_cmd})
  end,
}
-- Reuse handlers
file_handlers["7z"] = file_handlers.zip
file_handlers.rar = file_handlers.zip
file_handlers.jpg = file_handlers.png
file_handlers.jpeg = file_handlers.png
file_handlers.webp = file_handlers.png
file_handlers.gif = file_handlers.png
return {
  "stevearc/oil.nvim",
  keys = {{ "e", "<CMD>Oil --float<CR>", desc = "open oil (float)" }},
  cmd = "Oil",
  opts = {
    view_options = { 
      show_hidden = true,
      sort = {
        { "mtime", "desc" }
      }
    },
    float = {
      padding = 2,
      max_width = 80,
      max_height = 40,
      border = "rounded",
    },
    default_file_explorer = true,
    delete_to_trash = true,
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = function()
        local oil = require("oil")
        local actions = require("oil.actions")
        local entry = oil.get_cursor_entry()
        if not entry then return end
        
        local dir = oil.get_current_dir()
        if not dir then return end
        
        if entry.type == "directory" then
          return actions.select.callback()
        end
        
        if entry.type == "file" then
          local ext = vim.fn.fnamemodify(entry.name, ":e"):lower()
          local handler = file_handlers[ext]
          if handler then
            handler(dir .. entry.name, entry.name, dir)
            return
          end
        end
        
        actions.select.callback()
      end,
      ["<S-CR>"] = "actions.select",
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
        desc = "Copy filepath to system clipboard",
        callback = function()
          require("oil.actions").copy_entry_path.callback()
          vim.fn.setreg("+", vim.fn.getreg(vim.v.register))
        end,
      },
      ["<leader>o"] = {
        desc = "Copy 'z <directory>' and exit",
        callback = function()
          local dir = require("oil").get_current_dir()
          if dir then
            -- Copy z command to clipboard
            local cmd = "z " .. dir
            vim.fn.setreg("+", cmd)
            -- Exit immediately
            vim.cmd("qa!")
          end
        end,
      },
      ["<leader>O"] = {
        desc = "Open Kitty terminal in current directory",
        callback = function()
          local dir = require("oil").get_current_dir()
          if dir then vim.fn.jobstart({"setsid", "kitty", "--directory", dir}) end
        end,
      },
    },
    columns = { "icon", "size", { "mtime", format = "%b-%d-%y" } },
    watch_for_changes = true,
    case_insensitive = true,
  },
}
