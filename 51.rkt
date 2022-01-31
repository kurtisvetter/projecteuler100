#lang racket

(require math/number-theory)
(require "mylib/useful.rkt")

; returns the length of the prime family generated by replacing digits y in x
; e.g. x=56003 y=0b00110 => 56003,56113,56223...
; this function returns the number of these that are prime (in that case 7)
(define (prime-family x y)
  (let* [(lx (number->list x))
         (y (base-convert y 2))
         (digits (append (make-list (- (length lx) (length (number->list y))) 0)
                                (number->list y)))
         ; if x=12345, y=0b01100, start=10045
         (start (list->number
                 (map
                  (λ (a b) (cond [(= b 0) a]
                                 [(= b 1) 0]))
                  lx
                  digits)))]
    (count prime? (map (λ (a) (+ start (* y a)))
                       (range 10)))))

; find the smallest prime, starting from p, that is an n-value prime family
(define (find p n)
  (cond [(ormap (λ (y)
                  (= n (prime-family p y))) ; if a combination is an n-value prime family
                (range 1 (add1 (expt 2 (floor (log p 10)))))) ; map over every possible combination of digits to change
         p] ; we are done
        ; otherwise continue to the next prime
        [else (find (next-prime p) n)]))

(find 2 8)