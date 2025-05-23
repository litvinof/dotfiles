(package-initialize)

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                     ("melpa" . "https://melpa.org/packages/")))
(require 'use-package)
(setq use-package-always-ensure t)

;; Install from sources
(use-package quelpa
  :ensure)

(use-package quelpa-use-package
  :demand
  :config
  (quelpa-use-package-activate-advice))


(menu-bar-mode t)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(setq inhibit-startup-screen t)
;; (setq split-width-threshold nil) ;; split vertically by default
;; (setq split-width-threshold 300) ;; split vertically by default
(show-paren-mode 1) ;; show parentheses pairs
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
;; (setq display-line-numbers-type nil)
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))
(setq-default truncate-lines 0)
(setq make-backup-files nil)


;; Position on startup
(add-to-list 'default-frame-alist '(left   . 180))
(add-to-list 'default-frame-alist '(top    . 100))
(add-to-list 'default-frame-alist '(height . 60))
(add-to-list 'default-frame-alist '(width  . 120))
;; (add-to-list 'default-frame-alist '(fullscreen . maximized)) ;; fullscreen

;; (setq default-frame-alist
;;       '((top . 0)
;;         (left . 0)
;;         (width . 80) 
;;         (height . 24)
;;         (unsplittable . nil)))

;; (setq initial-frame-alist
;;       '((top . 0)
;;         (left . 0)
;;         (width . 80)
;;         (height . 24)
;;         (unsplittable . nil)))
;; (make-frame-on-display (getenv "DISPLAY"))
;; (setq display-buffer-alist
;;       '(("." (display-buffer-same-window))))




;; THEMES
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable treemacs
  (setq doom-themes-treemacs-theme "doom-earl-grey") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(load-theme 'doom-earl-grey t)

;; (use-package distinguished-theme :ensure)
;;(use-package gruber-darker-theme :ensure)
;;(load-theme 'gruber-darker t)
;; Other themes
;; - modus-vivendi-theme (modus-vivendi)
;; - espresso-theme (espresso)
;; - gruber-darker (gruber-darker)
;; - distinguished-theme (distinguished)

(set-frame-font "Fira Code 15" nil t)
;; Other fonts
;; - Ubuntu Mono 18
;; - PragmataPro 19
;; - PragmataPro Liga 19
;; - Hack 16
;; - JetBrains Mono 17
;; - Cousine 17
;; - Iosevka 17
(use-package all-the-icons
  :if (display-graphic-p))

(setq whitespace-style (quote (face spaces tabs newline space-mark tab-mark)))
(setq ring-bell-function 'ignore)
(blink-cursor-mode 0)


;; (setq python-shell-interpreter "~/.pyenv/shims/python")
;; (setq python-python-command "~/.pyenv/shims/python")
(setq lsp-pyls-plugins-flake8-enabled nil)  ; Disable flake8, which could trigger Ruff
(setq lsp-pyls-plugins-pylint-enabled nil)  ; Disable pylint if it's related to Ruff triggering


;; Modeline
(use-package all-the-icons)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(setq doom-modeline-height 10)
(put 'upcase-region 'disabled nil)


(use-package magit)

(global-set-key (kbd "C-x g") 'magit-status)


(use-package ag)

(use-package helm
  ;; Override default key bindings with those from Helm
  :bind (("C-h a"   . 'helm-apropos)
         ("C-h f"   . 'helm-apropos)
         ("C-h r"   . 'helm-info-emacs)
         ("C-x C-f" . 'helm-find-files)
         ("M-x"     . 'helm-M-x)
         ("C-x b"   . 'helm-mini)))
(use-package helm-ag)
(setq helm-split-window-in-side-p           t
      helm-buffers-fuzzy-matching           t
      helm-move-to-line-cycle-in-source     t
      helm-ff-search-library-in-sexp        t
      helm-ff-file-name-history-use-recentf t
      helm-autoresize-max-height            0
      helm-autoresize-min-height            40
      recentf-max-saved-items               100)

(add-hook 'after-init-hook '(lambda ()
                              (helm-mode 1)
                              (helm-autoresize-mode 1)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-code-face ((t (:extend t :background "gray91" :foreground "#886A44"))))
 '(whitespace-newline ((t (:foreground "gray93"))))
 '(whitespace-space ((t (:foreground "gray93"))))
 '(whitespace-tab ((t (:foreground "gray93")))))

(use-package typescript-mode
  :after lsp-mode
  :mode ("\.ts$")
  :hook (typescript-mode . lsp-deferred))

(setq lsp-keymap-prefix "s-l")
(setq lsp-prefer-flymake nil)
(use-package lsp-mode
  :config

  (setq lsp-clients-clangd-executable "/opt/homebrew/opt/llvm/bin/clangd")
  (setq lsp-clients-clangd-args '("-j=4" "-background-index" "-log=error"))

  :hook ((c++-mode . lsp)
	 (c-mode . lsp)
	 (python-mode . lsp)
	 (js-mode . lsp)
	 (js-jsx-mode . lsp)
  	 (typescript-mode . lsp))
  :commands lsp)


(setq lsp-eldoc-enable-hover nil)
(setq
    lsp-signature-auto-activate t
    lsp-signature-doc-lines 1)

(with-eval-after-load 'js
  (define-key js-mode-map (kbd "M-.") nil))


(use-package lsp-ui :commands lsp-ui-mode :ensure t)
(use-package helm-lsp :commands helm-lsp-workspace-symbol)
(use-package company)
(use-package flycheck-pycheckers)
(use-package format-all)
(use-package which-key)
(use-package lsp-docker)
(use-package flycheck)
(use-package yaml-mode)
(use-package dockerfile-mode)


;; SCHEME
(add-hook 'scheme-mode-hook
          (lambda ()
            (set (make-local-variable 'compile-command)
                 (concat "chez --script " buffer-file-name))))

;; PYTHON
;; (use-package lsp-pyright
;;   :ensure t
;;   :hook (python-mode . (lambda ()
;;                           (require 'lsp-pyright)
;;                           (lsp))))  ; or lsp-deferred


;; TREEMACS
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-forward-on-expand        nil
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              0
          treemacs-user-mode-line-format         nil
          treemacs-user-header-line-format       nil
          treemacs-width                         40
          treemacs-workspace-switch-cleanup      nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    ;; (display-line-numbers-mode -1) -> 

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))
(use-package lsp-treemacs)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-checker-error-threshold 2000)
 '(flycheck-python-flake8-executable "~/.pyenv/shims/python")
 '(flycheck-python-pycompile-executable "~/.pyenv/shims/python")
 '(flycheck-python-pylint-executable "~/.pyenv/shims/python")
 '(org-agenda-files '("/Users/slava/Dropbox/notes/journal"))
 '(org-agenda-window-setup 'current-window)
 '(org-export-backends '(ascii html icalendar latex md))
 '(package-selected-packages
   '(dap-cpptools dap-mode smart-compile lsp-yaml k8s-mode ligature copilot editorconfig typescript-mode org-mode ag char-menu rjsx-mode magit company lsp-treemacs distinguished-theme lsp-docker which-key yaml-mode use-package modus-vivendi-theme minimal-theme lsp-ui lsp-ivy helm-themes helm-lsp helm-ag format-all espresso-theme doom-modeline dockerfile-mode company-lsp))
 '(warning-suppress-log-types '(((copilot copilot-no-mode-indent)) (lsp-mode) (lsp-mode)))
 '(warning-suppress-types '((emacs) (lsp-mode))))

(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))

(global-set-key [C-f1] 'show-file-name) ; Or any other key you want


;; Load pragmatapro-lig.el
(add-to-list 'load-path "~/.emacs.d/prettyfonts")
(require 'pragmatapro-lig)

;; Enable pragmatapro-lig-mode for specific modes
;; (add-hook 'text-mode-hook 'pragmatapro-lig-mode)
;; (add-hook 'prog-mode-hook 'pragmatapro-lig-mode)
;; or globally

;;(pragmatapro-lig-global-mode)
;; (add-to-list 'load-path "~/.emacs.d/prettyfonts/iosevka.el")

;; Enable ligatures for Fira Code
(use-package ligature
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures 't '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
                                     ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
                                     "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
                                     "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**"
                                     "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
                                     "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
                                     "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
                                     "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
                                     "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
                                     "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))


(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(put 'downcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)


;; Load moving lines up or down
(load "/Users/viacheslav.litvinov/dotfiles/move-lines.el")


;; Compile window
;; (load "/Users/viacheslav.litvinov/dotfiles/compile-window.el")

;; Vertically split by default
(setq split-width-threshold 0)
(setq split-height-threshold nil)

(require 'quelpa-use-package)
(setq-default quelpa-build-tar-executable "/opt/homebrew/bin/gtar")
(use-package copilot
  :quelpa (copilot :fetcher github
                   :repo "zerolfx/copilot.el"
                   :branch "main"
                   :files ("dist" "*.el")))
(setq-default quelpa-build-tar-executable "/opt/homebrew/bin/gtar")
(add-hook 'yaml-mode-hook 'copilot-mode)
(add-hook 'c++-mode-hook 'copilot-mode)
(add-hook 'prog-mode-hook 'copilot-mode)
(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)
(add-to-list
 'copilot-indentation-alist
 '(go-mode 4)
 '(prog-mode 4))


;; White space for yaml
(add-hook 'yaml-mode-hook 'whitespace-mode)


(add-hook 'yaml-mode-hook 'lsp)

;; (use-package smart-compile)
;; (require 'compile)
;; (setq compilation-last-buffer nil)
;; ;; save all modified buffers without asking before compilation
;; (setq compilation-ask-about-save nil)
;; (defun compile-again (ARG)
;;   "Run the same compile as the last time.

;; With a prefix argument or no last time, this acts like M-x compile,
;; and you can reconfigure the compile args."
;;   (interactive "p")
;;   ;; the following two lines create bug: split a new window every time
;;   ;; (if (not (get-buffer-window "*compilation*"))
;;   ;;      (split-window-below))
;;   (if (and (eq ARG 1) compilation-last-buffer)
;;       (recompile)
;;     (call-interactively 'smart-compile)))
;; (bind-key* "C-x C-m" 'compile-again)
;; ;; create a new small frame to show the compilation info
;; ;; will be auto closed if no error
;; (setq special-display-buffer-names
;;       `(("*compilation*" . ((name . "*compilation*")
;;                             ,@default-frame-alist
;;                             ;; (left . (- 1))
;;                             (top . 0)))))
;; (setq compilation-finish-functions
;;       (lambda (buf str)
;;         (if (null (string-match ".*exited abnormally.*" str))
;;             ;;no errors, make the compilation window go away in a few seconds
;;             (progn
;;               (run-at-time
;;                "1 sec" nil 'delete-windows-on
;;                (get-buffer-create "*compilation*"))
;;               (message "No Compilation Errors!")))))

;; (use-package dap-mode)
;; (require 'dap-cpptools)
;; (require 'dap-gdb-lldb)
