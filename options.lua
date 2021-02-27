return { -- LuaFormatter off
  "autowriteall", "hidden",
  "clipboard+=unnamedplus",
  "complete+=kspell", "completeopt=menuone,noselect,noinsert",
  "diffopt+=algorithm:patience,indent-heuristic,vertical",
  "expandtab",
  "grepprg=git\\ grep\\ -n",
  "icon", "iconstring=nvim",
  "ignorecase",
  "inccommand=nosplit",
  "laststatus=0",
  "lazyredraw",
  "mouse=a", "mousemodel=extend",
  "noshowcmd", "noshowmode", "nostartofline", "nowrap",
  "omnifunc=v:lua.vim.lsp.omnifunc",
  "path=**",
  "shell=bash",
  "shortmess+=c",
  "signcolumn=yes:2",
  "smartcase", "smartindent",
  "splitbelow", "splitright",
  "termguicolors",
  "title",
  "titlestring=🐙\\ %{get(w:,'git_status','~git')}\\ 📚\\ %<%f%=%M\\ \\ 📦\\ %{nvim_treesitter#statusline(150)}",
  "updatetime=2000",
  "virtualedit=block,onemore",
  "wildcharm=<C-Z>",
  "wildignore+=*/.git/*,*/node_modules/*",
  "wildignorecase",
} -- LuaFormatter on
