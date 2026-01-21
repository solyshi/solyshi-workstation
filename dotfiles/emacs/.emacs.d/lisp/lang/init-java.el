;;; init-java.el --- Java -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:


(use-package lsp-java
  :ensure t
  :custom
  (lsp-java-import-gradle-enabled t)
  (lsp-java-gradle-wrapper-enabled t)
  (lsp-java-autobuild-enabled t)
  (lsp-java-save-actions-organize-imports t)
  :config
  (setq lsp-java-java-path "/usr/lib/jvm/default-runtime/bin/java")
  (setq lsp-java-vmargs
        '("-Xms512m"
          "-Xmx4G"
          "-XX:+UseG1GC"
          "-XX:MaxGCPauseMillis=150"
          "-XX:G1HeapRegionSize=8m"
          "-XX:+HeapDumpOnOutOfMemoryError"))
  (setq lsp-session-file (expand-file-name ".lsp-session" user-emacs-directory))
  (add-hook 'java-ts-mode-hook 'lsp-deferred))

(with-eval-after-load 'lsp-java
  (setq lsp-java-completion-favorite-static-members
        (vconcat
         lsp-java-completion-favorite-static-members
         '[
           "org.lwjgl.glfw.GLFW.*"
           "org.lwjgl.opengl.GL11.*"
           "org.lwjgl.opengl.GL15.*"
           "org.lwjgl.opengl.GL20.*"
           "org.lwjgl.opengl.GL30.*"
           "org.lwjgl.system.MemoryUtil.*"
           "org.lwjgl.system.MemoryStack.*"
           "org.lwjgl.glfw.Callbacks.*"
           ])))

(use-package gradle-mode
  :ensure t
  :hook
  (java-ts-mode . gradle-mode))

(use-package groovy-mode
  :ensure t
  :mode "\\.gradle\\'")

(provide 'init-java)
;;; init-java.el ends here
