-- For including /custom/autocmds
require "custom.autocmds"

-- Dap config
require "custom.configs.dap"

-- Custom options
-- timeoutlen controls two things:
--   1. How long Neovim waits after <leader> before showing the which-key popup.
--   2. How long it waits between keys in a multi-key mapping (e.g. "jk" → Esc).
--
-- Lower = which-key appears faster, but multi-key sequences become harder to type.
-- 150ms is a good sweet spot: noticeably snappier than the default (1000ms) or our
-- previous value (250ms), but still comfortable for two-key sequences.
-- If multi-key mappings start misfiring, bump this back up to 200–250ms.
vim.opt.timeoutlen = 150

-- Allow project-local .nvim.lua files (e.g. flutter-tools setup_project)
vim.o.exrc = true

-- Mappings
local M = {}
M.mappings = require("custom.mappings")

return M

