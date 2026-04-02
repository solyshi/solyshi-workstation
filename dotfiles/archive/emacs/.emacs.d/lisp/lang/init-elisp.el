;;; init-elisp.el --- Emacs Lisp -*- lexical-binding: t -*-
;;; Commentary:
;;; Utilities for evaluating code and commenting results.
;;; Code:

(use-package elisp-mode
  :bind (:map emacs-lisp-mode-map
              ("C-c C-c" . eval-to-comment)
              :map lisp-interaction-mode-map
              ("C-c C-c" . eval-to-comment))
  :config
  (defconst eval-as-comment-prefix ";;=> ")

  (defun eval-to-comment ()
    "Evaluate the expression at point and insert the result as a comment."
    (interactive)
    (let ((result (eval (sexp-at-point))))
      (end-of-line)
      (insert (concat " " eval-as-comment-prefix (prin1-to-string result))))))

(provide 'init-elisp)
;;; init-elisp.el ends here
