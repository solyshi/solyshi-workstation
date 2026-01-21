;;; init.el --- Main entry for Emacs -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; Package archives
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")))
(setq elpaca-repos package-archives)

(setq native-comp-async-report-warnings-errors nil)

(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Elpaca use-package support
(elpaca elpaca-use-package
  (elpaca-use-package-mode))

;; Load custom lisp dirs
(let ((dirs '("lisp" "lisp/lang")))
  (dolist (d dirs)
    (add-to-list 'load-path (expand-file-name d user-emacs-directory))))

(setq custom-file (locate-user-emacs-file "custom.el"))

;; Path adjustments (Flutter/Dart)
(dolist (p '("~/development/flutter/bin"
             "~/development/flutter/bin/cache/dart-sdk/bin"))
  (add-to-list 'exec-path p))
(setenv "PATH"
        (string-join (append '("~/development/flutter/bin/cache/dart-sdk/bin"
                               "~/development/flutter/bin")
                             (split-string (getenv "PATH") path-separator))
                     path-separator))

;; Load user modules
(dolist (mod '(init-general init-core init-evil init-ui init-org
                            init-prog init-nav init-tools init-util
                            init-dired init-git))
  (require mod))

(provide 'init)
;;; init.el ends here
