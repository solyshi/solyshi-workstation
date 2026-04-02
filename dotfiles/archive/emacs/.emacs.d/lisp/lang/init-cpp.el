;;; init-cpp.el --- C/C++ / Build Tools -*- lexical-binding: t -*-
;;; Commentary:
;;; Modular configuration for C/C++, CMake, LSP, compiler output, and snippets.
;;; Code:

;; ----------------------------
;; CC-MODE & GENERAL C/C++ SETTINGS
;; ----------------------------
(use-package cc-mode
  :ensure nil
  :hook ((c-mode   . (lambda ()
                       (setq comment-start "// "
                             comment-end "")))
         (c++-mode . (lambda ()
                       (setq comment-start "// "
                             comment-end ""))))
  :config
  ;; Auto-mode associations
  (dolist (ext '("\\.cpp\\'" "\\.cc\\'" "\\.cxx\\'" "\\.hpp\\'" "\\.h\\'"))
    (add-to-list 'auto-mode-alist `(,ext . c++-mode)))
  ;; Indentation and offsets
  (setq c-basic-offset 4
        c-label-minimum-indentation 0
        c-comment-prefix-regexp '((c-mode   . "//+!?\\|\\**")
                                  (c++-mode . "//+!?\\|\\**")
                                  (awk-mode . "#+")
                                  (other    . "//+\\|\\**"))
        c-doc-comment-style '((c-mode . gtkdoc)
                              (c++-mode . doxygen))
        c-offsets-alist
        '((c                 . c-lineup-C-comments)
          (string            . c-lineup-dont-change)
          (defun-open        . 0)
          (defun-close       . 0)
          (defun-block-intro . +)
          (class-open        . 0)
          (class-close       . 0)
          (access-label      . -)
          (inline-open       . 0)
          (inline-close      . 0)
          (inclass           . +)
          (friend            . 0)
          (func-decl-cont    . +)
          (brace-list-open   . 0)
          (brace-list-close  . 0)
          (brace-list-intro  . +)
          (brace-list-entry  . 0)
          (brace-entry-open  . 0)
          (namespace-open    . 0)
          (namespace-close   . 0)
          (innamespace       . 0)
          (block-open        . 0)
          (block-close       . 0)
          (topmost-intro     . 0)
          (topmost-intro-cont. c-lineup-topmost-intro-cont)
          (member-init-intro . +)
          (member-init-cont  . c-lineup-multi-inher)
          (inher-intro       . +)
          (inher-cont        . c-lineup-multi-inher)
          (statement         . 0)
          (statement-cont    . (c-lineup-ternary-bodies +))
          (statement-block-intro . +)
          (statement-case-intro  . +)
          (statement-case-open   . +)
          (substatement          . +)
          (substatement-open     . 0)
          (substatement-label    . 0)
          (case-label            . 0)
          (label                 . 0)
          (do-while-closure      . 0)
          (else-clause           . 0)
          (catch-clause          . 0)
          (comment-intro         . c-lineup-comment)
          (arglist-intro         . +)
          (arglist-cont          . 0)
          (arglist-cont-nonempty . c-lineup-arglist)
          (arglist-close         . c-lineup-close-paren)
          (stream-op             . c-lineup-streamop)
          (cpp-macro             . -1000)
          (cpp-macro-cont        . +)
          (extern-lang-open      . 0)
          (extern-lang-close     . 0)
          (inextern-lang         . 0)
          (inlambda              . 0)
          (lambda-intro-cont     . +)
          (inexpr-statement      . 0)
          (template-args-cont    . (c-lineup-template-args +)))))

;; ----------------------------
;; LSP / COMPLETION
;; ----------------------------
(with-eval-after-load 'lsp-mode
  (let ((clangd-args '("-j=2" "--background-index" "--clang-tidy"
                       "--completion-style=bundled" "--header-insertion-decorators"))
        (ccls-args nil))
    (cond ((executable-find "clangd")
           (setq lsp-clients-clangd-executable "clangd"
                 lsp-clients-clangd-args clangd-args))
          ((executable-find "ccls")
           (setq lsp-clients-clangd-executable "ccls"
                 lsp-clients-clangd-args ccls-args)))))

