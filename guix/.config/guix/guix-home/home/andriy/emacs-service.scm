(define-module (home andriy emacs-service)
  #:use-module (guix gexp)
  
  #:use-module (gnu packages emacs)

  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu home-services-utils))

(define (my-emacs-shepherd-service _)
  (list
   (shepherd-service
    (provision '(emacs-daemon))
    (start #~(make-forkexec-constructor
	      (list #$(file-append (@@ (gnu packages glib ) dbus) "/bin/dbus-run-session")
		    #$(file-append (@@ (gnu packages emacs) emacs-next-pgtk) "/bin/emacs")
		    "--fg-daemon")
	      #:log-file (string-append
			  (or (getenv "XDG_LOG_HOME")
			      (format #f "~a/.local/var/log"
				      (getenv "HOME")))
			  "/my-emacs.log")))
    (stop  #~(make-kill-destructor)))))

(define-public my-emacs-service-type
  (service-type
   (name 'my-emacs)
   (extensions
    (list (service-extension
	   home-shepherd-service-type
	   my-emacs-shepherd-service)))
   (default-value #f)
   (description "run emacs in daemon mode")))

