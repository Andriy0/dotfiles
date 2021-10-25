(define-module (home andriy pipewire)
  #:use-module (gnu home services)
  ;; #:use-module (kreved home-services dbus)
  #:use-module (home andriy pipewire-service))

(define-public services
  (list
   ;; (service home-dbus-service-type)
   (service home-pipewire-service-type)))
