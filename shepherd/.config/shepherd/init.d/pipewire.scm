(define pipewire
  (make <service>
    #:provides '(pipewire)
    #:docstring "Run `pipewire' as daemon"
    #:start (make-forkexec-constructor '("pipewire"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(register-services pipewire)
(start pipewire)
