lua require("plugins")
lua require("lualine").setup()

" === GENERAL === 

colorscheme catppuccin-mocha

set number
set expandtab

set tabstop=2
set shiftwidth=2 

set cursorline
set shell=/bin/bash

" !backups 
set nobackup 
set nowritebackup 
set noswapfile 
set nowrap

" === GENERAL === 

" === SHORTCUTS ===

" GENERAL

nmap <C-q> :q!<Enter>
nmap <C-e> :w<Enter>
nmap <C-a> :wq<Enter>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" TELESCOPE 
nmap <C-p> :lua require'telescope.builtin'.find_files{}<Enter>

" === SHORTCUTS === 
