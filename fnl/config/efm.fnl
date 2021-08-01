(fn fmt [cmd stdin]
  {:formatCommand cmd :formatStdin (not= stdin false)})

(fn lint [cmd fmts stdin]
  (set-forcibly! fmts (or fmts ["%f:%l:%c: %m"]))
  {:lintCommand cmd
   :lintStdin (not= stdin false)
   :lintFormats fmts
   :lintIgnoreExitCode true})

;; consider using https://github.com/fsouza/prettierd
(local prettier (fmt "prettier -w --stdin-filepath ${INPUT}"))

(local eslint (vim.tbl_extend :keep
                              (fmt "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}")
                              (lint "eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}"
                                    ["%f(%l,%c): %trror %m"
                                     "%f(%l,%c): %tarning %m"])))

(local golangciCmd
       "bash -c 'golangci-lint run --out-format github-actions|grep =$(realpath --relative-to . ${INPUT})'")

(local golangci (lint golangciCmd
                      ["::%trror file=%f,line=%l,col=%c::%m"
                       "::%tarn file=%f,line=%l,col=%c::%m"
                       "::%tnfo file=%f,line=%l,col=%c::%m"
                       "::%tint file=%f,line=%l,col=%c::%m"]
                      false))

(local fennelCmd
       (.. "bash -c 'export out=$(fennel --globals vim,unpack ${INPUT} 2>&1); "
           "[[ \"$out\" =~ ^([a-zA-Z\\s\\d]*).error.in.(.*):([0-9]+) ]] && "
           "(echo -n \"Error ${BASH_REMATCH[2]}:${BASH_REMATCH[3]} ${BASH_REMATCH[1]} error: \"; "
           "echo \"$out\"|head -n2|tail -n1|cut -b3-)'"))

(local fennel (lint fennelCmd ["%trror %f:%l %m"
                               "%tarning %f:%l %m"
                               "%tnfo %f:%l %m"
                               "%tint %f:%l %m"
                               "%f:%l %m"] false))

(local luacheck (lint "bash -c 'luacheck --globals vim --formatter plain -- ${INPUT}|sed s\"/^/Warn /\"'"
                      ["%tarn %f:%l:%c: %m"]))

(local tfsec (lint (.. "bash -c 'tfsec --tfvars-file terraform.tfvars -fcsv|"
                       "sed \"s/,CRITICAL,/,ERROR,/i; s/,HIGH,/,ERROR,/i; s/,MEDIUM,/,WARN,/i; s/,LOW,/,NOTICE,/i\"|"
                       "cut -f1,2,3,5,6 -d,|grep ${INPUT}'")
                   ["%f,%l,%c,%tARN,%m"
                    "%f,%l,%c,%tRROR,%m"
                    "%f,%l,%c,%tOTICE,%m"]))

(local terrascan
       (lint (.. "bash -c 'terrascan scan -o json|"
                 "jq -r \".results.violations[]|[.file,.line,.severity,.description]|join(\\\",\\\")\"|"
                 "sed \"s#^deployment/##; s/,CRITICAL,/,ERROR,/i; s/,HIGH,/,ERROR,/i; s/,MEDIUM,/,WARN,/i; s/,LOW,/,NOTICE,/i\"|"
                 "grep $(realpath --relative-to . ${INPUT})'")
             ["%f,%l,%tARN,%m" "%f,%l,%tRROR,%m" "%f,%l,%tOTICE,%m"]))

(local cfg {:go [golangci]
            :hcl [tfsec terrascan]
            :lua [(fmt "lua-format -i") luacheck]
            :fennel [(fmt "fnlfmt /dev/stdin" true) fennel]
            :json [(fmt "jq .") (lint "jsonlint ${INPUT}")]
            :javascript [prettier eslint]
            :typescript [prettier eslint]
            :vue [prettier eslint]
            :yaml [prettier]
            :html [prettier]
            :scss [prettier]
            :css [prettier]
            :markdown [prettier]})

{:settings {:rootMarkers [:go.mod :package.json :.git] :languages cfg}
 :init_options {:documentFormatting false}
 :filetypes (vim.tbl_keys cfg)
 :on_attach (fn [client bufnr]
              (local opts (. cfg (vim.fn.getbufvar bufnr :&ft)))
              (var ok false)
              (each [_ v (ipairs opts)]
                (when v.formatCommand
                  (set ok true)))
              (set client.resolved_capabilities.document_formatting ok)
              ((. (require :lsp) :on_attach) client bufnr))}

