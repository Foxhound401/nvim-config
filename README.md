# Neovim config

Requires v0.5+

Features:

- 100% Lua based;
- **syntax highlighting** (as well as **code folding**, **incremental selection**, **text objects** & more)
  powered by [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter);
- [builtin LSP](https://neovim.io/doc/user/lsp.html) setup for a dozen languages, of which I mostly use Go,
  Terraform, Lua, JavaScript;
- dual LSP setup, via [EFM](https://github.com/mattn/efm-langserver) to cover for "gaps", where needed,
  i.e.: I use `tsserver` for **JS**, but prefer `prettier` for formatting; I use `gopls` for **Go**, but I also
  want warnings from `golangci-lint`, etc.; I use `sumneko` for **Lua**, but also `efm` to run `lua-format` and
  `luacheck`;
- completion borrowed from [Supertab](https://vim.fandom.com/wiki/Smart_mapping_for_tab_completion)
  (hitting `<tab>` will do omnicomplete, file complete or insert actual tab, depending on where you are);
  no autocompletion, you actually have to hit `<tab>` (or any other of
  [insert mode completions](https://neovim.io/doc/user/insert.html#ins-completion));
- autoformat wherever possible; organize imports for **Go** and **JS**;
- builtin "fuzzy" searching (`set path=**` and just use `:find *whatever*` for filenames or `:Grep *whatever*`
  (set to `git grep`) for content);
- **git** integration: only a custom visual diff and for the rest, I just `:!git` away;
- convenient access to terminal (via `:Term` or `<C-n>`);
- easy access to all config files (`:Cfg <tab>`);
- minimal (I'd like to think :D) config that's been battle tested on the nightly branch
  since June 2020; no package manager, using builtin **packadd** + git submodules for managing the plugins;
  there are only ~8 plugins used, of which 4 are LSP and TS;
- minimal UI (no statusbar/linenumber; git branch, filename and function/method name are in the titlebar),
  using [my own colorscheme](https://github.com/alexaandru/froggy).

![Nvim](nvim.png)
