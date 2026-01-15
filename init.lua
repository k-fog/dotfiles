vim.o.number = true

vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.ttimeoutlen = 10

vim.keymap.set('n', 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true, silent = true })
vim.keymap.set('v', 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set('v', 'k', 'gk', { noremap = true, silent = true })
vim.keymap.set("n", "p", "p`]", { noremap = true })
vim.keymap.set("n", "P", "P`]", { noremap = true })
vim.keymap.set("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", { silent = true })

vim.cmd('packadd vim-jetpack')
require('jetpack.packer').add {
    {'tani/vim-jetpack'}, -- bootstrap
    {'lewis6991/gitsigns.nvim'},
    {'sindrets/diffview.nvim'},
    {'ibhagwan/fzf-lua', requires = 'nvim-tree/nvim-web-devicons', config = function()
        local fzf = require('fzf-lua')
        fzf.setup()
        local git_root_cache = {}

        local function is_git_repo()
            local cwd = vim.fn.getcwd()
            if git_root_cache[cwd] ~= nil then
                return git_root_cache[cwd]
            end

            local output = vim.fn.systemlist("git rev-parse --is-inside-work-tree")
            local is_git = output[1] == "true"
            git_root_cache[cwd] = is_git
            return is_git
        end

        vim.keymap.set('n', '<C-p>', function()
            if is_git_repo() then
                fzf.git_files()
            else
                fzf.files()
            end
        end, { noremap = true, silent = true })
    end},
    {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = function()
        require('nvim-treesitter.configs').setup {
            ensure_installed = { "c", "lua", "python", "markdown", },
            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,
            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,
            highlight = { enable = true, },
        }
    end},
    {'neovim/nvim-lspconfig', config = function()
        vim.lsp.enable('clangd')
        vim.lsp.enable('ocamllsp')
    end},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-nvim-lsp-signature-help'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-path'},
    {'hrsh7th/cmp-cmdline'},
    {'hrsh7th/nvim-cmp'},
    {'sindrets/diffview.nvim'},
    {'stevearc/conform.nvim', config = function()
        require("conform").setup({
            formatters_by_ft = {
                ocaml = { "ocamlformat" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_format = "never",
            },
        })
    end},
}


-- Set up nvim-cmp.
local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local cmp = require'cmp'

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<C-Space>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },

        ['<Tab>'] = function(fallback)
            if not cmp.select_next_item() then
                if vim.bo.buftype ~= 'prompt' and has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        end,

        ['<S-Tab>'] = function(fallback)
            if not cmp.select_prev_item() then
                if vim.bo.buftype ~= 'prompt' and has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        end,
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
vim.lsp.config('*', {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- ocaml indent config
vim.api.nvim_create_autocmd("FileType", {
    pattern = "ocaml",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end,
})
