(define pipewire-pulse
  (make <service>
    #:provides '(pipewire-pulse)
    ;; #:requires '(pipewire)
    #:docstring "Run `pipewire-pulse' as daemon"
    #:start (make-forkexec-constructor '("pipewire-pulse"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(register-services pipewire-pulse)
(start pipewire-pulse)
