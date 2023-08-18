" ------------------------------------------------------------------------------
" Configuration / options
" ------------------------------------------------------------------------------

" Searching
set ignorecase    " Searches are case-insensitive
set smartcase     " Search case-sensitively for terms with uppercase letters
set incsearch     " Show search hits while typing
set nohlsearch    " Do not highlight search hits
" set rnu
" set inccommand=nosplit   " Highlight and preview replace for substitute command

" Indentation and tabs
set autoindent       " Copy indent from current line when starting a new line
set tabstop=2        " A <Tab> is four spaces
set shiftwidth=4     " Indentation shift is 4 spaces
set expandtab        " Use spaces instead of tabs
set backspace=indent,eol,start      " Sensible backspace behaviour

" Completion
set complete+=kspell
set completeopt=menuone,longest

" Custom status line
set laststatus=2
set statusline=%f%<\ %q%h%w%m%r
set statusline+=%=
"set statusline+=[%b\ 0x%B]
"set statusline+=\ 
set statusline+=%l/%L
set statusline+=:%c
set statusline+=\ 
set statusline+=%#PmenuSel#
set statusline+=%{FugitiveStatusline()}
set statusline+=%#LineNr#
highlight StatusLineNC ctermfg=242
highlight StatusLine ctermfg=240

" Auto commands
augroup vdelrio
    autocmd!
    " Tab sizes per file type
    autocmd Filetype groovy,grails setlocal tabstop=4 shiftwidth=4
    autocmd Filetype html,scss,eruby,xml,yaml,eruby.yaml,ruby,haml,javascript,vue setlocal tabstop=2 shiftwidth=2
    " Keyword chars per file type
    autocmd Filetype ruby setlocal iskeyword+=?
    autocmd Filetype haml setlocal iskeyword+=?,-
    autocmd Filetype javascript,scss setlocal iskeyword+=-
augroup END

" Share default register with system clipboard
if has('mac')
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif

" Miscelaneous
set number             " Line numbers
set background=dark   " Use colors for light background
set nowrap             " Don't wrap long lines
set splitright         " Split horizontal to right
set splitbelow         " Split vertical below
set mouse=a            " Enable mouse
if !has('nvim')
    set ttymouse=xterm2    " Make mouse play nice with tmux
endif
set scrolloff=4        " Keep 4 lines off the edges when scrolling
set sidescrolloff=8    " Keep 8 columns off the edges when scrolling horizontally
set pastetoggle=<F2>   " F2 toggles paste mode (paste without autoindent)
set nrformats=bin,hex  " <C-a>, <C-x> don't mess with 0-padded numbers (octal)
set diffopt=filler,vertical " Open diff windows with vertical split

" Keep swap, backup and undo files out of workspaces
if !has('nvim')
    let swapdir = $HOME.'/.vim/swapfiles'
    if !isdirectory(swapdir)
        call mkdir(swapdir, "p")
    endif
    let swapdir_spec = swapdir.'//'
    let &directory = swapdir_spec
    let &backupdir = swapdir_spec
    let &undodir = swapdir_spec
endif

" Load matchit (match do ... end)
runtime macros/matchit.vim

" ------------------------------------------------------------------------------
" Mappings and custom commands
" ------------------------------------------------------------------------------

" Mapping normal keys

map <C-t><up> :tabr<cr>
map <C-t><down> :tabl<cr>
map <C-t><left> :tabp<cr>
map <C-t><right> :tabn<cr>

noremap ™ <C-w>h
noremap ¬ <C-w>l
noremap ¶ <C-w>j
noremap § <C-w>k

noremap <silent> <C-l> :vertical resize +3<CR>
noremap <silent> <C-h> :vertical resize -3<CR>
noremap <silent> <C-k> :resize +3<CR>
noremap <silent> <C-j> :resize -3<CR>

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

:imap ii <Esc>

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" nnoremap <C-n> :call g:ToggleNuMode()<cr>

" Ease things for spanish keyboard
noremap ñ /
noremap Ñ ?
let mapleader = ","

" Use the silver searcher for grepping  ||| VER CÓMO FUNCIONA CON ACK
cnoreabbrev Ack Ack!
nnoremap <Leader>ag :Ack!<Space>

" Move to next/previous quickfix location
nnoremap <F3> :cnext<cr>
nnoremap <S-F3> :cprevious<cr>
nnoremap <F4> :cnfile<cr>
nnoremap <S-F4> :cpfile<cr>

" Move to next/previous change location
nnoremap <A-o> g;
nnoremap <A-i> g,

" Open previous file
nnoremap <leader>p <C-^>

" Quick save
nnoremap <leader>w :w<cr>

" Quit
nnoremap <leader>q :q<cr>

" Quick quit
nnoremap <leader>Q :qa<cr>

