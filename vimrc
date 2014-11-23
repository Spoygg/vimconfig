set nocompatible

""" Vundle stuff
filetype off
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

" Add Vundle plugins
call vundle#begin()
" Let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'
" I <3 these
Plugin 'tpope/vim-fugitive'
Plugin 'rking/ag.vim'
Plugin 'Osse/double-tap'
Plugin 'mattn/gist-vim'
Plugin 'mattn/webapi-vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'godlygeek/tabular'
Plugin 'airblade/vim-gitgutter'
Plugin 'wakatime/vim-wakatime'
" Plugin 'Valloric/YouCompleteMe'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
" Plugin 'bling/vim-airline'
" End Vundle plugins <3
call vundle#end()
filetype plugin indent on
""" End Vundle stuff

syntax on
colorscheme molokai
" Fix for vim-gitgutter gutter color
highlight clear SignColumn

set ttyfast " Improves redrawing
set showcmd " Show commands at bottom right
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smartindent
set autoindent
set nowrap " I do not like that damn wrapping

" Folding
set foldmethod=manual
set foldlevel=4
set foldcolumn=0
set foldnestmax=7
set foldenable

" Status line
"keep status line even when single window is open
set laststatus=2
" colors for custom status line
hi User1 guifg=yellow guibg=red
hi User2 guifg=white guibg=#5C5C5C gui=italic
hi User3 gui=bold guibg=#009904 guifg=white
hi User4 guibg=#25365a guifg=white gui=underline
set statusline=%3*%{fugitive#statusline()}%*\ %4*%f%*%1*%M%*%R%H%W\ %{&ff}\ %Y\ %2*%04l:%04v%*\ %p%%\ TL%L

set incsearch

let mapleader = "č"

" For autocompletition
set wildmode=list:longest
" Complete options (disable preview scratch window)
set completeopt=menu,menuone,longest,preview

" My functions and mappings for functions
" Close preview window from insert mode
function SpoyggClosePreview()
  if pumvisible() == 0
    pclose
  endif
  return
endfunction
inoremap <Leader>s <Esc>:call SpoyggClosePreview()<CR>a

" Search for content of system clipboard in cwd
function SpoyggSearchSystemClipboadInCwd()
  let s:systemclipboard = @*

  if s:systemclipboard =~ '^\s*$'
    let s:systemclipboard = @+
  endif

  echo "Searching for: " . s:systemclipboard
  execute 'vim /' . s:systemclipboard . '/ **/*'
endfunction
nnoremap   <Leader>ssc        :call SpoyggSearchSystemClipboadInCwd()<CR>

""" My maps
set timeoutlen=300
nnoremap K :Ag <C-R><C-W><CR>
nmap <silent> <Leader>5 :CommandTFlush<CR>
nnoremap <Leader>hl :set hlsearch!<CR>
" Writing file
nmap       <Leader>w          :w<CR>
inoremap    <Leader><Leader>   <ESC>
inoremap   <Leader>w          <ESC>:w<CR>
"" Tabs
" Previous tab
nnoremap    <Leader>h          <ESC>:tabp<CR>
" Next tab
nnoremap    <Leader>l          <ESC>:tabn<CR>
" First tab
nnoremap    <Leader>H          <ESC>:tabr<CR>
" Last tab
nnoremap    <Leader>L          <ESC>:tabl<CR>
"" Windows
imap       <Leader>ww         <ESC><C-W><C-W>a
nmap       <Leader>ww         <C-W><C-W>
nnoremap   <Leader>wj         <C-W><C-J>
nnoremap   <Leader>wk         <C-W><C-K>
nnoremap   <Leader>wh         <C-W><C-H>
nnoremap   <Leader>wl         <C-W><C-L>
nnoremap   <Leader>wq         <C-W><C-Q>
nnoremap   <Leader>wo         <C-W><C-O>
nnoremap   <Leader>we         :tabe %<CR>

"" Set file types, for accessing all nice features that depend on file type
" when editing js or html in Php...
nnoremap   <Leader>fj         :set filetype=javascript<CR>
nnoremap   <Leader>fh         :set filetype=html<CR>
nnoremap   <Leader>fp         :set filetype=php<CR>
nnoremap   <Leader>fc         :set filetype=css<CR>
" For quick spell check we need to remove syntax highlight by setting ft to
" text
nnoremap   <Leader>ft         :set filetype=txt<CR>

" Allow specified keys that move the cursor to move between lines
set whichwrap=b,s,h,l

" NERDTree
nnoremap <leader>g :NERDTreeToggle<CR>
nnoremap <leader>q :NERDTreeFind<CR>
let NERDChristmasTree = 1
let NERDTreeQuitOnOpen = 1

" fugitive shortcuts
nnoremap ,s :Gstatus<CR>
nnoremap ,d :Gdiff<CR>

" Toggle quickfix window
function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

nmap <silent> <leader>2 :call ToggleList("Quickfix List", 'c')<CR>

" Index functions in file
nmap <silent> <leader>3 :vimgrep /function/ %<CR> :call ToggleList("Quickfix List", 'c')<CR>

" The point of using Vim is to be gui independent, doh
set guioptions-=T
set guioptions-=t
set guioptions-=r
set guioptions-=l
set guioptions-=L
set guioptions-=R
set guioptions-=b

" Use custom characters for tabstops and EOLs
set listchars=tab:▸\ ,eol:●

"Invisible character(tabstops, EOLs) custom color
highlight NonText guifg=#124956

" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    %s:\r::e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre *.css,*.php,*.js,*.scss,*.yml,*.sql,*.html :call <SID>StripTrailingWhitespaces()

" NERDCommenter add spaces
let NERDSpaceDelims=1

" Gundo command map
cnorea GG :GundoToggle <CR>
" Gundo customization
let g:gundo_width = 30
let g:gundo_preview_height = 40
let g:gundo_right = 1
let g:gundo_preview_bottom = 1

" Persist undo history beyond closing file
set undofile
" But do not swamp working dirs
" Store swap & undo files in fixed location, not current directory.
set undodir=~/.vim-meta-files//,/tmp//,.
set dir=~/.vim-meta-files//,/tmp//,.

" Ignore case while searching with lowercase letters
set ignorecase
set smartcase

" Syntastic
let g:syntastic_check_on_open=1

set cursorline

" Ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"
