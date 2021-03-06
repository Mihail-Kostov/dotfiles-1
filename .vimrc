" {{{ VIM-PLUG 
" _________ ensure vim-plug is installed 

if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -flo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" _________ the plugins

call plug#begin('~/.vim/plugged')
Plug 'sts10/vim-pink-moon'
Plug 'sjl/badwolf'
Plug 'junegunn/seoul256.vim'
call plug#end()

" VIM-PLUG }}} 

" {{{ EDITOR 

" it really does make vim more useful:
" even though having a vimrc turns compatible off,
" there are times, like when using -u to launch vim,
" when it's helpful to set this explicitly.
set nocompatible

syntax on
" necessary for correct rendering in tmux
if &term =~ '256color'
	set t_ut=
endif
let &background = 'dark'
colorscheme pink-moon
filetype plugin indent on
set tabstop=2
set softtabstop=0
set expandtab
set shiftwidth=2
set smarttab
" adds a menu to tab completion
set wildmenu
 
" _________ statusline
" by default, statusline is only shown when there are two or more windows 
" setting it to '2' always shows the statusline
set laststatus=2
" show the file's relative path
set statusline=%f
" add a space
set statusline+=\ 
" show filetype
set statusline+=%y
" add a space
set statusline+=\ 
" flags; modified, read-only
set statusline+=%(%m%r%)
" switch to right side of statusline
set statusline+=%=
" show column position
set statusline+=%c
" add a space
set statusline+=\ 
" show current line/total lines in file
set statusline+=[%04l\/%04L]

" EDITOR }}} 

" {{{ MAPPINGS 

" _________ leaders 

let mapleader = "," 
let maplocalleader = "\\"

" _________ editor
 
" enter normal mode from insert mode
" enter normal mode from insert
inoremap jk <esc>
" disable the <esc> key
inoremap <esc> <nop>
" disable the arrow keys in normal mode
nnoremap <up> <nop>
nnoremap <right> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
" and in insert mode
inoremap <up> <nop>
inoremap <right> <nop>
inoremap <down> <nop>
inoremap <left> <nop>

" switches to next buffer
nnoremap <leader>L :bnext<cr>

" _________ moving around

" moves to the beginning of the current line.
" overwrites the default mapping of 'H' which moves to the first line.
nnoremap H 0
" moves to the end of the current line.
" overwrites the default mapping of 'L' which moves to the last line.
nnoremap L $

" _________ vimrc editing 

" open ~/.vimrc in a vertical split
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" source ~/.vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>

" _______________ comments 

" comment opening
nnoremap <leader>cmt o"  <esc>3i{<esc>a
" comment sub-section 
nnoremap <leader>2mt o"  <esc>9i_<esc>a
" comment sub-sub-section
nnoremap <leader>3mt o"  <esc>15i_<esc>a
" comment closing 
nnoremap <leader>tmc o"  <esc>3i}<esc>3ha <esc>i

" _________ moving lines around 

" select the current line, delete it, then paste it below.
nnoremap <leader>_ Vdp
" same as above, but pastes it above the current line.
nnoremap <leader>- VdkP
" surround current line with empty lines
nnoremap <leader><c-o> O<esc>jo<esc>

" ________ text manipulation 

" in insert mode, make current word UPPERCASE
inoremap <leader><c-u> <esc>vawUi
" do the same THING in normal mode
nnoremap <leader><c-u> viwU<esc>
" surround current word with double quotes
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
" surround current word with single quotes
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel
" surround currentt selection with double quotes
vnoremap <leader>" y`<i"<esc>`>a"<esc>
" surround currentt selection with single quotes
vnoremap <leader>' y`<i'<esc>`>a'<esc>

" _________ operator pending mappings

" _______________ parentheses

onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>
onoremap an( :<c-u>normal! f(va(<cr>
onoremap al( :<c-u>normal! F)va(<cr>

" _______________ curly brackets

onoremap in{ :<c-u>normal! f{vi{<cr>
onoremap il{ :<c-u>normal! F}vi{<cr>
onoremap an{ :<c-u>normal! f{va{<cr>
onoremap al{ :<c-u>normal! F}va{<cr>
 
" ________ dummy mappings 

nnoremap <leader>ec :echo "ohai!"<cr>
" another dummy mapping, but maybe useful?
" comments?
" copies a line and pastes it below the current one, offset by 9 spaces.
nnoremap <leader>9 Vyp0i         <esc>

" MAPPINGS }}} 

" {{{ AUTOCOMMANDS

" _________ filetype
 
augroup filetype_javascript
        autocmd!
        autocmd FileType javascript setlocal lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
        autocmd FileType javascript setlocal list
        autocmd FileType javascript setlocal number
        autocmd FileType javascript setlocal relativenumber
        autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
augroup END

augroup filetype_yaml
        autocmd!
        autocmd FileType yaml setlocal lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
        autocmd FileType yaml setlocal list
        autocmd FileType yaml setlocal number
        autocmd FileType yaml setlocal relativenumber
        autocmd FileType yaml nnoremap <buffer> <localleader>c I#<esc>
augroup END

augroup filetype_html
        autocmd!
        autocmd FileType html nnoremap <buffer> <localleader>f Vatzf
augroup END

augroup filetype_markdown
        autocmd!
        autocmd BufNewFile,BufReadPost *.md set filetype=markdown
        autocmd FileType markdown onoremap <buffer> ht
                                \ :<c-u>execute "normal!
                                \ ?^[-=]\\{2,}$\r:nohlsearch\rkvg_"<cr>
        autocmd FileType markdown onoremap <buffer> hg
                                \ :<c-u>execute "normal!
                                \ ?^[-=]\\{2,}$\r:nohlsearch\rg_vk0"<cr>
augroup END

" _________ snippets
 
augroup snippets_javascript
        autocmd!
        autocmd FileType javascript iabbrev <buffer> fcn function () {
                                \<cr>
                                \<cr>
                                \}
augroup END

augroup snippets_html
        autocmd!
        autocmd FileType html iabbrev <buffer> doctype <!DOCTYPE html>
augroup END

" _________ folding
" Vimscript file settings ---------- {{{
augroup filetype_vim
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}


" AUTOCOMMANDS }}} 
