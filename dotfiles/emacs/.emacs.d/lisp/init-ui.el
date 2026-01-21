;;; init-ui.el --- Theme, modeline, and window behavior -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; --- Icons ---
(use-package nerd-icons
  :ensure t
  :when (display-graphic-p)
  :demand t)

;; --- Dashboard ---
(use-package dashboard
  :ensure t
  :init
  (dashboard-setup-startup-hook)
  :custom
  (dashboard-startup-banner 'logo)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-items '((recents . 10)
                     (projects . 5)
                     (agenda . 5)))
  (dashboard-startupify-list '(dashboard-insert-banner
                               dashboard-insert-newline
                               dashboard-insert-banner-title
                               dashboard-insert-newline
                               dashboard-insert-init-info
                               dashboard-insert-items
                               dashboard-insert-newline
                               dashboard-insert-footer)))

;; --- Themes ---
(use-package modus-themes
  :ensure t
  :init
  (modus-themes-include-derivatives-mode 1)
  :config
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs nil
        modus-themes-region '(bg-only no-extend)
        modus-themes-common-palette-overrides nil)
  (modus-themes-load-theme 'modus-vivendi-tritanopia)
  :bind
  (("<f5>" . modus-themes-rotate)
   ("C-<f5>" . modus-themes-select)
   ("M-<f5>" . modus-themes-load-random)))

;; --- Modeline ---
;;(use-package powerline
;;  :ensure t
;;  :config
;;  (powerline-center-evil-theme))

;; --- Global modes ---
(dolist (mode '(abbrev-mode column-number-mode show-paren-mode))
  (funcall mode 1))

;; Optional modern enhancements:
;; 1. Consider using doom-modeline or telephone-line for a richer, more configurable modeline:
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t))

;; 2. Enable `display-line-numbers-mode` globally for programming buffers:
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

(provide 'init-ui)
;;; init-ui.el ends here
