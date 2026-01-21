;;; early-init.el --- Emacs 27+ pre-initialization config -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Performance
(setq gc-cons-threshold most-positive-fixnum
      read-process-output-max (* 4 1024 1024)
      frame-inhibit-implied-resize t)

;; UI minimalism
(dolist (param '((menu-bar-lines . 0)
                 (tool-bar-lines . 0)
                 (vertical-scroll-bars . nil)))
  (push param default-frame-alist))

;; Package manager control
(setq package-enable-at-startup nil)

(provide 'early-init)
;;; early-init.el ends here

