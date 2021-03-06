(package-initialize)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                     ("melpa" . "https://melpa.org/packages/")))
(require 'use-package)
(setq use-package-always-ensure t)


(tool-bar-mode -1)
(toggle-scroll-bar -1)
(setq inhibit-startup-screen t)
(setq split-width-threshold nil) ;; split vertically by default
(show-paren-mode 1) ;; show parentheses pairs
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
;; (setq display-line-numbers-type nil)
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))
(setq-default truncate-lines 0)
(setq make-backup-files nil)


;; Position on startup
(add-to-list 'default-frame-alist '(left   . 200))
(add-to-list 'default-frame-alist '(top    . 100))
(add-to-list 'default-frame-alist '(height . 55))
(add-to-list 'default-frame-alist '(width  . 160))
;; (add-to-list 'default-frame-alist '(fullscreen . maximized)) ;; fullscreen


(use-package minimal-theme :ensure)
(load-theme 'minimal-light t)
;; (use-package distinguished-theme :ensure)
;; (load-theme 'distinguished t)
;; Other themes
;; - modus-vivendi-theme (modus-vivendi)
;; - espresso-theme (espresso)
;; - gruber-darker (gruber-darker)
;; - distinguished-theme (distinguished)

(set-frame-font "Ubuntu Mono 18" nil t)
;; Other fonts
;; - Ubuntu Mono 18
;; - PragmataPro 19
;; - Hack 16
;; - JetBrains Mono 15



(setq whitespace-style (quote (face spaces tabs newline space-mark tab-mark)))
(setq ring-bell-function 'ignore)
(blink-cursor-mode 0)


;; Modeline
(use-package all-the-icons)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(setq doom-modeline-height 10)
(put 'upcase-region 'disabled nil)


(global-set-key (kbd "C-x g") 'magit-status)

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
 '(cursor ((t (:background "#5e6170"))))
 '(flycheck-error ((t (:underline "Red1"))))
 '(flycheck-info ((t (:underline "ForestGreen"))))
 '(flycheck-warning ((t (:underline "DarkOrange"))))
 '(font-lock-string-face ((t (:foreground "DarkRed" :background nil))))
 '(fringe ((t (:background "#ffffff" :foreground "#453d41"))))
 '(helm-bookmark-directory ((t (:background "#ffffff" :foreground "#F93232"))))
 '(helm-buffer-directory ((t (:background "white" :foreground "#F93232"))))
 '(helm-ff-directory ((t (:extend t :background "white" :foreground "DarkRed"))))
 '(helm-ff-dotted-directory ((t (:extend t :background "white" :foreground "black"))))
 '(helm-ff-dotted-symlink-directory ((t (:extend t :background "white" :foreground "DarkOrange"))))
 '(helm-ff-executable ((t (:extend t :foreground "darkgreen"))))
 '(helm-ff-file-extension ((t (:extend t :foreground "darkred"))))
 '(helm-ff-invalid-symlink ((t (:foreground "red3"))))
 '(helm-selection ((t (:extend t :background "#C9D0D9" :distant-foreground "black"))))
 '(helm-source-header ((t (:extend t :foreground "black" :weight bold :height 1.1))))
 '(line-number ((t (:background "#ffffff" :foreground "#a8a8a8"))))
 '(whitespace-space ((t (:background "#ffffff" :foreground "windowBackgroundColor")))))



(setq lsp-keymap-prefix "s-l")
(setq lsp-prefer-flymake nil)
(use-package lsp-mode
  :config
  (lsp-register-custom-settings
   '(("pyls.plugins.pyls_mypy.enabled" t t)
     ("pyls.plugins.pyls_mypy.live_mode" nil t)
     ("pyls.plugins.pyls_black.enabled" t t)
     ("pyls.plugins.pyls_isort.enabled" t t)
     ("pyls.plugins.flake8.enabled" t t)))

  ;; Custom LSP settings
  (setq lsp-clients-python-library-directories "/Users/slava/.pyenv/shims/python")
  (setq lsp-pyls-server-command "/Users/slava/.pyenv/shims/pyls")
  (setq lsp-pyls-configuration-sources "/Users/slava/.pyenv/shims/pycodestyle")

  (setq lsp-clients-clangd-executable "/usr/local/opt/llvm/bin/clangd")
  (setq lsp-clients-clangd-args '("-j=4" "-background-index" "-log=error"))

  :hook ((c++-mode . lsp)
	 (c-mode . lsp)
	 (python-mode . lsp))

  :commands lsp)
(setq lsp-pyls-plugins-flake8-enabled t)

(use-package lsp-ui :commands lsp-ui-mode :ensure t)
(use-package helm-lsp :commands helm-lsp-workspace-symbol)
(use-package company-lsp)
(use-package flycheck-pycheckers)
(use-package format-all)
(use-package which-key)
(use-package lsp-docker)
(use-package flycheck)
(use-package yaml-mode)
(use-package dockerfile-mode)
;; (use-package lsp-python-ms)


;; PYTHON
(setq python-shell-interpreter "/Users/slava/.pyenv/shims/python")
(add-hook 'python-mode-hook
	  (lambda ()
	    (whitespace-mode)))


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
          treemacs-width                         35
          treemacs-workspace-switch-cleanup      nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (display-line-numbers-mode -1)

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


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(lsp-docker which-key yaml-mode use-package modus-vivendi-theme minimal-theme lsp-ui lsp-ivy helm-themes helm-lsp helm-ag format-all flycheck-pycheckers espresso-theme doom-modeline dockerfile-mode company-lsp)))
