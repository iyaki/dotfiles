"-------- General -------"

syntax enable
set t_Co=256

set backspace=indent,eol,start
set history=1000 " Increase history from 20 default to 1000
set lazyredraw " Don't redraw when we don't have to
set report=0 " Show all changes

"-------- Tabs & indentation -------"

filetype plugin indent on
set autoindent " Copy indent from last line when starting new line
set expandtab " Expand tabs to spaces
set shiftwidth=4 " The # of spaces for indenting
set tabstop=4 " Tab key results in 4 spaces
set softtabstop=4 " Tab key results in 4 spaces
set smarttab " At start of line, <Tab> inserts shiftwidth spaces, <Bs> deletes shiftwidth spaces
set shiftround " Round indent to nearest multiple of 4
set nowrap " No line-wrapping

"-------- Search -------"

set hlsearch " Highlight searches
set incsearch " Highlight dynamically as pattern is typed
set ignorecase " Ignore case of searches
set smartcase " Ignore 'ignorecase' if search patter contains uppercase characters

"-------- Visual decorations -------"

set wildmenu " Hitting TAB in command mode will show possible completions above command line
set number " Enable line numbers
set laststatus=2 " Show status line
set showmode " Show what mode you're currently in
set showcmd " Show what commands you're typing
set ruler " Show current line and column position in file
set title " Show file title in terminal tab
set cursorline " Highlight current line
set showmatch " Show matching brackets when text indicator is over them

"-------- Tree search ---------"

let g:netrw_liststyle = 3 " To open the file browser type :Explore or :Ex, or :Texplore or :Tex to open the browser in a new tab

"-------- Mouse Support --------"

set mouse=a
