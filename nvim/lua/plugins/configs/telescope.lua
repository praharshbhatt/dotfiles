local options = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      -- NOTE: "-j1" (single-thread ripgrep) was previously set here to prevent
      -- memory exhaustion crashes on live_grep (see telescope issue #1379). It
      -- was removed because it made grep ~4–8× slower on any project with more
      -- than a few hundred files. If memory crashes come back, add "-j2" as a
      -- middle ground before going back to "-j1".
    },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { "node_modules" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = {
      n = { ["q"] = require("telescope.actions").close },
    },
  },

  extensions_list = {
    "themes",
    "terms",
    -- fzf: uses the telescope-fzf-native C extension for sorting.
    -- Replaces the default Lua sorter with fzf's algorithm, which is ~10×
    -- faster for large result sets. The extension is defined in
    -- custom/plugins.lua and compiled at install time via `make`.
    -- NvChad's plugins/init.lua calls telescope.load_extension() for each
    -- entry in this list automatically, so no extra setup is needed here.
    "fzf",
  },

  -- fzf extension options: override sort algorithm and case sensitivity
  -- per picker type. These only take effect once fzf-native is compiled.
  --
  -- fuzzy = true           enables fuzzy (non-exact) matching, same as default
  -- override_generic_sorter replaces the sorter used by most pickers (grep, etc.)
  -- override_file_sorter   replaces the sorter used by find_files / file pickers
  -- case_mode options:
  --   "smart_case"  → case-insensitive unless the query has an uppercase letter
  --   "ignore_case" → always case-insensitive
  --   "respect_case"→ always case-sensitive
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
}

return options