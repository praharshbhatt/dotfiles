local M = {}

-- Register Harpoon key mappings with which-key
-- require("which-key").add({
--   ["<C-h>"] = {
--     name = "+Harpoon", -- This shows up in the popup as a header
--     m = "Mark file",
--     s = "Show Harpoon menu",
--     n = "Next mark",
--     p = "Previous mark",
--     x = "Clear all marks",
--     ["1"] = "Go to file 1",
--     ["2"] = "Go to file 2",
--     ["3"] = "Go to file 3",
--     ["4"] = "Go to file 4",
--     ["5"] = "Go to file 5",
--   },
-- }, { mode = "n" })

-- All key mappings
M.mappings = {

  git = {
    n = {
      -- Git switch branch
      ["<leader>gsb"] = {
        function()
          require("telescope.builtin").git_branches()
        end,
        "Git switch branch",
      },

      -- Git Diff with diffview.nvim
      ["<leader>gd"] = {
        function()
          local telescope = require("telescope.builtin")
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          telescope.git_branches({
            prompt_title = "Select Branch to Diff Against",
            attach_mappings = function(prompt_bufnr, map)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection and selection.value then
                  local branch = selection.value
                  vim.cmd("DiffviewOpen " .. branch)
                end
              end)
              return true
            end,
          })
        end,
        "Git Diff",
      },

      -- Git conflict resolution with diffview
      ["<leader>gc"] = {
        "<cmd>DiffviewOpen<CR>",
        "Git Conflict Resolution",
      },

      -- Git merge tool (alternative)
      ["<leader>gm"] = {
        "<cmd>Git mergetool<CR>",
        "Git Merge Tool",
      },
    },

    -- Git Squash commits
    -- Shows a picker with a list of all commits in the current branch
    -- The user can select multiple commits to squash
    -- ["<leader>gsq"] = {
    --   function()
    --     local telescope = require("telescope.builtin")
    --     local actions = require("telescope.actions")
    --     local action_state = require("telescope.actions.state")
    --
    --     telescope.git_commits({
    --       prompt_title = "Select Commits to Squash",
    --       attach_mappings = function(prompt_bufnr, map)
    --         actions.select_default:replace(function()
    --           actions.close(prompt_bufnr)
    --           local selection = action_state.get_selected_entry()
    --           if selection and selection.value then
    --             -- Collect selected commits and squash them
    --             local commit_hashes = {}
    --             for _, entry in ipairs(action_state.get_selected_entries()) do
    --               table.insert(commit_hashes, entry.value)
    --             end
    --             local commit_range = table.concat(commit_hashes, " ")
    --             vim.cmd("GitSquash " .. commit_range)
    --           end
    --         end)
    --         return true
    --       end,
    --     })
    --   end,
    --   "Git Squash",
    -- },
  },


  -- Harpoon
  -- harpoon = {
  --   n = {
  --     -- Mark file and open menu
  --     ["<leader>Hm"] = { function() require("harpoon.mark").add_file() end, "Mark new buffer" },
  --     ["<leader>Hs"] = { function() require("harpoon.ui").toggle_quick_menu() end, "Show menu" },
  --
  --     -- Navigate to marked files
  --     ["<leader>Hn"] = { function() require("harpoon.ui").nav_next() end, "Go to prev buffer" },
  --     ["<leader>Hp"] = { function() require("harpoon.ui").nav_prev() end, "Go to next buffer" },
  --     ["<leader>H1"] = { function() require("harpoon.ui").nav_file(1) end, "Go to buffer 1" },
  --     ["<leader>H2"] = { function() require("harpoon.ui").nav_file(2) end, "Go to buffer 2" },
  --     ["<leader>H3"] = { function() require("harpoon.ui").nav_file(3) end, "Go to buffer 3" },
  --     ["<leader>H4"] = { function() require("harpoon.ui").nav_file(4) end, "Go to buffer 4" },
  --     ["<leader>H5"] = { function() require("harpoon.ui").nav_file(5) end, "Go to buffer 5" },
  --
  --     -- Clear all marks
  --     ["<leader>Hx"] = { function() require("harpoon.mark").clear_all() end, "Clear all marks" },
  --   }
  -- },


  harpoon = {
    n = {
      -- Mark current file
      ["<C-h>m"] = { function() require("harpoon.mark").add_file() end, "Mark current file" },

      -- Toggle menu
      ["<C-h>s"] = { function() require("harpoon.ui").toggle_quick_menu() end, "Show Harpoon menu" },

      -- Navigation
      ["<C-h>n"] = { function() require("harpoon.ui").nav_next() end, "Go to next mark" },
      ["<C-h>p"] = { function() require("harpoon.ui").nav_prev() end, "Go to previous mark" },

      -- Direct navigation to files
      ["<C-h>1"] = { function() require("harpoon.ui").nav_file(1) end, "Go to file 1" },
      ["<C-h>2"] = { function() require("harpoon.ui").nav_file(2) end, "Go to file 2" },
      ["<C-h>3"] = { function() require("harpoon.ui").nav_file(3) end, "Go to file 3" },
      ["<C-h>4"] = { function() require("harpoon.ui").nav_file(4) end, "Go to file 4" },
      ["<C-h>5"] = { function() require("harpoon.ui").nav_file(5) end, "Go to file 5" },

      -- Clear all marks
      ["<C-h>x"] = { function() require("harpoon.mark").clear_all() end, "Clear all Harpoon marks" },
    }
  },


  dap = {
    n = {
      -- Toggle DAP UI
      ["<leader>Du"] = { function() require("dapui").toggle() end, "Toggle DAP UI" },
      -- Breakpoint set
      ["<leader>bs"] = { function() require 'dap'.toggle_breakpoint() end, "Set a breakpoint" },
      -- Breakpoint clear
      ["<leader>bc"] = { function() require 'dap'.clear_breakpoints() end, "Clear all breakpoints" },
      -- Continue
      ["<F5>"] = { function() require 'dap'.continue() end, "Launch Debug Session / Resume" },
      -- Step into
      ["<F11>"] = { function() require 'dap'.step_into() end, "Step into" },
      -- Step out
      ["<F12>"] = { function() require 'dap'.step_out() end, "Step out" },
      -- Step over
      ["<F10>"] = { function() require 'dap'.step_over() end, "Step over" },
      -- REPL
      ["<leader>bi"] = { function() require 'dap'.repl.open() end, "Inspect the state via the built-in REPL" },
      -- Stop debug session
      ["<F4>"] = { function() require 'dap'.terminate() end, "Stop debug session" },
      -- DAP Hover
      ["<leader>bh"] = { function() require 'dap.ui.widgets'.hover() end, "DAP Hover" },
      ["<F6>"] = { function() require 'dap.ui.widgets'.preview() end, "DAP Hover" },
    },
  },


  spectre = {
    n = {
      ["<leader>ss"] = { "<cmd>Spectre<CR>", "Spectre" },
      ["<leader>sw"] = { "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "Spectre Word" },
      ["<leader>sp"] = { "<cmd>lua require('spectre').open_file_search()<CR>", "Spectre File" },
      ["<leader>sc"] = { "<cmd>lua require('spectre').change_view()<CR>", "Spectre Change View" },
    },
  },


  flutter = {
    n = {
      ["<leader>FR"] = { "<cmd>FlutterRun<CR>", "Flutter Run" },
      ["<leader>FQ"] = { "<cmd>FlutterQuit<CR>", "Flutter Quit" },
      ["<leader>FS"] = { "<cmd>FlutterReload<CR>", "Flutter Hot Reload" },
      ["<leader>FHR"] = { "<cmd>FlutterRestart<CR>", "Flutter Restart" },
      ["<leader>FE"] = { "<cmd>FlutterEmulators<CR>", "Flutter Emulators" },

      -- Execute `:Telescope flutter commands`
      ["<leader>FC"] = {
        function()
          require('telescope').extensions.flutter.commands()
        end,
        "Flutter Commands"
      },
    },
  },

  ide = {
    n = {

      -- Find all Diagnostics: all
      ["<leader>fda"] = {
        "<cmd>Telescope diagnostics<CR>",
        "Find diagnostics (global)",
      },

      -- Find all Diagnostics: errors
      ["<leader>fde"] = {
        "<cmd>Telescope diagnostics severity=error<CR>",
        "Find diagnostics (global)",
      },

      -- Find all Diagnostics: warnings
      ["<leader>fdw"] = {
        "<cmd>Telescope diagnostics severity=warn<CR>",
        "Find diagnostics (global)",
      },

      -- Hover Diagnostics
      ["<leader>fdh"] = {
        function()
          vim.diagnostic.open_float()
        end,
        "Show diagnostics for the current line",
      },

      -- Code actions
      ["<leader>ca"] = {
        function()
          -- require("telescope.builtin").lsp_code_actions()
          vim.lsp.buf.code_action()
        end,
        "Code actions",
      },

      -- Go to definition
      -- The `gd` commans in core mappings does not work well, so this overrides the former.
      ["gd"] = {
        "<cmd>Telescope lsp_definitions<CR>",
        "Go to definition (Telescope)",
      },

      -- Open new tab
      ["<leader>To"] = {
        function()
          vim.cmd("tabnew")
        end,
        "Open new tab",
      },

      -- Close current tab
      ["<leader>tq"] = {
        function()
          vim.cmd("tabclose")
        end,
        "Close current tab",
      },

      -- Go to previous tab
      ["<leader>Th"] = {
        function()
          vim.cmd("tabprevious")
        end,
        "Go to previous tab",
      },

      -- Go to next tab
      ["<leader>Tl"] = {
        function()
          vim.cmd("tabnext")
        end,
        "Go to next tab",
      },

      -- Copy current buffer's file path
      ["<leader>cp"] = {
        function()
          local options = {
            "Copy file path from project root",
            "Copy complete file path",
            "Copy project root path"
          }

          vim.ui.select(options, { prompt = "Choose path to copy:" }, function(choice)
            if not choice then return end

            local path_to_copy

            if choice == "Copy file path from project root" then
              local file_path = vim.fn.expand("%:p")
              local project_root = vim.fn.getcwd()
              path_to_copy = vim.fn.fnamemodify(file_path, ":." --[[ relative to CWD ]])
            elseif choice == "Copy complete file path" then
              path_to_copy = vim.fn.expand("%:p")
            elseif choice == "Copy project root path" then
              path_to_copy = vim.fn.getcwd()
            end

            if path_to_copy then
              vim.fn.setreg("+", path_to_copy)
              print("Copied: " .. path_to_copy)
            end
          end)
        end,
        "Choose and copy file paths"
      },

      -- Find Grep: Telescope live grep
      ["<leader>fg"] = {
        function()
          require("telescope.builtin").live_grep()
        end,
        "Find Grep: Telescope live grep",
      },

      -- Format Json using :%!jq
      ["<leader>fj"] = {
        "<cmd>%!jq<CR>",
        "Format Json",
      },

      -- Close all buffers except current
      ["<leader>bo"] = {
        function()
          local current_buf = vim.api.nvim_get_current_buf()
          local buffers = vim.api.nvim_list_bufs()
          for _, buf in ipairs(buffers) do
            if buf ~= current_buf and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'buflisted') then
              vim.api.nvim_buf_delete(buf, { force = false })
            end
          end
        end,
        "Close all buffers except current",
      },

      -- Intellij
      --
      -- Intellij style format: Ctrl + Alt + L to format
      ["<C-A-l>"] = {
        function()
          vim.lsp.buf.format { async = true }
        end, "Format buffer",
      },
    },

    i = {
      -- Delete a word: Ctrl + Backspace
      ["<C-BS>"] = {
        "<C-w>",
        "Delete the previous word",
      },

      -- Delete a word: Ctrl + Delete
      ["<C-Del>"] = {
        "<C-u>",
        "Delete the next word",
      },

      -- Copy current buffer's file path
      ["<leader>cp"] = {
        function()
          vim.fn.setreg("+", vim.fn.expand("%:p"))
          print("Copied: " .. vim.fn.expand("%:p"))
        end,
        "Copy current buffer's file path"
      },


      -- Intellij
      --
      -- Intellij style format: Ctrl + Alt + L to format
      ["<C-A-l>"] = {
        function()
          vim.lsp.buf.format({ async = true })
        end,
        "Format buffer",
      },
    },

    v = {
      -- Format selected text
      ["<leader>fm"] = {
        function()
          vim.lsp.buf.format({
            async = true,
            range = {
              ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
              ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
            }
          })
        end,
        "Format selection",
      },

      -- Global search for selected text
      ["<leader>fw"] = {
        function()
          vim.cmd('noau normal! "vy"')
          require("telescope.builtin").live_grep({ default_text = vim.fn.getreg("v") })
        end,
        "Search selected text globally",
      },
    },
  },

}

return M
