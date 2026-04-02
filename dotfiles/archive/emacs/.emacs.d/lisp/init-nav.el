;;; init-nav.el --- Navigation, completion, and project traversal -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; --- File Tree ---
(use-package treemacs
  :ensure t
  :bind (:map global-map
              ("C-x t t" . treemacs)
              ("C-x t B" . treemacs-bookmark)
              ("C-x t f" . treemacs-find-file)))

;; --- Vertical Completion ---
(use-package vertico
  :ensure t
  :demand t
  :config
  (setq vertico-cycle t)
  (vertico-mode))

;; --- Fuzzy Matching ---
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

;; --- Annotations ---
(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

;; --- Consult ---
(use-package consult
  :ensure t
  :custom
  (consult-preview-key "M-;")
  (consult-narrow-key "<")
  :init
  (advice-add #'register-preview :override #'consult-register-window)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

;; --- Embark ---
(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; --- In-buffer completion ---
(use-package corfu
  :ensure t
  :hook (prog-mode . corfu-mode)
  :init
  (global-corfu-mode)
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 1))

(use-package cape
  :ensure t
  :init
  (setq completion-at-point-functions nil)
  (add-hook 'completion-at-point-functions #'lsp-completion-at-point)
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-history))

;; --- Projectile ---

;; (use-package project
;;  :ensure t
;;  :custom
;;  (project-switch-commands
;;   '((project-find-file "Find file")
;;     (project-find-dir "Find dir")
;;     (project-find-regexp "Grep")
;;     (project-eshell "Eshell")
;;     (magit-project-status "Magit")))
;;  (project-vc-extra-root-markers '(".project"))
;;  (add-to-list 'completion-ignored-extensions ".class")
;;  (project-vc-ignores '("build" "out" "target" "bin")))

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :custom
  ;; Globally ignore build outputs and .class files
  (projectile-globally-ignored-directories '("build" "out" "target" "bin" ".gradle"))
  (projectile-globally-ignored-file-suffixes '(".class"))
  ;; Define which actions you want when switching projects
  (projectile-switch-project-action
   #'projectile-find-file)) ; default action if you don't want prompt

(provide 'init-nav)
;;; init-nav.el ends here
