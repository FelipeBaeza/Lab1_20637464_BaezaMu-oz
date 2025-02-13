#lang racket

(require "TDA_option_20637464_BaezaMunoz.rkt")
(require "TDA_chatbot_20637464_BaezaMunoz.rkt")
(require "TDA_user_20637464_BaezaMunoz.rkt")
(require "TDA_flow_20637464_BaezaMunoz.rkt")
(require "TDA_chathistory_20637464_BaezaMunoz.rkt")




;------------------------------------------Constructor--------------------------------------------------
#|
Nombre: system.
Dominio: name (string) X InitialChatbotCodeLink (Int) X chatbot.
Recorrido: system.
Descripcion: Función constructora que toma como argumento un name, un InitialChatbotCodeLink y una lista chatbot.
Retorna una lista que representa un system. El chatbot es procesadas para eliminar duplicados antes de ser incluidas en la lista.
|#

(define (system name InitialChatbotCodeLink . chatbot)
  (list name InitialChatbotCodeLink (eliminar-ids-duplicados chatbot) '() '() '() (current-seconds)))

;----------------------------------------Selectores----------------------------------------------------

#|
Nombre: get-name-system.
Dominio: system.
Recorrido: name.
descripcion: Funcion selectora que obtiene el nombre del sistema.
|#

(define (get-name-system system)
  (car system))
#|
Nombre: get-codelink-system.
Dominio: system.
Recorrido: InitialChatbotCodeLink.
descripcion: Funcion selectora que obtiene el InitialChatbotCodeLink del sistema.
|#


(define (get-codelink-system system)
  (cadr system))

#|
Nombre: get-chatbot-system.
Dominio: system.
Recorrido: Lista.
descripcion: Funcion selectora que obtiene la lista de los chatbots del sistema.
|#

(define(get-chatbot-system system)
  (caddr system))


#|
Nombre: get-current-seconds.
Dominio: system.
Recorrido: Lista.
descripcion: Funcion selectora que obtiene la lista donde se encuentra la fecha del sistema.
|#


(define (get-current-seconds system)
  (list-ref system 6))


#|
Nombre: new-chatbot-message-palabra.
Dominio: Option x message.
Recorrido: option.
Tipo-Recursion: Cola
Descripcion: Funcion selectora que devuelve una opcion que sea igual a message entre la lista de opciones .
|#


(define (new-chatbot-message-palabra option message)
  (define (comparador palabras clave)
    (if (null? palabras)
        #f
        (if (equal? (car palabras) message)
            (car palabras)
            (comparador (cdr palabras) clave))))
  
  (if (equal? message (comparador (list-ref (car option) 4) message))
      (list (caddr (car option)) (cadddr (car option)))
      (new-chatbot-message-palabra (cdr option) message)))

#|
Nombre: new-buscar-chatbot.
Dominio: list-chatbot x chatbot-clave.
Recorrido: lista.
Tipo-recursion: cola
Descripcion: Funcion selectora que busca el chatbot que su id sea igual al de chatbot-clave.
|#



(define (new-buscar-chatbot list-chatbot chatbot-clave)
  (if (= (caar list-chatbot) (car chatbot-clave))
      (busqueda-especifica (list-ref (car list-chatbot) 4) (cadr chatbot-clave))
      (new-buscar-chatbot (cdr list-chatbot) chatbot-clave)))

#|
Nombre: busqueda-especifica.
Dominio: list-elementos x clave .
Recorrido: elemento.
Tipo-recursion: cola
Descripcion: Función selectora que busca un elemento de una lista de elemento que sea igual a clave.
|#


(define (busqueda-especifica List-elementos clave)
    (if (= (caar List-elementos)  clave)
       (car List-elementos)
      (busqueda-especifica (cdr List-elementos) clave)))


#|
Nombre: new-chatbot-message.
Dominio: option x clave.
Recorrido: lista.
Tipo-recursion: cola
Descripcion: Función selectora que busca entre las opciones el id que sea igual a clave.
|#



(define (new-chatbot-message option clave)
  (if (= (caar option)  clave)
      (list (caddr (car option)) (cadddr (car option)))
      (new-chatbot-message (cdr option) clave)))

#|
Nombre: busqueda-especifica-norec.
Dominio: list-elementos x clave .
Recorrido: elemento.
Descripcion: Función selectora que busca un elemento de una lista de elemento que sea igual a clave.
|#


(define (busqueda-especifica-norec list-elementos clave)
  (car (filter (lambda (flow) (= (car flow) clave)) list-elementos)))

#|
Nombre: new-chatbot-message-norec.
Dominio: option x clave.
Recorrido: lista.
Descripcion: Función selectora que busca entre las opciones el id que sea igual a clave y optiene el ChatbotCodeLink y InitialFlowCodeLink.
|#

(define (new-chatbot-message-norec option clave)
(list (caddr (car (filter (lambda (op) (= (car op) clave)) option)))
      (cadddr (car (filter (lambda (op) (= (car op) clave)) option)))))


#|
Nombre: new-buscar-chatbot-norec.
Dominio: list-chatbot x chatbot-clave.
Recorrido: lista.
Descripcion: Funcion selectora que busca el chatbot que su id sea igual al de chatbot-clave.
|#


(define (new-buscar-chatbot-norec list-chatbot chatbot-clave)
  (busqueda-especifica (list-ref (car (filter (lambda (cb) (= (car cb) (car chatbot-clave))) list-chatbot)) 4) (cadr chatbot-clave))      )


#|
Nombre: new-chatbot-message-palabra-norec.
Dominio: Option x message.
Recorrido: option.
Descripcion: Funcion selectora que devuelve una opcion que sea igual a message entre la lista de opciones .
|#


(define (new-chatbot-message-palabra-norec options clave)
  (define (comparador palabras)
    (if (not (null? (filter (lambda (palabra) (equal? palabra clave)) palabras)))
        (list (caddr (car options)) (cadddr (car options)))
        #f))

  (if (equal? clave (comparador (list-ref (car options) 4)))
      (list (caddr (car options)) (cadddr (car options)))
      (new-chatbot-message-palabra (cdr options) clave)))


#|
Nombre: system-synthesis.
Dominio: system x user.
Recorrido: string.
Descripcion: Función selectora que buscar el historial de un usuario en especifico.
|#


(define (system-synthesis system user)  
  (car (filter (lambda (x)(equal? (car x) user )) (get-system-user system))))




;-----------------------------------------------Pertenencia------------------------------------------------

#|
Nombre: is-number?.
Dominio: str.
Recorrido: booleano.
Descripcion: Función de pertenencia que verifica si es un numero o un string.
|#


(define (is-number? str)
  (if (string->number str)
      #t  
      #f)) 


;-----------------------------------------------Modificadores-------------------------------------------

#|
Nombre: system-add-chatbot.
Dominio: system x chatbot.
Recorrido: system.
Descripcion: Función modificadora que agrega un chatbot al sistema si es que el id del chatbot es distinto a los
ids de la lista de chatbot del sistema.
|#

(define (system-add-chatbot system chatbot)
  (if (member (get-id-chatbot chatbot) (map (lambda (sys) (car sys)) (get-chatbot-system system))) 
      system 
      (list (get-name-system system)
            (get-codelink-system system)
            (reverse (cons chatbot (reverse (get-chatbot-system system))))
            (get-system-user system)
            (get-login-user system)
            (get-talk-system system)
            (current-seconds)))) ; Agrega la opción al flujo si no existe



#|
Nombre: system-add-user.
Dominio: system x user.
Recorrido: system.
Descripcion: Función modificadora que agrega un usuario al sistema si es que el name del usuario es distinto a los
names de la lista de usuarios del sistema.
|#
(define (system-add-user system user)
  (if (member user (map car (get-system-user system)))
      system
      (list (get-name-system system)
            (get-codelink-system system)
            (get-chatbot-system system)
            (reverse (cons (list (users user) (chatHistory '())) (reverse (get-system-user system)))) ; Modificado para agregar la función user
            (get-login-user system)
            (get-talk-system system)
            (get-current-seconds system))))


#|
Nombre: system-login.
Dominio: system x user.
Recorrido: system.
Descripcion: Función modificadora que permite iniciar una sesión en el sistema si es que existe el usuario y
todavia no se iniciado sesion.
|#

(define (system-login system user)
  (if (equal? (register (map car (get-system-user system)) user) #t)
      (if (null? (get-login-user system))
          (list (get-name-system system)
                (get-codelink-system system)
                (get-chatbot-system system)
                (get-system-user system)
                (cons user (get-login-user system))
                (get-talk-system system)
                (current-seconds))
          system)
      system))


#|
Nombre: system-logout.
Dominio: system.
Recorrido: system.
Descripcion: Función modificadora que permite cerrar una sesion abierta.
|#
;li
(define (system-logout system)
  (list (get-name-system system)
        (get-codelink-system system)
        (get-chatbot-system system)
        (get-system-user system)
        '()
        '()
        (get-current-seconds system)))


#|
Nombre: agregar-contenido.
Dominio: usuario x contenido x list-user-chathistory.
Recorrido: lista.
Tipo-recursion: cola
Descripcion: Función modificadora que permite agregar contenido al chathistory.
|#



(define (agregar-contenido usuario contenido List-user-chathistory)
  (cond
    [(equal? (car (car List-user-chathistory)) usuario)
     (cons (list usuario (append (cadr (car List-user-chathistory)) contenido))
           (cdr List-user-chathistory))]
    [else
     (cons (car List-user-chathistory)
           (agregar-contenido usuario contenido (cdr List-user-chathistory)))]))

#|
Nombre: system-talk-rec.
Dominio: system x message.
Recorrido: lista.
Descripcion: Función modificadora que permite interactuar el usuario con el chatbot.
|#


(define (system-talk-rec system message)
  (if (not (null? (get-login-user system)))
      (if (null? (get-talk-system system));si todavia no se ha iniciado una coversacion
          (list (get-name-system system)
                (get-codelink-system system)
                (get-chatbot-system system)
                (agregar-contenido (car (get-login-user system)) (busqueda-especifica (get-chatbot-system system) (get-codelink-system system))  (get-system-user system))
                (get-login-user system)
                (cons (busqueda-especifica (get-chatbot-system system) (get-codelink-system system)) (get-talk-system system))
                (get-current-seconds system))
          ;caso cuando entrega una palabra o un numero
          (if (is-number? message)
              (if (= (length (get-talk-system system)) 1);caso donde ya se mostro chatbot y se escoge entre chatbot1 y chatbot2
                  (list (get-name-system system)
                        (get-codelink-system system)
                        (get-chatbot-system system)
                        (agregar-contenido (car (get-login-user system)) (new-buscar-chatbot (get-chatbot-system system) (new-chatbot-message (get-options-flow (car (get-flows-chatbot (car (get-talk-system system))))) (string->number message))) (get-system-user system))
                        (get-login-user system)
                        (cons (new-buscar-chatbot (get-chatbot-system system) (new-chatbot-message (get-options-flow (car (get-flows-chatbot (car (get-talk-system system))))) (string->number message)))
                              (get-talk-system system))
                        (get-current-seconds system))
                  (list (get-name-system system)
                        (get-codelink-system system)
                        (get-chatbot-system system)
                        (agregar-contenido (car (get-login-user system)) (new-buscar-chatbot (get-chatbot-system system) (new-chatbot-message (caddr (car (get-talk-system system))) (string->number message)))  (get-system-user system))
                        (get-login-user system)
                        (cons (new-buscar-chatbot (get-chatbot-system system) (new-chatbot-message (caddr (car (get-talk-system system))) (string->number message)))
                              (get-talk-system system))
                        (get-current-seconds system)))
              (if (= (length (get-talk-system system)) 1)
                  (list (get-name-system system)
                        (get-codelink-system system)
                        (get-chatbot-system system)
                        (agregar-contenido (car (get-login-user system))  (new-buscar-chatbot (get-chatbot-system system)(new-chatbot-message-palabra (get-options-flow (car (get-flows-chatbot (car (get-talk-system system))))) message)) (get-system-user system))
                        (get-login-user system)
                        (cons (new-buscar-chatbot (get-chatbot-system system)(new-chatbot-message-palabra (get-options-flow (car (get-flows-chatbot (car (get-talk-system system))))) message))
                              (get-talk-system system))
                        (get-current-seconds system))
                  (list (get-name-system system)
                        (get-codelink-system system)
                        (get-chatbot-system system)
                        (agregar-contenido (car (get-login-user system))  (new-buscar-chatbot (get-chatbot-system system) (new-chatbot-message-palabra (caddr (car (get-talk-system system))) message)) (get-system-user system))
                        (get-login-user system)
                        (cons (new-buscar-chatbot (get-chatbot-system system) (new-chatbot-message-palabra (caddr (car (get-talk-system system))) message))
                              (get-talk-system system))
                        (get-current-seconds system)))))
      system))




#|
Nombre: agregar-contenido-norec.
Dominio: usuario x contenido x list-user-chathistory.
Recorrido: lista.
Descripcion: Función modificadora que permite agregar contenido al chathistory.
|#

(define (agregar-contenido-norec usuario contenido lista-de-usuarios)
  (map (lambda (user)
         (if (equal? (car user) usuario)
             (list (car user) (append (cadr user) contenido))
             user))
       lista-de-usuarios))

#|
Nombre: system-talk-norec.
Dominio: system x message.
Recorrido: lista.
Descripcion: Función modificadora que permite interactuar el usuario con el chatbot.
|#


(define (system-talk-norec system message)
  (if (not (null? (get-login-user system)))
      (if (null? (get-talk-system system));si todavia no se ha iniciado una coversacion
          (list (get-name-system system)
                (get-codelink-system system)
                (get-chatbot-system system)
                (agregar-contenido-norec (car (get-login-user system)) (busqueda-especifica-norec (get-chatbot-system system) (get-codelink-system system)) (get-system-user system))
                (get-login-user system)
                (cons (busqueda-especifica-norec (get-chatbot-system system) (get-codelink-system system)) (get-talk-system system))
                (get-current-seconds system))
          (if (is-number? message)
              (if (= (length (get-talk-system system)) 1);caso donde ya se mostro chatbot y se escoge entre chatbot1 y chatbot2
                  (list (get-name-system system)
                        (get-codelink-system system)
                        (get-chatbot-system system)
                        (agregar-contenido-norec (car (get-login-user system)) (new-buscar-chatbot-norec (get-chatbot-system system) (new-chatbot-message-norec (get-options-flow (car (get-flows-chatbot (car (get-talk-system system))))) (string->number message))) (get-system-user system))
                        (get-login-user system)
                        (cons (new-buscar-chatbot-norec (get-chatbot-system system) (new-chatbot-message-norec (get-options-flow (car (get-flows-chatbot (car (get-talk-system system))))) (string->number message)))  
                              (get-talk-system system))
                        (get-current-seconds system))
                  (list (get-name-system system)
                        (get-codelink-system system)
                        (get-chatbot-system system)
                        (agregar-contenido-norec (car (get-login-user system)) (new-buscar-chatbot-norec (get-chatbot-system system) (new-chatbot-message-norec (caddr (car (get-talk-system system))) (string->number message))) (get-system-user system))
                        (get-login-user system)
                        (cons (new-buscar-chatbot-norec (get-chatbot-system system) (new-chatbot-message-norec (caddr (car (get-talk-system system))) (string->number message)))
                              (get-talk-system system))
                        (get-current-seconds system)))
              (if (= (length (get-talk-system system)) 1)
                  (list (get-name-system system)
                        (get-codelink-system system)
                        (get-chatbot-system system)
                        (agregar-contenido-norec (car (get-login-user system)) (new-buscar-chatbot-norec (get-chatbot-system system)(new-chatbot-message-palabra-norec (get-options-flow (car (get-flows-chatbot (car (get-talk-system system))))) message)) (get-system-user system))
                        (get-login-user system)
                        (cons (new-buscar-chatbot-norec (get-chatbot-system system)(new-chatbot-message-palabra-norec (get-options-flow (car (get-flows-chatbot (car (get-talk-system system))))) message))
                              (get-talk-system system))
                        (get-current-seconds system))
                  (list (get-name-system system)
                        (get-codelink-system system)
                        (get-chatbot-system system)
                        (agregar-contenido-norec (car (get-login-user system)) (new-buscar-chatbot-norec (get-chatbot-system system) (new-chatbot-message-palabra-norec (caddr (car (get-talk-system system))) message)) (get-system-user system))
                        (get-login-user system)
                        (cons (new-buscar-chatbot-norec (get-chatbot-system system) (new-chatbot-message-palabra-norec (caddr (car (get-talk-system system))) message))
                              (get-talk-system system))
                        (get-current-seconds system)))))
      system))







;-------------------------------------------------Provide------------------------------------------------
(provide (all-defined-out))
