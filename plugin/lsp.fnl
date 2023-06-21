(local cfg (require :config.lsp-cfg))
(local {:__diag cfg-diag :__keys lsp-keys} cfg)
(set cfg.__diag nil)
(set cfg.__keys nil)

;; TODO: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports
(fn OrgImports []
  (let [params (vim.lsp.util.make_range_params)]
    (set params.context {:only [:source.organizeImports]})
    (let [result (vim.lsp.buf_request_sync 0 :textDocument/codeAction params 1000)]
      (each [_ res (pairs (or result {}))]
        (each [_ r (pairs (or res.result {}))]
          (if r.edit
              (vim.lsp.util.apply_workspace_edit r.edit vim.b.offset_encoding)
              (vim.lsp.buf.execute_command r.command)))))))

(fn OrgJSImports []
  (vim.lsp.buf.execute_command {:arguments [(vim.fn.expand "%:p")]
                                :command :_typescript.organizeImports}))

(fn au [group-name commands]
  (let [group (vim.api.nvim_create_augroup group-name {:clear true})
        c #(vim.api.nvim_create_autocmd $1 {:callback $2 : group :buffer 0})]
    (each [ev cmd (pairs commands)] (c ev cmd))
    group))

(fn set-highlight []
  (au :Highlight {[:CursorHold :CursorHoldI] vim.lsp.buf.document_highlight
                  :CursorMoved vim.lsp.buf.clear_references}))

(local compl-attach (. (require :lsp_compl) :attach))

(fn on-attach [args]
  (let [client (vim.lsp.get_client_by_id args.data.client_id)
        buffer args.buf]
    ;; https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
    ;; https://github.com/golang/tools/blob/master/gopls/doc/semantictokens.md
    ;; https://github.com/golang/vscode-go/issues/2752
    (set client.server_capabilities.semanticTokensProvider {:full true
          :legend {:tokenModifiers [:declaration :definition :readonly :static :deprecated
                                    :abstract :async :modification :documentation :defaultLibrary]
                   :tokenTypes [:namespace :type :class :enum :interface :struct :typeParameter :parameter
                                :variable :property :enumMember :event :function :method :macro :keyword
                                :modifier :_comment :string :number :regexp :operator :decorator]}})
    (set vim.b.offset_encoding client.offset_encoding)
    (let [opts {:silent true : buffer}]
      (each [lhs rhs (pairs lsp-keys)] (vim.keymap.set :n lhs rhs opts)))
    (let [rc client.server_capabilities]
      (if rc.inlayHintProvider 
          (vim.lsp.buf.inlay_hint buffer true))
      (if rc.documentHighlightProvider (set-highlight))
      (if rc.codeLensProvider
          (au :CodeLens {[:BufEnter :CursorHold :InsertLeave] vim.lsp.codelens.refresh}))
      (if rc.completionProvider
          (compl-attach client buffer {:trigger_on_delete true})))))

(let [lsp-config (require :lspconfig)]
  (each [name cfg (pairs cfg)]
    (let [{: setup} (. lsp-config name)] (setup cfg))))

(vim.diagnostic.config cfg-diag)

(let [group (vim.api.nvim_create_augroup :LSP {:clear true})
      au #(vim.api.nvim_create_autocmd :BufWritePre {: group :callback $1 :pattern $2})]
  (au #(vim.lsp.buf.format {:timeout_ms 1000}) "*")
  (au OrgImports :*.go)
  (au OrgJSImports "*.js,*.jsx"))

(vim.api.nvim_create_autocmd :LspAttach {:group :LSP :callback on-attach})
;(vim.api.nvim_create_autocmd :LspTokenUpdate {:group :LSP :callback #(print (vim.inspect $1))})
