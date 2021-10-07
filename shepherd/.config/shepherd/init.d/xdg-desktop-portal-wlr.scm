(define xdg-desktop-portal-wlr
  (make <service>
    #:provides '(xdg-desktop-portal-wlr)
    #:docstring "Run `xdg-desktop-portal-wlr' as daemon"
    #:start (make-forkexec-constructor '("/gnu/store/clc1pb7n8qbc7202p8n9g2pbbg13ryvi-xdg-desktop-portal-wlr-0.4.0/libexec/xdg-desktop-portal-wlr"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

;; (register-services xdg-desktop-portal-wlr)
;; (start xdg-desktop-portal-wlr)
