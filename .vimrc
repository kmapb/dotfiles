"
"   FILE: ~/.vimrc
" AUTHOR: kma
"  DESCR: VIM configuration file
"

" The latest and greatest
version 6.1

execute pathogen#infect()

syntax enable
set notitle
set noicon
set number

" Lotsa colorz
set t_Co=256
"colorscheme grb4

" Bread and butter
set nomodeline          " ignore modeline directives (more secure)
set textwidth=75        " wrap at 75 cols
set expandtab           " tabs are spaces
set shiftwidth=4        " saner defaults
set smartindent         " nice, but makes pasting hard; see <C-I>, <C-N>
set ai                  " see smartindent
set ic                  " case-insensitive ...
set smartcase           " ... unless I MachoCaps it up...
set magic               " use cool-kid regexes
set showmatch           " show matching (), {}, [] pairs
set diffopt=filler,iwhite
set history=1000        " memory is cheap
set laststatus=2 ruler showmode
set autoread            " don't bug me when a file changes

set wildmode=full       " set up tab completion for vim commands
set wildmenu

" C formatting stuff. I like a pretty generous set of formatting
" possibilities
set cinkeys=o,O,{,},:,;,0#,!<Tab>,!^F

" Avoid selecting line numbers when copy/pasting
" set mouse=a

" Keep return types <t> and parameters <p> in K&R-style C at the left edge <0>
" When line breaks with unclosed parens, line up with the unclosed paren <(0>
" Indent the "case foo:" lines flush with the switch <:>
" Indent the braces in "case foo: {\n}" correctly <l>
" Use lots of compute time looking for unclosed parens <)> and comments <*>
set cinoptions=p0,t0,(0,:0,l1,)2000,*2000,+s

"""""""""""""""""""""""""""""
" Clever junk
"   abbreviation for read/write to/from cut-buffers; cut/paste between vi
"   sessions, basically. Give ourselves 10 of them.
ab _w0 w! $HOME/tmp/vim-cutbuff0
ab _r0 r $HOME/tmp/vim-cutbuff0

"""""""""""""""""""""""""""""
" C stuff
" Activate C indenting and comment formatting when editing C or C++
autocmd BufEnter *.java,*.C,*.cc,*.c,*.H,*.h set fo=croq cindent comments=sr:/*,mb:*,el:*/
autocmd BufLeave *.java,*.C,*.cc,*.c,*.H,*.h set nocindent
" Relic from my crazy folding-editor phase.
"autocmd BufLeave *.java,*.C,*.cc,*.c,*.H,*.h foldmethod=manual

map <C-I> :set nosmartindent noexpandtab noai fo= textwidth=0<CR>
map <C-N> :set smartindent ai fo=croq textwidth=75<CR>

" I don't write enough assembly these days.
"autocmd BufEnter *.s,*.S,*.asm,*.ASM source /usr/share/vim/syntax/masm.vim
"autocmd BufEnter *.s,*.S,*.asm,*.ASM set nocst
"autocmd BufLeave *.s,*.S,*.asm,*.ASM set cst

" Shiftwidth of 2 for the 'web productivity' languages; 4 for
" C-derivatives.
au BufEnter *.php,*.phpt,*.js set shiftwidth=2
au BufLeave *.php,*.phpt,*.js set shiftwidth=4
au BufEnter *.java,*.c,*.cpp,*.C,*.h,*.H set shiftwidth=2
au BufLeave *.java,*.c,*.cpp,*.C,*.h,*.H set shiftwidth=4

au BufRead,BufNewFile *.cpp,*.h,*.C,*.cc,*.hpp,$.cuh set syntax=cpp11

set cst

" highlight vmware types
au FileType c syn keyword cType Bool int8 int16 int32 int64 uint8 uint16
au FileType c syn keyword cType uint32 uint64
au FileType c syn keyword cType VA VPN LA LPN PA PPN BA BPN
au FileType c syn keyword cType VCPU Selector Descriptor ExcFrame
au FileType c syn keyword cConstant TRUE FALSE
au FileType c syn keyword cTodo XXXnested XXX64 XXXkma XXXvt XXXsvm XXXhv XXXvprobe
" use more memory to get syntax right
:let c_minlines = 400

" De-activate tabs-to-spaces and line wrapping when editing Makefiles
autocmd BufEnter Makefile,makefile,*.make,*.mk set textwidth=0 noexpandtab
autocmd BufLeave Makefile,makefile,*.make,*.mk set textwidth=75 expandtab

" Activate our skeleton generator whenever we open a new source file
" autocmd BufNewFile *.C,*.H,*.cc,*.c,*.h,*.pl,*.sh,*.ksh 1,$!/u/kma/bin/skel <afile>


" autoformat with [q; for perforce submits, ignore lines that are just a
" single tab. Visual selection for v
nmap [q !}sed -e s/^\	$// \| fmt -w 75<C-m>
vmap [q :!sed -e s/^\	$// \| fmt -w 75<C-m>

nmap [s :split 
nmap [v :vsplit 

" typo correction
ab teh the

" use mt when building
" set makeprg=hpmk
" hotkey to switch to fbcode
nmap [m :make
nmap [n :cn<C-m>
nmap [p :cp<C-m>
nmap [f :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap [a :Ack <C-R>=expand("<cword>")<CR>
nmap [A :Ack -i <C-R>=expand("<cword>")<CR>

" Fuf shortcuts
nmap [F :FufFile<C-m>
nmap [B :FufBuffer<C-m>
nmap [b :buffer
nmap [L :FufLine<C-m>

" [h: go to header-file current file's header
nmap [h :e <C-R>=substitute(expand("%:p"), '.cpp$', '.h', 'g')<CR>
" [h: go to cpp-file of current (presumably header) file
nmap [c :e <C-R>=substitute(expand("%:p"), '.h$', '.cpp', 'g')<CR>

" Tagbar hotness
nmap [t :TagbarToggle<CR>
let g:tagbar_left=1

set nohlsearch

function! ID_search()
  let g:word = expand("<cword>")
  let x = system("lid --key=none ". g:word)
  let x = substitute(x, "\n", " ", "g")
  execute "next " . x
endfun

set nocst
"" Stuff stolen from matt: use cscope for tags.
:let treedir=$TREE
"if has("cscope")
"	set csprg=/usr/bin/cscope
"	set csto=1
"	set cst
"	if filereadable("./cscope.out")
"                "cs add ./cscope.out
"	else
"		" Give up
"		set nocst
"	endif
"	set nocsverb
"        :nmap <C-\> :cs find c <C-R>=expand("<cword>")<CR><CR>
"endif

" & -- like # or *, but finds at the start of the line.
:map & /::=expand("<cword>")<CR>
" insert closing paren when I open one. Turns out this is insanely annoying.
":inoremap ( ()<ESC>i
":inoremap [ []<ESC>i
":inoremap [ []<ESC> :let leavechar="]"<CR>i
":inoremap { {<CR><CR>}<ESC>ki
:noremap ; :


"source $HOME/.highlight
"map [w :source $HOME/vim/word_complete.vim
"autocmd BufEnter *.c,*.h call DoWordComplete()
"autocmd BufLeave *.c,*.h call EndWordComplete()

" Don't let gdb muck about with my status line settings
:let g:gdb_statusline = 0

map <C-v> :!tkdiff % &<CR><CR>

" prevent recursion sourcing .vimrc in home directory
if filereadable(".vimrc") && getcwd() != $HOME
        :source .vimrc
endif

if has("gui_running")
    " use some sane defaults
    set gfn="Courier 10 Pitch 12"
    set background=dark
endif

so ~/.vim/table_format.vim
