;;;Ikarus Scheme -- A compiler for R6RS Scheme.
;;;Copyright (C) 2006,2007,2008  Abdulaziz Ghuloum
;;;Modified by Marco Maggi <marco.maggi-ipsu@poste.it>
;;;
;;;This program is free software: you can  redistribute it and/or modify it under the
;;;terms  of the  GNU General  Public  License version  3  as published  by the  Free
;;;Software Foundation.
;;;
;;;This program is  distributed in the hope  that it will be useful,  but WITHOUT ANY
;;;WARRANTY; without  even the implied warranty  of MERCHANTABILITY or FITNESS  FOR A
;;;PARTICULAR PURPOSE.  See the GNU General Public License for more details.
;;;
;;;You should have received a copy of  the GNU General Public License along with this
;;;program.  If not, see <http://www.gnu.org/licenses/>.


#!vicare
(library (ikarus conditions)
  (export
    condition? compound-condition? condition-and-rtd?
    simple-condition?
    list-of-conditions?
    list-of-simple-conditions?
    simple-conditions condition-predicate
    condition condition-accessor print-condition

    raise-non-continuable-standard-condition

    make-message-condition message-condition?
    condition-message make-warning warning?
    make-serious-condition serious-condition? make-error
    error? make-violation violation? make-assertion-violation
    assertion-violation? make-irritants-condition
    irritants-condition? condition-irritants
    make-who-condition who-condition? condition-who
    make-non-continuable-violation non-continuable-violation?
    make-implementation-restriction-violation
    implementation-restriction-violation?
    make-lexical-violation lexical-violation?
    make-syntax-violation syntax-violation?
    syntax-violation-form syntax-violation-subform
    make-undefined-violation undefined-violation?
    make-i/o-error i/o-error? make-i/o-read-error
    i/o-read-error? make-i/o-write-error i/o-write-error?
    make-i/o-invalid-position-error
    i/o-invalid-position-error? i/o-error-position
    make-i/o-filename-error i/o-filename-error?
    i/o-error-filename make-i/o-file-protection-error
    i/o-file-protection-error? make-i/o-file-is-read-only-error
    i/o-file-is-read-only-error?
    make-i/o-file-already-exists-error
    i/o-file-already-exists-error?
    make-i/o-file-does-not-exist-error
    i/o-file-does-not-exist-error? make-i/o-port-error
    i/o-port-error? i/o-error-port make-i/o-decoding-error
    i/o-decoding-error? make-i/o-encoding-error
    i/o-encoding-error? i/o-encoding-error-char
    no-infinities-violation? make-no-infinities-violation
    no-nans-violation? make-no-nans-violation
    interrupted-condition? make-interrupted-condition
    make-source-position-condition source-position-condition?
    source-position-port-id
    source-position-byte source-position-character
    source-position-line source-position-column

    &condition-rtd &condition-rcd &message-rtd &message-rcd
    &warning-rtd &warning-rcd &serious-rtd &serious-rcd
    &error-rtd &error-rcd &violation-rtd &violation-rcd
    &assertion-rtd &assertion-rcd &irritants-rtd
    &irritants-rcd &who-rtd &who-rcd &non-continuable-rtd
    &non-continuable-rcd &implementation-restriction-rtd
    &implementation-restriction-rcd &lexical-rtd &lexical-rcd
    &syntax-rtd &syntax-rcd &undefined-rtd &undefined-rcd
    &i/o-rtd &i/o-rcd &i/o-read-rtd &i/o-read-rcd
    &i/o-write-rtd &i/o-write-rcd &i/o-invalid-position-rtd
    &i/o-invalid-position-rcd &i/o-filename-rtd
    &i/o-filename-rcd &i/o-file-protection-rtd
    &i/o-file-protection-rcd &i/o-file-is-read-only-rtd
    &i/o-file-is-read-only-rcd &i/o-file-already-exists-rtd
    &i/o-file-already-exists-rcd &i/o-file-does-not-exist-rtd
    &i/o-file-does-not-exist-rcd &i/o-port-rtd &i/o-port-rcd
    &i/o-decoding-rtd &i/o-decoding-rcd &i/o-encoding-rtd
    &i/o-encoding-rcd &no-infinities-rtd &no-infinities-rcd
    &no-nans-rtd &no-nans-rcd
    &interrupted-rtd &interrupted-rcd
    &source-position-rtd &source-position-rcd

    &i/o-eagain make-i/o-eagain i/o-eagain-error?
    &i/o-eagain-rtd &i/o-eagain-rcd

    &errno &errno-rtd &errno-rcd
    make-errno-condition errno-condition? condition-errno
    &h_errno &h_errno-rtd &h_errno-rcd
    make-h_errno-condition h_errno-condition? condition-h_errno

    &failed-expression-condition
    &failed-expression-condition-rtd
    &failed-expression-condition-rcd
    make-failed-expression-condition
    failed-expression-condition?
    condition-failed-expression

    &procedure-precondition-violation
    &procedure-precondition-violation-rtd
    &procedure-precondition-violation-rcd
    make-procedure-precondition-violation
    procedure-precondition-violation?

    &procedure-postcondition-violation
    &procedure-postcondition-violation-rtd
    &procedure-postcondition-violation-rcd
    make-procedure-postcondition-violation
    procedure-postcondition-violation?

    &procedure-argument-violation
    &procedure-argument-violation-rtd
    &procedure-argument-violation-rcd
    make-procedure-argument-violation
    procedure-argument-violation?
    procedure-argument-violation

    &procedure-signature-argument-violation
    &procedure-signature-argument-violation-rtd
    &procedure-signature-argument-violation-rcd
    make-procedure-signature-argument-violation
    procedure-signature-argument-violation?
    procedure-signature-argument-violation.one-based-argument-index
    procedure-signature-argument-violation.failed-expression
    procedure-signature-argument-violation.offending-value
    procedure-signature-argument-violation

    &procedure-signature-return-value-violation
    &procedure-signature-return-value-violation-rtd
    &procedure-signature-return-value-violation-rcd
    make-procedure-signature-return-value-violation
    procedure-signature-return-value-violation?
    procedure-signature-return-value-violation.one-based-return-value-index
    procedure-signature-return-value-violation.failed-expression
    procedure-signature-return-value-violation.offending-value
    procedure-signature-return-value-violation

    &procedure-arguments-consistency-violation
    &procedure-arguments-consistency-violation-rtd
    &procedure-arguments-consistency-violation-rcd
    make-procedure-arguments-consistency-violation
    procedure-arguments-consistency-violation?
    procedure-arguments-consistency-violation
    procedure-arguments-consistency-violation/failed-expression

    &expression-return-value-violation
    &expression-return-value-violation-rtd
    &expression-return-value-violation-rcd
    make-expression-return-value-violation
    expression-return-value-violation?
    expression-return-value-violation

    &non-reinstatable
    make-non-reinstatable-violation
    non-reinstatable-violation?
    non-reinstatable-violation

    preconditions)
  (import (except (vicare)

		  ;;We use an internal macro  definition to define condition types in
		  ;;this library.
		  define-condition-type

		  condition? compound-condition? condition-and-rtd?
		  simple-condition?
		  list-of-conditions?
		  list-of-simple-conditions?
		  simple-conditions
		  condition condition-predicate condition-accessor
		  print-condition

		  raise-non-continuable-standard-condition

		  &condition &message &warning &serious &error &violation
		  &assertion &irritants &who &non-continuable
		  &implementation-restriction &lexical &syntax &undefined
		  &i/o &i/o-read &i/o-write &i/o-invalid-position
		  &i/o-filename &i/o-file-protection &i/o-file-is-read-only
		  &i/o-file-already-exists &i/o-file-does-not-exist
		  &i/o-port &i/o-decoding &i/o-encoding &no-infinities
		  &no-nans

		  make-message-condition message-condition?
		  condition-message make-warning warning?
		  make-serious-condition serious-condition? make-error
		  error? make-violation violation? make-assertion-violation
		  assertion-violation? make-irritants-condition
		  irritants-condition? condition-irritants
		  make-who-condition who-condition? condition-who
		  make-non-continuable-violation non-continuable-violation?
		  make-implementation-restriction-violation
		  implementation-restriction-violation?
		  make-lexical-violation lexical-violation?
		  make-syntax-violation syntax-violation?
		  syntax-violation-form syntax-violation-subform
		  make-undefined-violation undefined-violation?
		  make-i/o-error i/o-error? make-i/o-read-error
		  i/o-read-error? make-i/o-write-error i/o-write-error?
		  make-i/o-invalid-position-error
		  i/o-invalid-position-error? i/o-error-position
		  make-i/o-filename-error i/o-filename-error?
		  i/o-error-filename make-i/o-file-protection-error
		  i/o-file-protection-error? make-i/o-file-is-read-only-error
		  i/o-file-is-read-only-error?
		  make-i/o-file-already-exists-error
		  i/o-file-already-exists-error?
		  make-i/o-file-does-not-exist-error
		  i/o-file-does-not-exist-error? make-i/o-port-error
		  i/o-port-error? i/o-error-port make-i/o-decoding-error
		  i/o-decoding-error? make-i/o-encoding-error
		  i/o-encoding-error? i/o-encoding-error-char
		  no-infinities-violation? make-no-infinities-violation
		  no-nans-violation? make-no-nans-violation

		  &i/o-eagain make-i/o-eagain i/o-eagain-error?
		  &i/o-eagain-rtd &i/o-eagain-rcd

		  &errno &errno-rtd &errno-rcd
		  make-errno-condition errno-condition?
		  condition-errno

		  &h_errno &h_errno-rtd &h_errno-rcd
		  make-h_errno-condition h_errno-condition?
		  condition-h_errno

		  interrupted-condition? make-interrupted-condition
		  make-source-position-condition source-position-condition?
		  source-position-port-id
		  source-position-byte source-position-character
		  source-position-line source-position-column

		  &failed-expression-condition
		  &failed-expression-condition-rtd
		  &failed-expression-condition-rcd
		  make-failed-expression-condition
		  failed-expression-condition?
		  condition-failed-expression

		  &procedure-precondition-violation
		  &procedure-precondition-violation-rtd
		  &procedure-precondition-violation-rcd
		  make-procedure-precondition-violation
		  procedure-precondition-violation?

		  &procedure-postcondition-violation
		  &procedure-postcondition-violation-rtd
		  &procedure-postcondition-violation-rcd
		  make-procedure-postcondition-violation
		  procedure-postcondition-violation?

		  &procedure-argument-violation
		  &procedure-argument-violation-rtd
		  &procedure-argument-violation-rcd
		  make-procedure-argument-violation
		  procedure-argument-violation?
		  procedure-argument-violation

		  &procedure-signature-argument-violation
		  &procedure-signature-argument-violation-rtd
		  &procedure-signature-argument-violation-rcd
		  make-procedure-signature-argument-violation
		  procedure-signature-argument-violation?
		  procedure-signature-argument-violation.one-based-argument-index
		  procedure-signature-argument-violation.failed-expression
		  procedure-signature-argument-violation.offending-value
		  procedure-signature-argument-violation

		  &procedure-signature-return-value-violation
		  &procedure-signature-return-value-violation-rtd
		  &procedure-signature-return-value-violation-rcd
		  make-procedure-signature-return-value-violation
		  procedure-signature-return-value-violation?
		  procedure-signature-return-value-violation.one-based-return-value-index
		  procedure-signature-return-value-violation.failed-expression
		  procedure-signature-return-value-violation.offending-value
		  procedure-signature-return-value-violation

		  &procedure-arguments-consistency-violation
		  &procedure-arguments-consistency-violation-rtd
		  &procedure-arguments-consistency-violation-rcd
		  make-procedure-arguments-consistency-violation
		  procedure-arguments-consistency-violation?
		  procedure-arguments-consistency-violation

		  &expression-return-value-violation
		  &expression-return-value-violation-rtd
		  &expression-return-value-violation-rcd
		  make-expression-return-value-violation
		  expression-return-value-violation?
		  expression-return-value-violation

		  &non-reinstatable
		  &non-reinstatable-rtd
		  &non-reinstatable-rcd
		  make-non-reinstatable-violation
		  non-reinstatable-violation?
		  non-reinstatable-violation)
    (only (ikarus records procedural)
	  rtd-subtype?)
    (only (vicare language-extensions syntaxes)
	  define-list-of-type-predicate
	  define-min/max-comparison
	  define-equality/sorting-predicate
	  define-inequality-predicate))


;;;; arguments validation

(define (simple-condition-rtd-subtype? obj)
  (and (record-type-descriptor? obj)
       (rtd-subtype? obj (record-type-descriptor &condition))))

(define-list-of-type-predicate list-of-conditions? condition?)
(define-list-of-type-predicate list-of-simple-conditions? simple-condition?)


;;;; data types and some predicates

(define-record-type (&condition make-simple-condition simple-condition?)
  (nongenerative))

(define &condition-rtd
  (record-type-descriptor &condition))

(define &condition-rcd
  (record-constructor-descriptor &condition))

;;; --------------------------------------------------------------------

(define-record-type compound-condition
  (nongenerative)
  (fields (immutable components))
  (sealed #t)
  (opaque #f))

;;; --------------------------------------------------------------------

(define (condition? x)
  ;;Defined by R6RS.  Return  #t if X is a (simple  or compound) condition, otherwise
  ;;return #f.
  ;;
  (or (simple-condition? x)
      (compound-condition? x)))

(define* (condition-and-rtd? obj {rtd simple-condition-rtd-subtype?})
  (let ((p? (record-predicate rtd)))
    (cond ((compound-condition? obj)
	   (let loop ((ls (compound-condition-components obj)))
	     (and (pair? ls)
		  (or (p? (car ls))
		      (loop (cdr ls))))))
	  ((simple-condition? obj)
	   (p? obj))
	  (else #f))))


(case-define* condition
  ;;Defined by R6RS.  Return a condition  object with the components of the condition
  ;;arguments  as its  components,  in the  same order.   The  returned condition  is
  ;;compound  if  the  total number  of  components  is  zero  or greater  than  one.
  ;;Otherwise, it may be compound or simple.
  ;;
  (()
   (make-compound-condition '()))
  (({x condition?})
   x)
  (x*
   (let ((ls (let recur ((x* x*))
	       (if (pair? x*)
		   (cond ((simple-condition? (car x*))
			  (cons (car x*) (recur (cdr x*))))
			 ((compound-condition? (car x*))
			  (append (simple-conditions (car x*)) (recur (cdr x*))))
			 (else
			  (procedure-argument-violation __who__
			    "expected condition object as argument"
			    (car x*))))
		 '()))))
     (cond ((null? ls)
	    (make-compound-condition '()))
	   ((null? (cdr ls))
	    (car ls))
	   (else
	    (make-compound-condition ls))))))

(define* (simple-conditions x)
  ;;Defined by R6RS.  Return a list of the components of X, in the same order as they
  ;;appeared  in the  construction of  X.  The  returned list  is immutable.   If the
  ;;returned list is modified, the effect on X is unspecified.
  ;;
  ;;NOTE  Because   CONDITION  decomposes  its  arguments   into  simple  conditions,
  ;;SIMPLE-CONDITIONS always returns a ``flattened'' list of simple conditions.
  ;;
  (cond ((compound-condition? x)
	 (compound-condition-components x))
	((simple-condition? x)
	 (list x))
	(else
	 (procedure-argument-violation __who__
	   "expected condition object as argument"
	   x))))


(define* (condition-predicate {rtd simple-condition-rtd-subtype?})
  ;;Defined  by  R6RS.   RTD  must  be  a record-type  descriptor  of  a  subtype  of
  ;;"&condition".  The  CONDITION-PREDICATE procedure returns a  procedure that takes
  ;;one argument.  This  procedure returns #t if  its argument is a  condition of the
  ;;condition type represented  by RTD, i.e., if  it is either a  simple condition of
  ;;that record type (or  one of its subtypes) or a compound  conditition with such a
  ;;simple condition as one of its components, and #f otherwise.
  ;;
  (let ((p? (record-predicate rtd)))
    (lambda (x)
      (or (p? x)
	  (and (compound-condition? x)
	       (let loop ((ls (compound-condition-components x)))
		 (and (pair? ls)
		      (or (p? (car ls))
			  (loop (cdr ls))))))))))

(define* (condition-accessor {rtd simple-condition-rtd-subtype?} {proc procedure?})
  ;;Defined  by  R6RS.   RTD  must  be  a record-type  descriptor  of  a  subtype  of
  ;;"&condition".  PROC  should accept one argument,  a record of the  record type of
  ;;RTD.
  ;;
  ;;The  CONDITION-ACCESSOR  procedure returns  a  procedure  that accepts  a  single
  ;;argument,  which must  be  a condition  of  the type  represented  by RTD.   This
  ;;procedure extracts the  first component of the condition of  the type represented
  ;;by RTD, and returns the result of applying PROC to that component.
  ;;
  (let ((p? (record-predicate rtd)))
    (lambda (x)
      (fluid-let-syntax
	  ((__who__ (identifier-syntax 'anonymous-condition-accessor)))
	(define (%error)
	  (procedure-arguments-consistency-violation __who__ "not a condition of correct type" x rtd))
	(cond ((p? x)
	       (proc x))
	      ((compound-condition? x)
	       (let loop ((ls (compound-condition-components x)))
		 (cond ((pair? ls)
			(if (p? (car ls))
			    (proc (car ls))
			  (loop (cdr ls))))
		       (else
			(%error)))))
	      (else
	       (%error)))))))


;;;; raising exceptions

(case-define* raise-non-continuable-standard-condition
  (({who symbol?} {message string?} {irritants list?})
   (raise
    (condition (make-who-condition who)
	       (make-message-condition message)
	       (make-irritants-condition irritants))))
  (({who symbol?} {message string?} {irritants list?} {cnd condition?})
   (raise
    (condition cnd
	       (make-who-condition who)
	       (make-message-condition message)
	       (make-irritants-condition irritants)))))


(define-syntax (define-condition-type stx)
  ;;This macro is used in this library to define condition object types.
  ;;
  ;;NOTE Remember that this  macro is *not* the one exported by  the boot image.  The
  ;;transformer of  the keyword  binding DEFINE-CONDITION-TYPE  exported by  the boot
  ;;image is integrated in the expander.
  ;;
  (define (mkname name suffix)
    (datum->syntax name
		   (string->symbol
		    (string-append (symbol->string (syntax->datum name))
				   suffix))))
  (syntax-case stx ()
    ((ctxt name super constructor predicate (field* accessor*) ...)
     (and (identifier? #'name)
	  (identifier? #'super)
	  (identifier? #'constructor)
	  (identifier? #'predicate)
	  (andmap identifier? #'(field* ...))
	  (andmap identifier? #'(accessor* ...)))
     (with-syntax (((aux-accessor* ...) (generate-temporaries #'(accessor* ...)))
		   (rtd (mkname #'name "-rtd"))
		   (rcd (mkname #'name "-rcd")))
       #'(begin
	   (define-record-type (name constructor p?)
	     (parent super)
	     (fields (immutable field* aux-accessor*) ...)
	     (nongenerative)
	     (sealed #f) (opaque #f))
	   (define predicate (condition-predicate (record-type-descriptor name)))
	   (define accessor* (condition-accessor (record-type-descriptor name) aux-accessor*))
	   ...
	   (define rtd (record-type-descriptor name))
	   (define rcd (record-constructor-descriptor name)))))
    ))


;;;; R6RS condition types

(define-condition-type &message &condition
  make-message-condition message-condition?
  (message condition-message))

(define-condition-type &warning &condition
  make-warning warning?)

(define-condition-type &serious &condition
  make-serious-condition serious-condition?)

(define-condition-type &error &serious
  make-error error?)

(define-condition-type &violation &serious
  make-violation violation?)

(define-condition-type &assertion &violation
  make-assertion-violation assertion-violation?)

(define-condition-type &irritants &condition
  make-irritants-condition irritants-condition?
  (irritants condition-irritants))

(define-condition-type &who &condition
  make-who-condition who-condition?
  (who condition-who))

(define-condition-type &non-continuable &violation
  make-non-continuable-violation non-continuable-violation?)

(define-condition-type &implementation-restriction &violation
  make-implementation-restriction-violation
  implementation-restriction-violation?)

(define-condition-type &lexical &violation
  make-lexical-violation lexical-violation?)

(define-condition-type &syntax &violation
  make-syntax-violation syntax-violation?
  (form syntax-violation-form)
  (subform syntax-violation-subform))

(define-condition-type &undefined &violation
  make-undefined-violation undefined-violation?)

(define-condition-type &i/o &error
  make-i/o-error i/o-error?)

(define-condition-type &i/o-read &i/o
  make-i/o-read-error i/o-read-error?)

(define-condition-type &i/o-write &i/o
  make-i/o-write-error i/o-write-error?)

(define-condition-type &i/o-invalid-position &i/o
  make-i/o-invalid-position-error i/o-invalid-position-error?
  (position i/o-error-position))

(define-condition-type &i/o-filename &i/o
  make-i/o-filename-error i/o-filename-error?
  (filename i/o-error-filename))

(define-condition-type &i/o-file-protection &i/o-filename
  make-i/o-file-protection-error i/o-file-protection-error?)

(define-condition-type &i/o-file-is-read-only &i/o-file-protection
  make-i/o-file-is-read-only-error i/o-file-is-read-only-error?)

(define-condition-type &i/o-file-already-exists &i/o-filename
  make-i/o-file-already-exists-error i/o-file-already-exists-error?)

(define-condition-type &i/o-file-does-not-exist &i/o-filename
  make-i/o-file-does-not-exist-error i/o-file-does-not-exist-error?)

(define-condition-type &i/o-port &i/o
  make-i/o-port-error i/o-port-error?
  (port i/o-error-port))

(define-condition-type &i/o-decoding &i/o-port
  make-i/o-decoding-error i/o-decoding-error?)

(define-condition-type &i/o-encoding &i/o-port
  make-i/o-encoding-error i/o-encoding-error?
  (char i/o-encoding-error-char))

(define-condition-type &no-infinities &implementation-restriction
  make-no-infinities-violation no-infinities-violation?)

(define-condition-type &no-nans &implementation-restriction
  make-no-nans-violation no-nans-violation?)

;;; --------------------------------------------------------------------
;;; Ikarus specific condition types

(define-condition-type &interrupted &serious
  make-interrupted-condition interrupted-condition?)

(define-condition-type &source-position &condition
  make-source-position-condition source-position-condition?
  (port-id	source-position-port-id)
  (byte		source-position-byte)
  (character	source-position-character)
  (line		source-position-line)
  (column	source-position-column))


;;; Vicare specific condition types

(define-condition-type &i/o-eagain
    &i/o
  make-i/o-eagain i/o-eagain-error?)

(define-condition-type &errno
    &condition
  make-errno-condition errno-condition?
  (code		condition-errno))

(define-condition-type &h_errno
    &condition
  make-h_errno-condition h_errno-condition?
  (code		condition-h_errno))

(define-condition-type &failed-expression-condition
    &condition
  make-failed-expression-condition
  failed-expression-condition?
  (failed-expression	condition-failed-expression))

;;; --------------------------------------------------------------------

(define-condition-type &procedure-precondition-violation
    &assertion
  make-procedure-precondition-violation
  procedure-precondition-violation?)

;;; --------------------------------------------------------------------

(define-condition-type &procedure-postcondition-violation
    &assertion
  make-procedure-postcondition-violation
  procedure-postcondition-violation?)

;;; --------------------------------------------------------------------

(define-condition-type &procedure-argument-violation
    &procedure-precondition-violation
  make-procedure-argument-violation procedure-argument-violation?)

(define (procedure-argument-violation who message . irritants)
  (raise-non-continuable-standard-condition who
    message irritants (make-procedure-argument-violation)))

;;; --------------------------------------------------------------------

(define-condition-type &procedure-signature-argument-violation
    &procedure-argument-violation
  make-procedure-signature-argument-violation procedure-signature-argument-violation?
  ;;One-base index of the offending operand.
  (one-based-argument-index	procedure-signature-argument-violation.one-based-argument-index)
  ;;Symbolic expression representing the predicate used to validate the operand.
  (failed-expression		procedure-signature-argument-violation.failed-expression)
  ;;The actual operand.
  (offending-value		procedure-signature-argument-violation.offending-value))

(define (procedure-signature-argument-violation who message operand-index failed-expression offending-value)
  (raise-non-continuable-standard-condition who
    message (list offending-value)
    (make-procedure-signature-argument-violation operand-index failed-expression offending-value)))

;;; --------------------------------------------------------------------

(define-condition-type &procedure-signature-return-value-violation
    &procedure-postcondition-violation
  make-procedure-signature-return-value-violation procedure-signature-return-value-violation?
  ;;One-base index of the  offending return value in the tuple  of values returned by
  ;;the expression.
  (one-based-return-value-index	procedure-signature-return-value-violation.one-based-return-value-index)
  ;;Symbolic expression representing the predicate used to validate the return value.
  (failed-expression		procedure-signature-return-value-violation.failed-expression)
  ;;The actual value returned by the expression.
  (offending-value		procedure-signature-return-value-violation.offending-value))

(define (procedure-signature-return-value-violation who message retval-index failed-expression offending-value)
  (raise-non-continuable-standard-condition who
    message (list offending-value)
    (make-procedure-signature-return-value-violation retval-index failed-expression offending-value)))

;;; --------------------------------------------------------------------

(define-condition-type &procedure-arguments-consistency-violation
    &procedure-precondition-violation
  make-procedure-arguments-consistency-violation
  procedure-arguments-consistency-violation?)

(define (procedure-arguments-consistency-violation who message . irritants)
  (raise-non-continuable-standard-condition who
    message irritants
    (make-procedure-arguments-consistency-violation)))

(define (procedure-arguments-consistency-violation/failed-expression who message failed-expression . irritants)
  (raise-non-continuable-standard-condition who
    message irritants
    (condition (make-procedure-arguments-consistency-violation)
	       (make-failed-expression-condition failed-expression))))

;;; --------------------------------------------------------------------

(define-condition-type &expression-return-value-violation
    &assertion
  make-expression-return-value-violation expression-return-value-violation?)

(define (expression-return-value-violation who message . irritants)
  (raise-non-continuable-standard-condition who message irritants (make-expression-return-value-violation)))

;;; --------------------------------------------------------------------

(define-condition-type &non-reinstatable
    &violation
  make-non-reinstatable-violation
  non-reinstatable-violation?)

(define (non-reinstatable-violation who message . irritants)
  (raise-non-continuable-standard-condition who
    message irritants (make-non-reinstatable-violation)))


;;;; printing condition objects

(case-define* print-condition
  ;;Defined by Ikarus.  Print a human readable serialisation of a condition object to
  ;;the given port.
  ;;
  ((x)
   (print-condition x (console-error-port)))
  ((x {port textual-output-port?})
   (if (condition? x)
       (let ((ls (simple-conditions x)))
	 (if (pair? ls)
	     (begin
	       (display " Condition components:\n" port)
	       (let loop ((ls ls) (i 1))
		 (when (pair? ls)
		   (display "   " port)
		   (display i port)
		   (display ". " port)
		   (%print-simple-condition (car ls) port)
		   (loop (cdr ls) (fxadd1 i)))))
	   (display "Condition object with no further information\n" port)))
     (begin
       (display " Non-condition object: " port)
       (write x port)
       (newline port)))))

(define (%print-simple-condition x port)
  (let* ((rtd	(record-rtd x))
	 ;;Association list  having RTDs as keys and  vectors of symbols
	 ;;representing  the  field  names  as values.   Represents  the
	 ;;hierarchy of RTDs from child to parent.
	 ;;
	 (rf	(let loop ((rtd   rtd)
			   (accum '()))
		  (if rtd
		      (loop (record-type-parent rtd)
			    (cons (cons rtd (record-type-field-names rtd))
				  accum))
		    (remp (lambda (a)
			    (zero? (vector-length (cdr a))))
		      accum))))
	 (rf-len (fold-left (lambda (sum pair)
			      (+ sum (vector-length (cdr pair))))
		   0
		   rf)
		 #;(apply + (map vector-length (map cdr rf)))))
    (display (record-type-name rtd) port)
    (case rf-len
      ((0)	;Most condition objects have no fields...
       (newline port))
      ((1)	;... or only one field.
       (display ": " port)
       (pretty-print ((record-accessor (caar rf) 0) x) port)
       #;(write ((record-accessor (caar rf) 0) x) port)
       #;(newline port))
      (else
       (display ":\n" port)
       (for-each
	   (lambda (a)
	     (let loop ((i   0)
			(rtd (car a))
			(v   (cdr a)))
	       (unless (= i (vector-length v))
		 (display "       " port)
		 (display (vector-ref v i) port)
		 (display ": " port)
		 ;;Sometimes WRITE is better than PRETTY-PRINT, but what
		 ;;can I do?  (Marco Maggi; Oct 31, 2012)
		 (pretty-print ((record-accessor rtd i) x)
			       port)
		 ;; (begin
		 ;;   (write ((record-accessor rtd i) x) port)
		 ;;   (newline port))
		 (loop (fxadd1 i) rtd v))))
	 rf)))))


;;;; syntaxes

(define-syntax (preconditions stx)
  (module (vicare-built-with-arguments-validation-enabled)
    (module (arguments-validation)
      (include "ikarus.config.scm" #t))
    (define (vicare-built-with-arguments-validation-enabled)
      arguments-validation)
    #| end of module |# )
  (syntax-case stx ()
    ;;Single precondition.
    ;;
    ((_ (?predicate ?arg ...))
     (identifier? #'?who)
     (if (vicare-built-with-arguments-validation-enabled)
	 #'(unless (?predicate ?arg ...)
	     (procedure-arguments-consistency-violation/failed-expression __who__
	       "failed precondition" '(?predicate ?arg ...) ?arg ...))
       #'(void)))

    ;;Multiple preconditions.
    ;;
    ((_ (?predicate ?arg ...) ...)
     (identifier? #'?who)
     (if (vicare-built-with-arguments-validation-enabled)
	 #'(begin
	     (preconditions (?predicate ?arg ...))
	     ...)
       #'(void)))
    ))


;;;; done

;;(foreign-call "ikrt_print_emergency" #ve(ascii "ikarus.conditions"))

#| end of library |# )

;;; end of file
