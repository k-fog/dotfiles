vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true

vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.cursorline = true
vim.o.ttimeoutlen = 10

vim.o.swapfile = false
vim.g.mapleader = ' '

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  command = 'checktime',
})

vim.keymap.set('n', '<Esc><Esc>', '<Cmd>nohlsearch<CR>')

-- packages
vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.icons' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('*') },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/nvim-mini/mini.pairs' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
})

-- icons (picked up by fzf-lua and oil)
require('mini.icons').setup()

-- fzf-lua
local fzf = require('fzf-lua')
vim.keymap.set('n', '<C-p>', fzf.files)
vim.keymap.set('n', '<leader>f', fzf.files)
vim.keymap.set('n', '<leader>l', fzf.live_grep)
vim.keymap.set('n', '<leader>b', fzf.buffers)

-- treesitter (only for parsers bundled with nvim: c, lua, markdown, ...)
vim.api.nvim_create_autocmd('FileType', {
  callback = function() pcall(vim.treesitter.start) end,
})

-- completion
require('blink.cmp').setup({
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },
  keymap = { preset = 'super-tab' },
  signature = { enabled = true },
})

-- LSP
-- blink.cmp registers its own capabilities on '*', this only overrides one leaf
vim.lsp.config('*', {
  capabilities = { textDocument = { completion = { completionItem = { snippetSupport = false } } } },
})

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      check = { command = 'clippy' },
    },
  },
})

-- servers installed by mason are enabled automatically
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'clangd', 'rust_analyzer', 'verible', 'ts_ls', 'tinymist', 'pyright', 'zls' },
})
-- ocamllsp must match the opam switch's compiler, so it comes from opam, not mason
vim.lsp.enable('ocamllsp')

-- diagnostic
vim.diagnostic.config({ virtual_lines = { current_line = true }})
vim.keymap.set('n', '<leader>ye', function()
  local d = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })[1]
  if d then
    vim.fn.setreg('+', d.message)
    print('Diagnostic copied')
  end
end)

-- indent
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua', 'ocaml' },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- auto pairs
require('mini.pairs').setup()

-- git signs
require('gitsigns').setup()

-- filer
require('oil').setup()
vim.keymap.set('n', '-', '<Cmd>Oil<CR>')

