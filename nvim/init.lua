vim.o.number = true
vim.o.relativenumber = true

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
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/nvim-mini/mini.icons' },
  { src = 'https://github.com/nvim-mini/mini.pairs' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('*') },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/A7Lavinraj/fyler.nvim', version = 'stable' },
  { src = 'https://github.com/bullets-vim/bullets.vim' },
  { src = 'https://github.com/3rd/image.nvim' },
})

-- mini.icons
require('mini.icons').setup()

-- mini.pairs
require('mini.pairs').setup()

-- fzf-lua
local fzf = require('fzf-lua')
local function project_files()
  vim.fn.system('git rev-parse --is-inside-work-tree 2>/dev/null')
  if vim.v.shell_error == 0 then fzf.git_files() else fzf.files() end
end
vim.keymap.set('n', '<C-p>', project_files)
vim.keymap.set('n', '<leader>f', project_files)
vim.keymap.set('n', '<leader>F', fzf.files)
vim.keymap.set('n', '<leader>l', fzf.live_grep)
vim.keymap.set('n', '<leader>b', fzf.buffers)

-- nvim-treesitter
require('nvim-treesitter').install({'bash', 'c', 'cpp', 'lua', 'markdown', 'ocaml', 'python'})
vim.api.nvim_create_autocmd('FileType', {
  callback = function() pcall(vim.treesitter.start) end,
})

-- completion
require('blink.cmp').setup({
  completion = {
    menu = {
      draw = {
        columns = {
          { 'label', 'label_description', gap = 1 },
          { 'kind_icon', gap = 1, 'kind' }
        },
      },
    },
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

vim.lsp.enable('clangd')
vim.lsp.enable('ocamllsp')
vim.lsp.enable('rust_analyzer')
vim.lsp.config('verible', {
  cmd = {'verible-verilog-ls', '--nopush_diagnostic_notifications', '--rules_config_search'}
})
vim.lsp.enable('verible')

-- diagnostic
vim.diagnostic.config({ virtual_lines = { current_line = true }})
vim.keymap.set('n', '<leader>ye', function()
  local d = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })[1]
  if d then
    vim.fn.setreg('+', d.message)
    print('Diagnostic copied')
  end
end)

-- formatter
require('conform').setup({
  formatters_by_ft = {
    ocaml = { 'ocamlformat' },
    rust = { 'rustfmt' },
  },
  format_on_save = { timeout_ms = 500, lsp_format = 'never' },
})
vim.keymap.set({ 'n', 'x' }, '<leader>t', function()
  require('conform').format({ async = true, lsp_format = 'never' })
end)

-- indent
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua', 'ocaml' },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- filer
local fyler = require('fyler')
fyler.setup({
  views = {
    finder = {
      default_explorer = true,
    },
  },
})
vim.keymap.set('n', '-', fyler.open)

-- bullets.vim
-- keep '-' as the bullet marker even when indenting deeper
vim.g.bullets_outline_levels = { 'ROM', 'ABC', 'num', 'abc', 'rom', 'std-' }

-- image.nvim
require("image").setup()
