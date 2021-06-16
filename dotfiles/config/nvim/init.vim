set termguicolors
filetype plugin indent on

packadd minpac

call minpac#init()

" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})

" Add other plugins here.
call minpac#add('kassio/neoterm') " terminal tools
let g:neoterm_autoscroll = 1

call minpac#add('junegunn/fzf') " fuzzy finder

call minpac#add('beeender/Comrade')  " intelliJ
call minpac#add('Shougo/deoplete.nvim')
call minpac#add('neoclide/coc.nvim')  " conquer of completion
call minpac#add('puremourning/vimspector')  " debugger
let g:deoplete#enable_at_startup = 1

call minpac#add('davidhalter/jedi-vim') " python completion

call minpac#add('christoomey/vim-tmux-navigator')  " tmux navigation

call minpac#add('tpope/vim-fugitive') " git commands
call minpac#add('tpope/vim-commentary') " comment stuff
call minpac#add('tpope/vim-surround') " quotes exchange
call minpac#add('tpope/vim-projectionist') " project stuff : alternate files
call minpac#add('tpope/vim-obsession')  " session management
call minpac#add('tpope/vim-dispatch') " make replacement with projectionist tie-in
call minpac#add('c0r73x/neotags.nvim') " ctags support for neovim
call minpac#add('radenling/vim-dispatch-neovim')  " dispatch in neovim terminal
command! -bang -nargs=* -range=0 -complete=customlist,dispatch#command_complete D
      \ execute dispatch#compile_command(<bang>0, <q-args>,
      \   <line1> && !<count> ? -1 : <line1> == <line2> ? <count> : 0)

call minpac#add('airblade/vim-gitgutter')  " git changed
call minpac#add('vim-airline/vim-airline')  " statusbar
let g:airline#extensions#tabline#enabled = 1

call minpac#add('mbbill/undotree')  " undo explorer
nnoremap <Leader>u :UndotreeToggle<CR>
" If undotree is opened, it is likely one wants to interact with it.
let g:undotree_SetFocusWhenToggle=1
call minpac#add('scrooloose/nerdtree') " file explorer
nnoremap <Leader>e :NERDTreeToggle<CR>

call minpac#add('altercation/vim-colors-solarized') " theme
call minpac#add('icymind/NeoSolarized') " theme
set background=dark
let g:neosolarized_contrast = "high"
let g:neosolarized_termtrans=1
colorscheme NeoSolarized

call minpac#add('python-mode/python-mode') " python indent and all
let g:pymode_python = 'python3'
let g:pymode_lint = 0
let g:pymode_folding = 0

call minpac#add('w0rp/ale')  " Asyncronous Lint Engine
let g:ale_python_auto_pipenv = 1
let b:ale_fixers = {'python': ['black', 'isort']}
let b:ale_fix_on_save = 1

call minpac#add('mhinz/vim-grepper')  " async grep tool

if $VIM_UPDATE_CLEAN
    call minpac#clean()
    call minpac#update('', {'do': 'quit'})
endif



let g:airline_powerline_fonts=1

autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 softtabstop=2
nnoremap <silent> <ESC>OA <Nop>
nnoremap <silent> <ESC>OB <Nop>
nnoremap <silent> <ESC>OC <Nop>
nnoremap <silent> <ESC>OD <Nop>
inoremap <silent> <ESC>OA <Nop>
inoremap <silent> <ESC>OB <Nop>
inoremap <silent> <ESC>OC <Nop>
inoremap <silent> <ESC>OD <Nop>


nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-l> :wincmd l<CR>

set wrap
set nospell
autocmd BufEnter * :syntax sync fromstart
autocmd BufEnter * :set nocursorline
set nofoldenable                  " disable code folding
set foldmethod=manual                  " disable code folding


set clipboard=unnamed
set autowrite                       " Automatically write a file when leaving a modified buffer

set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set virtualedit=onemore             " Allow for cursor beyond last character
set history=1000                    " Store a ton of history (default is 20)

set backup                  " Backups are nice ...
set undofile                " So is persistent undo ...
set undolevels=1000         " Maximum number of changes that can be undone
set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
set undodir=~/.vim/.vimundo
set directory=~/.vim/.vimswap
set backupdir=~/.vim/.vimbackup
set viewdir=~/.vim/.vimviews

set hidden " don't warn when switching unsaved buffers

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set number                      " Line numbers on
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

set autoindent                  " Indent at the same level of the previous line
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

syntax enable

autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif  " Always switch to the current file directory
