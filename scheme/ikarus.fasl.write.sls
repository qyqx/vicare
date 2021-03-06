;;;Ikarus Scheme -- A compiler for R6RS Scheme.
;;;Copyright (C) 2006,2007,2008  Abdulaziz Ghuloum
;;;Modified by Marco Maggi <marco.maggi-ipsu@poste.it>.
;;;
;;;This program is free software:  you can redistribute it and/or modify
;;;it under  the terms of  the GNU General  Public License version  3 as
;;;published by the Free Software Foundation.
;;;
;;;This program is  distributed in the hope that it  will be useful, but
;;;WITHOUT  ANY   WARRANTY;  without   even  the  implied   warranty  of
;;;MERCHANTABILITY  or FITNESS FOR  A PARTICULAR  PURPOSE.  See  the GNU
;;;General Public License for more details.
;;;
;;;You should  have received  a copy of  the GNU General  Public License
;;;along with this program.  If not, see <http://www.gnu.org/licenses/>.


(library (ikarus.fasl.write)
  (export
    fasl-write
    fasl-write-header
    fasl-write-object
    writing-boot-image?)
  (import (except (vicare)
		  fixnum-width
		  greatest-fixnum
		  least-fixnum
		  fasl-write
		  fasl-write-header
		  fasl-write-object)
    ;;NOTE  This library  is needed  to build  a  new boot  image.  Let's  try to  do
    ;;everything here using the system  libraries and not loading external libraries.
    ;;(Marco Maggi; Fri May 23, 2014)
    (vicare system $fx)
    (vicare system $pairs)
    (vicare system $chars)
    (vicare system $flonums)
    (vicare system $bignums)
    (vicare system $vectors)
    (vicare system $strings)
    (vicare system $bytevectors)
    (vicare system $codes)
    (only (vicare system $structs)
	  base-rtd
	  $struct-rtd)
    (prefix (ikarus.code-objects)
    	    code.)
    (prefix (only (ikarus.options)
		  debug-mode-enabled?)
	    option.))

  (include "ikarus.wordsize.scm" #t)


;;;; helpers

(define who 'fasl-write)

(define writing-boot-image?
  (make-parameter #f))

(define fxshift
  (boot.case-word-size
   ((32)	2)
   ((64)	3)))

(define intbits (* wordsize 8))
(define fxbits  (- intbits fxshift))

(define fx?
  ;;FIXME Why FIXNUM? is not enough here?
  ;;
  (let ((DN (- (expt 2 (- fxbits 1))))
	(UP (- (expt 2 (- fxbits 1)) 1)))
    (lambda (x)
      (and (or (fixnum? x) (bignum? x))
	   (<= DN x UP)))))

(define int?
  (let ((DN (- (expt 2 (- intbits 1))))
	(UP (- (expt 2 (- intbits 1)) 1)))
    (lambda (x)
      (and (or (fixnum? x) (bignum? x))
	   (<= DN x UP)))))

(define-syntax $fxneg
  (syntax-rules ()
    ((_ ?op)
     ($fx- 0 ?op))))

(define-syntax write-byte
  (syntax-rules ()
    ((_ byte port)
     (put-u8 port byte))))

(define (put-tag ch port)
  ;;Write the single character CH to  the PORT as an octect.  It is used
  ;;to output the header of an object field.
  ;;
  (write-byte (char->integer ch) port))

(define (write-int32 x port)
  ;;Serialise  the  exact integer  X  to PORT  as  a  big endian  32-bit
  ;;integer.  If X is the integer:
  ;;
  ;;   X = #xAABBCCDD
  ;;         ^      ^
  ;;         |      least significant
  ;;         most significant
  ;;
  ;;in the file it is serialised as:
  ;;
  ;;                    DD CC BB AA
  ;;   head of file |--|--|--|--|--|--| tail of file
  ;;
  (write-byte (bitwise-and x          #xFF) port)
  (write-byte (bitwise-and (sra x 8)  #xFF) port)
  (write-byte (bitwise-and (sra x 16) #xFF) port)
  (write-byte (bitwise-and (sra x 24) #xFF) port))

(define (write-int x port)
  ;;Serialise the exact integer X to PORT: on 32-bit platforms, as a big
  ;;endian 32-bit integer; on 64-bit platforms, as a sequence of two big
  ;;endian 32-bit integers.
  ;;
  (assert (int? x))
  (boot.case-word-size
   ((32)
    (write-int32 x port))
   ((64)
    (write-int32 x port)
    (write-int32 (sra x 32) port))))

(define MAX-ASCII-CHAR
  ($fixnum->char 127))

(define (ascii-string? s)
  ;;Return true  if S is a  string holding only characters  in the ASCII
  ;;range.
  ;;
  (let next-char ((s s) (i 0) (n (string-length s)))
    (or ($fx= i n)
	(and ($char<= ($string-ref s i) MAX-ASCII-CHAR)
	     (next-char s ($fxadd1 i) n)))))

(define (write-bytevector bv i bv.len port)
  (unless ($fx= i bv.len)
    (write-byte ($bytevector-u8-ref bv i) port)
    (write-bytevector bv ($fxadd1 i) bv.len port)))


(case-define* fasl-write
  ((obj port)
   (fasl-write obj port #f))
  ((obj {port binary-output-port?} foreign-libraries)
   ;;Serialise OBJ to PORT prefixing it with the FASL file header.  FOREIGN-LIBRARIES
   ;;must be false or a list of strings representing foreign library identifiers
   ;;associated to the FASL file.  Return unspecified values.
   ;;
   ($fasl-write-header port)
   ($fasl-write-object obj port foreign-libraries)))

(define* (fasl-write-header {port binary-output-port?})
  ($fasl-write-header port))

(define ($fasl-write-header port)
  (put-tag #\# port)
  (put-tag #\@ port)
  (put-tag #\I port)
  (put-tag #\K port)
  (put-tag #\0 port)
  (put-tag (boot.case-word-size
	    ((32)	#\1)
	    ((64)	#\2))
	   port))

(case-define* fasl-write-object
  ((obj {port binary-output-port?})
   ($fasl-write-object obj port #f))
  ((obj {port binary-output-port?} foreign-libraries)
   ($fasl-write-object obj port foreign-libraries)))

(define ($fasl-write-object obj port foreign-libraries)
  (let ((refcount-table (make-eq-hashtable)))
    (make-graph obj               refcount-table)
    (make-graph foreign-libraries refcount-table)
    (let ((next-mark (if foreign-libraries
			 (let loop ((ls        foreign-libraries)
				    (next-mark 1))
			   (if (null? ls)
			       next-mark
			     (begin
			       (put-tag #\O port)
			       (loop (cdr ls)
				     (%write-object (car ls) port refcount-table next-mark)))))
		       1)))
      (%write-object obj port refcount-table next-mark)
      (void))))


(define (make-graph x h)
  ;;Visit object X counting how  many times its component objects appear
  ;;in  it.  Fill  the  EQ?   hashtable H  with  pairs object/fixnum  or
  ;;object/vector:
  ;;
  ;;*  For non-hashtable  objects:  the entries  are object/fixnum,  the
  ;;fixnum being  the number of references  to the object.
  ;;
  ;;*   for  EQ?   and   EQV?   hashtable   objects:  the   entries  are
  ;;object/vector, the vector having the format:
  ;;
  ;;	#(refcount keys vals)
  ;;
  ;;where <refcount> is the number of references to the table, <keys> is
  ;;the vector of keys, <vals> is the vector of values.
  ;;
  ;;The  hashtable is  filled  only with  objects  NOT being  immediate,
  ;;strings, bytevectors, fixnums of bignums.
  ;;
  ;;Remember that  "immediate" values are:  #t, #f, nil,  void, fixnums,
  ;;characters,  transcoders; that  is: all  the values  contained  in a
  ;;single machine word.
  ;;
  (unless (immediate? x)
    (cond ((hashtable-ref h x #f)
	   => (lambda (i)
		(if (vector? i)
		    ($vector-set! i 0 ($fxadd1 ($vector-ref i 0)))
		  (hashtable-set! h x ($fxadd1 i)))))
	  (else
	   (hashtable-set! h x 0)
	   (cond ((pair? x)
		  (make-graph (car x) h)
		  (make-graph (cdr x) h))
		 ((vector? x)
		  (let next-item ((x x) (i 0) (x.len ($vector-length x)))
		    (unless ($fx= i x.len)
		      (make-graph ($vector-ref x i) h)
		      (next-item x ($fxadd1 i) x.len))))
		 ((symbol? x)
		  (make-graph (symbol->string x) h)
		  (when (gensym? x)
		    (make-graph (gensym->unique-string x) h)))
		 ((string? x)
		  (void))
		 ((code? x)
		  (make-graph ($code-annotation x) h)
		  (make-graph (code.code-reloc-vector x) h))
		 ((hashtable? x)
		  (when (hashtable-hash-function x)
		    (assertion-violation who "not fasl-writable" x))
		  (let-values (((keys vals) (hashtable-entries x)))
		    (make-graph keys h)
		    (make-graph vals h)
		    (hashtable-set! h x (vector 0 keys vals))))
		 ((struct? x)
		  (cond ((eq? x (base-rtd))
			 (assertion-violation who "base-rtd is not fasl-writable"))
			((record-type-descriptor? x)
			 (make-graph (record-type-name x) h)
			 (make-graph (record-type-parent x) h)
			 (make-graph (record-type-uid x) h)
			 (vector-for-each
			     (lambda (x) (make-graph x h))
			   (record-type-field-names x)))
			(else
			 (let ((rtd ($struct-rtd x)))
			   (cond ((eq? rtd (base-rtd))
				  ;;this is a struct RTD
				  (make-graph (struct-type-name x) h)
				  (make-graph (struct-type-symbol x) h)
				  (for-each (lambda (x) (make-graph x h))
				    (struct-type-field-names x)))
				 (else
				  ;;this is a struct
				  (make-graph rtd h)
				  (let f ((i 0) (n (struct-length x)))
				    (unless (= i n)
				      (make-graph (struct-ref x i) h)
				      (f (+ i 1) n)))))))))
		 ((procedure? x)
		  (let ((code ($closure-code x)))
		    (unless (fxzero? (code.code-freevars code))
		      (assertion-violation who
			"cannot fasl-write a non-thunk procedure; the one given has free vars"
			(code.code-freevars code)))
		    (make-graph code h)))
		 ((bytevector? x)
		  (void))
		 ((flonum? x)
		  (void))
		 ((bignum? x)
		  (void))
		 ((ratnum? x)
		  (make-graph (numerator x) h)
		  (make-graph (denominator x) h))
		 ((or (compnum? x) (cflonum? x))
		  (make-graph (real-part x) h)
		  (make-graph (imag-part x) h))
		 (else
		  (assertion-violation who "not fasl-writable" x)))))))


(define (%write-object x port refcount-table next-mark)
  ;;Serialise any object X to PORT.
  ;;
  ;;If  X  needs to  be  marked for  future  reference:  use the  fixnum
  ;;NEXT-MARK to  do it.   The REFCOUNT-TABLE hashtable  of type  EQ? is
  ;;used  to  appropriately   insert  references  to  objects  appearing
  ;;multiple times.
  ;;
  ;;Return a fixnum being the mark  to be used for the next object field
  ;;with multiple references.
  ;;
  (cond ((immediate? x)
	 (fasl-write-immediate x port)
	 next-mark)
	((hashtable-ref refcount-table x #f)
	 => (lambda (refcount-entry)
	      (let ((rc/flag (if (fixnum? refcount-entry)
				 refcount-entry
			       (vector-ref refcount-entry 0))))
		(cond (($fxzero? rc/flag)
		       ;;X is an object appearing only once.  RC/FLAG is
		       ;;the reference count of X.
		       (do-write x port refcount-table next-mark))
		      (($fx> rc/flag 0)
		       ;;X is  an object appearing  multiple times; this
		       ;;is the first time it is serialised.  RC/FLAG is
		       ;;the reference count of  X.
		       ;;
		       ;;Mark  X  in   the  table  as  already  written.
		       ;;Serialise   a   new   mark   definition   using
		       ;;NEXT-MARK, then serialise the object itself.
		       (let ((flag ($fxneg next-mark)))
			 (if (fixnum? refcount-entry)
			     (hashtable-set! refcount-table x flag)
			   (vector-set! refcount-entry 0 flag)))
		       (put-tag #\> port)
		       (write-int32 next-mark port)
		       (do-write x port refcount-table ($fxadd1 next-mark)))
		      (else
		       ;;X is  an object appearing  multiple times; this
		       ;;is  NOT  the   first  time  it  is  serialised.
		       ;;RC/FLAG is a flag being the negated mark value.
		       ;;
		       ;;Serialise  a reference  to the  already defined
		       ;;mark.
		       (put-tag #\< port)
		       (write-int32 ($fxneg rc/flag) port)
		       next-mark)))))
	(else
	 (assertion-violation who
	   "*** Vicare: internal error: object was expected to be in hashtable" x))))

(define (fasl-write-immediate x port)
  ;;Serialise  the  immediate  object  X to  PORT.   Return  unspecified
  ;;values.
  ;;
  (cond ((null? x)
	 (put-tag #\N port))
	((fx? x)
	 (put-tag #\I port)
	 (write-int (bitwise-arithmetic-shift-left x fxshift) port))
	((char? x)
	 (let ((n ($char->fixnum x)))
	   (if ($fx<= n 255)
	       (begin
		 (put-tag #\c port)
		 (write-byte n port))
	     (begin
	       (put-tag #\C port)
	       (write-int32 n port)))))
	((boolean? x)
	 (put-tag (if x #\T #\F) port))
	((eof-object? x)
	 (put-tag #\E port))
	((eq? x (void))
	 (put-tag #\U port))
	(else
	 (assertion-violation who "not a fasl-writable immediate" x))))


(define-inline (count-leading-unshared-cdrs x refcount-table)
  (%count-leading-unshared-cdrs x refcount-table 0))
(define (%count-leading-unshared-cdrs x refcount-table count)
  (if (and (pair? x) (eq? (hashtable-ref refcount-table x #f) 0))
      (%count-leading-unshared-cdrs ($cdr x) refcount-table ($fxadd1 count))
    count))

(define (write-pairs x port refcount-table next-mark count)
  ;;Serialise the first COUNT pairs in the list X to PORT.
  ;;
  (if ($fxzero? count)
      (%write-object x port refcount-table next-mark)
    (let ((next-mark (%write-object (car x) port refcount-table next-mark)))
      (write-pairs (cdr x) port refcount-table next-mark ($fxsub1 count)))))

(define (do-write x port refcount-table next-mark)
  ;;Actually serialise object X to PORT.
  ;;
  ;;This function accesses REFCOUNT-TABLE  only when serialising EQ? and
  ;;EQV?  hashtables which have the keys and values stored there.
  ;;
  ;;This function  never uses the  NEXT-MARK argument directly,  it only
  ;;hands it as argument to other functions.
  ;;
  (define-syntax-rule (%write-single-object ?obj ?next-mark)
    (%write-object ?obj port refcount-table ?next-mark))

  (define (%write-r6rs-record-type-descriptor x next-mark)
    (put-tag #\W port)
    (let* ((next-mark (%write-single-object (record-type-name x)   next-mark))
	   (next-mark (%write-single-object (record-type-parent x) next-mark))
	   (next-mark (%write-single-object (record-type-uid x)    next-mark)))
      (fasl-write-immediate (record-type-sealed? x) port)
      (fasl-write-immediate (record-type-opaque? x) port)
      (let* ((field-names (record-type-field-names x))
	     (field-count ($vector-length field-names)))
	(fasl-write-immediate field-count port)
	(let next-field ((i           0)
			 (next-mark   next-mark)
			 (field-count field-count))
	  (if ($fx= i field-count)
	      next-mark
	    (begin
	      (fasl-write-immediate (record-field-mutable? x i) port)
	      (let ((next-mark (%write-single-object ($vector-ref field-names i) next-mark)))
		(next-field ($fxadd1 i) next-mark field-count))))))))

  (define (%write-struct-type-descriptor x next-mark)
    (put-tag #\R port)
    (let* ((field-names (struct-type-field-names x))
	   (next-mark   (%write-single-object (struct-type-name   x) next-mark))
	   (next-mark   (%write-single-object (struct-type-symbol x) next-mark)))
      (write-int (length field-names) port)
      (let next-field ((field-names field-names)
		       (next-mark   next-mark))
	(if (null? field-names)
	    next-mark
	  (let ((next-mark (%write-single-object (car field-names) next-mark)))
	    (next-field (cdr field-names) next-mark))))))

  (define (%write-struct-instance x rtd next-mark)
    (put-tag #\{ port)
    (let ((field-count (struct-length x)))
      (write-int field-count port)
      (let ((next-mark (%write-single-object rtd next-mark)))
	(let next-field ((i           0)
			 (next-mark   next-mark)
			 (field-count field-count))
	  (if ($fx= i field-count)
	      next-mark
	    (let ((next-mark (%write-single-object (struct-ref x i) next-mark)))
	      (next-field ($fxadd1 i) next-mark field-count)))))))


  (cond ((pair? x)
	 ;;We have to distinguish pairs from proper lists.  Also we have
	 ;;to distinguish between short (<= 255) lists and long lists.
	 ;;
	 (let* ((A	($car x))
		(D	($cdr x))
		(count	(count-leading-unshared-cdrs D refcount-table)))
	   (cond (($fxzero? count)
		  (put-tag #\P port)
		  (let* ((next-mark (%write-single-object A next-mark))
			 (next-mark (%write-single-object D next-mark)))
		    next-mark))
		 (else
		  (cond (($fx<= count 255)
			 (put-tag #\l port)
			 (write-byte count port))
			(else
			 (put-tag #\L port)
			 (write-int count port)))
		  (let* ((next-mark (%write-single-object A next-mark))
			 (next-mark (write-pairs D port refcount-table next-mark count)))
		    next-mark)))))

;;; --------------------------------------------------------------------

	((vector? x)
	 (put-tag #\V port)
	 (let ((x.len ($vector-length x)))
	   (write-int x.len port)
	   (let next-item ((x x) (i 0) (x.len x.len) (next-mark next-mark))
	     (if ($fx= i x.len)
		 next-mark
	       (let ((next-mark (%write-single-object ($vector-ref x i) next-mark)))
		 (next-item x ($fxadd1 i) x.len next-mark))))))

;;; --------------------------------------------------------------------

	((string? x)
	 (let ((x.len ($string-length x)))
	   (if (ascii-string? x)
	       (begin ;ASCII string, will write octets as chars
		 (put-tag #\s port)
		 (write-int x.len port)
		 (let next-char ((x x) (i 0) (x.len x.len))
		   (unless ($fx= i x.len)
		     (write-byte ($char->fixnum ($string-ref x i)) port)
		     (next-char x ($fxadd1 i) x.len))))
	     (begin ;Unicode string, will write int32 as chars
	       (put-tag #\S port)
	       (write-int x.len port)
	       (let next-char ((x x) (i 0) (x.len x.len))
		 (unless ($fx= i x.len)
		   (write-int32 ($char->fixnum ($string-ref x i)) port)
		   (next-char x ($fxadd1 i) x.len))))))
	 next-mark)

;;; --------------------------------------------------------------------

	((gensym? x)
	 (put-tag #\G port)
	 (let* ((next-mark (%write-single-object (symbol->string x)        next-mark))
		(next-mark (%write-single-object (gensym->unique-string x) next-mark)))
	   next-mark))

;;; --------------------------------------------------------------------

	((symbol? x)
	 (put-tag #\M port)
	 (%write-single-object (symbol->string x) next-mark))

;;; --------------------------------------------------------------------

	((code? x)	;code object
	 ;;Write the character "x" as header.
	 (put-tag #\x port)
	 ;;Write a raw  exact integer representing the number of  bytes actually used
	 ;;in the data area of the code object;
	 (write-int ($code-size x) port)
	 ;;Write a fixnum representing the number of free variables in the code.
	 (write-int (bitwise-arithmetic-shift-left ($code-freevars x) fxshift) port)
	 (let ((next-mark (if (option.debug-mode-enabled?)
			      ;;Write   a  Scheme   object   representing  the   code
			      ;;annotation.
			      (%write-single-object ($code-annotation x) next-mark)
			    (begin
			      (fasl-write-immediate #f port)
			      next-mark))))
	   ;;Write an array of bytes being the binary code.
	   (let next-byte ((i 0) (x.len (code.code-size x)))
	     (unless ($fx= i x.len)
	       (write-byte (code.code-ref x i) port)
	       (next-byte ($fxadd1 i) x.len)))
	   ;;Write the relocation vector as Scheme vector.
	   (%write-single-object ($code-reloc-vector x) next-mark)))

;;; --------------------------------------------------------------------

	((hashtable? x)
	 (if (eq? eq? (hashtable-equivalence-function x))
	     (put-tag #\h port)
	   (put-tag #\H port))
	 (let* ((v         (hashtable-ref refcount-table x #f))
		(next-mark (%write-single-object ($vector-ref v 1) next-mark))
		(next-mark (%write-single-object ($vector-ref v 2) next-mark)))
	   next-mark))

;;; --------------------------------------------------------------------

	((struct? x)
	 (cond ((record-type-descriptor? x)
		(if (writing-boot-image?)
		    (assertion-violation who
		      "invalid R6RS record-type descriptor as boot image object" x)
		  (%write-r6rs-record-type-descriptor x next-mark)))
	       ;;FIXME To  be uncommented  at the next  boot image  rotation.  (Marco
	       ;;Maggi; Wed Sep 24, 2014)
	       ;;
	       ;; ((record-object? x)
	       ;; 	(if (writing-boot-image?)
	       ;; 	    (assertion-violation who
	       ;; 	      "invalid R6RS record as boot image object" x)
	       ;; 	  (%write-struct-instance x next-mark)))
	       (else
		(let ((rtd ($struct-rtd x)))
		  (if (eq? rtd (base-rtd))
		      (%write-struct-type-descriptor x next-mark)
		    (%write-struct-instance x rtd next-mark))))))

;;; --------------------------------------------------------------------

	((procedure? x)
	 (put-tag #\Q port)
	 (%write-single-object ($closure-code x) next-mark))

;;; --------------------------------------------------------------------

	((bytevector? x)
	 (put-tag #\v port)
	 (let ((x.len ($bytevector-length x)))
	   (write-int x.len port)
	   (write-bytevector x 0 x.len port))
	 next-mark)

;;; --------------------------------------------------------------------

	((flonum? x)
	 (put-tag #\f port)
	 (write-byte ($flonum-u8-ref x 7) port)
	 (write-byte ($flonum-u8-ref x 6) port)
	 (write-byte ($flonum-u8-ref x 5) port)
	 (write-byte ($flonum-u8-ref x 4) port)
	 (write-byte ($flonum-u8-ref x 3) port)
	 (write-byte ($flonum-u8-ref x 2) port)
	 (write-byte ($flonum-u8-ref x 1) port)
	 (write-byte ($flonum-u8-ref x 0) port)
	 next-mark)

;;; --------------------------------------------------------------------

	((ratnum? x)
	 (put-tag #\r port)
	 (let* ((next-mark (%write-single-object (denominator x) next-mark))
		(next-mark (%write-single-object (numerator   x) next-mark)))
	   next-mark))

;;; --------------------------------------------------------------------

	((bignum? x)
	 (put-tag #\b port)
	 (let ((x.len ($bignum-size x)))
	   (write-int (if ($bignum-positive? x)
			  x.len
			(- x.len))
		      port)
	   (let next-byte ((i 0))
	     (unless ($fx= i x.len)
	       (write-byte ($bignum-byte-ref x i) port)
	       (next-byte ($fxadd1 i)))))
	 next-mark)

;;; --------------------------------------------------------------------

	((or (compnum? x) (cflonum? x))
	 (put-tag #\i port)
	 (let* ((next-mark (%write-single-object (real-part x) next-mark))
		(next-mark (%write-single-object (imag-part x) next-mark)))
	   next-mark))

;;; --------------------------------------------------------------------

	(else
	 (assertion-violation who "not fasl-writable" x))))


;;;; done

)

;;; end of file
