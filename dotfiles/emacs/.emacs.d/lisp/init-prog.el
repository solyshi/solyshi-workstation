;;; init-prog.el --- Programming & LSP -*- lexical-binding: t -*-
;;; Commentary:
;;; Configures LSP, DAP, Tree-sitter, flycheck, snippets, and dev docs.
;;; Code:

;; --- LSP ---
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((python-ts-mode c++-ts-mode c-ts-mode java-ts-mode js-ts-mode cmake-ts-mode typescript-ts-mode tsx-ts-mode web-mode css-ts-mode json-ts-mode) . lsp-deferred)
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-enable-completion-at-point t)
  (lsp-enable-which-key-integration t)
  (lsp-semantic-tokens-enable nil)
  (lsp-gdscript-port 6005)
  (lsp-typescript-preferences-quote-style "single")
  (lsp-typescript-preferences-import-module-specifier "relative")
  (lsp-enable-file-watchers nil)
  (lsp-file-watch-threshold 2000)
  (lsp-file-watch-ignored-directories '("[/\\\\]\\.git$" "[/\\\\]\\.gradle$" "[/\\\\]build$" "[/\\\\]out$" "[/\\\\]bin$" "[/\\\\]target$"))
  (lsp-keep-workspace-alive nil))

;; --- Debugging ---
(use-package dap-mode
  :ensure t
  :after lsp-mode
  :commands dap-debug
  :config
  (setq dap-auto-configure-features '(sessions locals breakpoints))
  ;; Optional: load language-specific adapters, e.g., Python or C++
  ;; (require 'dap-python)
  ;; (require 'dap-cpptools)
  )

;; --- LSP UI ---
(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :commands lsp-ui-mode
  :config
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
  (setq lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-code-actions nil
        lsp-ui-doc-enable nil
        lsp-ui-doc-delay 0.2
        lsp-ui-doc-show-with-cursor t
        lsp-ui-doc-show-with-mouse nil))


;; --- Syntax checking ---
(use-package flycheck
  :ensure t
  :hook (after-init . global-flycheck-mode)
  :config
  (setq flycheck-javascript-eslint-executable "eslint_d"))

;; --- Tree-sitter ---
(use-package treesit-auto
  :ensure t
  :config
  (global-treesit-auto-mode)
  (treesit-auto-add-to-auto-mode-alist 'all))

;; --- Documentation ---
(use-package devdocs
  :ensure t
  :bind ("C-h D" . devdocs-lookup)
  :custom
  (devdocs-window-select t)
  :config
  (add-to-list 'completion-category-overrides '(devdocs (styles . (flex)))))

;; --- Bug reference integration ---
(use-package bug-reference
  :ensure nil
  :bind (:map bug-reference-map
              ("C-c C-o" . bug-reference-push-button)))

;; --- Quickrun ---
(use-package quickrun
  :ensure t
  :bind ("C-c x" . quickrun)
  :custom
  (quickrun-focus-p nil)
  (quickrun-input-file-extensions ".qr")
  :config
  (quickrun-add-command
    "cmake-root"
    '((:command . "cmake")
      (:exec . (
                "cmake -S . -B build"
                "cmake --build build"
                "build/%e"
                ))
      (:cd . (lambda ()
               (file-name-directory
                (locate-dominating-file default-directory "CMakeLists.txt")))))
    :mode 'c++-mode))
;; --- Snippets ---
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

;; --- Language-specific configs ---
(dolist (lang-init '(init-cpp init-flutter init-elisp init-python init-godot init-java init-frontend))
  (require lang-init))

(provide 'init-prog)
;;; init-prog.el ends here
