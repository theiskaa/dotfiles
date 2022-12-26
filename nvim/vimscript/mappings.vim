let mapleader = ","
command! W :w
command! Q :q
command! Wq :wq
command! WQ :wq
nnoremap <CR> :nohlsearch<CR>

" Move between buffers
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>

" Disable arrow keys on normal mode.
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Manage windows map.
nnoremap <leader>w- :5winc- <CR>
nnoremap <leader>w+ :5winc+ <CR>

" Splitting map commands. 
nnoremap fsv :vs <CR>
nnoremap fsh :split horizontal <CR>

" Nerd Tree configurations
nnoremap <leader>e :NERDTreeToggle <cr>
nnoremap <leader>ef  :NERDTreeFocus <cr>

" Telescope configurations.
nnoremap <C-f> <cmd>Telescope find_files<CR>
nnoremap <leader>f <cmd>Telescope find_files<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>

" Flutter & Dart actions.
nnoremap fd <cmd>DartFmt <CR>
nnoremap <leader>,fa :FlutterRun <CR>
nnoremap <leader>,fq :FlutterQuit <CR>
nnoremap <leader>,fr :FlutterHotReload <CR>
nnoremap <leader>,fR :FlutterHotRestart <CR>
nnoremap <leader>,fd :FlutterVisualDebug<CR>

" CoC definitions.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

