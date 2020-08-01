(define-module (montokapro databases)
  #:use-module (gnu packages databases)
  #:use-module (guix packages)
  #:use-module (guix download))

(define-public postgresql-12
  (package
    (inherit postgresql)
    (name "postgresql")
    (version "12.3")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://ftp.postgresql.org/pub/source/v"
                                  version "/postgresql-" version ".tar.bz2"))
              (sha256
               (base32
                "0hfg3n7rlz96579cj3z1dh2idl15rh3wfvn8jl31jj4h2yk69vcl"))))))
