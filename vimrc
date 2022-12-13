set nocompatible               " Disable VI compatibility
filetype off

let vimhome = expand("$HOME/.vim")
let vundlehome = vimhome."/vundle"

if isdirectory(vundlehome) && &loadplugins
  exe 'set rtp+=' . vundlehome
  call vundle#begin()

  " Package install:
  " VIM: :PluginInstall
  " CLI: vim +PluginInstall +qall

  " Solarized colourscheme
  Plugin 'altercation/vim-colors-solarized'

  " Vim Vundle Package Manager
  Plugin 'gmarik/vundle'

  " JIT Code Compilation
  Plugin 'scrooloose/syntastic'
  nnoremap <leader>e :Errors<CR>
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 0
  let g:syntastic_check_on_open = 1
  let g:syntastic_enable_signs = 1
  let g:syntastic_auto_jump = 0
  let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
  let g:syntastic_error_symbol = '✗'
  let g:syntastic_warning_symbol = '!'
  let g:syntastic_enable_highlighting = 0
  let g:syntastic_cpp_cpplint_exec = 'cpplint'
  let g:syntastic_cpp_checkers = ['cppcheck', 'cpplint']
  let g:syntastic_cpp_check_header = 1
  let g:syntastic_python_checkers = ['pyflakes']
  let g:syntastic_ruby_checkers = ['mri', 'rubocop']
  let g:syntastic_python_pylint_post_args = '--rcfile="`upfind .pylintrc | head`"'
  let g:syntastic_ruby_rubocop_exec = 'chef exec rubocop'

  " Intensely orgasmic commenting (their words, not mine)
  " See: :Help NERD_Commenter.txt
  Plugin 'scrooloose/nerdcommenter'
  let g:NERDSpaceDelims = 1

  " Vim-based Filesystem Explorer
  " See: :help NERD_Tree.txt
  Plugin 'scrooloose/nerdtree'
  nnoremap <leader>n :NERDTreeToggle<CR>

  " C++11 Enhanced Highlighting
  Plugin 'octol/vim-cpp-enhanced-highlight'

  " Fugitive - Git wrapper
  " :Gitedit :Gitdiff :Gitblame etc.
  Plugin 'tpope/vim-fugitive'
  set statusline+=%{fugitive#statusline()}

  " EasyMotion - Easy text searching
  " <leader><leader><motion> (e.g. \\w for start of word search)
  Plugin 'Lokaltog/vim-easymotion'
  map <leader> <Plug>(easymotion-prefix)
  nmap s <Plug>(easymotion-s2)

  " Full path fuzzy file, buffer, mru, tag
  " See: :help ctrlp-commands
  " See: :help ctrlp.txt
  Plugin 'kien/ctrlp.vim'
  nmap <silent> <leader>. :CtrlPTag<cr>

  " Gist support
  Plugin 'mattn/gist-vim'
  let g:gist_post_private = 1

  " Enable better vim EOL whitespace support
  Plugin 'ntpeters/vim-better-whitespace'
  call vundle#end()

  " Git gutter (show git diffs in gutter)
  Plugin 'airblade/vim-gitgutter'
  let g:gitgutter_max_signs = 5000

  " Better Ruby syntax support
  Plugin 'vim-ruby/vim-ruby'

  " Pencil - Rethinking Vim as a tool for writing
  Plugin 'reedes/vim-pencil'
  let g:pencil#wrapModeDefault = 'soft'

  " HTML Tag Matching
  Plugin 'valloric/MatchTagAlways'
  let g:mta_use_matchparen_group = 1
  nnoremap <leader>% :MtaJumpToOtherTag<cr>

  augroup pencil
    autocmd!
    autocmd FileType markdown,mkd    call pencil#init()
    autocmd FileType text            call pencil#init({'wrap': 'soft', 'autoformat': 1})
    autocmd FileType html,htmldjango call pencil#init({'autoformat': 0})
  augroup END

  noremap <buffer> <silent> <F7> :<C-u>PFormatToggle<cr>
  inoremap <buffer> <silent> <F7> <C-o>:PFormatToggle<cr>

  " Terraform integration
  Plugin 'hashivim/vim-terraform'
endif

filetype plugin indent on " required!
syntax enable             " Enable syntax highlighting

" Map F1 to man page on current word (or use K)
source $VIMRUNTIME/ftplugin/man.vim
nnoremap <F1>  :Man <cword><CR>

" vimdiff shortcuts
nnoremap <F2>  do
nnoremap <F3>  dp
nnoremap <F9>  :tprev<CR>
nnoremap <F10> :tnext<CR>
nnoremap <F11> [czz
nnoremap <F12> ]czz

" This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" Standard options
set autowrite             " Automatically save before commands like :next and :make
set autoindent            " Match indentation of previous line
set backspace=indent,eol,start " Backspace through everything in insert mode
set background=dark       " Dark background
set clipboard=unnamedplus " Attempt to use clipboardplus for cp
set encoding=utf-8        " Use UTF-8 for character encoding
set expandtab             " Use spaces, not tabs
set exrc                  " enable per-directory .vimrc files
set foldmethod=indent     " Fold based on indentation
set foldnestmax=3         " Deepest fold is 3 levels
set hidden                " Hide buffers when they are abandoned
set history=1000          " Store 1000 commands in history buffer
set hlsearch              " Highlight search terms
set ignorecase            " Do case insensitive matching
set incsearch             " Incremental search
set ls=2                  " Always show status line
set mouse=a               " Enable mouse usage (all modes)
set nocursorline          " Don't highlight the current line
set noerrorbells          " Turn error bells off
set nofoldenable          " Don't fold by default
set nolist                " Don't visualise characters
set norelativenumber      " Don't show relative numbers for lines
set novisualbell          " Turn visual bells off
set nowrap                " Don't wrap lines automatically
set ruler                 " Always display row/col (cursor) position.
set scrolloff=4           " Keep cursor <n> characters away from top/bottom
set secure                " disable unsafe commands in local .vimrc files
set shiftwidth=4          " Tabs = 4 spaces
set showcmd               " Show (partial) command in status line.
set showmatch             " Show matching brackets
set showmatch             " Show matching parentheses
set sidescrolloff=7       " Keep cursor <n> characters away from left/right
set smartcase             " Do smart case matching
set synmaxcol=120         " Only highlight syntax upto 120 characters
set tabstop=4             " Tabs = 4 spaces
set t_Co=256              " Set terminal to 256 colours
set title                 " Set the terminals title
set ttyfast               " Smoother changes
set lazyredraw            " Smoother changes
set wildmenu              " Enhanced command line completion

" Customisations
set completeopt+=preview
let &directory=vimhome."/swap//"
let &backupdir=vimhome."/backup//"
set number                " Enable line numbers

silent! call system('mkdir -p ' . &directory)
silent! call system('mkdir -p ' . &backupdir)

if has('unnamedplus')
  set clipboard=unnamedplus,unnamed
endif

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
  let &undodir = vimhome."/undo"
  silent! call system('mkdir -p ' . &undodir)
  set undofile
endif

"hi Normal ctermbg=NONE
try
  let g:solarized_termtrans=1
  let g:solarized_termcolors=256
  color solarized
catch
  color Tomorrow-Night-Bright
endtry

autocmd BufRead SConstruct,SConscript
  \ set filetype=python
autocmd BufRead Berksfile
  \ set filetype=ruby
autocmd BufRead *.yaml,*.yml
  \ set filetype=yaml
autocmd BufRead *.json
  \ set filetype=json
autocmd BufRead *.csl
  \ set filetype=csl
autocmd BufRead *.g4
  \ set filetype=g4

au FileType markdown set textwidth=80
au FileType python set textwidth=88

au FileType eruby,ruby set textwidth=79            " Ruby Friendly
au FileType eruby,ruby set shiftwidth=2 tabstop=2  " Ruby standard
au FileType eruby,ruby set re=1                    " Use older regex engine for Ruby

au FileType yaml,yml set shiftwidth=2 tabstop=2  " YAML recommendation
au FileType json set shiftwidth=2 tabstop=2  " JSON recommendation
au FileType javascript set shiftwidth=2 tabstop=2  " YAML recommendation

au FileType bash,sh set shiftwidth=2 tabstop=2
au FileType vim set shiftwidth=2 tabstop=2
au FileType css set shiftwidth=2 tabstop=2
au FileType scss set shiftwidth=2 tabstop=2
au FileType terraform set shiftwidth=2 tabstop=2
au FileType groovy set shiftwidth=2 tabstop=2
au FileType xml set shiftwidth=2 tabstop=2

au FileType text,markdown,html,htmldjango set textwidth=0 shiftwidth=2 tabstop=2
au FileType text,html,htmldjango set noautoindent nosmartindent

" This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" Strip whitespaces endings on save
function! s:StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction

autocmd FileType c,cpp,csl,eruby,g4,java,json,markdown,php,python,ruby,yaml,vim
  \ autocmd BufWritePre <buffer> :call s:StripTrailingWhitespaces()

" Zoom / Restore window.
function! s:ZoomToggle() abort
  if exists('t:zoomed') && t:zoomed
    execute t:zoom_winrestcmd
    let t:zoomed = 0
  else
    let t:zoom_winrestcmd = winrestcmd()
    resize
    vertical resize
    let t:zoomed = 1
  endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <C-W>z :ZoomToggle<CR>

" Source user local .vimrc
if filereadable(glob("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif

python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

set laststatus=2
