vim.o.number = true
vim.opt.relativenumber = true

vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.ttimeoutlen = 10

vim.o.swapfile = false
vim.g.mapleader = ' '

vim.o.autoread = true
vim.o.updatetime = 1000
vim.api.nvim_create_autocmd({
  "FocusGained",
  "BufEnter",
  "CursorHold",
}, {
  command = "checktime",
})

vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('v', 'j', 'gj')
vim.keymap.set('v', 'k', 'gk')
vim.keymap.set('n', 'p', 'p`]')
vim.keymap.set('n', 'P', 'P`]')
vim.keymap.set('n', '<Esc><Esc>', '<Cmd>nohlsearch<CR>')

-- packages
vim.pack.add({
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/nvim-mini/mini.icons' },
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

-- fzf-lua
local fzf = require('fzf-lua')
fzf.setup()
vim.keymap.set('n', '<C-p>', function()
  vim.fn.system('git rev-parse --is-inside-work-tree 2>/dev/null')
  if vim.v.shell_error == 0 then fzf.git_files() else fzf.files() end
end)
vim.keymap.set('n', '<leader>f', function()
  vim.fn.system('git rev-parse --is-inside-work-tree 2>/dev/null')
  if vim.v.shell_error == 0 then fzf.git_files() else fzf.files() end
end)
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
    accept = {
      auto_brackets = {
        enabled = false,
      },
    },
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
local capabilities = require('blink.cmp').get_lsp_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false
vim.lsp.config('*', {
  capabilities = capabilities,
})

vim.lsp.enable('clangd')
vim.lsp.enable('ocamllsp')
vim.lsp.enable('rust_analyzer')
vim.lsp.config('verible', {
  cmd = {'verible-verilog-ls', '--nopush_diagnostic_notifications', '--rules_config_search'}
})
vim.lsp.enable('verible')
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gr', vim.lsp.buf.rename)

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
  },
  format_on_save = { timeout_ms = 500, lsp_format = 'never' },
})

-- indent
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua', 'ocaml' },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
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
