" foo
if exists("did_load_filetypes")
   " analogy with cpp define guards.
   finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile,BufEnter *.phpt setfiletype php
augroup END

