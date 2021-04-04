-- luacheck: globals vim
return {
  Setup = {
    "VimEnter,DirChanged * CdProjRoot | exe 'LoadLocalCfg' | lua GitStatus()",
    "WinNew,WinEnter * lua GitStatus()",
    "TextYankPost * silent! lua vim.highlight.on_yank()",
    "ColorScheme * HiFix",
    "QuickFixCmdPost [^l]* nested cw",
    "QuickFixCmdPost    l* nested lw",
    "TermOpen * star",
    "TermClose * q",
    "FileType qf AutoWinHeight",
    "FileType gitcommit,asciidoc,markdown setl spell spl=en_us",
    "FileType lua,vim setl ts=2 sw=2 sts=2 fdls=0 fdm=expr fde=nvim_treesitter#foldexpr()",
    "FileType go setl ts=4 sw=4 noet fdm=expr fde=nvim_treesitter#foldexpr()",
    "BufEnter * exe 'ColorizerAttachToBuffer' | LastWindow",
    "BufReadPost *.go,*.lua JumpToLastLocation",
    "BufWritePre * TrimTrailingSpace | TrimTrailingBlankLines",
    "BufWritePre *.vim AutoIndent",
    ("BufWritePost %s/*.lua exe 'luafile' $MYVIMRC | e | HiFix"):format(vim.fn.stdpath("config")),
  },
}
