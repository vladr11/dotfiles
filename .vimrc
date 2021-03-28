"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"       Amir Salihefendic
"       http://amix.dk - amix@amix.dk
"
" Version:
"       5.0 - 29/05/12 15:43:36
"
" Blog_post:
"       http://amix.dk/blog/post/19691#The-ultimate-Vim-configuration-on-Github
"
" Awesome_version:
"       Get this config, nice color schemes and lots of plugins!
"
"       Install the awesome version from:
"
"           https://github.com/amix/vimrc
"
" Syntax_highlighted:
"       http://amix.dk/vim/vimrc.html
"
" Raw_version:
"       http://amix.dk/vim/vimrc.txt
"
" Sections:
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
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
set history=700
 
" Enable filetype plugins
filetype plugin on
filetype indent on
 
" Set to auto read when a file is changed from the outside
set autoread

" Close vim when NERDTree is the last window
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Mirror the same NERDTree on every tab
autocmd BufWinEnter * silent NERDTreeMirror
 
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","
 
" Fast saving
nmap <leader>w :w!<cr>

" Make pear-tree not delete closing pair 
let g:pear_tree_repeatable_expand = 0
 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7
 
" Show line numbers
set number relativenumber

" Toggle numbers with relative numbers
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * if &nu | set relativenumber | endif
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
 
" Turn on the WiLd menu
set wildmenu
 
" Ignore compiled files
set wildignore=*.o,*~,*.pyc
 
"Always show current position
set ruler
 
" Height of the command bar
set cmdheight=2
 
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
 
" For regular expressions turn magic on
set magic
 
" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2
 
" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500
 
" Airline config
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable
 
colorscheme desert
set background=dark
 
" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set t_Co=256
    set guitablabel=%M\ %t
endif
 
" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8
 
" Use Unix as the standard file type
set ffs=unix,dos,mac
 
 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile
 
 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs - NOPE
" set expandtab
 
" Be smart when using tabs ;)
set smarttab
 
" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
 
" Linebreak on 500 characters
set lbr
set tw=500
 
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
 
 
""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>
 
 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk
 
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
 
" Split windows below (e.g. terminal)
set splitbelow

" Terminal size
set termwinsize=15x0

" Close the current buffer
map <leader>bd :Bclose<cr>
 
" Close all the buffers
map <leader>ba :1,1000 bd!<cr>
 
" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
 
" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
 
" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>
 
" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry
 
" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%
 
 
""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2
 
" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
 
 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^
 
" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z
 
if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif
 
" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()
 
 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>
 
" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>
 
" Vimgreps in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>
 
" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>
 
" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>
 
" Open fuzzy search window which opens a new tab with the selected file
nnoremap <C-f> :call fzf#run({'sink': 'e', 'down': '20%'})<CR>
nnoremap <C-x> :Ag<CR>
 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>
 
" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=
 
 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>z mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
 
" Quickly open a buffer for scripbble
map <leader>q :e ~/buffer<cr>
 
" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>
 
" Mappings for YcmCompleter goto functions
nnoremap <leader>d :YcmCompleter GoTo<cr>
nnoremap <leader>i :YcmCompleter GoToInclude<cr>
nnoremap <leader>g :YcmCompleter GoToDefinition<cr>
nnoremap <leader>s :YcmCompleter GoToSymbol 
nnoremap <leader>e :YcmCompleter GoToReferenecs<cr>
nnoremap <leader>m :YcmCompleter GoToImplementation<cr>
nnoremap <leader>t :YcmCompleter GoToType<cr>
nnoremap <leader>a :YcmCompleter GetDoc<cr>

 
 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction
 
function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"
 
    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")
 
    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif
 
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
 
 
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    end
    return ''
endfunction
 
" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")
 
   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif
 
   if bufnr("%") == l:currentBufNum
     new
   endif
 
   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

so ~/.vim/plugins.vim

nmap ]c <Plug>GitGutterNextHunk
nmap [c <Plug>GitGutterPrevHunk
nmap <Leader>hs <Plug>GitGutterStageHunk
nmap <Leader>hu <Plug>GitGutterUnstageHunk

map <C-a> :NERDTreeFocus<CR>
autocmd VimEnter * NERDTree | wincmd p

let author="Vlad Rusu"
let gatename=substitute(toupper(expand("%:t")), "\\.", "_", "g")

autocmd bufnewfile *.c so ~/.vim/c-file-preamble.txt
autocmd bufnewfile *.h so ~/.vim/h-file-preamble.txt
autocmd bufnewfile *.[c|h] exe "1," . 7 . "g/<filename>/s//" . expand("%")
autocmd bufnewfile *.[c|h] exe "1," . 7 . "g/<author>/s//" . author
autocmd bufnewfile *.[c|h] exe "1," . 7 . "g/<date>/s//" . strftime("%d-%m-%Y")
autocmd bufnewfile *.[c|h] exe "1," . 7 . "g/<year>/s//" . strftime("%Y")
autocmd bufnewfile *.h exe "1," . 12 . "g/<gatename>/s//" . gatename

autocmd Bufwritepre,filewritepre *.[c|h] execute "normal ma"

function! s:typedef_struct(type_name)
    execute "normal! itypedef struct " . a:type_name . "_s"
    execute "normal! o{"
    normal! o
    execute "normal! o} " . a:type_name . "_t;"
    call cursor( line('.') - 1, 1 )
    execute "normal! i\t"
    normal! A
endfunction

command! -nargs=1 Tds call <SID>typedef_struct(<q-args>)

function! s:typedef_enum(type_name)
    execute "normal! itypedef enum " . a:type_name . "_e"
    execute "normal! o{"
    normal! o
    execute "normal! o} " . a:type_name . "_t;"
    call cursor( line('.') - 1, 1 )
endfunction

command! -nargs=1 Tde call <SID>typedef_enum(<q-args>)

function! s:typedef_union(type_name)
    execute "normal! itypedef union " . a:type_name . "_u"
    execute "normal! o{"
    normal! o
    execute "normal! o} " . a:type_name . "_t;"
    call cursor( line('.') - 1, 1 )
endfunction

command! -nargs=1 Tdu call <SID>typedef_union(<q-args>)

let g:ycm_confirm_extra_conf = 0

let g:ackprg = 'ag --nogroup --nocolor --column'
