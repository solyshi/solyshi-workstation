;;; init-core.el --- Core Emacs settings -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; Make Emacs inherit PATH from your shell (for Linux/macOS)
(when (memq window-system '(x w32 ns))
  (use-package exec-path-from-shell
    :ensure t
    :config
    (exec-path-from-shell-initialize)))

;; --- GUI & startup ---
(setq use-file-dialog nil
      use-dialog-box nil
      inhibit-x-resources t
      inhibit-default-init t
      inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-buffer-menu t
      ring-bell-function 'ignore
      blink-cursor-mode nil
      use-short-answers t)

;; --- Linux / GTK tweaks ---
(setq x-gtk-use-system-tooltips nil
      x-gtk-use-native-input t
      x-underline-at-descent-line t)

;; --- File handling ---
(setq make-backup-files nil
      auto-save-default nil
      create-lockfile nil
      load-prefer-newer t)

;; --- Clipboard compatibility ---
(setq select-enable-primary t
      select-enable-clipboard t)

;; --- Performance ---
(setq inhibit-compacting-font-caches t
      display-raw-bytes-as-hex t
      redisplay-skip-fontification-on-input t)

;; --- Smooth scrolling ---
(setq scroll-step 2
      scroll-margin 2
      hscroll-step 2
      hscroll-margin 2
      scroll-conservatively 101
      scroll-preserve-screen-position 'always)

;; --- Text defaults ---
(setq-default fill-column 80
              indent-tabs-mode nil
              tab-width 4)

;; --- Font ---
(set-face-attribute 'default nil
                    :family "JetBrainsMono Nerd Font"
                    :height 120
                    :weight 'normal
                    :width 'normal)
(add-to-list 'default-frame-alist '(font . "JetBrainsMono Nerd Font"))

;; --- Minibuffer & input ---
(setq y-or-n-p-use-read-key t
      read-char-choice-use-read-key t)

(use-package emacs
  :custom
  (context-menu-mode 1)
  (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

;; --- Keep .emacs.d clean ---
(use-package no-littering
  :ensure t
  :demand t)

;;;; Force compilation window to 10% width on the right + auto-focus

(setq compilation-scroll-output 'first-error)

(defun solyshi/display-compilation-buffer (buffer _alist)
  (let ((window
         (display-buffer-in-side-window
          buffer
          '((side . right)
            (slot . 0)
            (window-width . 0.30)))))
    (select-window window)
    window))

(setq display-buffer-alist
      '(("\\*compilation\\*"
         solyshi/display-compilation-buffer)))


;;;; Make Evil "q" close the compilation window instantly

(with-eval-after-load 'evil
  (evil-define-key 'normal compilation-mode-map
    (kbd "q") #'quit-window))


(provide 'init-core)
;;; init-core.el ends here
