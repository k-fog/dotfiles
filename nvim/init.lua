vim.o.number = true

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

vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('v', 'j', 'gj')
vim.keymap.set('v', 'k', 'gk')
vim.keymap.set('n', 'p', 'p`]')
vim.keymap.set('n', 'P', 'P`]')
vim.keymap.set('n', '<Esc><Esc>', '<Cmd>nohlsearch<CR>')

-- packages
vim.pack.add({
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/nvim-mini/mini.icons',
    'https://github.com/ibhagwan/fzf-lua',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/neovim/nvim-lspconfig',
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('*') },
    'https://github.com/stevearc/conform.nvim',
})

-- mini.icons
require('mini.icons').setup()

-- fzf-lua
local fzf = require('fzf-lua')
fzf.setup()
vim.keymap.set('n', '<C-p>', fzf.files, { silent = true })

-- nvim-treesitter
require('nvim-treesitter').install({'bash', 'c', 'cpp', 'lua', 'markdown', 'ocaml', 'python'})
vim.api.nvim_create_autocmd('FileType', {
    callback = function() pcall(vim.treesitter.start) end,
})

-- LSP
vim.lsp.enable('clangd')
vim.lsp.enable('ocamllsp')
vim.lsp.enable('rust_analyzer')

-- completion
require('blink.cmp').setup({
    completion = {
        menu = {
            draw = {
                columns = {
                    { "label", "label_description", gap = 1 },
                    { "kind_icon", gap = 1, "kind" }
                },
            },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },
    keymap = { preset = 'super-tab' },
    signature = { enabled = true },
})

-- formatter
require('conform').setup({
    formatters_by_ft = {
        ocaml = { 'ocamlformat', lsp_format = 'never' },
    },
    format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },
})
