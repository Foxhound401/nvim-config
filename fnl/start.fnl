
;; fnlfmt: skip
(local {: !providers : !builtin : setup
        : au : lēt : opt : com : map : sig : colo} (require :setup))

(local cfg (require :config))

;; fnlfmt: skip
(!builtin [:2html_plugin :man :matchit :tutor_mode_plugin
           :gzip :tarPlugin :zipPlugin])

(!providers [:python3 :node :ruby :perl])

(lēt cfg.vars)
(opt cfg.options)
(au {:Setup cfg.autocmd})
(com cfg.commands)
(map cfg.keys.global)
(sig cfg.signs)

(setup :lsp)
(setup :nvim-treesitter.configs)
(setup :colorizer)
(setup :package-info)
(setup :dressing)

(colo :froggy)

