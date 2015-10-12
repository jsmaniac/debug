#lang racket/base

(provide (all-defined-out))

(require (for-syntax racket/base))

;; from mbutterick/sugar, typed/sugar/debug.rkt
;; https://github.com/mbutterick/sugar/blob/0ffe3173879cef51d29b4c91a336a4de6c3f8ef8/typed/sugar/debug.rkt
;; using normal racket/base so that it doesn't have a dependancy on typed racket

(define-syntax (report stx)
  (syntax-case stx ()
    [(_ expr) #'(report expr expr)]
    [(_ expr name)
     #'(let ([expr-result expr]) 
         (eprintf "~a = ~v\n" 'name expr-result)
         expr-result)]))


(define-syntax (report/line stx)
  (syntax-case stx ()
    [(_ expr) #'(report/line expr expr)]
    [(_ expr name)
     (with-syntax ([line (syntax-line #'expr)])
       #'(let ([expr-result expr])
           (eprintf "~a = ~v on line ~v\n" 'name expr-result 'line)
           expr-result))]))


(define-syntax (report/file stx)
  (syntax-case stx ()
    [(_ expr) #'(report/file expr expr)]
    [(_ expr name)
     (with-syntax ([file (syntax-source #'expr)]
                   [line (syntax-line #'expr)])
       #'(let ([expr-result expr])
           (eprintf "~a = ~v on line ~v in \"~a\"\n" 'name expr-result 'line 'file)
           expr-result))]))


(define-syntax-rule (define-multi-version multi-name name)
  (define-syntax-rule (multi-name x (... ...))
    (begin (name x) (... ...))))

(define-multi-version report* report)
(define-multi-version report*/line report/line)
(define-multi-version report*/file report/file)
