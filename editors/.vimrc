syntax on

set ignorecase
set ruler
set showcmd
set wildmenu

" ##### PLUGINS #####
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif
