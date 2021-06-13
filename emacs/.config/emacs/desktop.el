(defun efs/run-in-background (command)
    (let ((command-parts (split-string command "[ ]+")))
      (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))
  
  (defun efs/set-wallpaper ()
    (interactive)
    ;; NOTE: You will need to update this to a valid background path!
    (start-process-shell-command
        "feh" nil  "feh --bg-scale /usr/share/backgrounds/matt-mcnulty-nyc-2nd-ave.jpg"))

  ;; fix for ivy-posframe in x11 windows
  (defun exwm-update-ivy-posframe-parameters (&rest args)
    (interactive)
    (if (equal major-mode 'exwm-mode)
      (progn (setq ivy-posframe-parameters 
        '((parent-frame nil)                                               
          (alpha . 92)                                               
          (left-fringe . 7)                                               
          (right-fringe . 7))))
    (progn (setq-local ivy-posframe-parameters 
      '((alpha . 92)                                   
        (left-fringe . 7)                                                   
        (right-fringe . 7))))))
        
(defun efs/exwm-update-class ()
    (exwm-workspace-rename-buffer exwm-class-name))

(defun efs/exwm-update-title ()
  (pcase exwm-class-name
    ("Nightly" (exwm-workspace-rename-buffer (format "firefox: %s" exwm-title)))
    ("Chromium-browser" (exwm-workspace-rename-buffer (format "chromium: %s" exwm-title)))
    ("qutebrowser" (exwm-workspace-rename-buffer (format "qutebrowser: %s" exwm-title)))))

(defun efs/configure-window-by-class ()
  (interactive)
  (pcase exwm-class-name
    ((or "Nightly" "Chromium-browser" "qutebrowser") (exwm-workspace-move-window 2))
    ;; ("Sol" (exwm-workspace-move-window 3))
    ("mpv" (exwm-floating-toggle-floating)
           (exwm-layout-toggle-mode-line))))

(defun efs/exwm-init-hook ()
  ;; Make workspace 1 be the one where we land at startup
  (exwm-workspace-switch-create 1)

  ;; Open eshell by default
  ;; (eshell)
  ;; (find-file "/sudo:root@localhost:/etc/config.scm")
  ;; (find-file "~/Emacs.org")
  ;; (find-file "~/Desktop.org")
  ;; (vterm)

  ;; Show battery status in the mode line
  ;; (display-battery-mode 1)

  ;; Show the time and date in modeline
  ;; (setq display-time-day-and-date t)
  ;; (display-time-mode 1)
  ;; Also take a look at display-time-format and format-time-string

  ;; Launch panel
  (efs/start-panel)

  ;; Launch apps that will run in the background
  ;; (efs/run-in-background "volumeicon")
  ;; (efs/run-in-background "blueman-applet")
  ;; (efs/run-in-background "pasystray")
  ;; (efs/run-in-background "nm-applet")
  )

(use-package exwm
  :config
  ;; Set the default number of workspaces
  (setq exwm-workspace-number 5)

  ;; When window "class" updates, use it to set the buffer name
  (add-hook 'exwm-update-class-hook #'efs/exwm-update-class)

  ;; When window title updates, use it to set the buffer name
  (add-hook 'exwm-update-title-hook #'efs/exwm-update-title)

  ;; Configure windows as they're created
  (add-hook 'exwm-manage-finish-hook #'efs/configure-window-by-class)

  ;; apply ivy-posframe fix for x11 windows
  ;; (add-to-list 'exwm-mode-hook 'exwm-update-ivy-posframe-parameters)
  ;; (advice-add 'set-window-buffer :after 'exwm-update-ivy-posframe-parameters)
  ;; (add-to-list 'ivy-posframe-parameters '(parent-frame nil))

  ;; For polybar
  ;; (add-hook 'exwm-workspace-list-change-hook
  ;;       #'exwm-workspace--update-ewmh-desktop-names)

  ;; When EXWM starts up, do some extra configuration
  (add-hook 'exwm-init-hook #'efs/exwm-init-hook)

  ;; Startup
  ;; (start-process-shell-command "xset" nil "xset r rate 300 50")
  ;; (start-process-shell-command "xsetroot" nil "xsetroot -cursor_name left_ptr")
  ;; (start-process-shell-command "picom" nil "picom")
  ;; (start-process-shell-command "nitrogen" nil "nitrogen --restore")
  ;; (start-process-shell-command "xsettingsd" nil "xsettingsd")
  ;; (start-process-shell-command "mpdris2" nil "mpdris2")
  ;; (start-process-shell-command "mpd" nil "mpd")

  ;; Load the system tray before exwm-init
  ;; (require 'exwm-systemtray)
  ;; (exwm-systemtray-enable)

  ;; These keys should always pass through to Emacs
  (setq exwm-input-prefix-keys
        '(?\C-x
          ?\C-u
          ?\C-h
          ?\M-x
          ?\M-`
          ?\M-&
          ?\M-:
          ?\M-!
          ?\C-\M-j  ;; Buffer list
          ?\C-\ ))  ;; Ctrl+Space

  ;; Ctrl+Q will enable the next key to be sent directly
  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  ;; Set up global key bindings.  These always work, no matter the input state!
  ;; Keep in mind that changing this list after EXWM initializes has no effect.
  (setq exwm-input-global-keys
        `(;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
          ([?\s-r] . exwm-reset)

          ;; Move between windows
          ([s-left] . windmove-left)
          ([?\s-h] . windmove-left)
          ([s-right] . windmove-right)
          ([?\s-l] . windmove-right)
          ([s-up] . windmove-up)
          ([?\s-k] . windmove-up)
          ([s-down] . windmove-down)
          ([?\s-j] . windmove-down)

          ;; Launch applications via shell command
          ([?\s-&] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))

          ;; Switch workspace
          ([?\s-w] . exwm-workspace-switch)
          ([?\s-`] . (lambda () (interactive)
                       (exwm-workspace-switch-create 0)))

          ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))

  ;; (exwm-input-set-key (kbd "s-SPC") 'counsel-linux-app)

  ;; Resize windows
  (defmacro efs/resize-helper (resize-window-function)
    (let ((delta 5))
      `(lambda () (interactive) (,resize-window-function ,delta))))

  (exwm-input-set-key (kbd "s-[") (efs/resize-helper shrink-window-horizontally))
  (exwm-input-set-key (kbd "s-{") (efs/resize-helper shrink-window))
  (exwm-input-set-key (kbd "s-]") (efs/resize-helper enlarge-window-horizontally))
  (exwm-input-set-key (kbd "s-}") (efs/resize-helper enlarge-window))

  (exwm-enable))

(server-start)

(use-package desktop-environment
  :after exwm
  :config (desktop-environment-mode)
  :custom
  (desktop-environment-brightness-small-increment "1%+")
  (desktop-environment-brightness-small-decrement "1%-")
  (desktop-environment-brightness-normal-increment "1%+")
  (desktop-environment-brightness-normal-decrement "1%-")
  (desktop-environment-screenshot-command "flameshot gui"))

(defvar efs/polybar-process nil
  "Holds the process of the running Polybar instance, if any")

(defun efs/kill-panel ()
  (interactive)
  (when efs/polybar-process
    (ignore-errors
      (kill-process efs/polybar-process)))
  (setq efs/polybar-process nil))

(defun efs/start-panel ()
  (interactive)
  (efs/kill-panel)
  (setq efs/polybar-process (start-process-shell-command "polybar" nil "polybar panel")))

(defun efs/polybar-exwm-workspace ()
  (pcase exwm-workspace-current-index
    (0 "")
    (1 "")
    (2 "")
    (3 "")
    (4 "")))

(setq exwm-workspace-index-map
      (lambda (index)
	(let ((named-workspaces ["code" "brow" "extr" "slac" "lisp"]))
	  (if (< index (length named-workspaces))
	      (elt named-workspaces index)
	    (number-to-string index)))))

(defun exwm-workspace--update-ewmh-desktop-names ()
  (xcb:+request exwm--connection
		(make-instance 'xcb:ewmh:set-_NET_DESKTOP_NAMES
			       :window exwm--root :data
			       (mapconcat (lambda (i) (funcall exwm-workspace-index-map i))
					  (number-sequence 0 (1- (exwm-workspace--count)))
					  "\0"))))
