(macro set?
     ;; if not defined,
     (unless ((context) (car margs))
             ;; set the value in the context,
             ((context) setObject: (eval (second margs)) forKey: (car margs)))
      ;; regardless, return the value of the variable
     ((context) (car margs)))