;; ----------------------------
;; COMPILER OUTPUT VIEWER
;; ----------------------------
(use-package rmsbolt
  :ensure t
  :commands rmsbolt-compile
  :custom
  (rmsbolt-asm-format nil)
  (rmsbolt-default-directory temporary-file-directory))

;; ----------------------------
;; PARSER / LANGUAGE MODES
;; ----------------------------
(use-package bison-mode
  :ensure t
  :mode (("\\.l\\'" . flex-mode)
         ("\\.y\\'" . bison-mode)))

(use-package llvm-mode
  :ensure nil
  :mode ("\\.ll\\'" . llvm-mode))

(use-package tablegen-mode
  :ensure nil
  :mode ("\\.td\\'" . tablegen-mode))

;; ----------------------------
;; CONDITIONAL COMPILATION
;; ----------------------------
(use-package hideif
  :ensure nil
  :hook ((c-mode c++-mode) . hide-ifdef-mode)
  :custom
  (hide-ifdef-initially nil)
  (hide-ifdef-shadow t)
  :config
  ;; Linux / Clang detection
  (dolist (pair (cond
                 ((eq system-type 'gnu/linux) '((__linux__ . 1) (__GNUC__ . 11)))
                 ((eq system-type 'darwin) '((__APPLE__ . 1) (__clang__ . 1) (__llvm__ . 1)))))
    (add-to-list 'hide-ifdef-env pair)))

;; ----------------------------
;; SNIPPETS (TEMPO)
;; ----------------------------
(use-package tempo
  :ensure nil
  :hook ((c-mode   . c-mode-tempo-setup)
         (c++-mode . c++-mode-tempo-setup)
         (cmake-mode . cmake-mode-tempo-setup))
  :config
  (defvar c-tempo-tags nil)
  (defvar c++-tempo-tags nil)
  (defvar cmake-tempo-tags nil)

  ;; C/C++ templates
  (defun c-mode-tempo-setup ()   (tempo-use-tag-list 'c-tempo-tags))
  (defun c++-mode-tempo-setup () (tempo-use-tag-list 'c-tempo-tags)
                                  (tempo-use-tag-list 'c++-tempo-tags))

  ;; #ifndef template
  (tempo-define-template "c-ifndef"
                         '("#ifndef " (P "ifndef-clause: " clause) > n
                           "#define " (s clause) n> p n
                           "#endif // " (s clause) n>)
                         "ifndef" "Insert #ifndef #define #endif"
                         'c-tempo-tags)

  ;; extern "C" template
  (tempo-define-template "c-extern-C"
                         '("#ifdef __cplusplus" n
                           "extern \"C\" {" n
                           "#endif" n
                           p n
                           "#ifdef __cplusplus" n
                           "}" n
                           "#endif" n)
                         "externC" "Insert #ifdef __cplusplus"
                         'c-tempo-tags)

  ;; main function
  (tempo-define-template "c-main"
                         '("int main(int argc, char* argv[]) {" > n>
                           p n
                           "}" > n>)
                         "main" "Insert a main function"
                         'c-tempo-tags))

;; ----------------------------
;; CMAKE SUPPORT
;; ----------------------------
(use-package cmake-mode
  :ensure t
  :mode (("CMakeLists\\.txt\\'" . cmake-mode)
         ("\\.cmake\\'"         . cmake-mode))
  :config
  (setq-local completion-at-point-functions
              (list #'lsp-completion-at-point))
  (set-company-backends-for! cmake-mode company-cmake company-dabbrev-code company-dabbrev))

(use-package cmake-font-lock
  :ensure t
  :hook (cmake-mode . cmake-font-lock-activate))

(provide 'init-cpp)
;;; init-cpp.el ends here
