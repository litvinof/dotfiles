  (defun my-compile ()
      "Run compile and resize the compile window"
      (interactive)
      (progn
        (call-interactively 'compile)
        (setq cur (selected-window))
        (setq w (get-buffer-window "*compilation*"))
        (select-window w)
        (setq h (window-height w))
        (shrink-window (- h 10))
        (select-window cur)
        )
    )
