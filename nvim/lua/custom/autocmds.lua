-- Autosave on change: https://github.com/LazyVim/LazyVim/issues/2491#issuecomment-1925050936
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = { "*" },
  command = "silent! wall",
  nested = true,
})

