---@type ChadrcConfig
local M = {}

M.ui = { theme = 'chocolate' }
M.plugins = "custom.plugins"


-- Ensure mappings in ~/.config/nvim/lua/custom/mappings.lua are loaded
M.mappings = require("custom.mappings").mappings

return M
