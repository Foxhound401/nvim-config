local S = {silent = true}
local E = {expr = true}
local function T(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

return { -- LuaFormatter off
  lsp = {
    buf = {
      declaration      = "gd",
      definition       = "<c-]>",
      hover            = "<F1>",
      implementation   = "gD",
      signature_help   = "<c-k>",
      type_definition  = "1gD",
      references       = "gr",
      document_symbol  = "g0",
      workspace_symbol = "gW",
      rename           = "<F2>",
      code_action      = "<F16>"},
    diagnostic = {
      goto_next        = "<M-Right>",
      goto_prev        = "<M-Left>",
      set_loclist      = "<F7>"},
  },
  global = {
    n = {
      {"gb",             "<Cmd>ls<CR>:b<Space>", S},
      {"db",             "<Cmd>%bd<bar>e#<CR>", S},
      {"<C-n>",          [[<Cmd>let $CD=expand('%:p:h')<CR><Cmd>Term<CR>cd "$CD"<CR>clear<CR>]], S},
      {"<F3>",           "<Cmd>only<CR>", S},
      {"<F8>",           "<Cmd>Gdiff<CR>", S},
      {"<Leader>w",      "<Cmd>SaveAndClose<CR>", S},
      {"<Leader>c",      "<Cmd>so $VIMRUNTIME/syntax/hitest.vim<CR>", S},
      {"<Space>",        "@=((foldclosed(line('.')) < 0) ? 'zC' : 'zO')<CR>", S},
      {"Q",              "<Nop>", S}
    },
    c = {
      {"<Up>",           T'wildmenumode() ? "<Left>" : "<Up>"', E},
      {"<Down>",         T'wildmenumode() ? "<Right>" : "<Down>"', E},
      {"<Left>",         T'wildmenumode() ? "<Up>" : "<Left>"', E},
      {"<Right>",        T'wildmenumode() ? "<BS><C-Z>" : "<Right>"', E},
    },
    i = {
      {"<Tab>",          [[luaeval("require'util'.SmartTabComplete()")]], E},
      {"'",              "''<Left>"},
      {"(",              "()<Left>"},
      {"[",              "[]<Left>"},
      {"{",              "{}<Left>"},
    },
  },
} -- LuaFormatter on
