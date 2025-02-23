#lang sicp
(#%require sicp-pict)


; Exercise 2.46.

; A two-dimensional vector v running from the origin to a point can be represented as a pair
; consisting of an x-coordinate and a y-coordinate.
; Implement a data abstraction for vectors by giving a constructor make-vect and corresponding
; selectors xcor-vect and ycor-vect. In terms of your selectors and constructor,
; implement procedures add-vect, sub-vect, and scale-vect that perform the operations vector addition,
; vector subtraction, and multiplying a vector by a scalar:

; (x_1, y_1) + (x_2, y_2) = (x_1 + x_2, y_1 + y_2)
; (x_1, y_1) - (x_2, y_2) = (x_1 - x_2, y_1 - y_2)
; s·(x, y)                = (sx, sy)


; ==================================================
; Define data abstraction of vector
(define (make-vect x y)
  (cons x y))
(define (xcor-vect v)
  (car v))
(define (ycor-vect v)
  (cdr v))

; ==================================================
; Define add-vect, sub-vect, scale-vect
(define (add-vect v1 v2)
  (make-vect (+ (xcor-vect v1) (xcor-vect v2))
             (+ (ycor-vect v1) (ycor-vect v2))))
(define (sub-vect v1 v2)
  (make-vect (- (xcor-vect v1) (xcor-vect v2))
             (- (ycor-vect v1) (ycor-vect v2))))
(define (scale-vect s v)
  (make-vect (* s (xcor-vect v))
             (* s (ycor-vect v))))

