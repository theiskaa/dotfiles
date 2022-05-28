set background=dark
colorscheme onedark

" set transparency=10
highlight ColorColumn ctermbg=0 guibg=lightgrey

" Enable opacity.
hi! link Conceal Normal
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE

if !has('gui_running')
    hi! Normal ctermbg=NONE guibg=NONE
    hi! NonText ctermbg=NONE guibg=NONE
endif
