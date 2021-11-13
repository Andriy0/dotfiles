(add-hook 'focus-out-hook 'garbage-collect)
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
;; (setq straight-check-for-modifications '(check-on-save find-when-checking))

(defvar efs/default-font-size 160)
(defvar efs/default-variable-font-size 160)
(defvar efs/default-font "mononoki")
(defvar efs/default-theme 'modus-operandi)
(defvar efs/frame-transparency '(90 . 90))

(defalias 'yes-or-no-p 'y-or-n-p)
(blink-cursor-mode 0)
(setq make-backup-files nil
      auto-save-default nil)

(set-face-attribute 'default nil :font efs/default-font :height efs/default-font-size)

(load-theme efs/default-theme t)

(savehist-mode 1)

;; (straight-use-package 'helm)
;; (add-hook 'after-init-hook
;; 	  (lambda ()
;; 	    (run-with-idle-timer
;; 	     1 nil
;; 	     (lambda ()
;; 	  (message "Loading helm...")
;; 	  (require 'helm)))))

(with-eval-after-load 'helm
  (add-hook 'after-init-hook 'helm-mode)
  (progn
    (define-key minibuffer-local-map (kbd "C-r") 'helm-minibuffer-history)
    (define-key global-map (kbd "M-x") 'helm-M-x)
    (define-key global-map (kbd "C-x C-f") 'helm-find-files)
    (define-key global-map (kbd "C-M-j") 'helm-buffers-list)
    ))

(straight-use-package 'helm-swoop)

(with-eval-after-load 'helm
  (require 'helm-swoop)

  (progn
    (define-key global-map (kbd "C-s") 'helm-swoop)
    ))

(straight-use-package 'consult)

(straight-use-package 'vertico)

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
    (add-to-list 'org-structure-template-alist '("co" . "src conf-unix"))
    (add-to-list 'org-structure-template-alist '("lu" . "src lua"))
    (add-to-list 'org-structure-template-alist '("hs" . "src haskell"))
    (add-to-list 'org-structure-template-alist '("sc" . "src scheme")))
