" Sections:
"    -> General
"    -> Plugins
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file 
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" Share vim and macos clipboard
set clipboard=unnamed


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins and plugins config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'itchyny/lightline.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mattn/emmet-vim'
Plug 'sheerun/vim-polyglot'
Plug 'simnalamburt/vim-mundo'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'
Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-webdevicons'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-startify'
Plug 'Yggdroot/indentLine'
Plug 'machakann/vim-sandwich'
Plug 'easymotion/vim-easymotion'
Plug 'ludovicchabant/vim-gutentags'
Plug 'junegunn/goyo.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'metakirby5/codi.vim'
Plug 'SkyLeach/pudb.vim', { 'do': ':UpdateRemotePlugins' }
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'liuchengxu/vista.vim'
call plug#end()

" Mundo config
" Toggle gundo
nnoremap <leader>u :MundoToggle<CR>

" fzf.vim config
map <leader>b :Buffers<cr>
map <leader>f :FZF<cr>
map <leader>a :Ag<cr>
map <leader>m :FZFMru<cr>

" mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
let $FZF_DEFAULT_OPTS='--layout=reverse'

let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! FloatingFZF()
  " creates a scratch, unlisted, new, empty, unnamed buffer
  " to be used in the floating window
  let buf = nvim_create_buf(v:false, v:true)

  " 90% of the height
  let height = float2nr(&lines * 0.5)
  " 60% of the height
  let width = float2nr(&columns * 0.5)
  " horizontal position (centralized)
  let horizontal = float2nr((&columns - width) / 2)
  " vertical position (one line down of the top)
  let vertical = float2nr((&lines - height) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height
        \ }

  " open the new window, floating, and enter to it
  call nvim_open_win(buf, v:true, opts)
endfunction" Make :Ag not match file names, only the file content

command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
command! -bang -nargs=+ -complete=dir Rag call fzf#vim#ag_raw(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

" NERDtree config
let NERDTreeShowHidden=0
let NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI = 1
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>

" vim-signify config
" default updatetime 4000ms is not good for async update
set updatetime=100
" Disable vim-signify for CSV files for performance purpose
let g:signify_skip_filetype = { 'csv': 1 } 

" Gutentags configuration
let g:gutentags_project_root = ['main.c', '.git']
nnoremap <leader>gd <C-]>
let g:gutentags_file_list_command = {
    \ 'markers': {
        \ '.git': 'git ls-files',
    \ },
\ }

" Goyo configuration
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set nonumber
  set norelativenumber
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set number
  set relativenumber
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Codi configuration
let g:codi#width = 60
let g:codi#interpreters = {
    \ 'python': {
        \ 'bin': 'python3',
        \ 'prompt': '^\(>>>\|\.\.\.\) ',
        \ },
\ }
" pudb.vim configuration
let g:pudb_breakpoint_symbol='☠'
map <leader>dt :PUDBToggleBreakPoint<cr>
map <leader>du :PUDBUpdateBreakPoints<cr>
map <leader>dc :PUDBClearAllBreakpoints<cr>

" Autocomplete configuration
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)

" LSP configuration
let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_signs_error = {'text': '✘'}
let g:lsp_signs_warning = {'text': '⚠'}
let g:lsp_signs_hint = {'text': '⚑'}
highlight link LspErrorText ErrorMsg
highlight link LspWarningText WarningMsg
map <leader>ld :LspDefinition<cr>
map <leader>lf :LspDocumentFormat<cr>
map <leader>ln :LspNextDiagnostic<cr>
map <leader>lp :LspPreviousDiagnostic<cr>
map <leader>lr :LspReferences<cr>
map <leader>lrr :LspRename<cr>
map <leader>ls :LspStatus<cr>


" Vista configuration
let g:vista#renderer#enable_icon = 1
let g:vista_executive_for = {
	\ 'cpp': 'vim_lsp',
	\ 'python': 'vim_lsp',
	\ }
map <leader>lv :Vista!!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" Show matching brackets when text indicator is over them
set showmatch 
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
set foldcolumn=1

" highlight current line
set cursorline

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Enable Dracula colorscheme
try
    colorscheme dracula
catch
endtry

" Set term background color to None (use tmux background color conf)
highlight Normal ctermbg=None

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup on
set backup
" Change default backup directory
set backupdir=~/.local/share/nvim/backup
" Protect against crash-during-write
set wb
set swapfile

" Keep undo tree
set undodir=~/.local/share/nvim/undo
set undofile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" enable folding
set foldenable

" open most folds by default
set foldlevelstart=10

" 10 nested fold max
set foldnestmax=10

" fold based on indent level
set foldmethod=indent


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext 

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Enable relative line numbering
:set number relativenumber
" Disable relative line numbering in insert mode
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c 
let g:lightline = {
  \ 'colorscheme': 'dracula'
\}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" make Y consistent with C and D and copy from cursor position
" until the end of line
nnoremap Y y$

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" set spell language
set spelllang=fr,en

" set different custom dictionnaries
set spellfile=$VIMRUNTIME/spell/fr.utf-8.add,$VIMRUNTIME/spell/en.utf-8.add

" Shortcuts using <leader>
map <leader>sn ]s
map <Leader>sN G[s
map <leader>sp [s
map <leader>sP gg]s
map <leader>sa zg
map <leader>s? z=

" set easier add to custom dict bindings
map <Leader>sf 1z
map <Leader>se 2z

" set binding to open macOS dictionnary from vim
nnoremap <Leader>sd "zyiw:execute ":silent !open dict://".@z.""<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction
