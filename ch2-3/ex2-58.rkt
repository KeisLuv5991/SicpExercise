#lang sicp


; Exercise 2.58.

; Suppose we want to modify the differentiation program so that it works with ordinary mathematical
; notation, in which + and * are infix rather than prefix operators.
; Since the differentiation program is defined in terms of abstract data, we can modify it to work
; with different representations of expressions solely by changing the predicates, selectors,
; and constructors that define the representation of the algebraic expressions
; on which the differentiator is to operate.

; a. Show how to do this in order to differentiate algebraic expressions presented in infix form,
;    such as (x + (3 * (x + (y + 2)))). To simplify the task, assume that + and * always take
;    two arguments and that expressions are fully parenthesized.

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list a1 '+ a2))))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))))

(define (sum? x)
  (and (pair? x) (pair? (cdr x)) (eq? (cadr x) '+)))

(define (augend s) (car s))

(define (addend s) (caddr s))

(define (product? x)
  (and (pair? x) (pair? (cdr x)) (eq? (cadr x) '*)))

(define (multiplicand p) (car p))

(define (multiplier p) (caddr p))

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
          (make-product (multiplier exp)
                        (deriv (multiplicand exp) var))
          (make-product (deriv (multiplier exp) var)
                        (multiplicand exp))))
        (else
         (error "unknown expression type -- DERIV" exp))))


(deriv '(x + (3 * (x + (y + 2)))) 'x)


; b. The problem becomes substantially harder if we allow standard algebraic notation, such as
;    (x + 3 * (x + y + 2)), which drops unnecessary parentheses and assumes that multiplication
;    is done before addition. Can you design appropriate predicates, selectors, and constructors
;    for this notation such that our derivative program still works?

(define op-priority (list '* '+))
(define (select-op s) (cadr s))
(define (prior? op)
  (if (equal? op (car op-priority))
      #t
      #f))

(define (next-op-exist? s) (and (not (null? (cdr s)))
                                (not (null? (cddr s)))
                                (not (null? (cdddr s)))
                                (not (null? (cdr (cdddr s))))))
(define (next-exp s) (cddr s))

(define (deriv2 exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        (else (let ((now-op (select-op exp)))
                (cond ((prior? now-op)
                       (make-sum
                        (make-product (multiplier exp)
                                      (deriv (multiplicand exp) var))
                        (make-product (deriv (multiplier exp) var)
                                      (multiplicand exp))))
                      ((next-op-exist? exp)
                       (deriv (make-sum (augend exp)
                                        (next-exp exp))
                              var))
                      ((sum? exp)
                       (make-sum (deriv (addend exp) var)
                                 (deriv (augend exp) var)))
                      (else (error "unknown expression type -- DERIV" exp)))))))


(deriv2 '(x + 3 * (x + y + 2)) 'x)

