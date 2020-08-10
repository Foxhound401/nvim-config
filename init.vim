scriptencoding utf-8

call plug#begin(stdpath('data').'/plugged')
Plug 'neovim/nvim-lsp'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'hashivim/vim-terraform'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'nvim-lua/completion-nvim'
Plug 'srcery-colors/srcery-vim'
call plug#end()

exe 'luafile' stdpath('config').'/init.lua'

set clipboard+=unnamedplus
set complete+=kspell completeopt=menuone,noselect,noinsert
set diffopt+=algorithm:patience,indent-heuristic,vertical
set expandtab
set exrc
set foldmethod=indent foldlevelstart=1000
set grepprg=git\ grep\ -n
set icon iconstring=nvim
set ignorecase
set inccommand=nosplit
set laststatus=0
set lazyredraw
set mouse=a mousemodel=extend
set noshowcmd noshowmode nostartofline nowrap
set omnifunc=v:lua.vim.lsp.omnifunc
set path=**
set shell=bash
set shortmess+=c
set signcolumn=yes:2
set smartcase smartindent
set splitbelow splitright
set tags=
set termguicolors
set title titlestring=%{b:git_status}\ %<%f%=%M
set wildcharm=<C-Z>
set wildignore+=*/.git/*,*/node_modules/*
set wildignorecase

" needs termguicolors to be set 1st
lua require'colorizer'.setup()

let $GOFLAGS='-tags=development'
let g:loaded_python_provider = 0
let g:loaded_python3_provider = 0
let g:loaded_node_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:netrw_banner = 0
let g:netrw_liststyle = 1
let g:netrw_browse_split = 4
let g:netrw_preview = 1
let g:netrw_altv = 1
let g:netrw_list_hide = '^\.[a-zA-Z].*,^\./$'
let g:netrw_hide = 1
let g:netrw_winsize = 15
let s:makeprg = {
      \ 'go': '(go build ./... && go vet ./...)',
      \ 'gomod': 'go mod tidy',
      \ 'gosum': 'go mod tidy',
      \ 'vim': 'vint --enable-neovim %',
      \ 'javascript': 'npm run lint',
      \ 'terraform': '(terraform validate -no-color && for i in $(find -iname ''*.tf''\|xargs dirname\|sort -u\|paste -s); do tflint $i; done)',
      \ 'json': 'jsonlint %',
      \ }

func! GolangCI(...)
  let l:scope = get(a:, 1, '.') | if l:scope ==# '%' | let l:scope = expand('%') | endif
  let l:only = get(a:, 2, '') | if l:only !=# '' | let l:only = '--exclude-use-default=0 --no-config --disable-all --enable '.l:only | endif
  let l:lst = systemlist('golangci-lint run --print-issued-lines=0 '.l:only.' ./...')

  cgete filter(l:lst, 'v:val =~ "^'.l:scope.'"')
endf

func! ProjRelativePath()
  return expand('%:p')[len(b:proj_root):]
endf

func! GitStatus()
  let l:branch = trim(system('git rev-parse --abbrev-ref HEAD 2> /dev/null'), "\n")
  if l:branch ==# '' | return '~git |' | endif
  let l:dirty = system('git diff --quiet || echo -n \*')

  return l:branch.l:dirty.' |'
endf

com! -bar     Make silent make
com! -nargs=1 Grep silent grep <args>
com! -nargs=* Term split | resize 12 | term <args>
com! -nargs=* -bar -complete=file_in_path GolangCI call GolangCI(<f-args>)
com! -bar     SetProjRoot let b:proj_root = fnamemodify(finddir('.git/..', expand('%:p:h').';'), ':p')
com! -bar     GitStatus let b:git_status = GitStatus()
com!          Gdiff exe 'silent !cd '.b:proj_root.' && git show HEAD^:'.ProjRelativePath().' > /tmp/gdiff' | diffs /tmp/gdiff
com!          Terrafmt exe 'silent !terraform fmt %' | e
com!          JumpToLastLocation if line("'\"") > 0 && line("'\"") <= line("$") | exe "norm! g'\"" | endif
com! -bar     TrimTrailingSpace norm m':%s/[<Space><Tab><C-v><C-m>]\+$//e<NL>''
com! -bar     TrimTrailingBlankLines %s#\($\n\s*\)\+\%$##e
com!          SaveAndClose w | bdel
com!          LastWindow if (&buftype ==# 'quickfix' || &buftype ==# 'terminal' || &filetype ==# 'netrw')
      \ && winbufnr(2) ==# -1 | q | endif
com! -bar     Scratchify setl nobl bt=nofile bh=delete noswf
com! -bar     Scratch <mods> new +Scratchify
com! -bar     AutoWinHeight silent exe max([min([line('$'), 12]), 1]).'wincmd _'
com! -bar     AutoIndent silent norm gg=G`.
com! -bar     LspCapabilities lua LspCapabilities()
com! -range   JQ '<,'>!jq .

aug Setup | au!
  au VimEnter * exe 'cd '.b:proj_root | GitStatus
  au DirChanged * if filereadable('.nvimrc') | so .nvimrc | endif
  au BufEnter * SetProjRoot | GitStatus | LastWindow
  au BufEnter * let &makeprg = get(s:makeprg, &filetype, 'make')
  au BufEnter * lua require'completion'.on_attach()
  au BufEnter go.mod set ft=gomod
  au BufEnter go.sum set ft=gosum
  au BufReadPost * JumpToLastLocation
  au BufWritePre * TrimTrailingSpace | TrimTrailingBlankLines
  au TextYankPost * silent! lua require'vim.highlight'.on_yank()
  au TermOpen * star
  au TermClose * q
  au BufWritePost * GitStatus
  au BufWritePost,FileWritePost go.mod,go.sum silent! make | e
  au BufWritePre *.go lua GoOrgImports(); vim.lsp.buf.formatting_sync()
  au BufWritePre *.vim,*.lua AutoIndent
  au BufWritePre *.json 1,$JQ
  au QuickFixCmdPost [^l]* nested cw
  au QuickFixCmdPost    l* nested lw
  au FileType qf AutoWinHeight
  au FileType gitcommit,asciidoc,markdown setl spell spl=en_us
  au FileType lua,vim setl ts=2 sw=2 sts=2
  au BufWritePost ~/.config/nvim/*.vim so $MYVIMRC
  au BufWritePost *.tf Terrafmt
  au FileType go setl ts=4 sw=4 noet fdm=expr fde=nvim_treesitter#foldexpr()
aug END

nno <silent> gb        <Cmd>ls<CR>:b<Space>
nno <silent> db        <Cmd>%bd<bar>e#<CR>
nno <silent> gd        <Cmd>lua vim.lsp.buf.declaration()<CR>
nno <silent> <c-]>     <Cmd>lua vim.lsp.buf.definition()<CR>
nno <silent> <F1>      <Cmd>lua vim.lsp.buf.hover()<CR>
nno <silent> gD        <Cmd>lua vim.lsp.buf.implementation()<CR>
nno <silent> <c-k>     <Cmd>lua vim.lsp.buf.signature_help()<CR>
nno <silent> 1gD       <Cmd>lua vim.lsp.buf.type_definition()<CR>
nno <silent> gr        <Cmd>lua vim.lsp.buf.references()<CR>
nno <silent> g0        <Cmd>lua vim.lsp.buf.document_symbol()<CR>
nno <silent> gW        <Cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nno <silent> <F2>      <Cmd>lua vim.lsp.buf.rename()<CR>
nno <silent> <C-n>     <Cmd>let $CD=expand('%:p:h')<CR><Cmd>Term<CR>cd "$CD"<CR>clear<CR>
nno <silent> <F3>      <Cmd>only<CR>
nno <silent> <F5>      <Cmd>Make<CR>
nno <silent> <F6>      <Cmd>GolangCI<CR>
nno <silent> <F6>%     <Cmd>GolangCI %<CR>
nno <silent> <F8>      <Cmd>Gdiff<CR>
nno <silent> <C-Right> <Cmd>cnext<CR>
nno <silent> <C-Left>  <Cmd>cprev<CR>
nno <silent> <F12>     <Cmd>vs ~/.config/nvim/init.vim<CR>
nno <silent> <F12>l    <Cmd>vs ~/.config/nvim/init.lua<CR>
nno <silent> <Leader>w <Cmd>SaveAndClose<CR>
nno <silent> <Space>   @=((foldclosed(line('.')) < 0) ? 'zC' : 'zO')<CR>
nno          <C-p>     :find *
cno <expr>   <Up>      wildmenumode() ? "\<Left>"     : "\<Up>"
cno <expr>   <Down>    wildmenumode() ? "\<Right>"    : "\<Down>"
cno <expr>   <Left>    wildmenumode() ? "\<Up>"       : "\<Left>"
cno <expr>   <Right>   wildmenumode() ? "\<BS>\<C-Z>" : "\<Right>"
xno          <Leader>q !jq .<CR>
ino <silent> <F2>      <C-x>s
ino          '         ''<Left>
ino          (         ()<Left>
ino          [         []<Left>
ino          {         {}<Left>

for i in systemlist('ls '.stdpath('config').'/*.vim|grep -v init.vim') | exe 'so '.i | endfor
