
;; fnlfmt: skip
(local diffopt [:defaults "algorithm:patience" :indent-heuristic :vertical "linematch:60"])

{:autowriteall true
 :clipboard :unnamedplus
 :cmdheight 1
 :complete [:defaults :kspell]
 :completeopt [:menu :noselect :noinsert]
 :conceallevel 3
 : diffopt
 :expandtab true
 :foldexpr "nvim_treesitter#foldexpr()"
 :foldlevel 99
 :foldmethod :expr
 :foldminlines 1
 :foldnestmax 4
 :grepprg "git grep -EIn"
 :icon true
 :iconstring :nvim
 :ignorecase true
 :laststatus 0
 :lazyredraw true
 :mouse :a
 :mousemodel :extend
 :path "**"
 :pumblend 10
 :shell :bash
 :shortmess :+c
 :showcmd false
 :showmode false
 :signcolumn "yes:2"
 :smartcase true
 :smartindent true
 :splitbelow true
 :splitright true
 :startofline false
 :termguicolors true
 :title true
 :titlestring :Neovim
 :updatetime 2000
 :virtualedit [:block :onemore]
 :wildcharm (tonumber (vim.keycode :<C-Z>))
 :wildignore [:*/.git/* :*/node_modules/*]
 :wildignorecase true
 :wildmode "longest:full,full"
 :wildoptions :pum
 :winbar "🐙 %{get(w:,'git_status','~git')} 📚 %<%f%M  📦 %{nvim_treesitter#statusline()}"
 :wrap false}

