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
set completeopt=menuone,noselect,preview pumheight=0 pumwidth=0 previewheight=7
" set completepopup=height:10,width:10,align:menu,border:on,highlight:IncSearch
hi! Pmenu        cterm=NONE ctermfg=Black ctermbg=DarkGrey
hi! PmenuSel     cterm=NONE ctermfg=Black ctermbg=Grey
hi! StatusLine   cterm=underline,bold ctermfg=Green ctermbg=Black
hi! StatusLineNC cterm=underline ctermfg=DarkGreen ctermbg=Black
hi! TabLineFill  cterm=underline ctermfg=DarkGrey ctermbg=Black
hi! TabLine      cterm=underline ctermfg=DarkCyan ctermbg=Black
hi! TabLineSel   cterm=NONE ctermfg=Black ctermbg=DarkGreen
hi! VertSplit    cterm=NONE ctermfg=LightGreen ctermbg=Black
hi! Search ctermbg=DarkGrey
set list listchars=tab:»\ ,trail:·,nbsp:_,precedes:<,extends:>
hi! User1 cterm=bold ctermfg=Black ctermbg=Red     guifg=Black guibg=Red
hi! User2 cterm=bold ctermfg=Black ctermbg=Green   guifg=Black guibg=Green
hi! User3 cterm=bold ctermfg=Black ctermbg=Blue    guifg=Black guibg=Blue
hi! User4 cterm=bold ctermfg=Black ctermbg=Yellow  guifg=Black guibg=Yellow
hi! User5 cterm=bold ctermfg=Blue ctermbg=Black  guifg=Black guibg=Yellow
fu! ExtraStatus()
    let exstate = []
    if &paste            |let exstate += ['paste']|endif
    if &virtualedit != ''|let exstate += ['vedit']|endif
    return exstate != [] ? ' {'.join(exstate,',').'} ' : ''
endfunction

function! GitBranchName()
    let gitroot = ".git"
    if isdirectory(gitroot)
        return split(readfile(gitroot."/HEAD")[0],"/")[2]
    else
        let pt = "/"
        let dirn=split(expand("%:p"),pt)[:-3]
        let dirl=[]
        let path=''
        for i in dirn|let path=path.pt.i|call insert(dirl,path)|endfor
        for i in dirl
            let gitpath = i.pt.gitroot
            if isdirectory(gitpath)
                return split(readfile(gitpath."/HEAD")[0],"/")[2]
            endif
        endfor
    endif
    return ''
endfunction
set statusline=%q(%n)%<%f%1*%m%*%4*%r%*%w
            \%=%5*%{ExtraStatus()}%*%{&ff}.%\{&fenc==\"utf-8\"?\"\":toupper(&fenc)\}%Y%5l\ Ξ\ %2v
set statusline^=%3*%{GitBranchName()}%*
" autocmd FileType * setlocal formatoptions-=cro "

" FUNC:
function! CleverTab()
    if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
        return "\<Tab>"
    else
        return "\<C-N>"
    endif
endfunction
inoremap       <Tab>   <C-R>=CleverTab()<CR>
inoremap<expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-g>u\<S-Tab>"
inoremap<expr> <CR>    pumvisible() ? "\<C-y>" : "\<C-g>u\<Cr>"

function! InsAutoPmenu(complm)
  let l:charList = [
        \ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
        \ 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
        \ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
        \ 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
        \ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ]
  if mapcheck("a","i") == ""
      for key in l:charList
          execute printf("inoremap<expr><silent> %s pumvisible() ? \'%s\' : \'%s%s\'"
                    \ ,key,key,key,a:complm)
      endfor
  endif
endfunction
autocmd! BufEnter * call InsAutoPmenu( &omnifunc?'<C-X><C-O>':'<C-N>' )

function! QuickComment()
    let l:commentSymbol = { 'vim':'" ', 'c':'\/\/','cpp':'\/\/','sh':'# ','ruby':'# ', 'python':'# '  }
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
command! -range QuickComment <line1>,<line2>call QuickComment()

function! SwitchSrcHeadFile()
    if expand("%:e") =~ '\(c\|cpp\|cxx\)'
        execute "e ".expand("%:r").".h"
    elseif expand("%:e") == 'h'
        execute "e ".expand("%:r").".c*" 
    endif
endfunction
command! A call SwitchSrcHeadFile()<CR>
command! P e #

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
let g:netrw_list_hide='.*\.swp$'
let g:netrw_sort_by="exten"
let g:netrw_sizestyle="H"
let g:netrw_winsize=2
let g:netrw_special_syntax=1
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
inoremap ## #{}i
inoremap $$ ${}i
inoremap `` ``i
inoremap %% %%i
inoremap '' ''i
inoremap "" ""i
inoremap () ()i
inoremap [] []i
inoremap {} {}i
inoremap <> <>i
inoremap {<CR> {}i<CR>O
" force save!!
cnoremap w!! w !sudo tee % >/dev/null

" add your tags files
set tags+=../tags;
let g:ctags_bin="ctags-universal"
let g:ctags_param=" --c-kinds=+pxz --c++-kinds=+ALNUp --fields=NPKSaistz --extras=+fgqr "
function! GenerateTagfiles()
    if exists("*mkdir") | call mkdir("~/tagfiles","p") | endif
    cd ~/tagfiles
    let l:incdir = {
                \ "cc":"/usr/include",
                \ "py":"/usr/lib/python3.7",
                \ "rb":"/usr/lib/ruby/2.5.0"
                \}
    for [key, value] in items(l:incdir)
        echo key " " value
        call system(g:ctags_bin.g:ctags_param." -f ".key." -R ".value)
    endfor
    echo "all work done!"
endfunction

augroup TAGFILES
    autocmd!
    autocmd FileType c,cpp  setlocal tags+=~/tagfiles/cc
    autocmd FileType python setlocal tags+=~/tagfiles/py
    autocmd FileType ruby   setlocal tags+=~/tagfiles/rb
augroup END
command! TagGenerate call system(g:ctags_bin . g:ctags_param . " -f - > ~/tagfiles/_ -R ." )
" autocmd BufWritePost * call system(g:ctags_bin.g:ctags_param." -f - > ~/tagfiles/_ -R .")
set tags+=~/tagfiles/_

" add your path (include files etc.)
set path+=$PWD/**
augroup ADDPATHS
    autocmd!
    autocmd FileType c,cpp  setlocal path+=/usr/include/x86_64-linux-gun
    autocmd FileType python setlocal path+=/usr/lib/python3.7
    autocmd FileType ruby   setlocal path+=/usr/lib/ruby/2.5.0
augroup END

" head line
augroup HEADLINE
    autocmd BufNewFile *.rb call setline(1,"\#!/usr/bin/ruby -w")
    autocmd BufNewFile *.py call setline(1,"\#!/usr/bin/python3.7")
augroup END

