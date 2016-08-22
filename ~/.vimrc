call plug#begin('~/.vim/plugged')
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-surround'
Plug 'editorconfig/editorconfig-vim'
Plug 'kchmck/vim-coffee-script'
Plug 'mxw/vim-jsx'
Plug 'ecomba/vim-ruby-refactoring'
Plug 'vim-scripts/matchit.zip'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'godlygeek/tabular'
Plug 'rooprob/vim-urweb'
Plug 'vim-airline/vim-airline'
call plug#end()

" Automatic indenting, on new line.
set autoindent

" Use spaces instead of tabs
set expandtab

" Real tab chars for Haskell files.
"autocmd FileType haskell
"  \ set noexpandtab

" Tab spacing.
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Use tabs at the start of a line, spaces elsewhere
set smarttab

" Show line numbers.
set number

" show the cursor position all the time
" set ruler
set backspace=indent,eol,start

" always sho status line
set laststatus=2

" Proper autocomplete when opening files
set wildmode=longest,list,full
set wildmenu

" Highlight searches
set hlsearch

" Show some whitespace characters
set listchars=eol:¶,tab:▸\ ,trail:·,extends:>,precedes:<
set list

" Do not wrap long lines
set nowrap

highlight NonText ctermfg=240 guifg=#4a4a59
highlight SpecialKey ctermfg=240 guifg=#4a4a59

" Source the vimrc file after saving it
if has("autocmd")
  autocmd BufWritePost .vimrc source $MYVIMRC
endif

let mapleader = ","
nmap <leader>v :tabedit $MYVIMRC<CR>

" Smart home key
function! SmartHome()
  let s:col = col(".")
  normal! ^
  if s:col == col(".")
    normal! 0
  endif
endfunction
nnoremap <silent> <Home> :call SmartHome()<CR>
inoremap <silent> <Home> <C-O>:call SmartHome()<CR>

" Window title
autocmd BufEnter * let &titlestring = expand("%:@")
set title

set wildignore+=*/tmp/*,*.so,*.swp,*.zip

" Sane Ignore For ctrlp
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\data$|\v[\/]\.(git|hg|svn|vagrant|rsync_cache)$',
  \ 'file': '\v\.(exe|so|dll|pdf|png|jpg)$',
  \ }

let g:gitgutter_sign_column_always = 1
let g:gitgutter_eager = 0

" Line numbers
nnoremap <F3> :set hlsearch! hlsearch?<CR>

" Remove trailing whitespace
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" Some color
" set t_Co=256
syntax on

let g:inkpot_black_background=1
colorscheme inkpot
"set background=dark
"colorscheme solarized
"colorscheme railscasts

" Avoid flashing terminal output in :Ag
set shellpipe=>

