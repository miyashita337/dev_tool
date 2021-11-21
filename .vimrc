" 1. curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh && mkdir -p ~/.vim/backup
" 2. cp このファイル ~/.vimrc
" 3. 一旦vim起動してBundleInstallする
" 4. cd ~/.vim/bundle/jedi-vim/ && git submodule update --init
" 5. pip install pep8 pyflakes


scriptencoding utf-8

set nocompatible
set antialias
set autoindent
set ambiwidth=double
"set backupcopy=auto
"set backupdir=~/.vim/backup
set backspace=indent,eol,start
set backupext=.vimbak


set cmdheight=2
set confirm
set cursorcolumn
set cursorline
set encoding=utf-8
set noerrorbells
set expandtab
set fileencoding=utf-8
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
set guioptions-=b
set ignorecase
set imdisable
set incsearch

set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:%,eol:↲
set matchpairs+=<:>,":",':'

" これを入れるとクリップボードができないのでOFF
"set mouse=a
"set mousemodel=extend
set number
set numberwidth=5
set shell=zsh

set shiftround
set shiftwidth=4
set showcmd
set showmatch
set noshowmode
set smartcase
set smartindent
set softtabstop=4
set statusline=%(%r%t%m%)%<%=%h%w[ch=%B][%l:%c%V][%p%%]
set tabstop=4
set textwidth=0
set title

set ttymouse=xterm2
set visualbell t_vb=
set wildmenu wildmode=list:full
set wrap

"---------------------------
" Start Neobundle Settings.
"---------------------------
filetype off
if has('vim_starting')
    if &compatible
        set nocompatible
    endif
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))

" vimのパッケージマネージャー
NeoBundleFetch 'Shougo/neobundle.vim'

" カッコ補完(<C-H>でキーバインドされてしまうため自前リポジトリで対処)
"NeoBundle 'jiangmiao/auto-pairs'
NeoBundle 'CS-Toku/auto-pairs'

" サブモード作成用
NeoBundle 'kana/vim-submode'

" HTML補完
NeoBundle 'mattn/emmet-vim'

" プログラムを簡単に実行
NeoBundle 'thinca/vim-quickrun'

" vimで非同期実行
NeoBundle 'Shougo/vimproc.vim', {
  \ 'build' : {
  \     'windows' : 'tools\\update-dll-mingw',
  \     'cygwin' : 'make -f make_cygwin.mak',
  \     'mac' : 'make',
  \     'linux' : 'make',
  \     'unix' : 'gmake'
  \    }
  \ }

" 統合ユーザインターフェース
NeoBundle 'Shougo/unite.vim'
" Unite依存
NeoBundle 'Shougo/neomru.vim'

" ファイラー/ファイルサポート
NeoBundle 'Shougo/vimfiler'

" カラースキーム閲覧用
NeoBundle 'unite-colorscheme'

" vimのカラースキーム
NeoBundle 'flazz/vim-colorschemes'

" ディレクトリをツリー表示
NeoBundle 'scrooloose/nerdtree'

" ステータスラインを便利に
NeoBundle 'itchyny/lightline.vim'

" lightlineのカラースキーム
NeoBundle 'cocopon/lightline-hybrid.vim'

" インデントガイド
NeoBundle 'nathanaelkane/vim-indent-guides'

" コメントアウトツール
NeoBundle 'tomtom/tcomment_vim'

" sudoで編集(:e sudo:/etc/passwd)
NeoBundle 'sudo.vim'

" vim用grep
NeoBundle 'grep.vim'

" 「あの」ファイルを開く
NeoBundle 'kana/vim-altr'

" ブラウザで開く関連
NeoBundle 'tyru/open-browser.vim'

" Markdownプレビュー
NeoBundle 'kannokanno/previm'

" 補完
"NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache'

" gitのラッパー
NeoBundle 'tpope/vim-fugitive'

" vim用shell
NeoBundleLazy 'Shougo/vimshell', {
  \ 'depends' : 'Shougo/vimproc.vim',
  \ 'autoload' : {
  \   'commands' : [{ 'name' : 'VimShell', 'complete' : 'customlist,vimshell#complete'},
  \                 'VimShellExecute', 'VimShellInteractive',
  \                 'VimShellTerminal', 'VimShellPop'],
  \   'mappings' : ['<Plug>(vimshell_switch)']
  \ }
  \ }

