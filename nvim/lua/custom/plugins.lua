local plugins = {
  -- Load which-key early so leader key works immediately on startup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },

  -- telescope-fzf-native: replaces Telescope's default pure-Lua sorter with a
  -- compiled C extension that wraps fzf's algorithm. The result is roughly 10×
  -- faster fuzzy matching for large projects — most noticeable on <leader>ff
  -- (find_files) and <leader>fg (live_grep) in repos with thousands of files.
  --
  -- `build = "make"` compiles the C extension on first install (requires gcc/make).
  -- If the build fails, Telescope still works — it just falls back to the Lua sorter.
  -- Re-run `:Lazy build telescope-fzf-native.nvim` to recompile after a toolchain change.
  --
  -- NvChad picks this up automatically: plugins/init.lua iterates over
  -- opts.extensions_list and calls telescope.load_extension() for each entry.
  -- We add "fzf" to that list in plugins/configs/telescope.lua.
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },

  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "pyright",
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end
  },

  -- Exrc
  {
    'jedrzejboczar/exrc.nvim',
    lazy = false,
    dependencies = { 'neovim/nvim-lspconfig' }, -- (optional)
    config = true,
    opts = {
      exrc_name = '.nvim.lua', -- Name of exrc files to use
      on_vim_enter = true,     -- Load exrc from current directory on start
      on_dir_changed = {       -- Automatically load exrc files on DirChanged autocmd
        enabled = true,
        -- Wait until CursorHold and use vim.ui.select to confirm files to load, instead of loading unconditionally
        use_ui_select = true,
      },
      trust_on_write = true,                -- Automatically trust when saving exrc file
      use_telescope = true,                 -- Use telescope instead of vim.ui.select for picking files (if available)
      min_log_level = vim.log.levels.DEBUG, -- Disable notifications below this level (TRACE=most logs)
      lsp = {
        auto_setup = false,                 -- Automatically configure lspconfig to register on_new_config
      },
      commands = {
        instant_edit_single = true, -- Do not use vim.ui.select if there is only 1 candidate for ExrcEdit* commands
      },
    },
  },

  -- Dap
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "igorlfs/nvim-dap-view",
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          enabled = true,
          enabled_commands = true,
          highlight_changed_variables = true,
          highlight_new_as_changed = false,
          show_stop_reason = true,
          commented = false,
          only_first_definition = true,
          all_references = false,
          clear_on_continue = false,

          display_callback = function(variable, buf, stackframe, node, options)
            if options.virt_text_pos == 'inline' then
              return ' = ' .. variable.value:gsub("%s+", " ")
            else
              return variable.name .. ' = ' .. variable.value:gsub("%s+", " ")
            end
          end,
          -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
          virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
          all_frames = false,
          virt_lines = false,
          virt_text_win_col = nil,
        },
      },
    },
    config = function()
      -- python
      local dap_python = require("dap-python")
      -- dap_python.setup("~/.virtualenvs/debugpy/bin/python") -- Or any Python path with debugpy installed
      dap_python.setup("/usr/bin/python3")

      -- typescript
      -- require("dap-vscode-js").setup({
      --   -- debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      --   debugger_cmd = { "js-debug-adapter" },
      --   adapters = { "pwa-node", "pwa-chrome" },
      -- })
    end,
  },

  {
    "lucaSartore/nvim-dap-exception-breakpoints",
    dependencies = { "mfussenegger/nvim-dap" },

    config = function()
      local set_exception_breakpoints = require("nvim-dap-exception-breakpoints")

      vim.api.nvim_set_keymap(
        "n",
        "<leader>be",
        "",
        { desc = "[D]ebug [C]ondition breakpoints", callback = set_exception_breakpoints }
      )
    end
  },

  -- Harpoon
  {
    'ThePrimeagen/harpoon',
    lazy = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require("harpoon").setup({
        global_settings = {
          save_on_toggle = true,
          save_on_change = true,
          enter_on_sendcmd = false,
          mark_branch = true,
        },
      })
    end,
  },

  -- iron.nvim
  {
    "hkupty/iron.nvim",
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")

      iron.setup {
        config = {
          scratch_repl = true,
          repl_definition = {
            sh = {
              command = { "zsh" },
            },
            python = {
              command = { "python3" },
              format = common.bracketed_paste_python,
              block_dividers = { "# %%", "#%%" },
            },
          },
          repl_filetype = function(bufnr, ft)
            return ft
          end,
          repl_open_cmd = view.bottom(40),
        },
        keymaps = {
          toggle_repl = "<space>rr",
          restart_repl = "<space>rR",
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_file = "<space>sf",
          send_line = "<space>sl",
          send_paragraph = "<space>sp",
          send_until_cursor = "<space>su",
          send_mark = "<space>sm",
          send_code_block = "<space>sb",
          send_code_block_and_move = "<space>sn",
          mark_motion = "<space>mc",
          mark_visual = "<space>mc",
          remove_mark = "<space>md",
          cr = "<space>s<cr>",
          interrupt = "<space>s<space>",
          exit = "<space>sq",
          clear = "<space>cl",
        },
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true,
      }

      -- Additional keymaps for Iron commands
      vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>', { desc = "Iron Focus REPL" })
      vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>', { desc = "Iron Hide REPL" })
    end
  },

  -- Colorizer
  -- Disabling, due to performance issues with large files and live grep: https://github.com/nvim-telescope/telescope.nvim/issues/1379#issuecomment-993321085
  -- {
  --   'norcalli/nvim-colorizer.lua',
  --   lazy = true,
  --   config = function()
  --     require('colorizer').setup({
  --       '*', -- Highlight all files, but customize some others.
  --       -- '!vim',          -- Exclude vim from highlighting.
  --     }, {
  --       RGB = true,      -- #RGB hex codes
  --       RRGGBB = true,   -- #RRGGBB hex codes
  --       names = false,   -- "Name" codes like Blue or blue
  --       RRGGBBAA = true, -- #RRGGBBAA hex codes
  --       rgb_fn = true,   -- CSS rgb() and rgba() functions
  --       hsl_fn = true,   -- CSS hsl() and hsla() functions
  --     })
  --   end,
  -- },
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
          require("nvim-treesitter.configs").setup({
            ensure_installed = { "markdown" },
            highlight = { enable = true },
          })
        end,
      },
    },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      kitty_method = "normal",
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
    },
  },
  -- Vim-Surround
  -- Must NOT be lazy: if deferred, the plugin's `xmap S` hasn't been registered
  -- yet when you press S in visual mode, so Neovim falls through to the built-in
  -- S (delete selection + insert). Loading eagerly ensures the mapping is active
  -- from the moment Neovim starts.
  {
    'tpope/vim-surround',
    lazy = false,
  },

  -- nvim-treesitter-context
  {
    'nvim-treesitter/nvim-treesitter-context',
    lazy = false,
    config = function()
      require('treesitter-context').setup({
        enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,      -- Use line numbers instead of relative ones
        zindex = 20,              -- The Z-index of the context window
        mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
        ft = {
          'lua',
          'python',
          'javascript',
          'typescript',
          'html',
          'css',
          'markdown',
          'json',
          'dart',
          'kotlin',
        },                       -- Filetypes to enable treesitter context. This overrides all other settings if set.
        ensure_installed = true, -- Ensure that the treesitter parsers are installed for the specified filetypes
      })
    end,
  },

  -- smear-cursor.nvim
  {
    'sphamba/smear-cursor.nvim',
    lazy = false,
    opts = {
      -- The cursor will be smeared when entering insert mode
      smear_on_insert = true,
      -- The cursor will be smeared when leaving insert mode
      smear_on_exit = false,
      -- The cursor will be smeared when entering visual mode
      smear_on_visual = true,
      -- The cursor will be smeared when leaving visual mode
      smear_on_visual_exit = false,
      -- The cursor will be smeared when entering replace mode
      smear_on_replace = true,


      stiffness = 0.8,          -- 0.6      [0, 1]
      trailing_stiffness = 0.5, -- 0.4      [0, 1]
      -- stiffness_insert_mode = 0.6,          -- 0.4      [0, 1]
      -- trailing_stiffness_insert_mode = 0.6, -- 0.4      [0, 1]
      -- distance_stop_animating = 0.5,        -- 0.1      > 0


      -- cursor_color = "#ff8800",
      -- stiffness = 0.3,
      -- trailing_stiffness = 0.1,
      -- trailing_exponent = 5,
      -- never_draw_over_target = true,
      -- hide_target_hack = true,
      -- gamma = 1,
    },
  },

  -- noice.nvim
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
  {
    'sindrets/diffview.nvim',
    lazy = true,
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles" },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'sindrets/diffview.nvim',
    },
    config = function()
      require('diffview').setup({
        enhanced_diff_hl = true, -- Enable enhanced highlighting for diff views
      })
    end,
  },

  -- vim-illuminate
  -- {
  --   'RRethy/vim-illuminate',
  --   lazy = false,
  --   config = function()
  --     require('illuminate').configure({
  --       delay = 10,
  --       filetypes_denylist = {
  --         'dirvish',
  --         'fugitive',
  --         'help',
  --         'lazy',
  --         'mason',
  --         'TelescopePrompt',
  --         'TelescopeResults',
  --       },
  --     })
  --   end,
  -- },
  {
    "rbong/vim-flog",
    lazy = true,
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = {
      "tpope/vim-fugitive",
    },
  },
  -- mini.indentscope
  {
    'echasnovski/mini.indentscope',
    -- event = 'BufReadPre',
    lazy = false,
    config = function()
      require('mini.indentscope').setup({
        draw = {
          delay = 0,
          animation = function() return 0 end, -- no animation
        },
        options = {
          try_as_border = true,
        },
      })
    end,
  },


  -- Spectre
  {
    'nvim-pack/nvim-spectre',
    lazy = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('spectre').setup({
        color_devicons = true,
        mapping = {
          ['toggle_line'] = {
            map = 'dd',
            cmd = '<C-U>',
            desc = 'Toggle current line',
          },
          ['send_to_qf'] = {
            map = '<leader>q',
            cmd = '<C-U>',
            desc = 'Send all items to quickfix',
          },
        },
      })
    end,
  },

  -- Autosave Session
  {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '/' },
      git_use_branch_name = true,               -- Include git branch name in session name
      git_auto_restore_on_branch_change = true, -- Should we auto-restore the session when the git branch changes. Requires git_use_branch_name
      close_unsupported_windows = true,         -- Close windows that aren't backed by normal file before autosaving a session
      sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions",
    }
  },

  -- Markdown Renderer
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    ft = { 'markdown', 'quarto' },
  },

  -- snacks.nvim (required by claudecode terminal provider)
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      terminal = { enabled = true },
    },
  },

  -- Claude Code
  {
    'coder/claudecode.nvim',
    lazy = false,
    dependencies = {
      'folke/snacks.nvim',
    },
    opts = {

    -- Server Configuration
      port_range = { min = 10000, max = 65535 },
      auto_start = true,
      log_level = "info", -- "trace", "debug", "info", "warn", "error"
      terminal_cmd = nil, -- Custom terminal command (default: "claude")
                        -- For local installations: "~/.claude/local/claude"
                        -- For native binary: use output from 'which claude'
      -- Send/Focus Behavior
      -- When true, successful sends will focus the Claude terminal if already connected
      focus_after_send = false,

    -- Selection Tracking
    track_selection = true,
    visual_demotion_delay_ms = 50,
      terminal = {
        provider = "snacks",
        split_side = "right",
        split_width_percentage = 0.40,
        auto_close = false,
      },
      diff = {
        layout = "vertical",
      },
    },
    config = function(_, opts)
      require('claudecode').setup(opts)

      -- Keymaps
      vim.keymap.set('n', '<leader>ac', '<cmd>ClaudeToggle<cr>', { desc = 'Claude: Toggle terminal' })
      vim.keymap.set('n', '<leader>af', '<cmd>ClaudeFocus<cr>', { desc = 'Claude: Focus terminal' })
      vim.keymap.set('n', '<leader>ar', '<cmd>ClaudeResume<cr>', { desc = 'Claude: Resume task' })
      vim.keymap.set('n', '<leader>aC', '<cmd>ClaudeContinue<cr>', { desc = 'Claude: Continue task' })
      vim.keymap.set('n', '<leader>am', '<cmd>ClaudeModel<cr>', { desc = 'Claude: Select model' })
      vim.keymap.set('n', '<leader>ab', '<cmd>ClaudeAddBuffer<cr>', { desc = 'Claude: Add current buffer' })
      vim.keymap.set('v', '<leader>as', '<cmd>ClaudeSendSelection<cr>', { desc = 'Claude: Send selection' })
      vim.keymap.set('n', '<leader>aa', '<cmd>ClaudeAcceptDiff<cr>', { desc = 'Claude: Accept diff' })
      vim.keymap.set('n', '<Tab>', '<cmd>ClaudeAcceptDiff<cr>', { desc = 'Claude: Accept diff' })
      vim.keymap.set('n', '<leader>ad', '<cmd>ClaudeRejectDiff<cr>', { desc = 'Claude: Reject diff' })
    end,
  },

  -- neoformat for Json
  {
    'sbdchd/neoformat',
    lazy = true,
    config = function()
      vim.g.neoformat_try_node_exe = 1
      vim.g.neoformat_enabled_json = { 'jq' }
      vim.g.neoformat_json_jq = {
        exe = 'jq',
        args = { '--indent', '2', '--compact-output' },
        replace = 1,
        stdin = 1,
      }
    end,
  },

  -- typescript-tools.nvim
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      on_attach = function(client, bufnr)
        -- Disable tsserver formatting if using an external formatter like Prettier
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        -- Set up keymaps or other on_attach logic here
      end,
      capabilities = require("plugins.configs.lspconfig").capabilities,
      settings = {
        jsx_close_tag = {
          enable = true,
          filetypes = { "javascriptreact", "typescriptreact" },
        },
      },
    },
  },

  {
    'rcarriga/nvim-dap-ui',
    lazy = true,
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    },
    opts = {},

    config = function()
      local dap, dapui = require 'dap', require 'dapui'

      dapui.setup()
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },

  -- kotlin dap
  {
    "Mgenuit/nvim-dap-kotlin",
    -- lazy = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("dap-kotlin").setup({
        dap_command = "kotlin-debug-adapter",
        project_root = "${workspaceFolder}",
        enable_logging = false,
        log_file_path = "",
      })
    end,
  },


  -- Flutter
  {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = function()
      require("flutter-tools").setup {
        fvm = true,  -- Enable FVM integration
        debugger = { -- Integrate with nvim-dap + install Dart code debugger
          enabled = true,
          run_via_dap = true,
        },

        dev_tools = {
          autostart = false,         -- autostart devtools server if not detected
          auto_open_browser = false, -- Automatically opens devtools in the browser
        },
      }
      require('telescope').load_extension('flutter')
    end,
  },

  -- Git support
  {
    'tpope/vim-fugitive',
    lazy = false,
  },
}

return plugins
