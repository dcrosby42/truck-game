noremap <F5> :only<CR>:w<CR>:!spec '%' 2>&1 \| tee ~/tmp/.specrun.out<CR>:sp ~/tmp/.specrun.out<CR><CR>
noremap \o :e ~/tmp/.specrun.out<CR>
let g:ao_f5_defined = "true"
let g:fuzzy_ignore = "tmp/*,vendor/*,*.log"
let g:fuzzy_matching_limit = 20
