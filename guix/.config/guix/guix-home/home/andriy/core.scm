(define-module (home andriy core)
  #:use-module (gnu home)
  ;; #:use-module ((home yggdrasil gnupg) #:prefix gnupg:)
  ;; #:use-module ((home yggdrasil version-control) #:prefix vc:)
  ;; #:use-module ((home yggdrasil wm) #:prefix wm:)
  #:use-module ((home andriy emacs) #:prefix emacs:)
  ;; #:use-module ((home andriy shell) #:prefix shell:)
  ;; #:use-module ((home yggdrasil password-utils) #:prefix pass:)
  ;; #:use-module ((home yggdrasil xdg) #:prefix xdg:)
  ;; #:use-module ((home yggdrasil ssh) #:prefix ssh:)
  #:use-module ((home andriy pipewire) #:prefix pw:)
  ;; #:use-module ((home yggdrasil terminals) #:prefix term:)
  ;; #:use-module ((home yggdrasil mail) #:prefix mail:)
  #:use-module ((home andriy packages) #:select (packages)))

(home-environment
 (packages packages)
 (services
  (append
   ;; wm:services
   ;; vc:services
   ;; gnupg:services
   emacs:services
   ;; pass:services
   ;; shell:services
   ;; xdg:services
   ;; ssh:services
   pw:services
   ;; term:services
   ;; mail:services
   )))
