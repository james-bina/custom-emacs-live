;;; midje-test-mode.el --- Minor mode for midje

;; Author: Ben Poweski  <bpoweski@gmail.com>
;; Version: 20131208.914
;; X-Original-Version: 0.0.1
;; Keywords: languages, lisp, test
;; Package-Requires: ((clojure-mode "1.7") (cider "0.3.0"))

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This library is based on the clojure-test-mode by Phil Hagelberg et al.

;;; History:

;; 0.0.1: 2013-11-20
;;  * initial release

;;; Code:
(require 'clojure-mode)
(require 'clojure-test-mode)
(require 'nrepl-client)
(require 'cider-interaction)

(defface midje-test-failure-face
  '((((class color) (background light))
     :background "orange red")
    (((class color) (background dark))
     :background "firebrick"))
  "Face for failures in facts."
  :group 'midje-test-mode)

(defface midje-test-error-face
  '((((class color) (background light))
     :background "orange1")
    (((class color) (background dark))
     :background "orange4"))
  "Face for errors in facts."
  :group 'midje-test-mode)

(defface midje-test-success-face
  '((((class color) (background light))
     :foreground "black"
     :background "green")
    (((class color) (background dark))
     :foreground "black"
     :background "green"))
  "Face for success in facts."
  :group 'midje-test-mode)

(defvar midje-test-count         0)
(defvar midje-test-failure-count 0)
(defvar midje-test-error-count   0)


(defun midje-test-response-handler (callback)
  (lexical-let ((buffer (current-buffer))
                (callback callback))
    (nrepl-make-response-handler buffer
                                 (lambda (buffer value)
                                   (funcall callback buffer value))
                                 (lambda (buffer value)
                                   (cider-repl-emit-interactive-output value))
                                 (lambda (buffer err)
                                   (cider-repl-emit-interactive-output err))
                                 '())))

(defun midje-test-eval (string &optional handler)
  (nrepl-send-string string
                     (midje-test-response-handler (or handler #'identity))
                     (or (cider-current-ns) "user")
                     (nrepl-current-tooling-session)))

(defun midje-test-clear ()
  "Clear all counters and unmap generated vars for midje test"
  (interactive)
  (remove-overlays)
  (setq midje-test-count         0
        midje-test-failure-count 0
        midje-test-error-count   0))

(defun midje-test-echo-results ()
  (message
   (propertize
    (format "Ran %s facts. %s failures, %s errors."
            midje-test-count midje-test-failure-count
            midje-test-error-count)
    'face
    (cond ((not (= midje-test-error-count 0)) 'midje-test-error-face)
          ((not (= midje-test-failure-count 0)) 'midje-test-failure-face)
          (t 'midje-test-success-face)))))

(defun midje-colorize ()
  (cl-flet ((f (keywords face)
               (cons (concat "\\<\\("
                             (mapconcat 'symbol-name keywords "\\|")
                             "\\)\\>")
                     face)))
    (font-lock-add-keywords
     nil
     (list (f '(fact facts future-fact future-facts tabular provided)
              'font-lock-keyword-face)
           (f '(just contains has has-suffix has-prefix
                     truthy falsey anything exactly roughly throws)
              'font-lock-type-face)
           '("=>\\|=not=>" . font-lock-negation-char-face) ; arrows
           '("\\<\\.+[a-zA-z\-]+\\.+\\>" . 'font-lock-type-face)))))

(add-hook 'clojure-test-mode-hook 'midje-colorize)

(defun midje-test-run-tests ()
  "Run all the facts in the current namespace."
  (interactive)
  (save-some-buffers nil (lambda () (equal major-mode 'clojure-mode)))
  (message "Testing Midje...")
  (midje-test-clear)
  (midje-test-eval
   (format "(do (require 'midje.repl)
                (midje.repl/forget-facts)
                (midje.config/with-augmented-config {:print-level :print-nothing}
                  (load-file \"%s\")
                  (for [fact (midje.repl/fetch-facts '%s)
                        :let [md (meta fact)
                              result (midje.repl/check-one-fact fact)]]
                      (list :fact-result (if result :success :failure)))))"
           (buffer-file-name)
           (clojure-find-ns))
   #'midje-test-extract-results))

(defun midje-test-extract-results (buffer value)
  (with-current-buffer buffer
    (let ((fact-results (car (read-from-string value))))
      (dolist (fact-result fact-results)
        (incf midje-test-count)
        (message "%s" (plist-get fact-result :fact-result))
        (cond ((eq (plist-get fact-result :fact-result) :failure) (incf midje-test-failure-count))))
      (midje-test-echo-results))))

(defvar midje-test-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c ,")   'midje-test-run-tests)
    (define-key map (kbd "C-c C-,") 'midje-test-run-tests)
    (define-key map (kbd "C-c k")   'midje-test-clear)
    map))

;;;###autoload
(define-minor-mode midje-test-mode
  "A minor mode for running midje"
  nil " MT" midje-test-mode-map)

(defconst midje-test-regex
  (rx "midje.sweet"))

;;;###autoload
(defun clojure-find-midje-test ()
  (let ((regexp midje-test-regex))
    (save-restriction
      (save-excursion
        (save-match-data
          (goto-char (point-min))
          (when (re-search-forward regexp nil t)
            (match-string-no-properties 0)))))))

(progn
  (defun midje-test-maybe-enable ()
    "Enable midje-test-mode"
    (when (clojure-find-midje-test)
      (save-window-excursion
        (midje-test-mode t))))

  (add-hook 'clojure-mode-hook 'midje-test-maybe-enable))

(provide 'midje-test-mode)

;;; midje-test-mode.el ends here
