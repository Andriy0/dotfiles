(define emacsd
  (make <service>
    #:provides '(emacsd)
    #:docstring "Run `emacs' as daemon"
    #:start (make-forkexec-constructor '("emacs" "--fg-daemon"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(register-services emacsd)
(start emacsd)