"-------------------------
" 言語系プラグイン
"-------------------------
" 構文チェック
NeoBundle 'scrooloose/syntastic'
" Python
"" 補完
NeoBundle 'davidhalter/jedi-vim'
" Scala
"" 補完用
NeoBundle 'derekwyatt/vim-scala'
"" yaml用syntax
NeoBundle 'stephpy/vim-yaml'
"" ansible-yaml用syntax
NeoBundle 'chase/vim-ansible-yaml'
"" json用syntax
NeoBundle 'elzr/vim-json'
" C++
"" 構文チェック用
NeoBundleLazy 'vim-jp/cpp-vim', {
            \ 'autoload' : {'filetypes' : 'cpp'}
            \ }
"" pyenv対応
"NeoBundleLazy "lambdalisue/vim-pyenv", {
"      \ "depends": ['davidhalter/jedi-vim'],
"      \ "autoload": {
"      \   "filetypes": ["python", "python3"]
"      \ }}


"-------------------------
" 言語系プラグイン終わり
"-------------------------

call neobundle#end()
filetype plugin indent on
NeoBundleCheck
""-------------------------
"" End Neobundle Settings.
""-------------------------


" jjでノーマルモードに戻る
inoremap jj <Esc><Esc><Esc>

" 検索時に対象を中央に表示
nnoremap n nzz
nnoremap N Nzz

" カーソル下の単語を検索、中央に表示
nnoremap * *zz
nnoremap # #zz
" カーソル下の単語を検索、中央に表示
nnoremap g* g*zz
nnoremap g# g#zz

" 下へ移動する時に見た目の1行下に移動する
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" 対応するカッコへジャンプ
nnoremap <Tab> %
vnoremap <Tab> %

" 以下で使用するキーバインドのため解除
"iunmap <C-H>
inoremap <C-H> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

"-------------------------
" スクリーン系キーバインド
"-------------------------
" 入力時ctl押しながらhjklでカのみは無効
nnoremap s <Nop>
"  ウィンドウを横分割
nnoremap ss :<C-u>sp<CR>
"  ウィンドウを縦分割
nnoremap sv :<C-u>vs<CR>
"  カーソルを移動
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
"  カーソルを次に移動
nnoremap sw <C-w>w
"  ウィンドウを移動
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
"  ウィンドウを移動(回転？近いウィンドウと反転なきがする)
nnoremap sr <C-w>r
"  タブの作成
nnoremap st :<C-u>tabnew<CR>
"  タブの一覧表示
nnoremap sT :<C-u>Unite tab<CR>
"  タブを移動
nnoremap sn gt
nnoremap sp gT
"  ウィンドウの大きさを揃える
nnoremap s= <C-w>=
nnoremap sO <C-w>=
" 縦横最大化
nnoremap so <C-w>_<C-w>|
" 画面サイズ変更用サブモード(sの後該当ボタン長押しでサイズ変更)
call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')
"  開いてたバッファの移動
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
"  ウィンドウを閉じる
nnoremap sq :<C-u>q<CR>
"  バッファを閉じる
nnoremap sQ :<C-u>bd<CR>
"  現在のタブで開いたバッファ一覧
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
"  バッファ一覧
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>

"-------------------------
" スクリーン系キーバインド：終わり
"-------------------------

" altrプラグイン進むと戻る
nnoremap <Leader>f  <Plug>(altr-forward)
nnoremap <Leader>b  <Plug>(altr-back)

" 全角スペースを　で表示
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=darkgrey
endfunction
if has('syntax')
    augroup ZenkakuSpace
        autocmd!
            " ZenkakuSpaceをカラーファイルで設定するなら次の行は削除
        autocmd ColorScheme       * call ZenkakuSpace()
        " 全角スペースのハイライト指定
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif


" neocomplete設定
if neobundle#is_installed('neocomplete')
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
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
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
    " <BS>: close popup and delete backword char.
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

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif
    "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
elseif neobundle#is_installed('neocomplcache')
    " neocomplcache用設定
    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_enable_ignore_case = 1
    let g:neocomplcache_enable_smart_case = 1
    if !exists('g:neocomplcache_keyword_patterns')
        let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns._ = '\h\w*'
    let g:neocomplcache_enable_camel_case_completion = 1
    let g:neocomplcache_enable_underbar_completion = 1
endif
" TABで補完選択
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"


" emmetのキーバインドを変更(今はデフォ)
let g:user_emmet_leader_key='<C-y>'

" quickrun設定(bufferが空なら自動で閉じる)
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
      \ 'runner'    : 'vimproc',
      \ 'runner/vimproc/updatetime' : 60,
      \ 'outputter' : 'error',
      \ 'outputter/error/success' : 'buffer',
      \ 'outputter/error/error'   : 'quickfix',
      \ 'outputter/buffer/split'  : ':rightbelow 8sp',
      \ 'outputter/buffer/close_on_empty' : 1,
      \ }
