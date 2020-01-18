"--- general ---"
set nocompatible
set number     "set a number of line
set visualbell
set shiftwidth=4
set softtabstop=4

set showmatch
set hlsearch       " highlight all search result
set autoindent
set statusline+=%F " show filename
set paste

"--- syntax highlight ---"
syntax on      "turn on syntax highlighting
au BufNewFile,BufRead Jenkinsfile* setf groovy "for Jenkins files

"--- vim colorscheme ---"
colorscheme desert     "colorscheme

