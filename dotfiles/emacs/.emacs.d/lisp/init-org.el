;;; init-org.el --- Org mode configurations -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; --- Org Core ---
(defvar org-directory "~/.org/")
(defvar org-tasks-file (expand-file-name "tasks.org" org-directory))
(defvar org-default-notes-file (expand-file-name "notes.org" org-directory))

(use-package org
  :ensure nil
  :hook (org-mode . visual-line-mode)
  :custom
  (org-src--tab-width 8)
  (org-startup-indented t)
  (org-fontify-todo-headline nil)
  (org-fontify-done-headline t)
  (org-fontify-whole-heading-line t)
  (org-fontify-quote-and-verse-blocks t)
  (org-list-demote-modify-bullet '(("+" . "-") ("1." . "a.") ("-" . "+")))
  (org-todo-keywords '((sequence "TODO(t)" "WIP(i!)" "DONE(d!)" "CANCELLED(c@/!)")))
  (org-todo-keyword-faces '(("TODO" :foreground "#7c7c75" :weight bold)
                            ("WIP"  :foreground "#0098dd" :weight bold)
                            ("DONE" :foreground "#50a14f" :weight bold)
                            ("CANCELLED" :foreground "#ff6480" :weight bold)))
  (org-use-fast-todo-selection 'expert)
  (org-enforce-todo-dependencies t)
  (org-enforce-todo-checkbox-dependencies t)
  (org-priority-faces '((?A :foreground "red") (?B :foreground "orange") (?C :foreground "yellow")))
  (org-log-repeat 'time)
  (org-pretty-entities t)
  (org-hide-emphasis-markers t)
  (org-refile-use-cache nil)
  (org-refile-allow-creating-parent-nodes 'confirm)
  (org-use-fast-tag-selection t)
  (org-fast-tag-selection-single-key t)
  (org-link-abbrev-alist '(("GitHub" . "https://github.com/")
                           ("Google" . "https://google.com/search?q=")))
  :config
  ;; Org Capture Templates
  (setq org-capture-templates
        `(("t" "Todo" entry (file+headline ,org-tasks-file "Tasks")
           "* TODO %?\n  %U\n  %a")
          ("n" "Note" entry (file+headline ,org-default-notes-file "Notes")
           "* %? :NOTE:\n  %U\n  %a")))

  ;; Habit support
  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit t))

;; --- Org Agenda ---
(use-package org-agenda
  :ensure nil
  :hook (org-agenda-finalize . org-agenda-to-appt)
  :custom
  (org-agenda-files (list org-tasks-file))
  (org-agenda-diary-file (expand-file-name "diary.org" org-directory))
  (org-agenda-insert-diary-extract-time t))

;; --- Org Super Agenda ---
(use-package org-super-agenda
  :ensure t
  :after org-agenda
  :config
  (org-super-agenda-mode)
  (setq org-super-agenda-groups
        '((:name "Today" :time-grid t :todo "TODAY")
          (:name "Important" :tag "bills" :priority "A")
          (:order-multi (2
                         (:name "Shopping in town" :and (:tag "shopping" :tag "@town"))
                         (:name "Food-related" :tag ("food" "dinner"))
                         (:name "Personal" :habit t :tag "personal")
                         (:name "Space-related (non-moon-or-planet-related)" :and (:regexp ("space" "NASA") :not (:regexp "moon" :tag "planet")))))
          (:todo "WAITING" :order 8)
          (:todo ("SOMEDAY" "TO-READ" "CHECK" "TO-WATCH" "WATCHING") :order 9)
          (:priority<= "B" :order 1))))

(provide 'init-org)
;;; init-org.el ends here
