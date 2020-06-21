" if executable()
if has(&compatible) | set nocompatible | endif
if has('python3')   | set pyxversion=3 | endif

" COLOR:
filetype plugin indent on
syntax on
set t_Co=256
colorscheme desert

" OPTION: danger!!! hidden gdefault
set hidden nu rnu laststatus=2 wrap linebreak breakindent termencoding=utf-8 encoding=utf-8 fileencodings=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936 background=dark foldmethod=marker nofoldenable browsedir=buffer autochdir smartindent tabstop=4 shiftwidth=4 expandtab cmdheight=1 laststatus=2 textwidth=0 showcmd showmatch matchtime=1 showmode hlsearch incsearch ignorecase smartcase gdefault mousehide mouse=a backspace=2 scrolloff=99 display=lastline history=9999 noswapfile autoread exrc secure nostartofline title shortmess=flnxtToOcF updatetime=400 ttyfast ttyscroll=3 timeout timeoutlen=500 ttimeoutlen=50 modeline modelines=4
set wildmenu wildmode=full wildignore+=**/.git/**,**/__pycache__/**,**/venv/**,**/node_modules/**,**/dist/**,**/build/**,*.o,*.pyc,*.swp
set define="^\(#\s*define\|[a-z]*\s*const\s*[a-z]*\)"
set complete=.,w,b,u,t,i
set completeopt=menuone,noselect pumheight=0 pumwidth=0
" set completepopup=height:10,width:10,align:menu,border:on,highlight:IncSearch
hi! Pmenu    ctermfg=Black ctermbg=DarkGrey
hi! PmenuSel ctermfg=Black ctermbg=White
set list listchars=tab:»\ ,trail:·,nbsp:_,precedes:<,extends:>
hi! User1 cterm=inverse,bold ctermfg=Red    ctermbg=Black guifg=Black guibg=Red
hi! User2 cterm=inverse,bold ctermfg=Green  ctermbg=Black guifg=Black guibg=Green
hi! User3 cterm=inverse,bold ctermfg=Blue   ctermbg=Black guifg=Black guibg=Blue
hi! User4 cterm=inverse,bold ctermfg=Yellow ctermbg=Black guifg=Black guibg=Yellow
set statusline=%q(%n)%<%f%1*%m%*%4*%r%*%w
            \%=%{&ff}.%\{&fenc==\"utf-8\"?\"\":toupper(&fenc)\}%Y%5l\ Ξ\ %2c
" autocmd FileType * setlocal formatoptions-=cro "

" FUNC:
function! CleverTab()
    if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
        return "\<Tab>"
    else
        return "\<C-N>"
    endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>
inoremap<expr> <Cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<Cr>"


function! InsAutoPmenu()
  let l:charList = [
        \ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
        \ 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
        \ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
        \ 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
        \ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ]
  if mapcheck("a","i") == ""
      for key in l:charList
          execute printf("inoremap<expr><silent> %s pumvisible() ? \'%s\' : \'%s<C-n>\'"
                    \ ,key,key,key)
      endfor
  else
      for key in l:charList
          execute "iunmap " . key
      endfor
  endif
endfunction
call InsAutoPmenu()

function! QuickComment()
    let l:commentSymbol = {'vim':'" ', 'c':'\/\/','cpp':'\/\/'}
    let cSyml = has_key(l:commentSymbol, &filetype) ?
                  \ get(l:commentSymbol, &filetype) : ''
    if cSyml == ''
        echo "commentSymbol not set for *." . &filetype
    else
        let line = getline(".")
        call setline(".", (line =~ '^'.cSyml.'.*') ?
                    \ substitute(line, '^'.cSyml , ""   ,"g") :
                    \ substitute(line, '^'       , cSyml,"g") )
    endif
endfunction
command -range QuickComment <line1>,<line2>call QuickComment()

" KEYS:
" use [number]+ctrl+/ comment or uncomment line
nnoremap <C-_> :call QuickComment()<cr>
xnoremap <C-_> :call QuickComment()<cr>
inoremap <C-_> <C-o>:call QuickComment()<cr>
" leader
nnoremap s <NOP>
let mapleader='s'
let g:netrw_banner=0
let g:netrw_liststyle = 2
let g:netrw_list_hide= '.*\.swp$'
let g:netrw_sort_by = "exten"
let g:netrw_sizestyle = "H"
let g:netrw_winsize = 2
let g:netrw_special_syntax = 1
nnoremap <F2> :Sexplore<CR>
nnoremap <leader>w :w<cr>
nnoremap \ :noh<bar>redraw!<cr>
" n-mode paste copy
nnoremap <leader>p "+p
nnoremap <leader>P "+P
nnoremap <leader>y "+y
nnoremap <leader>yy "+yy
" v-mode paste copy
xnoremap <leader>p "+p
xnoremap <leader>P "+P
xnoremap <leader>y "+y
" append to clipboard reg
xnoremap Sy y:let @+ .= @0<cr>
" always enter improved Ex-mode
nnoremap Q gQ
" always enter virtual Replace-mode
nnoremap r gr
nnoremap R gR
" inspired by vim-unimpaired
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [c :cprevious<CR>
nnoremap ]c :cnext<CR>
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
nnoremap [t :tprevious<CR>
nnoremap ]t :tnext<CR>
nnoremap [op :set nopaste<CR>
nnoremap ]op :set paste<CR>
nnoremap [ov :set virtualedit=<CR>
nnoremap ]ov :set virtualedit=all<CR>
" auto-pair
inoremap $$ $()i
inoremap `` ``i
inoremap %% %%i
inoremap '' ''i
inoremap "" ""i
inoremap () ()i
inoremap [] []i
inoremap {} {}i
inoremap <> <>i
" force save!!
cnoremap w!! w !sudo tee % >/dev/null

" add your tags files
" ctags -R --c-kinds=+lpx --c++-kinds=+lpx --fields=+KSlianmtz --extra=+fq .
set tags+=../tags;

" add your path (include files etc.)
set path+=$PWD/**
set path+=/usr/include/x86_64-linux-gnu
