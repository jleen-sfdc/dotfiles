" Only load this indent file when no other was loaded.
if exists("b:did_indent")
   finish
endif
let b:did_indent = 1

setlocal indentkeys-=0#
setlocal indentexpr=GetEmacsCIndent()

