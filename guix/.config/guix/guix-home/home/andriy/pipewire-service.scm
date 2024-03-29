(define-module (home andriy pipewire-service)
  #:use-module (guix gexp)

  ;; #:use-module (rde features base)
  
  #:use-module (gnu packages linux)
  #:use-module (gnu packages pulseaudio)

  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd))

(define (home-pipewire-files-service _)
  `(("config/alsa/asoundrc"
     ,(mixed-text-file
       "asoundrc"
       #~(string-append
          "<"
          #$(file-append
             pipewire-0.3
             "/share/alsa/alsa.conf.d/50-pipewire.conf")
          ">\n<"
          #$(file-append
             pipewire-0.3
             "/share/alsa/alsa.conf.d/99-pipewire-default.conf")
          ">\n"
          "
pcm_type.pipewire {
  lib " #$(file-append
           pipewire-0.3
           "/lib/alsa-lib/libasound_module_pcm_pipewire.so") "
}

ctl_type.pipewire {
  lib " #$(file-append
           pipewire-0.3
           "/lib/alsa-lib/libasound_module_ctl_pipewire.so") "
}
")))))

(define (home-pipewire-shepherd-service _)
  (list
   (shepherd-service
        (provision '(dbus-home))
        (stop  #~(make-kill-destructor))
        (start #~(make-forkexec-constructor
                  (list #$(file-append (@@ (gnu packages glib) dbus)
                                       "/bin/dbus-daemon")
                        "--nofork"
                        "--session"
                        (string-append
                         "--address=" "unix:path="
                         (getenv "XDG_RUNTIME_DIR") "/dbus.sock")))))
   
   (shepherd-service
    (requirement '(dbus-home))
    (provision '(pipewire))
    (stop  #~(make-kill-destructor))
    (start #~(make-forkexec-constructor
              (list #$(file-append pipewire-0.3 "/bin/pipewire")))))
   
   (shepherd-service
    (requirement '(pipewire))
    (provision '(wireplumber))
    (start #~(make-forkexec-constructor
              (list #$(file-append (@@ (gnu packages glib ) dbus) "/bin/dbus-run-session")
		    #$(file-append wireplumber "/bin/wireplumber"))
	      #:log-file (string-append
			  (or (getenv "XDG_LOG_HOME")
			      (format #f "~a/.local/var/log"
				      (getenv "HOME")))
			  "/wireplumber.log")))
    (stop  #~(make-kill-destructor)))
   
   (shepherd-service
    (requirement '(pipewire))
    (provision '(pipewire-pulse))
    (stop  #~(make-kill-destructor))
    (start #~(make-forkexec-constructor
              (list #$(file-append pipewire-0.3 "/bin/pipewire-pulse")))))))

(define (home-pipewire-environment-variables-service _)
  '(("RTC_USE_PIPEWIRE" . "true")))

(define-public home-pipewire-service-type
  (service-type
   (name 'home-pipewire)
   (extensions
    (list (service-extension
           home-files-service-type
           home-pipewire-files-service)
          (service-extension
           home-shepherd-service-type
           home-pipewire-shepherd-service)
          (service-extension
           home-environment-variables-service-type
           home-pipewire-environment-variables-service)
          (service-extension
           home-profile-service-type
           (const (list pipewire-0.3 wireplumber pulseaudio)))
	  ))
   (default-value #f)
   (description "run pipewire and stuff")))
