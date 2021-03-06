;;;;
;; Clojure
;;;;

;; autoindent code on return rather than press C-j
(add-hook 'clojure-mode-hook '(lambda ()
  (local-set-key (kbd "RET") 'newline-and-indent)))

;; Enable paredit for Clojure
(add-hook 'clojure-mode-hook 'enable-paredit-mode)

;; This is useful for working with camel-case tokens, like names of
;; Java classes (e.g. JavaClassName)
(add-hook 'clojure-mode-hook 'subword-mode)

;; A little more syntax highlighting
(require 'clojure-mode-extra-font-locking)

;; syntax hilighting for midje
(add-hook 'clojure-mode-hook
          (lambda ()
            (setq inferior-lisp-program "lein repl")
            (font-lock-add-keywords
             nil
             '(("(\\(facts?\\)"
                (1 font-lock-keyword-face))
               ("(\\(background?\\)"
                (1 font-lock-keyword-face))))
            (define-clojure-indent (fact 1))
            (define-clojure-indent (facts 1))))

;;;;
;; Cider
;;;;

;; provides minibuffer documentation for the code you're typing into the repl
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)

;; don't go right to the REPL buffer when it's finished connecting
(setq cider-repl-pop-to-buffer-on-connect nil)

;; When there's a cider error, don#t show its buffer and switch to it
(setq cider-show-error-buffer nil)
(setq cider-auto-select-error-buffer nil)

; Don't aggresively popup stacktraces
(setq cider-popup-stacktraces t)                                      
(setq cider-repl-popup-stacktraces nil)
;; switching to CIDER buffer does so in the current window
(setq cider-repl-display-in-current-window t)


;; Where to store the cider history.
(setq cider-repl-history-file "~/.emacs.d/cider-history")

;; Wrap when navigating history.
(setq cider-repl-wrap-history t)

;; enable paredit in your REPL
(add-hook 'cider-repl-mode-hook 'paredit-mode)

;; Use clojure mode for other extensions
(add-to-list 'auto-mode-alist '("\\.edn$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.boot$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.cljs.*$" . clojure-mode))


;; key bindings
;; these help me out with the way I usually develop web apps
(defun cider-start-http-server ()
  (interactive)
  (cider-load-current-buffer)
  (let ((ns (cider-current-ns)))
    (cider-repl-set-ns ns)
    (cider-interactive-eval (format "(println '(def server (%s/start))) (println 'server)" ns))
    (cider-interactive-eval (format "(def server (%s/start)) (println server)" ns))))


(defun cider-reval-env ()
  (interactive)
  (let ((current-ns (cider-current-ns)))
    (cider-interactive-eval
     "(in-ns 'environ.core)
      (def env (merge (read-env-file) (read-system-props) (read-system-env)))")
    (cider-repl-set-ns current-ns)))


(defun cider-refresh ()
  (interactive)
  (cider-interactive-eval "(user/go)"))

(eval-after-load 'cider
  '(progn
     (define-key clojure-mode-map (kbd "C-c C-v") 'cider-start-http-server)
     (define-key clojure-mode-map (kbd "C-M-r") 'cider-refresh)))
