" Vim indent file
" Language:    Nix
" Maintainer:  Daiderd Jordan <daiderd@gmail.com>
" URL:         https://github.com/LnL7/vim-nix

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetNixIndent()
setlocal indentkeys+=0=then,0=else,0=in

if exists("*GetNixIndent")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

let s:skip_syntax = '\%(Comment\|String\)$'
let s:block_open  = '\%({\|[\)'
let s:block_close = '\%(}\|]\)'

function! GetNixIndent()
  let lnum = prevnonblank(v:lnum - 1)
  let ind  = indent(lnum)

  " At the start of the file use zero indent.
  if lnum == 0
    return 0
  endif

  if synIDattr(synID(v:lnum, 1, 1), "name") !~ s:skip_syntax
    let current_line = getline(v:lnum)
    let last_line = getline(lnum)

    if last_line =~ s:block_open . '\s*$'
      let ind += &sw
    endif

    if current_line =~ '^\s*' . s:block_close
      let ind -= &sw
    endif

    if last_line =~ '\<let\s*$'
      let ind += &sw
    endif

    if getline(v:lnum - 1) =~ '^\<in\s*$'
      let ind += &sw
    endif

    if current_line =~ '^\s*in\>'
      let ind -= &sw
    endif
  endif

  if synIDattr(synID(v:lnum, 1, 1), "name") =~ '^nixString'
    let current_line = getline(v:lnum)

    let ind = indent(v:lnum)
    let bslnum = searchpair('''''', '', '''''', 'bnW',
          \ 'synIDattr(synID(line("."), col("."), 0), "name") =~? "InterpolationSpecial$"')

    if ind <= indent(bslnum)
      let ind = indent(bslnum) + &sw
    endif

    if current_line =~ '^\s*''''[^''\$]'
      let ind = indent(bslnum)
    endif
    if current_line =~ '^\s*''''$'
      let ind = indent(bslnum)
    endif
  endif

  return ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
