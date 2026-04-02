;;; init-flutter.el --- Flutter -*- lexical-binding: t -*-
;;; Commentary:
;;; Dart and Flutter development setup.
;;; Code:

(use-package dart-mode
  :ensure t
  :mode ("\\.dart\\'")
  :hook (dart-mode . lsp-deferred)
  :custom
  (dart-format-on-save t))

(use-package lsp-dart
  :ensure t
  :after lsp-mode)

(use-package flutter
  :ensure t
  :after dart-mode
  :config
  (let ((flutter-path (expand-file-name "~/development/flutter/bin")))
    (add-to-list 'exec-path flutter-path)
    (setenv "PATH" (concat flutter-path ":" (getenv "PATH"))))
  :bind (:map dart-mode-map
              ("C-M-x" . flutter-run-or-hot-reload)))

(provide 'init-flutter)
;;; init-flutter.el ends here
