;;; init-evil.el --- Vim emulation -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; --- Evil core ---
(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump nil)
  :config
  (evil-mode 1))

;; --- Evil collection (mode-specific keybindings) ---
(use-package evil-collection
  :ensure t
  :after (evil dirvish)
  :config
  (evil-collection-init))

;; --- Dirvish integration ---
(with-eval-after-load 'dirvish
  (when (featurep 'evil-collection)
    (evil-collection-define-key 'normal 'dirvish-mode-map)))

(with-eval-after-load 'evil
  (defun my/evil-format-on-write (&rest _args)
    "Autoformat buffer when using :w in Evil."
    (when (and (boundp 'format-all-mode) format-all-mode)
      (format-all-buffer)))

  (advice-add 'evil-write :before #'my/evil-format-on-write))


;; --- Optional Vim enhancements ---
;; (use-package evil-surround :ensure t :config (global-evil-surround-mode 1))
;; (use-package evil-commentary :ensure t :config (evil-commentary-mode))
;; (use-package evil-visualstar :ensure t)

(provide 'init-evil)
;;; init-evil.el ends here
