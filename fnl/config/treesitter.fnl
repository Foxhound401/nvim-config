{:ensure_installed [:bash :make :toml :json :jq :yaml :diff :dockerfile :dot :sql :csv :ssh_config
                    :markdown :markdown_inline :vimdoc :comment :printf
                    :c :cpp :go :gomod :gosum :gotmpl :gowork
                    :fennel :lua :luadoc :python
                    :hcl :terraform
                    :git_config :git_rebase :gitattributes :gitcommit :gitignore
                    :html :css :javascript :typescript :vue]
 :sync_install false
 :ignore_install {}
 :highlight {;; :custom_captures {"@text.danger" :Todo "@text.note" :Todo}
             :enable true}
 :autotag {:enable true}
 :indent {:enable true}
 :incremental_selection {:enable true
                         :keymaps {:init_selection :<Return>
                                   :node_incremental :<Return>
                                   :scope_incremental :<Tab>
                                   :node_decremental :<S-Tab>}}
 :textobjects {:select {:enable true
                        :lookahead true
                        :keymaps {:af "@function.outer"
                                  :if "@function.inner"
                                  :ac "@conditional.outer"
                                  :al "@loop.outer"
                                  :as "@statement.outer"}}
               :lsp_interop {:enable true
                             :peek_definition_code {:df "@function.outer"
                                                    :dF "@class.outer"}}}}