"  qで閉じる
au FileType qf nnoremap <silent><buffer>q :quit<CR>
"  \rで保存して実行
let g:quickrun_no_default_key_mappings = 1
nnoremap \r :write<CR>:QuickRun -mode n<CR>        
xnoremap \r :<C-U>write<CR>gv:QuickRun -mode v<CR> 
"  <C-c>で停止
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"


" lightline Settings
let g:lightline = {
        \'colorscheme': 'hybrid',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename'] ],
        \   'right': [ [ 'syntastic', 'lineinfo' ],
        \              [ 'percent' ],
        \              [ 'filetype', 'fileencoding', 'pyenv' ] ]
        \ },
        \ 'component_expand':{
        \   'syntastic': 'SyntasticStatuslineFlag'
        \ },
        \ 'component_type':{
        \   'syntastic': 'error'
        \ },
        \ 'component_function': {
        \   'modified': 'MyModified',
        \   'readonly': 'MyReadonly',
        \   'fugitive': 'MyFugitive',
        \   'filename': 'MyFilename',
        \   'fileformat': 'MyFileformat',
        \   'filetype': 'MyFiletype',
        \   'fileencoding': 'MyFileencoding',
        \   'mode': 'MyMode',
        \ }
        \}

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
      if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      return "\u2b60 " . fugitive#head()
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
return  &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! MyPyenvVersion()
  return '⌘ '.pyenv#info#preset('short')[1:]
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

" OpenBrowser設定
let g:netrw_nogx = 1
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
nmap gz <Plug>(openbrowser-open)

" Previm設定
augroup PrevimSettings
    autocmd!
    autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END
nnoremap <C-p> :PrevimOpen<CR>


" <Space>キーでプラグイン起動系統のキーバインド
nnoremap <Space> <Nop>
nnoremap <silent> <Space>f :VimFiler<CR>
nnoremap <silent> <Space>t :NERDTreeToggle<CR>
nnoremap <silent> <Space>u :Unite<CR>
"" VimShell系統キーバインド
nnoremap <silent> <Space>v :VimShellCreate<CR>
""" gvimでpython実行するととても重いのでzsh経由。コレだとまだ軽い。
""" 以下5つの設定はどうにかしたい・・・
nnoremap <silent> <Space>s <Nop>
nnoremap <silent> <Space>s<CR> :VimShellInteractive zsh<CR>
nnoremap <silent> <Space>s<Space> :VimShellInteractive<Space>
nnoremap <silent> <Space><Space> :VimShellSendString<CR>
vnoremap <silent> <Space><Space> :VimShellSendString<CR>
nnoremap <silent> <Space>sb :VimShellSendBuffer<Space>


"-------------------------
" 言語系設定
"-------------------------
" C,C++,PythonでのみSyntasticを稼働
let g:syntastic_mode_map = {'mode': 'passive'}
augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp,*.py call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction
" Python
"" jediでdocstringは表示しない
autocmd FileType python setlocal completeopt-=preview
"" quickrunのマップと衝突するためコマンド作成
command! -nargs=0 JediRename :call jedi#rename()
let g:jedi#rename_command = ""
"" neocomplete共存設定
autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '\h\w*\|[^. \t]\.\w*'
"" syntasticでのチェッカーの指定
let g:syntastic_python_checkers=['pyflakes', 'pep8']
"if jedi#init_python()
"    function! s:jedi_auto_force_py_version() abort
"        let major_version = pyenv#python#get_internal_major_version()
"        call jedi#force_py_version(major_version)
"    endfunction
"    augroup vim-pyenv-custom-augroup
"        autocmd! *
"        autocmd User vim-pyenv-activate-post call s:jedi_auto_force_py_version()
"        autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
"    augroup END
"endif

" Scala
au BufNewFile,BufRead *.scala setf scala
au BufNewFile,BufRead *.sbt setf scala


" Highlight Settings
syntax enable
colorscheme hybrid
set t_Co=256

hi Normal ctermbg=236 guibg=Gray25
hi LineNr term=reverse ctermfg=10 ctermbg=0 guifg=Green guibg=Gray20
hi CursorLineNr term=reverse ctermbg=240 guibg=Gray25 guifg=Yellow
hi CursorLine term=reverse ctermbg=240 guibg=Gray30
hi CursorColumn term=reverse ctermbg=240 guibg=Gray30
hi Visual term=reverse ctermbg=250 guibg=Gray50

" インデントガイドをオン
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors=0
let g:indent_guides_start_level=2
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=239 guibg=Gray28
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=241 guibg=Gray32
let g:indent_guides_color_change_percent = 30
let g:indent_guides_guide_size = 1

