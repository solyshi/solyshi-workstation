;;; init-general.el --- General Keybindings (Leader) -*- lexical-binding: t -*-
;;; Commentary: Optimized leader key configuration with global and mode-specific keys.
;;; Code:

(use-package general
  :ensure t
  :config
  ;; === Leader Definers ===
  (general-create-definer solyshi/leader
    :states '(normal visual insert emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")

  ;; Helper functions
  (defun solyshi/dirvish-toggle ()
    "Toggle Dirvish mode."
    (interactive)
    (if (derived-mode-p 'dirvish-mode) (quit-window)
      (dirvish)))

  (defun solyshi/project-root ()
    "Determine the project root."
    (or (when-let ((proj (project-current)))
          (project-root proj))
        (locate-dominating-file default-directory "CMakeLists.txt")
        default-directory))

;;;; Build
  (defun solyshi/cmake-build ()
    (interactive)
    (let ((root (shell-quote-argument
                 (file-truename (solyshi/project-root)))))
      (compile
       (format
        "cmake -S %s -B %s/build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && cmake --build %s/build"
        root root root))))

;;;; Executable Discovery
  (defun solyshi/cmake--first-executable (dir)
    (car
     (seq-filter
      (lambda (f)
        (and (file-executable-p f)
             (not (file-directory-p f))))
      (directory-files dir t "^[^.]"))))

;;;; Run Only (No Rebuild)
  (defun solyshi/cmake-run ()
    (interactive)
    (let* ((root (file-truename (solyshi/project-root)))
           (build-dir (expand-file-name "build" root)))
      (unless (file-directory-p build-dir)
        (error "Build directory does not exist")) (let ((exe (solyshi/cmake--first-executable build-dir))) (unless exe (error "No executable found"))
        (compile
         (format "cd %s && %s"
                 (shell-quote-argument build-dir)
                 (shell-quote-argument exe))))))

;;;; Build + Run Orchestration
  (defvar solyshi/cmake--pending-run nil)

  (defun solyshi/cmake-build-and-run ()
    (interactive)
    (setq solyshi/cmake--pending-run t)
    (solyshi/cmake-build))

  (defun solyshi/cmake--run-after-build (_buf status)
    (when (and solyshi/cmake--pending-run
               (string-match "finished" status))
      (setq solyshi/cmake--pending-run nil)
      (let* ((root (file-truename (solyshi/project-root)))
             (build-dir (expand-file-name "build" root))
             (exe (solyshi/cmake--first-executable build-dir)))
        (unless exe
          (error "Build succeeded but no executable found"))
        (compile
         (format "cd %s && %s"
                 (shell-quote-argument build-dir)
                 (shell-quote-argument exe))))))

  (add-hook 'compilation-finish-functions #'solyshi/cmake--run-after-build)


  ;; ----- TSX / React / PNPM --------
  (defun solyshi/monorepo-root ()
    "Return the root of the Turbo monorepo."
    (or (locate-dominating-file default-directory "pnpm-workspace.yaml")
        (locate-dominating-file default-directory "turbo.json")
        (solyshi/project-root)))

  (defun solyshi/find-package-json-root (&optional dir)
    "Return the directory containing the nearest package.json from DIR or default-directory."
    (let ((dir (or dir default-directory)))
      (or (locate-dominating-file dir "package.json")
          dir)))

  (defun solyshi/pnpm-dev-all ()
    "Run `pnpm dev` for the entire monorepo (all apps/packages)."
    (interactive)
    (let ((default-directory (solyshi/monorepo-root)))
      (compile "pnpm dev")))

  (defun solyshi/pnpm-dev-all-vterm ()
    "Spawn a vterm and run `pnpm dev` for the entire monorepo."
    (interactive)
    (let ((buf (vterm "*pnpm-dev-all*")))
      (with-current-buffer buf
        (let ((default-directory (solyshi/monorepo-root)))
          (vterm-send-string "pnpm dev")
          (vterm-send-return)))))


  (defun solyshi/pnpm-dev ()
    "Run `pnpm dev` in the nearest package.json folder."
    (interactive)
    (let ((default-directory (solyshi/find-package-json-root)))
      (compile "pnpm dev")))

  (defun solyshi/pnpm-dev-vterm ()
    "Spawn a vterm in nearest package.json folder and run `pnpm dev`."
    (interactive)
    (let ((buf (vterm (format "*pnpm-dev-%s*" (project-name (project-current))))))
      (with-current-buffer buf
        (let ((default-directory (solyshi/find-package-json-root)))
          (vterm-send-string "pnpm dev")
          (vterm-send-return)))))

  (defun solyshi/gradle-run-app ()
    "Run Gradle application in project context."
    (interactive)
    (gradle-execute "run"))

  ;; === Global Leader Keys ===
  (solyshi/leader
    ;; Top-level groups
    "f" '(:ignore t :which-key "files")
    "b" '(:ignore t :which-key "buffers")
    "w" '(:ignore t :which-key "windows")
    "p" '(:ignore t :which-key "project")
    "g" '(:ignore t :which-key "git")
    "s" '(:ignore t :which-key "search")
    "l" '(:ignore t :which-key "lsp")
    "T" '(:ignore t :which-key "toggles")
    "t" '(:ignore t :which-key "todo")
    "h" '(:ignore t :which-key "help")
    "o" '(:ignore t :which-key "org")

    ;; Core commands
    "B" #'pop-global-mark
    "x" #'quickrun
    "X" #'compile
    "." #'embark-act
    ";" #'embark-dwim
    ":" #'eval-expression
    "-" #'solyshi/dirvish-toggle

    ;; Buffers
    "b d" #'kill-this-buffer
    "b n" #'next-buffer
    "b p" #'previous-buffer
    "b l" #'ibuffer

    ;; Windows
    "w h" #'windmove-left
    "w l" #'windmove-right
    "w j" #'windmove-down
    "w k" #'windmove-up
    "w s" #'split-window-below
    "w v" #'split-window-right
    "w d" #'delete-window
    "w m" #'delete-other-windows

    ;; Toggles
    "T t" #'vterm
    "T T" #'modus-themes-select
    "T f" #'toggle-frame-fullscreen
    "T r" #'read-only-mode

    ;; Todo
    "t p" #'hl-todo-previous
    "t n" #'hl-todo-next
    "t i" #'hl-todo-insert
    "t o" #'hl-todo-occur
    "t s" #'hl-todo-rgrep

    ;; Projects
    "p f" #'projectile-find-file
    "p b" #'projectile-switch-to-buffer
    "p s" #'projectile-switch-project
    "p d" #'projectile-dired

    ;; LSP
    "l c" #'lsp-execute-code-action
    "l d" #'lsp-find-definition
    "l D" #'lsp-find-declaration
    "l r" #'lsp-find-references
    "l i" #'lsp-find-implementation
    "l k" #'lsp-ui-doc-focus-frame
    "l K" #'lsp-ui-doc-unfocus-frame
    "l t" #'lsp-ui-doc-toggle

    ;; Search
    "s f" #'consult-find
    "s r" #'consult-ripgrep
    "s b" #'consult-buffer
    "s g" #'consult-git-grep
    "s m" #'consult-man

    ;; Org
    "o c" #'org-capture
    "o a" #'org-agenda
    "o t" #'org-todo

    ;; Git
    "g m" #'magit
    "g c" #'magit-commit
    "g p" #'magit-push
    "g P" #'magit-pull
    "g C" #'magit-clone
    "g s" #'magit-stage
    "g S" #'magit-status
    "g b" #'magit-branch

    ;; Help / Documentation
    "h d" #'devdocs-lookup
    "h b" #'embark-bindings
    "h v" #'helpful-variable
    "h f" #'helpful-function)

  ;; === Mode-specific Leaders ===


  ;; Dirvish
  (with-eval-after-load 'dirvish
    (general-create-definer solyshi/leader-dirvish
      :states '(normal visual emacs)
      :keymaps 'dirvish-mode-map
      :prefix "SPC"
      :global-prefix "C-SPC")
    (solyshi/leader-dirvish
      "-" #'quit-window
      "f" #'dirvish-file-info-menu
      "o" #'dirvish-quick-access
      "s" #'dirvish-quicksort
      "r" #'dirvish-history-jump))

  (with-eval-after-load 'java-ts-mode
    (solyshi/leader
      :keymaps 'java-ts-mode-map
      "G r" #'solyshi/gradle-run-app
      "G R" #'gradle-run
      "G B" #'gradle-build))

  ;; Tree-Sitter C/C++
  (with-eval-after-load 'c-ts-mode
    (solyshi/leader
      :keymaps '(c-ts-mode-map c++-ts-mode-map)
      "C b" #'solyshi/cmake-build
      "C r" #'solyshi/cmake-run
      "C R" #'solyshi/cmake-build-and-run))

  ;; Dart / Flutter
  (with-eval-after-load 'dart-mode
    (solyshi/leader
      :keymaps 'dart-mode-map
      "F r" #'flutter-run-or-hot-reload
      "F R" #'flutter-run
      "F t" #'flutter-test-all
      "F T" #'flutter-test-at-point))

  ;; Godot
  (with-eval-after-load 'gdscript-ts-mode
    (solyshi/leader
      :keymaps 'gdscript-ts-mode-map
      "G r" #'gdscript-godot-run-project
      "G d" #'gdscript-godot-run-project-debug
      "G o" #'gdscript-godot-open-project-in-editor
      "G D" #'gdscript-docs-browse-api))

  ;; TypeScript / TSX
  (add-hook 'typescript-ts-mode-hook
            (lambda ()
              (solyshi/leader
                :keymaps 'typescript-ts-mode-map
                "R d" #'solyshi/pnpm-dev      ;; local package
                "R t" #'solyshi/pnpm-dev-vterm
                "R D" #'solyshi/pnpm-dev-all  ;; full monorepo
                "R T" #'solyshi/pnpm-dev-all-vterm)))

  (add-hook 'tsx-ts-mode-hook
            (lambda ()
              (solyshi/leader
                :keymaps 'tsx-ts-mode-map
                "R d" #'solyshi/pnpm-dev
                "R t" #'solyshi/pnpm-dev-vterm
                "R D" #'solyshi/pnpm-dev-all
                "R T" #'solyshi/pnpm-dev-all-vterm))))

(provide 'init-general)
;;; init-general.el ends here
