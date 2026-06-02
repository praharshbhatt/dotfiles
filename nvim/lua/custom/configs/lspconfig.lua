local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach
local capabilities = config.capabilities

-- Setup Python LSP
vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "python" },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json', '.git' },
  single_file_support = true,
})

-- TypeScript LSP
-- npm install -g typescript-language-server typescript
vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  single_file_support = true,
})

-- Kotlin LSP
-- git clone git@github.com:fwcd/kotlin-language-server.git && cd kotlin-language-server && ./gradlew installDist
-- Copy this entire project to ~/.local/bin/kotlin-language-server, which is accessible in the $PATH.
-- cp -r ~/Downloads/kotlin-language-server ~/.local/bin/kotlin-language-server
-- Use this path suffixed by the path to build executable in the `cms` below.
-- lspconfig.kotlin_language_server.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   filetypes = { "kotlin" },
--   cmd = {
--     os.getenv("HOME") ..
--     "/.local/bin/kotlin-language-server/server/build/install/server/bin/kotlin-language-server"
--   },
-- })


-- Kotlin LSP (Official LSP from Kotlin)
-- https://github.com/Kotlin/kotlin-lsp
-- Instructions:
-- 1. Downloads the standalone Kotlin LSP server zip from: https://github.com/Kotlin/kotlin-lsp/blob/main/RELEASES.md
-- Extract the zip file `.local/bin`, since it's in the $PATH, and rename it to `kotlin-lsp`.
-- update the `cmd` below to point to the `kotlin-lsp.sh` script in the extracted directory.
--
-- For Debugging:
-- :MasonInstall kotlin-debug-adapter
-- brew install kotlin-debug-adapter

vim.lsp.config('kotlin_language_server', {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "kotlin" },
  cmd = {
    os.getenv("HOME") ..
    '/.local/bin/kotlin-lsp/kotlin-lsp.sh', '--stdio',
  },
  root_markers = { 'build.gradle', 'build.gradle.kts', 'pom.xml', '.git' },
  single_file_support = true,
  settings = {
    kotlin = { compiler = { jvm = { target = '17' } } },
  },
})
