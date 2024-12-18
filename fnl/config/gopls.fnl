;; https://github.com/golang/tools/blob/master/gopls/doc/settings.md
{:cmd [:gopls :-remote=auto]
 :filetypes [:go :gomod :template]
 :settings {:gopls {:vulncheck :Imports
                    :analyses {:shadow true :useany true :unusedvariable true}
                    :buildFlags [:-tags=test]
                    :directoryFilters [:-**/node_modules :-**/testdata]
                    :templateExtensions [:tmpl]
                    :codelenses {:gc_details true
                                 :generate true
                                 :run_govulncheck true
                                 :test true
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

