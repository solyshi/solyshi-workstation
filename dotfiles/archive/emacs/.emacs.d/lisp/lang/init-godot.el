;;; init-godot.el --- Godot -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package gdscript-mode
  :ensure t
  :mode ("\\.gd\\'" . gdscript-ts-mode)
  :config
  (setq gdscript-docs-local-path "/home/solyshi/Documents/godot")
  (add-hook 'gdscript-mode-hook 'lsp-deferred)
  (add-hook 'gdscript-ts-mode-hook 'lsp-deferred))

(provide 'init-godot)
;;; init-godot.el ends here
