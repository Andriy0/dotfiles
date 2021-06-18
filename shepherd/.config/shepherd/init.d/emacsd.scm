(define emacsd
  (make <service>
    #:declarative? #f
    #:provides '(emacsd)
    #:docstring "Run `emacs' as daemon"
    #:start (make-forkexec-constructor '("emacs" "--fg-daemon"))
    ;; "-l ~/dotfiles/emacs/.config/emacs/desktop.el" 
    #:stop (make-kill-destructor)
    #:respawn? #t))

(register-services emacsd)
(start emacsd)
