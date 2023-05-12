;; https://github.com/golang/tools/blob/master/gopls/doc/settings.md
{:cmd [:gopls :-remote=auto]
 :filetypes [:go :gomod :template]
 :settings {:gopls {:vulncheck :Imports
                    :analyses {:fieldalignment true
                               :nilness true
                               :shadow true
                               :unusedparams true
                               :unusedwrite true
                               :useany true
                               :unusedvariable true}
                    :buildFlags [:-tags=development]
                    :directoryFilters nil
                    :templateExtensions [:tmpl]
                    :codelenses {:gc_details true
                                 :generate true
                                 :run_vulncheck_exp true
                                 :tidy true
                                 :upgrade_dependency true
                                 :vendor true}
                    :staticcheck true
                    :gofumpt true
                    :hoverKind :FullDocumentation
                    ;; :SynopsisDocumentation
                    ; https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
                    :hints {:assignVariableTypes true
                            :compositeLiteralFields false
                            :compositeLiteralTypes true
                            :constantValues true
                            :functionTypeParameters true
                            :parameterNames true
                            :rangeVariableTypes true}
                    :experimentalPostfixCompletions true
                    :semanticTokens true
                    :usePlaceholders true
                    :local vim.env.GOPRIVATE}}}

