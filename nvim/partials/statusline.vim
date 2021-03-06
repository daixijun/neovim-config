augroup VimrcLightline
  autocmd!
  autocmd User ALEFixPre   call lightline#update()
  autocmd User ALEFixPost  call lightline#update()
  autocmd User ALELintPre  call lightline#update()
  autocmd User ALELintPost call lightline#update()
augroup end

let g:lightline = {
      \ 'colorscheme': &background ==? 'light' ? 'cosmic_latte_light' : 'nord',
      \ 'active': {
                  \ 'left': [[ 'mode', 'paste'], ['git_status'], [ 'readonly', 'relativepath', 'custom_modified' ]],
                  \ 'right': [['linter_errors', 'linter_warnings'], ['indent', 'percent', 'lineinfo'], ['anzu', 'filetype']],
                  \ },
      \ 'inactive': {
                  \ 'left': [[ 'readonly', 'relativepath', 'modified' ]],
                  \ 'right': [['lineinfo'], ['percent'], ['filetype']]
                  \ },
      \ 'component_expand': {
                  \ 'linter_warnings': 'LightlineLinterWarnings',
                  \ 'linter_errors': 'LightlineLinterErrors',
                  \ 'git_status': 'GitStatusline',
                  \ 'custom_modified': 'StatuslineModified',
                  \ 'indent': 'IndentInfo',
                  \ },
      \ 'component_function': {
                  \ 'anzu': 'anzu#search_status',
                  \ },
      \ 'component_type': {
                  \ 'linter_errors': 'error',
                  \ 'custom_modified': 'error',
                  \ 'linter_warnings': 'warning'
                  \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

function! IndentInfo() abort
  let l:indent_type = &expandtab ? 'spaces' : 'tabs'
  return l:indent_type.': '.&shiftwidth
endfunction


function! StatuslineModified() abort
  return &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineLinterWarnings() abort
  return AleStatus('warning')
endfunction

function! LightlineLinterErrors() abort
  return AleStatus('error')
endfunction

function AleStatus(type) abort
  let l:count = ale#statusline#Count(bufnr(''))
  let l:items = l:count[a:type] + l:count['style_'.a:type]

  if l:items
    return printf('%d %s', l:items, toupper(strpart(a:type, 0, 1)))
  endif
  return ''
endfunction

function! GitStatusline() abort
  let l:head = fugitive#head()
  if !exists('b:gitgutter')
    return (empty(l:head) ? '' : printf(' %s', l:head))
  endif

  let l:summary = GitGutterGetHunkSummary()
  let l:result = filter([l:head] + map(['+','~','-'], {i,v -> v.l:summary[i]}), 'v:val[-1:] !=? "0"')

  return (empty(l:result) ? '' : printf(' %s', join(l:result, ' ')))
endfunction
