;; TODO:
;; - autostart API server?
;; - run the API call async
;; - display errors
;; - ability to run from files other than JSON (use treesitter to detect if we're in a JSON object)
;; - autoselect outermost json object?
;; - add buf local autocommand to rerun on save
;; - lsof +c0 -P -n -c indexalogic # autodetect port

(local {: get-selection} (require :util))

(fn process-json [json]
  (let [[_ l1] (vim.fn.getpos :v)
        [_ l2] (vim.fn.getcurpos)
        cl (if (= l1 l2) l1 -1)]
    (if (= -1 cl) [json :query]
        (let [m "curl%s+-d%s+'(.*)'%s+localhost:5000/(.*)"
              lines (vim.fn.getline cl cl)
              line (. lines 1)
              matches (line:gmatch m)
              (data action) (matches)]
          (if (and data action) [data action] [json :query])))))

;; params:
;;   node (bool) - if set will query node, otherwise will query master;
;;   port (string) - will be used if set, if not, 5001 is used.
(fn api [node port]
  (vim.cmd "norm va{")
  (when (vim.tbl_contains [:json :markdown] vim.bo.filetype)
    (let [json (get-selection)
          port (if port port :5001)
          [json action] (process-json json)
          action (if node (.. :node/ action) action)
          f (assert (io.open :/tmp/api.json :w))]
      (assert (f:write json))
      (assert (f:flush))
      (assert (f:close))
      (when (not vim.g.api)
        (set vim.g.api (vim.api.nvim_create_buf false true))
        (vim.api.nvim_set_option_value :filetype :json {:buf vim.g.api}))
      (let [cmd vim.cmd
            opts [:curl
                  :-H "Content-Type: application/json"
                  :-H "indexalogic-noCache: true"
                  :-H "indexalogic-noStats: true"
                  :-H "indexalogic-noPerf: true"
                  :-H "request-tag: Apiary v0.8.2"
                  :-sd "@/tmp/api.json"
                  (.. "localhost:" port "/" action)]
            out (vim.fn.system opts)
            out (string.gsub out "\n" "")
            wnum (vim.fn.bufwinnr vim.g.api)
            jump-or-split (if (= -1 wnum) (.. :vs|b vim.g.api)
                              (.. wnum "wincmd w"))]
        (print (.. "curl -d@/tmp/api.json localhost:" port "/" action))
        (vim.api.nvim_buf_set_lines vim.g.api 0 -1 false [out])
        (cmd jump-or-split)
        (cmd "setl nofoldenable")
        (cmd :JQ)
        (vim.fn.setpos "." [0 0 0 0])))))

(each [_ mode (ipairs [:n :v])]
  (vim.keymap.set mode :<Leader>qq api {:silent true})
  (vim.keymap.set mode :<Leader>q1 #(api true :5001) {:silent true})
  (vim.keymap.set mode :<Leader>q2 #(api true :5002) {:silent true}))

