" Plugins {{{
call plug#begin()

    Plug 'morhetz/gruvbox'                      " Colour theme
    Plug 'itchyny/lightline.vim'                " Light status line
    Plug 'tpope/vim-commentary'                 " Comment/uncomment

    Plug 'scrooloose/nerdtree'                  " Tree file manager
    Plug 'ctrlpvim/ctrlp.vim'                   " Fuzzy finder - find files
    Plug 'dyng/ctrlsf.vim'                      " Fuzzy search - find in files

    Plug 'tpope/vim-fugitive'                   " Git commands
    Plug 'airblade/vim-gitgutter'               " Remove/modify/new line signs for git
    Plug 'Xuyuanp/nerdtree-git-plugin'          " Show files statuses in nerd tree

    Plug 'neoclide/coc.nvim', {'branch': 'release'} " Autocomplete

    Plug 'Glench/Vim-Jinja2-Syntax'

call plug#end()
" }}}

" Plugins Options {{{

" LightLine {{{
    let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }
" }}}

" NERDTree {{{
    let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '^__pycache__', 'build', 'venv', 'egg', 'egg-info/', 'dist']
" }}}

" CtrlP {{{
    let g:ctrlp_custom_ignore = '\vbuild/|dist/|venv/|target/|__pycache__/|\.git/\.(o|swp|pyc|egg|pyo)$'

    "" The Silver Searcher
    if executable('ag')
      " Use ag over grep
      set grepprg=ag\ --nogroup\ --nocolor

      " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
      let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

      " ag is fast enough that CtrlP doesn't need to cache
      let g:ctrlp_use_caching = 0
    endif
    " let g:ctrlp_match_func = { 'match': 'cpsm#CtrlPMatch' }
" }}}

" CtrlSF {{{
    let g:ctrlsf_ackprg = '/usr/bin/ag'
" }}}

" }}}

" Keys mapping {{{
    " move through windows
    map <C-l> <c-w>l
    map <C-h> <c-w>h
    map <C-k> <c-w>k
    map <C-j> <c-w>j
    " move vertically by visual line
    nnoremap j gj
    nnoremap k gk
    " toggle file tree manager with F2
    map <F2> :NERDTreeToggle<CR>
    " fold/unfold
    nnoremap <space> za
    " map ESC to jj
    imap jj <Esc>
" }}}

" Leader Shortcuts {{{
    let mapleader=","
    " save file
    map <leader>w :w<CR>
    " quit file
    map <leader>x :q<CR>
    " quit all
    map <leader>q :qa<CR>
    " Fuzzy search
    nnoremap <leader>f :CtrlSF -I 
" }}}

" Settings {{{
   set clipboard+=unnamedplus 
   set relativenumber

" Colors {{{
    syntax enable           " enable syntax processing
    " set t_Co=256
    set background=dark
    let g:gruvbox_contrast_dark='hard'
    let g:gruvbox_italic='1'
    silent! colorscheme gruvbox
" }}}

" Spaces & Tabs {{{
    set backspace=indent,eol,start  " make backspace work as usual
    set tabstop=4           " 4 space tab
    set expandtab           " use spaces for tabs
    set softtabstop=4       " 4 space tab
    set shiftwidth=4
    set modelines=1      	" set options for particular file (ex.: " vim: tabstop:2)
    filetype indent on
    filetype plugin on
    set autoindent
" }}}

" Autocomplete {{{
    " if hidden is not set, TextEdit might fail.
    set hidden
    " Some servers have issues with backup files, see #649
    set nobackup
    set nowritebackup
    " Better display for messages
    set cmdheight=2
    " Smaller updatetime for CursorHold & CursorHoldI
    set updatetime=300
    " don't give |ins-completion-menu| messages.
    set shortmess+=c
    " always show signcolumns
    set signcolumn=yes

    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

    " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
    " Coc only does snippet and additional edit on confirm.
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    " Remap keys for gotos
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
        else
            call CocAction('doHover')
        endif
    endfunction
" }}}

" Searching {{{
    set ignorecase          " ignore case when searching
    set incsearch           " search as characters are entered
    " set hlsearch            " highlight all matches
    noremap <leader>h :set hlsearch!<CR>
    nnoremap / :set hlsearch<CR>/
    vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
" }}}

" Spelling {{{
    set spelllang=en                " spell checking language
    set spellfile=$HOME/.vim/spell/en.utf-8.add     " file to add new words for spell checking
    set spell                       " turn on spell checking
    hi clear SpellBad
    hi SpellBad cterm=underline
" }}}
" }}}

" AutoGroups {{{
augroup config_group
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd FileType vim setlocal foldmethod=marker
    autocmd BufRead .vimrc setlocal foldlevel=0
    autocmd BufWritePre *.py,*.php,*.js,*.txt,*.hs,*.java,*.md,*.rb,*.css,*.jinja2,*.html :call <SID>StripTrailingWhitespaces()
    " Highlight currently open buffer in NERDTree
    autocmd BufEnter * call SyncTree()
augroup END

augroup python_group
    autocmd!
    autocmd FileType python setlocal signcolumn=yes
    autocmd FileType python map <silent> <leader>b oimport pdb; pdb.set_trace()<esc>
    autocmd FileType python  setlocal
                \ tabstop=4
                \ softtabstop=4
                \ shiftwidth=4
                \ textwidth=79
                \ expandtab
                \ autoindent
                \ fileformat=unix
augroup END

augroup jinja2_group
    autocmd!
    autocmd BufNewFile,BufRead *.html,*.jinja2 setlocal filetype=jinja
    autocmd FileType jinja setlocal autoindent smartindent ts=2 sts=2 sw=2 expandtab
augroup END

augroup yaml_group
    autocmd!
    autocmd FileType yaml setlocal autoindent smartindent ts=2 sts=2 sw=2 expandtab
augroup END

augroup sass_group
    autocmd!
    autocmd FileType scss setlocal autoindent smartindent ts=2 sts=2 sw=2 expandtab
augroup END

augroup html
    autocmd!
    autocmd FileType html setlocal foldmethod=syntax ts=2 sts=2 sw=2 expandtab
augroup END
" }}}

" Custom functions {{{

" strips trailing whitespace at the end of files. This
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

" sync open file with NERDTree
" " Check if NERDTree is open or active
function! IsNERDTreeOpen()        
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" }}}
