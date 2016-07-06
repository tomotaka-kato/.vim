"""""""""""""""""""""""""""""
"				dein setting				"
"""""""""""""""""""""""""""""
let s:use_dein = 1

" vi compatibility
if !&compatible
	set nocompatible
endif

" Prepare .vim dir
if has('win32') || has ('win64')
	let s:vimdir = $HOME . "/vimfiles"
else
	let s:vimdir = $HOME . "/.vim"
endif
if has("vim_starting")
	if ! isdirectory(s:vimdir)
		call system("mkdir " . s:vimdir)
	endif
endif

" dein setting
let s:dein_enabled = 0
if s:use_dein && v:version >= 704
	let s:dein_enabled = 1

	" Set dein paths
	let s:dein_dir = s:vimdir . '/dein'
	let s:dein_github = s:dein_dir . '/repos/github.com'
	let s:dein_repo_name = "Shougo/dein.vim"
	let s:dein_repo_dir = s:dein_github . '/' . s:dein_repo_name

	" Check dein has been installed or not.
	if !isdirectory(s:dein_repo_dir)
		echo "dein is not installed, install now"
		let s:dein_repo = "https://github.com/" . s:dein_repo_name
		echo "git clone " . s:dein_repo . " " . s:dein_repo_dir
		call system("git clone " . s:dein_repo . " " . s:dein_repo_dir)
	endif
	let &runtimepath = &runtimepath . "," . s:dein_repo_dir

	" Begin plugin part
	call dein#begin(s:dein_dir)
	
	" TOML files
	let g:rc_dir = s:vimdir . "/rc"
	let s:toml = g:rc_dir . '/dein.toml'
	let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

	" Read TOML and cash
	call dein#load_toml(s:toml, {'lazy': 0})
	call dein#load_toml(s:lazy_toml, {'lazy': 1})

	" End setting
	call dein#end()
	call dein#save_state()
endif

" Install plugins if there are not installed plugins
if dein#check_install()
	call dein#install()
endif

"""""""""""""""""""""""""""
"				vim setting				"
"""""""""""""""""""""""""""

"バックアップ
set backup
if has ('win64')
	set backupdir=$HOME\vimfiles\tmp\backup
else
	set backupdir=$HOME/.vim/tmp/backup
endif

"アンドゥファイル
set undofile
if has('win32') || has ('win64')
	set undodir=$HOME\vimfiles\tmp\undo
else
	set undodir=$HOME/.vim/tmp/undo
endif

"スワップファイル
set swapfile
if has('win32') || has ('win64')
	set directory=$HOME\vimfiles\tmp\swap
else
	set directory=$HOME/.vim/tmp/swap
endif

"エンコード
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp932,default,latin1

"表示
syntax on
set cursorline
set incsearch
set hlsearch
set laststatus=2
if !has("gui_running") && !has('win64')
	set background=dark
	colorscheme hybrid
endif

" フォーマット
set formatoptions=q
set number
set smarttab
set nowrap
set nrformats=
set noexpandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
filetype plugin indent on " filetype プラグインによる indent を on にする
set formatoptions-=ro " 開業時にコメントアウトするのはなくす

" マウス
set mouse=a
set ttymouse=xterm2

"その他
set backspace=indent,eol,start " インサートモード時にバックスペースを使う
set clipboard=unnamed,autoselect
set nrformats= "C-X,C-Aを強制的に10進数認識させる
set ruler
set confirm " 終了前に保存確認
set hidden " 保存前でも別ファイルを開ける
set autoread " 外部でファイルに変更がされた場合に読みなおす
set visualbell t_vb=
:set helplang=en,ja " ヘルプを英語優先で開く
let loaded_matchparen = 1 " 括弧のハイライトをなくす


"""""""""""""""""""""""""""""""
"				plugin setting				"
"""""""""""""""""""""""""""""""

:source $VIMRUNTIME/macros/matchit.vim

"""""""""neo complete""""""""""

if has ('lua')
	" Disable AutoComplPop.
	let g:acp_enableAtStartup = 0
	" Use neocomplete.
	let g:neocomplete#enable_at_startup = 1
	" Use smartcase.
	let g:neocomplete#enable_smart_case = 1
	" Set minimum syntax keyword length.
	let g:neocomplete#sources#syntax#min_keyword_length = 3
	let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

	" Define dictionary.
	let g:neocomplete#sources#dictionary#dictionaries = {
							\ 'default'  : '',
							\ 'scala'    : s:vimdir. '/dict/scala.dict'
							\ }

	" Define keyword.
	if !exists('g:neocomplete#keyword_patterns')
			let g:neocomplete#keyword_patterns = {}
	endif
	let g:neocomplete#keyword_patterns['default'] = '\h\w*'

	" Plugin key-mappings.
	inoremap <expr><C-g>     neocomplete#undo_completion()
	inoremap <expr><C-l>     neocomplete#complete_common_string()

	" Recommended key-mappings.
	" <CR>: close popup and save indent.
	inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
	function! s:my_cr_function()
			return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
			" For no inserting <CR> key.
			"return pumvisible() ? "\<C-y>" : "\<CR>"
	endfunction
	" <TAB>: completion.
	inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
	" <C-h>, <BS>: close popup and delete backword char.
	inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
	inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
	" Close popup by <Space>.
	"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

	" AutoComplPop like behavior.
	"let g:neocomplete#enable_auto_select = 1

	" Shell like behavior(not recommended).
	"set completeopt+=longest
	"let g:neocomplete#enable_auto_select = 1
	"let g:neocomplete#disable_auto_complete = 1
	"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

	" Enable omni completion.
	autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
	autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
	autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
	autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
	autocmd FileType scala setlocal omnifunc=scalacomplete#CompleteTags

	" Enable heavy omni completion.
	if !exists('g:neocomplete#sources#omni#input_patterns')
			let g:neocomplete#sources#omni#input_patterns = {}
	endif
	let g:neocomplete#sources#omni#input_patterns.go = '\h\w*\.\?'
	"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
	"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
	"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
	"let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

endif

	
"""""""""""""""""""""""""""""""


""""""""" vim-easy-align """"""
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"""""""""""""""""""""""""""""""


""""""""" VimFiler """"""

let g:vimfiler_as_default_explorer=1 " open VimFiler by :e . comand
nnoremap <leader>e :VimFilerExplore -split -winwidth=30 -find -no-quit<Cr>
"
"""""""""""""""""""""""""""""""



""""""""" neosnippet """"""
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
"
" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
"let g:neosnippet#snippets_directory= s:vimdir . '/dein/repos/github.com/Shougo/neosnippet-snippets/neosnippets'
let g:neosnippet#snippets_directory= s:vimdir . '/dein/snippets'
"
"""""""""""""""""""""""""""""""


""""""""" ctrlp.vim """"""
let g:ctrlp_user_command = 'ag -l --nocolor -g "" %s'

"""""""""""""""""""""""""""""""

""""""""" vim-lesscss """"""
let g:lesscss_cmd = 'lessc'
let g:lesscss_on = 1
"""""""""""""""""""""""""""""""


""""""""" unite-outline """"""
let g:unite_split_rule = 'botright'
noremap <SPACE>uo :Unite -vertical -winwidth=40 outline<Return>
"""""""""""""""""""""""""""""""