" Delete trailing spaces
nnoremap <leader>ds :s/\v\s+$//<cr>

" Close quickfix/local list, fugitive and terminal rspec windows
function! CloseFugitiveWindow()
    let fugitive_winnr = bufwinnr('/.git/index$')
    if fugitive_winnr != -1
        exe fugitive_winnr . "wincmd c"
    endif
endfunction
function! CloseTestWindow()
    let rspec_winnr = bufwinnr('rspec')
    if rspec_winnr != -1
        exe rspec_winnr . "wincmd c"
    endif
    let rspec_winnr = bufwinnr('jest')
    if rspec_winnr != -1
        exe rspec_winnr . "wincmd c"
    endif
endfunction
nnoremap <leader>c :cclose<cr>:lclose<cr>:call CloseFugitiveWindow()<cr>:call CloseTestWindow()<cr>

" Change ruby hashrockets to new format on current line
nnoremap <leader>h :s/\v:([A-Za-z_0-9]+) ?\=\>/\1:/g<cr>
vnoremap <leader>h :s/\v:([A-Za-z_0-9]+) ?\=\>/\1:/g<cr>

" Toggle highlighting search matches
nnoremap <leader>ll :set hlsearch!<cr>

" Create tags file: only project files
nnoremap <leader>tp :!ctags -R --languages=ruby,javascript --exclude=.git --exclude=log --exclude=node_modules .<cr>
" Create tags file: project files and bundled gems
nnoremap <leader>tb :!ctags -R --languages=ruby,javascript --exclude=.git --exclude=log . $(bundle show --paths \| grep ^/)<cr>
" Jump to tag, open select window for multiple matches
nnoremap <leader>tt g<C-]>
vnoremap <leader>tt g<C-]>

" Quickly edit and save .vimrc
 nnoremap <leader>ev :vsp $MYVIMRC<cr>
 nnoremap <leader>sv :w<cr>:source $MYVIMRC<cr>:q<cr>

" Move up/down inside wrapped lines
nnoremap j gj
nnoremap k gk

" Exit insert mode without <esc> stretch
inoremap jk <esc>
if has('nvim')
    tnoremap jk <C-\><C-n>
endif

" Quicker begin and end of line
nnoremap H 0
vnoremap H 0
nnoremap L $
vnoremap L $

" Sensible yank to end of line
nnoremap Y y$

