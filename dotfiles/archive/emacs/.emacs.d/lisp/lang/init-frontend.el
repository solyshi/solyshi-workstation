;;; init-frontend.el --- Frontend -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; ---------- Modes ----------
(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode))
  :config
  (setq web-mode-enable-auto-quoting nil
        web-mode-enable-auto-closing t
        web-mode-enable-current-element-highlight t))

;; ----- Formatter -----
(use-package prettier
  :ensure t
  :hook ((js-ts-mode
          typescript-ts-mode
          tsx-ts-mode
          web-mode
          css-ts-mode
          json-ts-mode) . prettier-mode)
  :custom
  (prettier-pre-warm t))

;; ---------- Emmet ----------
(use-package emmet-mode
  :ensure t
  :hook ((web-mode
          css-ts-mode
          html-ts-mode) . emmet-mode)
  :custom
  (emmet-move-cursor-between-quotes t))

;; ---------- Node project awareness ----------
(use-package add-node-modules-path
  :ensure t
  :hook ((js-ts-mode
          typescript-ts-mode
          tsx-ts-mode
          web-mode) . add-node-modules-path))

;; ---------- Tailwind CSS LSP -------------
(use-package lsp-tailwindcss
  :ensure t
  :after lsp-mode
  :custom
  (lsp-tailwindcss-add-on-mode t)
  (lsp-tailwindcss-class-regex
   '("class\\s-*[:=]\\s-*\"\\([^\"]+\\)\""
     "className\\s-*[:=]\\s-*\"\\([^\"]+\\)\""))
  :hook
  ((web-mode
    tsx-ts-mode
    typescript-ts-mode
    css-ts-mode
    html-ts-mode) . lsp-deferred))

(provide 'init-frontend)
;;; init-frontend.el ends here
