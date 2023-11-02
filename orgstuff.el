(defun org-insert-source-block (name language switches header)
  "Asks name, language, switches, header.
Inserts org-mode source code snippet"
  (interactive "sname? 
slanguage? 
sswitches? 
sheader? ")
  (insert 
   (if (string= name "")
       ""
     (concat "#+NAME: " name) )
   (format "
#+BEGIN_SRC %s %s %s

#+END_SRC" language switches header
)
   )
  (forward-line -1)
  (goto-char (line-end-position))
  )

(setq org-startup-folded t)
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(setq calendar-week-start-day 1)


(setq package-check-signature nil)


(require 'epa-file)
(setq epg-pinentry-mode 'loopback)
(epa-file-enable)
(setq epg-gpg-program "/opt/homebrew/bin/gpg") ; replace with actual path to gpg if different
(setq plstore-cache-passphrase-for-symmetric-encryption t)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")


(setq plstore-cache-passphrase-for-symmetric-encryption t)

(setq org-gcal-fetch-file-alist '(("viacheslavlitvinov@gmail.com" .  "~/Dropbox/notes/journal/google.org")))

(use-package org-gcal
  :ensure t
  :config
  (setq org-gcal-client-id "472645061701-dt2259sg9v4bndgheurg4gmc4l8rvi3k.apps.googleusercontent.com"
        org-gcal-client-secret "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"
        org-gcal-file-alist '(("viacheslavlitvinov@gmail.com" .  "~/Dropbox/notes/journal/google.org"))))



;; (use-package 'org-gcal)

(add-hook 'org-agenda-mode-hook (lambda () (org-gcal-sync) ))
(add-hook 'org-capture-after-finalize-hook (lambda () (org-gcal-sync) ))

;; (setq org-agenda-files (list "~/Dropbox/notes/journal/planner.org"
;; "~/Dropbox/notes/journal/i.org"
;; "~/Dropbox/notes/journal/schedule.org"
;; "~/Dropbox/notes/journal/gcal.org"))


(setq org-capture-templates
'(("a" "Appointment" entry (file  "~/Dropbox/notes/journal/google.org" )
"* %?\n\n%^T\n\n:PROPERTIES:\n\n:END:\n\n")
("l" "Link" entry (file+headline "~/Dropbox/notes/journal/links.org" "Links")
"* %? %^L %^g \n%T" :prepend t)
("t" "To Do Item" entry (file+headline "~/Dropbox/notes/journal/planner.org" "To Do")
"* TODO %?\n%u" :prepend t)
("n" "Note" entry (file+headline "~/Dropbox/notes/journal/planner.org" "Note space")
"* %?\n%u" :prepend t)))

(org-gcal-reload-client-id-secret)
