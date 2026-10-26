(define-module (guix system modules secrets)
  #:use-module (gnu)
  #:export (%lain-password %root-password))

(define %lain-password
  (string-append "$6$6oWfpm3YqdQxBUm1$vrGsnyNsJUXOjnrUxcWq9mTX/QS"
                 "rhinssK1XTmOcdrbwmL1nF6xWZPv5yrYbQE0/naGuf7UlKNeW4Yhukyfdm1"))

(define %root-password
  (string-append "$6$8jA.CrbBjWSwj7xK$L4wKmA97j9FfLxLiXqqREUaNgKN"
                 "GCEjr.Hf0ufRensRoUXNMBYHCWQsfsVVIG/jCKzUPpbPEdqGlei/G1c3VV1"))
