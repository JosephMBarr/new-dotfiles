set title 
set expandtab
set tabstop=2
set shiftwidth=2
set noshowmode
set clipboard=unnamedplus
set ignorecase
set smartcase
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
set t_u7=
highlight Comment cterm=italic


" vim-markdown settings
set conceallevel=3
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_math = 1

" vimwiki settings
let g:vimwiki_list = [{'path': '~/notebook/',
                      \ 'syntax': 'markdown', 'ext': '.md', 'auto_tags':1}]

nnoremap <C-x> :VimwikiToggleListItem<CR>
let g:vimwiki_folding='expr'
autocmd FileType vimwiki setlocal syntax=markdown

autocmd FileType vimwiki setlocal foldenable

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#close_symbol = '×'
let g:airline#extensions#tabline#show_close_button = 0


" rooter
let g:rooter_patterns = ['=notebook']

" easymotion


set nocompatible
filetype plugin on
syntax enable
syntax on
let mapleader = "\<space>"
call plug#begin()
" The default plugin directory will be as follows:
" "   - Vim (Linux/macOS): '~/.vim/plugged'
" "   - Vim (Windows): '~/vimfiles/plugged'
" "   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" " You can specify a custom plugin directory by passing it as the argument
" "   - e.g. `call plug#begin('~/.vim/plugged')`
" "   - Avoid using standard Vim directory names like 'plugin'
"
" " Make sure you use single quotes
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'masukomi/vim-markdown-folding'
Plug 'reedes/vim-pencil'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vimwiki/vimwiki'
Plug 'airblade/vim-rooter'
Plug 'easymotion/vim-easymotion'
Plug 'ellisonleao/gruvbox.nvim'

call plug#end()

nnoremap <leader><space> :Files<CR>
nnoremap <leader>p :Rg<CR>
nnoremap <leader>b :Buffers<CR>
nmap em <Plug>(easymotion-prefix)
nmap f <Plug>(easymotion-overwin-f)
nnoremap <leader>gtd :put =strftime('# %Y-%m-%d')<CR>
nnoremap <leader>tn :VimwikiMakeTomorrowDiaryNote<CR>
nnoremap <leader>yn :VimwikiMakeYesterdayDiaryNote<CR>
nnoremap <leader>dn :VimwikiMakeTodayDiaryNote<CR>
nnoremap <leader>ts :VimwikiSearchTags<CR>
nnoremap <leader>yc "+yi`

function! s:ZoweWrite()
  let path = split(expand('%:f'), 'zowe/')[1]
  let file_name = split(path,'/')[-1]
  let pds = join(split(path, '/')[:-2],'.')

  :call system("zowe zos-files upload file-to-data-set " . file_name . " \"" . pds . "\"")
  return 1
endfunction

command! Wds call <SID>ZoweWrite()
if has("autocmd")
  filetype plugin indent on
endif
 

let g:pencil#wrapModeDefault = 'soft' 
augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init()
  autocmd FileType text         call pencil#init()
augroup END
func! s:insert_file_name(lines)
				let @@ = fnamemodify(a:lines[0], ":f")
				normal! p
endfunc
let g:fzf_buffers_jump = 1
let g:fzf_action = {
\ 'enter': 'tab drop',
\ 'ctrl-t': 'tab split',
\ 'ctrl-r': function('s:insert_file_name'),
\ 'ctrl-x': 'split',
\ 'ctrl-v': 'vsplit' }

function! VimwikiFindIncompleteTasks()
  lvimgrep /- \[ \]/ %:p
  lopen
endfunction

function! VimwikiFindAllIncompleteTasks()
  VimwikiSearch /- \[ \]/
  lopen
endfunction

nmap <Leader>wa :call VimwikiFindAllIncompleteTasks()<CR>
nmap <Leader>wx :call VimwikiFindIncompleteTasks()<CR>

set termguicolors
set background=dark
colorscheme gruvbox
autocmd vimenter * AirlineTheme base16_gruvbox_dark_medium
