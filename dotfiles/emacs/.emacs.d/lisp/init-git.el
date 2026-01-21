;;; init-git.el --- Git / Magit etc. -*- lexical-binding: t -*-
;;; Comment:
;;; Code:

(use-package transient
  :ensure t)

(use-package magit
  :ensure t
  :after transient)

(use-package diff-hl
  :ensure t
  :after magit
  :defer t
  :hook ((magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (global-diff-hl-mode 1))

(provide 'init-git)
;;; init-git.el ends here
