;; User pack init file
;;
;; Use this file to initiate the pack configuration.
;; See README for more information.

;; Load bindings config
;; (live-load-config-file "bindings.el")

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)

(live-load-config-file "thrift-conf.el")
(live-load-config-file "themes.el")

(global-hl-line-mode 1)

;; midje
(add-hook 'clojure-mode-hook 'midje-mode)

;; cider
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
(add-hook 'cider-repl-mode-hook 'paredit-mode)
(setq cider-repl-popup-stacktraces t)
(setq cider-repl-display-in-current-window t)
