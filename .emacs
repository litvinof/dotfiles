(package-initialize)

(tool-bar-mode -1)
(toggle-scroll-bar -1)
(setq inhibit-startup-screen t)

;; (set-default-font "Ubuntu Mono 18")
(set-default-font "JetBrains Mono 17")
;; (set-default-font "PragmataPro 19")
;; (set-default-font "Hack 17")
(show-paren-mode 1)

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                     ("melpa" . "https://melpa.org/packages/")))


(add-to-list 'default-frame-alist '(fullscreen . maximized))

(require 'use-package)
(setq use-package-always-ensure t)


(setq make-backup-files nil)


(use-package modus-vivendi-theme :ensure)
(load-theme 'modus-vivendi t)


;; ;; An atom-one-dark theme for smart-mode-line
;; (setq sml/no-confirm-load-theme t)
;; (use-package smart-mode-line-atom-one-dark-theme :ensure t)

;; ;; smart-mode-line
;; (use-package smart-mode-line
;;   :config
;;   (setq sml/theme 'atom-one-dark)
;;   (sml/setup))


(setq whitespace-style (quote (face spaces tabs newline space-mark tab-mark)))

; Set cursor color
(set-cursor-color "#e6c079")
(setq ring-bell-function 'ignore)

; Set time to 24hrs format
(setq display-time-24hr-format t)

(blink-cursor-mode 0)
(auto-save-mode 0)


(use-package yaml-mode)
(use-package dockerfile-mode)


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

(put 'set-goal-column 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fringe ((t (:background "black" :foreground "#453d41"))))
 '(whitespace-space ((t (:background "#000000" :foreground "windowBackgroundColor")))))


(setq python-shell-interpreter "/Users/viacheslav/.pyenv/shims/python")

(setq lsp-keymap-prefix "s-l")

(use-package lsp-mode
  :config
   (lsp-register-custom-settings
   '(("pyls.plugins.pyls_mypy.enabled" t t)
     ("pyls.plugins.pyls_mypy.live_mode" nil t)
     ("pyls.plugins.pyls_black.enabled" t t)
     ("pyls.plugins.pyls_isort.enabled" t t)))

  (setq lsp-clients-python-library-directories "/Users/viacheslav/.pyenv/shims")
  (setq lsp-pyls-server-command "/Users/viacheslav/.pyenv/shims/pyls")
  (setq lsp-pyls-configuration-sources "/Users/viacheslav/.pyenv/shims/pycodestyle")

  (setq lsp-clients-clangd-executable "/usr/local/opt/llvm/bin/clangd")
  (setq lsp-clients-clangd-args '("-j=4" "-background-index" "-log=error"))

  :hook ((c++-mode . lsp)
	 (c-mode . lsp)
	 (python-mode . lsp))

  :commands lsp)


;; optionally
(use-package lsp-ui :commands lsp-ui-mode :ensure t)
;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)

(use-package company-lsp)


(add-hook 'python-mode-hook
	  (lambda ()
	    (whitespace-mode)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (dockerfile-mode doom-modeline all-the-icons which-key use-package smart-mode-line-atom-one-dark-theme modus-vivendi-theme lsp-ui lsp-python-ms lsp-ivy lsp-docker helm-lsp helm-ag gruber-darker-theme flycheck distinguished-theme dap-mode company-lsp company-c-headers))))

(use-package all-the-icons)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(setq doom-modeline-height 10)
(put 'upcase-region 'disabled nil)

