;;; init-tools.el --- Utilities & terminals -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; --- History persistence ---
(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

;; --- Terminal ---
(use-package vterm
  :ensure t
  :commands (vterm)
  :bind ("M-o t" . vterm)
  :config
  (setq vterm-shell "/usr/sbin/fish"))

;; --- Optional enhancements ---
(use-package multi-vterm
  :ensure t
  :bind (("C-c v" . multi-vterm)
         ("C-c V" . multi-vterm-next)))

(use-package format-all
  :ensure t
  :config
  ;; Initialize formatter when opening programming buffers
  (add-hook 'prog-mode-hook
            (lambda ()
              (format-all-mode 1)
              ;; Force detection of the correct formatter
              (format-all-ensure-formatter)))
  (if format-all-mode
      (add-hook 'before-save-hook
                'format-all--buffer-from-hook
                nil 'local)
    (remove-hook 'before-save-hook
                 'format-all--buffer-from-hook
                 'local))
  (add-hook 'prog-mode-hook 'format-all-mode)
  (add-hook 'emacs-lisp-mode-hook 'format-all-mode)
  (add-hook 'before-save-hook 'format-all-buffer))

(provide 'init-tools)
;;; init-tools.el ends here
