;; NOTE: init.el is now generated from Emacs.org.  Please edit that file
;;       in Emacs and init.el will be generated automatically!

;; Garbage collection
(add-hook 'focus-out-hook 'garbage-collect)

;; Use a hook so the message doesn't get clobbered by other messages.
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;; Return gc-threshold to normal value
(run-with-idle-timer
 5 nil
 (lambda ()
   (setq gc-cons-threshold (* 2 1000 1000))
   (message "gc-cons-threshold restored to %s"
            gc-cons-threshold)))

;; (use-package esup)

(eval-after-load 'ivy-rich
  (progn
    (defvar ek/ivy-rich-cache
      (make-hash-table :test 'equal))

    (defun ek/ivy-rich-cache-lookup (delegate candidate)
      (let ((result (gethash candidate ek/ivy-rich-cache)))
        (unless result
          (setq result (funcall delegate candidate))
          (puthash candidate result ek/ivy-rich-cache))
        result))

    (defun ek/ivy-rich-cache-reset ()
      (clrhash ek/ivy-rich-cache))

    (defun ek/ivy-rich-cache-rebuild ()
      (mapc (lambda (buffer)
              (ivy-rich--ivy-switch-buffer-transformer (buffer-name buffer)))
            (buffer-list)))

    (defun ek/ivy-rich-cache-rebuild-trigger ()
      (ek/ivy-rich-cache-reset)
      (run-with-idle-timer 1 nil 'ek/ivy-rich-cache-rebuild))

    (advice-add 'ivy-rich--ivy-switch-buffer-transformer :around 'ek/ivy-rich-cache-lookup)
    (advice-add 'ivy-switch-buffer :after 'ek/ivy-rich-cache-rebuild-trigger)))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;  Effectively replace use-package with straight-use-package
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
(setq use-package-verbose t)
;; (setq straight-check-for-modifications '(check-on-save find-when-checking))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Change some keys for Mac
(setq mac-command-modifier 'control)
(setq mac-control-modifier 'command)

(use-package general
  :defer 1
  :config
  (general-create-definer efs/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (efs/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")
    "c" '(:ignore t :which-key "configs")
    "ca" '((lambda () (interactive) (find-file "~/dotfiles/emacs/.config/emacs/Emacs.org")) :which-key "Emacs.org")
    "cb" '((lambda () (interactive) (find-file "~/dotfiles/desktop/Desktop.org")) :which-key "Desktop.org")
    "cc" '((lambda () (interactive) (find-file "~/dotfiles/guix/.config/guix/system/config.scm")) :which-key "config.scm")
    "cd" '((lambda () (interactive) (find-file "~/dotfiles/awesome/.config/awesome/rc.lua")) :which-key "rc.lua")
    "ce" '((lambda () (interactive) (find-file "~/dotfiles/xmonad/.xmonad/Xmonad.org")) :which-key "Xmonad.org")))

(use-package evil
  ;; :disabled
  :defer 1
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  (define-key evil-normal-state-map (kbd "C-r") 'undo-tree-redo)

  ;; Use visual line motions even outside of visual-line-mode buffers
  ;; (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  ;; (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  ;; :disabled
  :defer 1
  :after evil
  :config
  (evil-collection-init))

(use-package undo-tree
  :disabled
  :defer 1
  :after evil
  :config
  (global-undo-tree-mode 1))

;; You will most likely need to adjust this font size for your system!
(defvar efs/default-font-size 160)
(defvar efs/default-variable-font-size 160)

;; Make frame transparency overridable
(defvar efs/frame-transparency '(90 . 90))

(setq inhibit-startup-message t)

;; Set up the visible bell
(setq visible-bell nil)

;; Set up the ring bell
(setq ring-bell-function 'ignore)

;; (column-number-mode)
;; (global-display-line-numbers-mode t)
;; (menu-bar--display-line-numbers-mode-relative)

;; Set frame transparency
(set-frame-parameter (selected-frame) 'alpha efs/frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,efs/frame-transparency))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; For correct fullscreen mode
(setq frame-resize-pixelwise t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                vterm-mode-hook
                eshell-mode-hook
                treemacs-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Disable blink cursor
(blink-cursor-mode 0)

;; Accept 'y' and 'n' rather than 'yes' and 'no'.
(defalias 'yes-or-no-p 'y-or-n-p)

;; Stop creating backup and autosave files.
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Auto-revert files and dired buffers on change
;; (setq global-auto-revert-mode 1)
;; (setq global-auto-revert-non-file-buffers 1)

;; (server-start)

(use-package modus-themes)

(use-package doom-themes)

;; Color theme
;; (load-theme 'modus-vivendi t)
(load-theme 'modus-operandi t)

(setq my-fixed-font-name "mononoki Nerd Font")

(defun efs/set-font-faces ()
  (message "Setting faces!")
  (set-face-attribute 'default nil :font my-fixed-font-name :height efs/default-font-size)

  ;; Set the fixed pitch face
  (set-face-attribute 'fixed-pitch nil :font my-fixed-font-name :height efs/default-font-size)

  ;; Set the variable pitch face
  (set-face-attribute 'variable-pitch nil :font "Cantarell" :height efs/default-font-size))

(if (daemonp)
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (setq doom-modeline-icon t)
                (with-selected-frame frame
                  (efs/set-font-faces))))
  (efs/set-font-faces))

(use-package command-log-mode
  :commands command-log-mode)

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config (setq doom-modeline-height 10))

(use-package which-key
  :defer 2
  ;; :init (which-key-mode)
  :diminish which-key-mode
  :custom
  (which-key-idle-delay 1)
  :config
  (which-key-mode))

;; (use-package which-key-posframe
;;   :load-path "~/.config/emacs/elpa/which-key-posframe-20190427.1103/which-key-posframe.el"
;;   :config
;;   (which-key-posframe-mode))

(use-package savehist
  :defer 1
  :init
  (savehist-mode 1)
  :config
  (setq history-length 25))

(use-package prescient
  :disabled
  :init
  (setq prescient-persist-mode 1))

(use-package vertico
  :disabled
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode 1))

(use-package marginalia
  :disabled
  :after vertico
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode 1))

(use-package consult
  :disabled
  :after vertico
  :bind
  (("C-s" . consult-line)
   ("C-M-l" . consult-imenu)
   ("C-M-j" . consult-buffer)
   :map minibuffer-local-map
   ("C-r" . consult-history))
  :custom
  (completion-in-region-function #'consult-completion-in-region))

(use-package helm
  :disabled
  :bind ("M-x" . helm-M-x)
  :config
  (setq completion-styles '(flex))
  (setq helm-display-function 'helm-display-buffer-in-own-frame)
  :init
  (helm-mode 1))

(use-package ivy
  :defer 1
  :after counsel
  :diminish ivy-mode
  :bind (("C-s" . swiper)
         ;; :map ivy-minibuffer-map
         ;; ("TAB" . ivy-alt-done)
         ;; ("C-l" . ivy-alt-done)
         ;; ("C-j" . ivy-next-line)
         ;; ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ;; ("C-k" . ivy-previous-line)
         ;; ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ;; ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  ;; (setq ivy-wrap t)
  (setq ivy-use-selectable-prompt 1)
  (ivy-mode 1))

(use-package ivy-prescient
  :after ivy
  :custom
  (prescient-persist-mode t)
  :config
  (ivy-prescient-mode 1))

(use-package ivy-rich
  ;; :init (ivy-rich-mode 1)
  :after ivy
  :config
  (ivy-rich-mode 1))

(use-package counsel
  :defer 1
  :bind (("C-M-j" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(use-package swiper
  :commands swiper)

(use-package ivy-posframe
  :disabled
  :after ivy
  :custom
  (ivy-posframe-display-functions-alist
   '((swiper          . ivy-posframe-display-at-point)
     (complete-symbol . ivy-posframe-display-at-point)
     (counsel-M-x     . ivy-posframe-display-at-window-bottom-left)
     (t               . ivy-posframe-display)))
  (ivy-posframe-parameters 
   '((alpha . 80)                                   
     ;; (parent-frame nil)
     (left-fringe . 7)                                                   
     (right-fringe . 7)))
  :config 
  (ivy-posframe-mode 1))

(use-package diminish
  :defer 1)

(use-package helpful
  :defer 2
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package hydra
  :defer t)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(efs/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(use-package smooth-scrolling
  :defer t
  :commands smooth-scrolling-mode)
  ;; :custom
  ;; (smooth-scrolling-mode 1))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook))

(defun efs/org-mode-setup ()
  (org-indent-mode 1)
  (electric-indent-local-mode -1)
  (variable-pitch-mode 1)
  (visual-line-mode 0))

(use-package org
  :defer 1
  ;; :pin org
  :commands (org-capture org-agenda)
  :hook (org-mode . efs/org-mode-setup)
  :config
  ;; (setq org-ellipsis " ▾")

  ;; Place for Org Agenda config

  (efs/org-font-setup))

;; (use-package org-bullets
;;   :after org
;;   :hook (org-mode . org-bullets-mode)
;;   :custom
;;   (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  ;; :disabled
  :hook (org-mode . efs/org-mode-visual-fill))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  ;; (font-lock-add-keywords 'org-mode
  ;;                         '(("^ *\\([-]\\) "
  ;;                            (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch))

(straight-use-package 'org-make-toc)
(with-eval-after-load 'org
  (require 'org-make-toc))

(with-eval-after-load 'org
  (org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . t)
      (lua . t)
      (haskell . t)
      (python . t)))

  (push '("conf-unix" . conf-unix) org-src-lang-modes))

(with-eval-after-load 'org
  ;; This is needed as of Org 9.2
  (require 'org-tempo)
    (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
    (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
    (add-to-list 'org-structure-template-alist '("py" . "src python"))
    (add-to-list 'org-structure-template-alist '("xm" . "src xml"))
    (add-to-list 'org-structure-template-alist '("co" . "src conf"))
    (add-to-list 'org-structure-template-alist '("lu" . "src lua"))
    (add-to-list 'org-structure-template-alist '("hs" . "src haskell"))
    (add-to-list 'org-structure-template-alist '("sc" . "src scheme")))

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name user-emacs-directory))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

;; (add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(use-package wgrep
  :defer t)

(use-package magit
  :commands magit-status)

(use-package direnv
  :defer 2
  :config
  (direnv-mode))

(use-package asdf
 :straight 
 (asdf :type git :host github :repo "tabfugnic/asdf.el")
 :config
 (require 'asdf)
 (asdf-enable))

;; (defun efs/lsp-mode-setup ()
;;   (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
;;   (lsp-headerline-breadcrumb-mode))

;; (use-package lsp-mode
;;   :commands (lsp lsp-deferred)
;;   :hook (lsp-mode . efs/lsp-mode-setup)
;;   :init
;;   (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
;;   :config
;;   (lsp-enable-which-key-integration t))

;; (use-package lsp-ui
;;   :hook (lsp-mode . lsp-ui-mode)
;;   :custom
;;   (lsp-ui-doc-position 'bottom))

;; (use-package lsp-treemacs
;;   :after lsp)

;; (use-package lsp-ivy
;;   :after lsp-mode)

(use-package flycheck
  :commands (flycheck-mode))

(use-package nix-mode
  :mode "//.nix//'"
  :hook (nix-mode ;; . lsp-deferred
         ))

(use-package lua-mode
  ;; :disabled
  :mode "//.lua'"
  ;; :hook (lua-mode ;; . lsp-deferred)
  )

(use-package haskell-mode
  ;; :disabled
  :mode "//.hs'"
  ;; :hook (haskell-mode ;; . lsp-deferred)
  )

(use-package geiser
  :commands geiser
  :config
  (setq geiser-scheme-implementation 'guile))

(use-package geiser-guile
  :after geiser)

(use-package slime
  :commands slime
  :config
  (setq inferior-lisp-program "sbcl --noinform --no-linedit"))

(use-package slime-company
  :after '(slime company))

(use-package slime-docker
  :defer t
  :config
  (setq slime-docker-image-name "my-sbcl")
  (setq slime-docker-program "sbcl")
  (setq slime-docker-ports '((:host-port 8080 :container-port 8080)))
  (setq slime-docker-mounts `(((,(expand-file-name "~/proj/lisp/") . "/home/cl/")))))

(use-package web-mode
  :hook (web-mode . company-mode)
  :mode 
  ("//.html'" "//.php'" "//.erb'")
  :config
  (setq web-mode-markup-indent-offet 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-attr-indent-offset 2)
  (setq web-mode-attr-value-indent-offset 2)
  (setq web-mode-sql-indent-offset 2))

(use-package emmet-mode
  :commands (emmet-mode)
  :hook (web-mode . emmet-mode))

(use-package css-mode
  :defer t
  :hook (css-mode . company-mode)
  :config
  (setq css-indent-offset 2))

(use-package php-mode
  :defer t
  ;; :mode "//.php'"
  )

(use-package js
  :defer t
  :hook (js-mode . company-mode)
  :config
  (setq js-indent-level 2))

(use-package ruby-mode
  :defer t
  :hook (ruby-mode . company-mode))

(use-package ruby-test-mode
  :defer t)

(use-package robe
  :defer t)

(use-package haml-mode
  :hook 
  (haml-mode . flycheck-mode)
  (haml-mode . company-mode)
  :mode ("//.haml'"))

(use-package slim-mode
  :hook 
  (slim-mode . flycheck-mode)
  (slim-mode . company-mode)
  :mode ("//.slim"))

(use-package yaml-mode
  :hook (yaml-mode . company-mode)
  :mode ("//.yaml'"))

(use-package csv-mode
  :defer t)

(use-package markdown-mode
  :hook (markdown-mode . company-mode)
  :mode ("//.md'"))

(use-package plantuml-mode
  :defer t
  :config
  ;; (setq plantuml-executable-path "~/.guix-profile/bin/plantuml")
  (setq plantuml-default-exec-mode 'executable))

(use-package graphviz-dot-mode
  :defer t
  :config
  (setq graphviz-dot-indent-width 2))

(use-package grip-mode
  :defer t
  :config
  (setq grip-binary-path "~/.guix-profile/bin/grip")
  (setq grip-url-browser "firefox")
  (setq grip-update-after-change nil))

(use-package eglot
  :defer t)

(use-package company
  ;; :ensure t
  :defer t
  ;; :after lsp-mode
  ;; :hook (after-init . global-company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        ;; (:map lsp-mode-map
        ;;  ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-tooltip-limit 5)
  (company-minimum-prefix-length 2)
  (company-idle-delay 0.3)
  (company-selection-wrap-around t)
  (company-require-match 'never))

;; (use-package company-box
  ;; :hook (company-mode . company-box-mode))

;; Collection of snippets
(use-package yasnippet-snippets
  :defer t)

(use-package yasnippet                  ; Snippets
  :defer t
  ;; :ensure t
  :config
  (setq
   yas-verbosity 1                      ; No need to be so verbose
   yas-wrap-around-region t)

  (with-eval-after-load 'yasnippet
    (setq yas-snippet-dirs '(yasnippet-snippets-dir)))

  (yas-reload-all)
  ;; (yas-global-mode)
  )

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; (use-package parinfer
;;   :bind
;;   ("C-," . parinfer-toggle-mode)
;;   :init
;;   (progn
;;     (setq parinfer-extensions
;;           '(defaults       ; should be included.
;;             pretty-parens  ; different paren styles for different modes.
;;             evil           ; If you use Evil.
;;             ;; lispy          ; If you use Lispy. With this extension, you should install Lispy and do not enable lispy-mode directly.
;;             ;; paredit        ; Introduce some paredit commands.
;;             smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
;;             smart-yank))   ; Yank behavior depend on mode.
;;     (add-hook 'clojure-mode-hook #'parinfer-mode)
;;     (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
;;     (add-hook 'common-lisp-mode-hook #'parinfer-mode)
;;     (add-hook 'scheme-mode-hook #'parinfer-mode)
;;     (add-hook 'lisp-mode-hook #'parinfer-mode)))

(use-package highlight-indent-guides
  :commands (highlight-indent-guides))

(use-package term
  :commands term
  :config
  (setq explicit-shell-file-name "bash") ;; Change this to zsh, etc
  ;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

  ;; Match the default Bash shell prompt.  Update this if you have a custom prompt
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(defun efs/configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Bind some useful keys for evil-mode
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt
  :after eshell)

(use-package eshell
  :commands eshell
  :hook (eshell-first-time-mode . efs/configure-eshell)
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "vim")))

  (eshell-git-prompt-use-theme 'robbyrussell))

(if (equal (system-name) "guixsd")
    (use-package vterm
      ;; :ensure nil
      :straight nil
      :commands vterm)
  (use-package vterm
    :commands vterm))

  ;; (use-package vterm
  ;;   :commands vterm)

(use-package multi-vterm
  :defer t)

(use-package dired
  ;; :ensure nil
  :defer 1
  :after evil-collection
  :straight nil
  :hook (dired-mode . dired-hide-details-mode)
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :config
  (setq dired-async-mode t)
  (setq dired-dwim-target t)
  (when (eq system-type 'darwin)
    (setq insert-directory-program "/usr/local/bin/gls"))
  (setq dired-listing-switches "-agho --group-directories-first")
  (setq wdired-allow-to-change-permissions t)
  (setq wdired-create-parent-directories t)
  (setq diredfl-global-mode t)
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-up-directory
    "l" 'dired-find-file)
  )

(use-package diredfl
  :defer 1
  :after dired
  :commands (dired dired-jump))

(use-package all-the-icons-dired
  :defer 1
  :after dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :defer 1
  :after dired
  :custom
  (dired-open-extensions '(("png" . "imv")
                           ("mkv" . "mpv")
                           ("odt" . "libreoffice")
                           ("ods" . "libreoffice")
                           ("docx" . "libreoffice")
                           ("doc" . "libreoffice")
                           ("pptx" . "libreoffice")
                           ("pdf" . "evince"))))

(use-package bluetooth
  :commands bluetooth-list-devices)

(use-package guix
  :defer t)
