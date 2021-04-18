set number              "行番号
set autoindent          "改行時に自動でインデント
set tabstop=2           "タブを空白に変換
set shiftwidth=2        "自動インデント時に入力する空白の数
set expandtab           "タブ入力を空白に変換
set splitright          "画面を縦分割する際に右に開く
set clipboard=unnamed   "yank した文字列をクリップボードにコピー
set hls                 "検索した文字をハイライトする
set t_ut=""             "画面色関連の設定？
let mapleader = "\<Space>"  "Leaderをスペースキーに割り当て

" コピペ設定
let g:clipboard = {
      \   'name': 'myClipboard',
      \   'copy': {
      \      '+': 'win32yank.exe -i',
      \      '*': 'win32yank.exe -i',
      \    },
      \   'paste': {
      \      '+': 'win32yank.exe -o',
      \      '*': 'win32yank.exe -o',
      \   },
      \   'cache_enabled': 1,
      \ }

" dein Scripts -----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

  call dein#load_toml('~/.config/nvim/dein.toml')
  call dein#load_toml('~/.config/nvim/dein_lazy.toml', { 'lazy': 1 })

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

" End dein Scripts-------------------------

command! RemoveM :%s///g

" Tab setting-----------------------------
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ
" End Tab setting-------------------------

" 言語別インデントの設定
augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile,BufRead *.jl setlocal tabstop=4 shiftwidth=4
augroup END

" その他キーマップ設定
nnoremap <ESC><ESC> :nohlsearch<CR><Esc>
