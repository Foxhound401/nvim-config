#!/bin/bash

export CONFIG=~/.config/nvim
git clone https://gist.github.com/alexaandru/9449a9d838c8632fad91ef35d4f6fd43 $CONFIG
cd $CONFIG

# Setup Lua modules
mkdir -p lua/config
for i in *.lua; do ln -s ../../$i lua/config/; done
rm lua/config/init.lua # wrong init.lua
mv lua/config/config.lua lua/config/init.lua
ln -s ../notify.lua lua/
ln -s ../util.lua lua/
ln -s ../lsp.lua lua/

# Setup package submodules
mkdir -p pack/{colors,plugins,syntax}/{opt,start}; cd pack && git init && git submodule init

declare -A plugins=(
  ["plugins/opt/nvim-lspconfig"]="https://github.com/neovim/nvim-lspconfig.git"
  ["plugins/opt/nvim-lspupdate"]="https://github.com/alexaandru/nvim-lspupdate.git"
  ["plugins/opt/nvim-treesitter"]="https://github.com/nvim-treesitter/nvim-treesitter.git"
  ["plugins/opt/nvim-treesitter-textobjects"]="https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  ["plugins/opt/nvim-colorizer"]="https://github.com/norcalli/nvim-colorizer.lua.git"
  ["plugins/opt/gomod"]="https://github.com/mattn/vim-gomod.git"
  ["colors/opt/deus"]="https://github.com/ajmwagar/vim-deus.git"
)

for path in "${!plugins[@]}"; do
  export url="${plugins[$path]}"
  git submodule add $url $path
done

cp .golangci.yml ~
