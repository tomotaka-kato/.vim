" フォントを設定
if has('win32') || has ('win64')
	set encoding=cp932 " フォント名に開業時日本語名を使うので、一時的に文字コードを変える
	set guifont=Ricty_Diminished:h10
	set guifontwide=Osaka－等幅:h10
	set ambiwidth=double " 文字コードを元に戻す
endif

" 見た目を設定
if has('win32') || has ('win64')
	autocmd guienter * set transparency=220
endif

set encoding=utf8
set visualbell t_vb=
set formatoptions-=ro " 改行時自動でにコメントアウトするのはなくす

set background=dark
colorscheme hybrid
" colorscheme molokai
" colorscheme zenburn
" colorscheme mirodark
