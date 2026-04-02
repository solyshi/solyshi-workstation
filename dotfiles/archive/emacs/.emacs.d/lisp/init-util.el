;;; init-util.el --- Utilities & enhancements -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; --- Which-key ---
(use-package which-key
  :ensure t
  :demand t
  :custom
  (which-key-idle-delay 0.2)
  (which-key-max-description-length 40)
  :config
  (which-key-mode))

;; --- Helpful ---
(use-package helpful
  :ensure t
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-key] . helpful-key)
  ([remap describe-command] . helpful-command)
  ([remap describe-callable] . helpful-callable))

;; --- TODO highlighting ---
(use-package hl-todo
  :ensure t
  :hook (after-init . global-hl-todo-mode)
  :bind (:map hl-todo-mode-map
              ("C-c t p" . hl-todo-previous)
              ("C-c t n" . hl-todo-next)
              ("C-c t i" . hl-todo-insert)
              ("C-c t o" . hl-todo-occur)
              ("C-c t s" . hl-todo-rgrep))
  :custom
  (hl-todo-keyword-faces
   '(("TODO" . "#7c7c75")
     ("WIP" . "#0098dd")
     ("FIXME" . "#ff6480")
     ("NOTE" . "#50a14f"))))

(electric-pair-mode 1)

;; --- Optional utilities ---
;; (use-package symbol-overlay
;;   :ensure t
;;   :hook (prog-mode . symbol-overlay-mode))

(provide 'init-util)
;;; init-util.el ends here
