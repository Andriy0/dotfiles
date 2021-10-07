(define pipewire-media-session
  (make <service>
    #:provides '(pipewire-media-session)
    ;; #:requires '(pipewire)
    #:docstring "Run `pipewire-media-session' as daemon"
    #:start (make-forkexec-constructor '("pipewire-media-session"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(register-services pipewire-media-session)
(start pipewire-media-session)
