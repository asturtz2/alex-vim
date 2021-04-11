scriptencoding utf-8

if exists('g:loaded_ghcid_quickfix')
  finish
endif
let g:loaded_ghcid_quickfix = v:true

command! -bar -nargs=* GhcidQuickfixStart call ghcid_quickfix#start(function('s:make_new_event_hooks'), <q-args>)
command! -bar GhcidQuickfixStop call ghcid_quickfix#stop()

let s:config = get(g:, 'ghcid_quickfix', {})

function! s:make_new_event_hooks(qf_bufnr) abort
  let Showing = get(s:config, 'showing', v:null)
  return
    \ Showing is v:null
      \ ? ghcid_quickfix#event_hooks#quickfix_on_start#new(a:qf_bufnr) :
    \ Showing ==# 'quickfix_on_start'
      \ ? ghcid_quickfix#event_hooks#quickfix_on_start#new(a:qf_bufnr) :
    \ Showing ==# 'quickfix_on_error'
      \ ? ghcid_quickfix#event_hooks#quickfix_on_error#new(a:qf_bufnr) :
    \ Showing ==# 'popup_always'
      \ ? ghcid_quickfix#event_hooks#popup_always#new(a:qf_bufnr) :
    \ type(Showing) is v:t_func
      \ ? Showing(a:qf_bufnr) :
    \ execute(printf('throw "unknown value of g:ghcid_quickfix_showing: "%s"', string(Showing)))
endfunction
