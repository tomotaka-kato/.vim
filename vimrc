"
" Vim8用サンプル vimrc
"
set encoding=utf-8
scriptencoding utf-8              " This file's encoding

" 推奨設定の読み込み (:h defaults.vim)
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

set pythonthreedll=/usr/local/Cellar/python/3.6.5_1/Frameworks/Python.framework/Versions/3.6/Python

"===============================================================================
" 設定の追加はこの行以降でおこなうこと！
" 分からないオプション名は先頭に ' を付けてhelpしましょう。例:
" :h 'helplang

packadd! vimdoc-ja                " 日本語help の読み込み
set helplang=ja,en                " help言語の設定

set scrolloff=0
set laststatus=2                  " 常にステータス行を表示する
set cmdheight=2                   " hit-enter回数を減らすのが目的
if !has('gui_running')            " (== 端末)
  set mouse=a                     " マウス有効
  set ttymouse=xterm2             
  set term=xterm-256color         " iterm2用の設定
  set ttimeoutlen=0               " モード変更時の表示更新を最速化
  if $COLORTERM == "truecolor"    " True Color対応端末？
    set termguicolors
  endif
endif
set clipboard+=unnamed            " クリップボードをOSと共有
set nofixendofline                " Windowsのエディタの人達に嫌われない設定
set ambiwidth=double              " ○, △, □等の文字幅をASCII文字の倍にする
set formatoptions+=mM             " 日本語の途中でも折り返す
let &grepprg="grep -rnIH --exclude=.git --exclude-dir=.hg --exclude-dir=.svn --exclude=tags"
set showmatch                     " 括弧ペアをハイライト
set matchpairs& matchpairs+=<:>   " HTMLなどの<>をハイライトに追加
" set cursorline                    " 現在の行を強調表示
set tabstop=2                     " タブの幅をスペース2つ分にする
set shiftwidth=2
source $VIMRUNTIME/macros/matchit.vim "対応するtagにも%で飛べるようにする

" 折り返した時に表示行単位で移動できるようにする
nnoremap j gj
nnoremap k gk

" 閉じタグの補完
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

" :grep 等でquickfixウィンドウを開く (:lgrep 等でlocationlistウィンドウを開く)
"augroup qf_win
"  autocmd!
"  autocmd QuickfixCmdPost [^l]* copen
"  autocmd QuickfixCmdPost l* lopen
"augroup END


"-------------------------------------------------------------------------------
" バックアップ、アンドゥ、スワップ

"バックアップ
set backup
set backupdir=$HOME/.vim/tmp/backup

"アンドゥファイル
set undofile
set undodir=$HOME/.vim/tmp/undo

"スワップファイル
set swapfile
set directory=$HOME/.vim/tmp/swap

"-------------------------------------------------------------------------------
" ステータスライン設定
let &statusline = "%<%f %m%r%h%w[%{&ff}][%{(&fenc!=''?&fenc:&enc).(&bomb?':bom':'')}] "
if has('iconv')
  let &statusline .= "0x%{FencB()}"

  function! FencB()
    let c = matchstr(getline('.'), '.', col('.') - 1)
    if c != ''
      let c = iconv(c, &enc, &fenc)
      return s:Byte2hex(s:Str2byte(c))
    else
      return '0'
    endif
  endfunction
  function! s:Str2byte(str)
    return map(range(len(a:str)), 'char2nr(a:str[v:val])')
  endfunction
  function! s:Byte2hex(bytes)
    return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
  endfunction
else
  let &statusline .= "0x%B"
endif
let &statusline .= "%=%l,%c%V %P"

"-------------------------------------------------------------------------------
" ファイルエンコーディング検出設定
let &fileencoding = &encoding
if has('iconv')
  if &encoding ==# 'utf-8'
    let &fileencodings = 'iso-2022-jp,euc-jp,cp932,' . &fileencodings
  else
    let &fileencodings .= ',iso-2022-jp,utf-8,ucs-2le,ucs-2,euc-jp'
  endif
endif
" 日本語を含まないファイルのエンコーディングは encoding と同じにする
if has('autocmd')
  function! AU_ReSetting_Fenc()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding = &encoding
    endif
  endfunction
  augroup resetting_fenc
    autocmd!
    autocmd BufReadPost * call AU_ReSetting_Fenc()
  augroup END
endif

"-------------------------------------------------------------------------------
" カラースキームの設定
set background=dark
colorscheme solarized

try
  silent hi CursorIM
catch /E411/
  " CursorIM (IME ON中のカーソル色)が定義されていなければ、紫に設定
  hi CursorIM ctermfg=16 ctermbg=127 guifg=#000000 guibg=#af00af
endtry

" vim:set et ts=2 sw=0:

