(define-module (home andriy shell)
  #:use-module (gnu services)
  #:use-module (gnu home services shells)
  #:use-module (gnu home-services shellutils)
  )

(define (wrap str)
  (string-append "\"" str "\""))

(define-public services
  (list
;;    (service home-bash-service-type
;;             (home-bash-configuration
;; 	     ;; (guix-defaults? #f)
;;              ;; (bash-profile
;;              ;;  '("source /run/current-system/profile/etc/profile.d/nix.sh"))
;; ;; 	     (bash-profile '("\
;; ;; export HISTFILE=\"$XDG_CACHE_HOME\"/.bash_history"))
;; 	     ;; (bashrc
;; 	     ;;  '("fish"))
;;              (environment-variables
;;               `(("XDG_CURRENT_DESKTOP" . "sway")
;;                 ("XDG_SESSION_TYPE" . "wayland")
;;                 ("MOZ_ENABLE_WAYLAND" . "1")
;; 		("XDG_DATA_DIRS" . ,(string-join
;; 				     '("$XDG_DATA_DIRS"
;; 				       ":$HOME/.local/share/themes"
;; 				       ":$HOME/.local/share/icons"
;; 				       ":$HOME/.local/share/fonts"
;; 				       ":$HOME/.local/share/flatpak/exports/share")
;; 				     ""))
;;                 ("BEMENU_OPTS" . ,(wrap
;;                                    (string-join '("--fn 'Iosevka Light 18'"
;;                                                   "--nb '#FFFFFF'"
;;                                                   "--nf '#000000'"
;;                                                   "--tb '#FFFFFF'"
;;                                                   "--tf '#000000'"
;;                                                   "--fb '#FFFFFF'"
;;                                                   "--ff '#000000'"
;;                                                   "--hb '#F0F0F0'"
;;                                                   "--hf '#721045'")
;;                                                 " ")))))))
   (service home-bash-direnv-service-type)
   ;; (service home-fish-service-type)
   ))