" Swap 'jump to' markers.
" Easier to type ' now jumps to line and column.
nnoremap ' `
nnoremap ` '

" Close window
nnoremap <leader>x <C-w>c

" Keep only current window
nnoremap <leader>z <C-w>o

" Yank current file/folder path to clipboard
nnoremap <leader>yy :let @+=expand('%')<cr> \| :echo "Copied path:"@+<cr>
nnoremap <leader>yb :let @+=expand('%:t')<cr> \| :echo "Copied basename:"@+<cr>
nnoremap <leader>yf :let @+=expand('%:p')<cr> \| :echo "Copied full path:"@+<cr>

" Open file from path in clipboard
nnoremap <leader>yo :e <C-r>+<cr>

" Move visually selected lines up and down
vnoremap J :m '>+1<cr>gv
vnoremap K :m '<-2<cr>gv

" XML pretty formatting
if executable('xmllint')
    command! XXmlLint execute '%!xmllint --format -'
endif

" JSON pretty formatting
if executable('python')
    command! XJsonPretty execute '%!python -m json.tool'
endif

" Hex dump
if executable('xxd')
    command! XHexDump execute '%!xxd'
endif

" Quick open terminal in vertical split
if has('nvim')
    command! T execute 'set shell=/bin/bash\ --login' | execute 'vsplit' | execute 'terminal' | execute 'set shell=/bin/bash'
endif

" ------------------------------------------------------------------------------
" Plugins
" ------------------------------------------------------------------------------

" Keep vim and neovim plugins in separate paths
let plug_vim_path = '~/.vim/autoload/plug.vim'
let plugins_path = '~/.vim/plugged'
if has('nvim')
    let plug_vim_path = '~/.local/share/nvim/site/autoload/plug.vim'
    let plugins_path = '~/.local/share/nvim/plugged'
endif

" Automatically install vim-plug (https://github.com/junegunn/vim-plug)
if empty(glob(plug_vim_path))
  echo "Downloading vim-plug..."
  execute "!curl -fLo ".plug_vim_path." --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(plugins_path)

" JavaScript support
Plug 'pangloss/vim-javascript'
" TypeScript syntax
Plug 'leafgarland/typescript-vim' 
" Nice statusline at the bottom of each vim window
Plug 'vim-airline/vim-airline'
" Vim theme
Plug 'morhetz/gruvbox'
" Searcher like silver
Plug 'mileszs/ack.vim'
" Add/change surrounding elements
Plug 'tpope/vim-surround'
" Allow dot command for plugins
Plug 'tpope/vim-repeat'
" Git integration
Plug 'tpope/vim-fugitive'
" Rails utilities
Plug 'tpope/vim-rails'
" Add/remove comments
Plug 'tpope/vim-commentary'
" Automatically add 'end'
Plug 'tpope/vim-endwise'
" Automatically close html tags
Plug 'alvan/vim-closetag'
" Automatically pair brackets, parentheses, quotes
Plug 'jiangmiao/auto-pairs'
" File tree sidebar
Plug 'scrooloose/nerdtree'
" Quick movements
Plug 'easymotion/vim-easymotion'
" Fuzzy file searches
Plug 'ctrlpvim/ctrlp.vim'
" Check syntax inside vim
Plug 'dense-analysis/ale'
" Running tests
Plug 'vim-test/vim-test'
" Run rspecs in tmux pane, read errors to quickfix list
Plug 'tpope/vim-dispatch'
" Custom text-objects
Plug 'kana/vim-textobj-user'
" CoC
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" Ruby text-objects: r(uby block), f(unction), c(lass), n(ame)
Plug 'tek/vim-textobj-ruby'
" ERB text-objects: E(RB)
Plug 'whatyouhide/vim-textobj-erb'
" Open file:line
Plug 'bogado/file-line'
" Show indentation lines
Plug 'yggdroot/indentline'
" Comentary toggle
Plug 'tpope/vim-commentary' 
" Markdown viewer
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}
" Autocomplete
if has('nvim')
    Plug 'vim-scripts/AutoComplPop'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    " Autocomplete source: syntax highlighting
    Plug 'Shougo/neco-syntax'
    " Autocomplete source: ruby
    Plug 'etordera/deoplete-ruby'
    " Autocomplete source: rails
    Plug 'etordera/deoplete-rails'
endif
" Dart syntax highlighting
Plug 'dart-lang/dart-vim-plugin'
" Rubocop autocorrection
if executable('rubocop')
  Plug 'etordera/vim-rubocop-autocorrect'
endif
" nginx syntax highlighting
Plug 'chr4/nginx.vim'
" Flutter
Plug 'nvim-lua/plenary.nvim'
Plug 'akinsho/flutter-tools.nvim'
call plug#end()

" Snippets
Plug 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
" Plugin 'honza/vim-snippets'
" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" LSPConfig
" local use = require('packer').use
" require('packer').startup(function()
  " use 'wbthomason/packer.nvim' -- Package manager
  " use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
" end)

""" FLUTTER
 " Show hover
nnoremap K <Cmd>lua vim.lsp.buf.hover()<CR>
 " Jump to definition
nnoremap gd <Cmd>lua vim.lsp.buf.definition()<CR>
 " Open code actions using the default lsp UI, if you want to change this please see the plugins above
nnoremap <leader>ca <Cmd>lua vim.lsp.buf.code_action()<CR>
 " Open code actions for the selected visual range
xnoremap <leader>ca <Cmd>lua vim.lsp.buf.range_code_action()<CR>

" NERDTree settings
nnoremap <leader>n :NERDTreeToggle<cr>
nnoremap <leader>i :NERDTreeFind<cr>
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMouseMode = 2

" vim-closetag settings
let g:closetag_filenames = '*.html,*.htm,*.xml,*.erb,*.php,*.gsp'

" Ctrl-P settings
set wildignore+=*/bin/*,*tmp/*,*node_modules/*,*.class,*.zip,*.jpg,*.png
let g:ctrlp_map = '<leader>o'
let g:ctrlp_max_files = 0
let g:ctrlp_working_path_mode = 'a'
" Add kinds for universal-ctags (ruby: S for singleton methods, s for scopes)
let g:ctrlp_buftag_types = { 'ruby': '--ruby-types=cfFmSs', 'javascript': '--javascript-types=CGScfgmpv' }
nnoremap <leader>r :CtrlPMRUFiles<cr>
nnoremap <leader>m :CtrlPBufTag<cr>

" ALE settings
let g:ale_linters = { 'ruby': ['ruby'] }
if executable('rubocop')
    let g:ale_linters = { 'ruby': ['rubocop'] }
    let g:ale_ruby_rubocop_executable = 'bundle'
    function! ToggleRubocop()
        if has_key(g:ale_linters, 'ruby')
            if g:ale_linters['ruby'] == ['ruby']
                let g:ale_linters = { 'ruby': ['rubocop'] }
                echo "RuboCop is now enabled"
            else
                let g:ale_linters = { 'ruby': ['ruby'] }
                echo "RuboCop is now disabled"
            endif
        else
            let g:ale_linters = { 'ruby': ['rubocop'] }
            echo "RuboCop is now enabled"
        endif
        ALELint
    endfunction
    nnoremap <Leader>b :call ToggleRubocop()<cr>
endif
nnoremap <Leader>lt :ALEToggleBuffer<cr>

" Vim Test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" vim-test settings
function! InitTestCommands()
    let config_file = '.vim_test_commands' 
    if filereadable(config_file)
        let g:test_commands = readfile(config_file)
    else
        let g:test_commands = ['vsplit | terminal', 'Dispatch -compiler=rspec',]
    endif
    let g:test_command_current = 0
endfunction
call InitTestCommands()

function! RotateTestCommand()
    let g:test_command_current = g:test_command_current + 1
    if g:test_command_current >= len(g:test_commands)
        let g:test_command_current = 0
    endif
endfunction

function! TestCommandInfo()
    echo "Test command: ".g:test_commands[g:test_command_current]
endfunction

function! CustomTestStrategy(cmd)
  execute g:test_commands[g:test_command_current] . ' ' . a:cmd
endfunction

let test#ruby#use_binstubs = 0
let g:test#custom_strategies = {'custom': function('CustomTestStrategy')}
let g:test#strategy = 'custom'

nnoremap <Leader>sc :call RotateTestCommand()<cr>:call TestCommandInfo()<cr>
nnoremap <Leader>si :call TestCommandInfo()<cr>
nnoremap <Leader>sf :call CloseTestWindow()<cr>:TestFile<cr>
nnoremap <Leader>ss :call CloseTestWindow()<cr>:TestNearest<cr>
nnoremap <Leader>sl :call CloseTestWindow()<cr>:TestLast<cr>
nnoremap <Leader>sa :call CloseTestWindow()<cr>:TestSuite<cr>

" Indentline settings
function! ColorColumnToggle()
    let newcolorcolumn = &colorcolumn == "" ? "100" : ""
    let &colorcolumn = newcolorcolumn
endfunction
let g:indentLine_enabled = 0
nnoremap <Leader><TAB> :IndentLinesToggle<cr>:call ColorColumnToggle()<cr>

"
" Set compatibility to Vim only.
" set nocompatible
" set nolist
" Helps force plug-ins to load correctly when it is turned back on below.
filetype off

" Turn on syntax highlighting.
syntax on

" For plug-ins to load correctly.
filetype plugin indent on

" Vim's auto indentation feature does not work properly with text copied from outside of Vim. Press the <F2> key to toggle paste mode on/off.
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>

" Uncomment below to set the max textwidth. Use a value corresponding to the width of your screen.
" set textwidth=100
" set formatoptions=tcqrn1
" set tabstop=2
" set shiftwidth=2
" set softtabstop=2
" set expandtab
" set noshiftround

" terminal window
" set termwinsize = 20x0
" open terminal below all splits
cabbrev bterm bo term

" Display 5 lines above/below the cursor when scrolling with a mouse.
" set scrolloff=5
" Fixes common backspace problems
set backspace=indent,eol,start

" Speed up scrolling in Vim
set ttyfast

" Status bar
set laststatus=2

" Display options
set showmode
set showcmd

" Highlight matching pairs of brackets. Use the '%' character to jump between them.
set matchpairs+=<:>

" Set status line display
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%c')}

" Encoding
set encoding=utf-8

" Enable incremental search
set incsearch
" Include matching uppercase words with lowercase search term
set ignorecase
" Include only uppercase words with uppercase search term
set smartcase

" Store info from no more than 100 files at a time, 9999 lines of text, 100kb of data. Useful for copying large amounts of data between files.
set viminfo='100,<9999,s100

" Map the <Space> key to toggle a selected fold opened/closed.
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" Automatically save and load folds
" autocmd BufWinLeave *.* mkview 
" autocmd BufWinEnter *.* silent loadview 
noremap <leader><cr> <cr><c-w>h:q<cr>
nnoremap <leader>th :sp<CR><C-w>J15<C-w>_:terminal<CR>

set runtimepath^=~/.vim/bundle/ctrlp.vim
:helptags ~/.vim/bundle/ctrlp.vim/doc

" bind K to grep word under cursor
nnoremap K :Ack! "\b<C-R><C-W>\b"<CR>:cw<CR>

colorscheme gruvbox
let g:gruvbox_contrast_dark = "hard"
let g:coc_global_extensions = [ 'coc-tsserver' ]

let g:airline_powerline_fonts = 1
let g:ackprg = 'ag --nogroup --nocolor --column'

" relative number toggle function.
" function! g:ToggleNuMode()
" 	if(&rnu == 1)
" 		set norelativenumber
" 		set number
" 	else
" 		set relativenumber
" 	endif
" endfunc

" Rubocop lintern.
" ngmy
" let g:vimrubocop_config = '~/.rubocop.yml'

" Autocomplete html tags
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
:ab <<< </<C-x><C-o>
