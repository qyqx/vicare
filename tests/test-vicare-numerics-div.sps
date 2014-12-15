;;; -*- coding: utf-8-unix -*-
;;;
;;;Part of: Vicare Scheme
;;;Contents: tests for numerics functions: div
;;;Date: Wed Nov 28, 2012
;;;
;;;Abstract
;;;
;;;
;;;
;;;Copyright (C) 2012, 2013, 2014 Marco Maggi <marco.maggi-ipsu@poste.it>
;;;
;;;This program is free software:  you can redistribute it and/or modify
;;;it under the terms of the  GNU General Public License as published by
;;;the Free Software Foundation, either version 3 of the License, or (at
;;;your option) any later version.
;;;
;;;This program is  distributed in the hope that it  will be useful, but
;;;WITHOUT  ANY   WARRANTY;  without   even  the  implied   warranty  of
;;;MERCHANTABILITY or  FITNESS FOR  A PARTICULAR  PURPOSE.  See  the GNU
;;;General Public License for more details.
;;;
;;;You should  have received a  copy of  the GNU General  Public License
;;;along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;;


#!r6rs
(import (vicare)
  (libtest numerics-helpers)
  (vicare system $ratnums)
  (vicare system $compnums)
  (vicare system $numerics)
  (vicare checks))

(check-set-mode! 'report-failed)
(check-display "*** testing Vicare numerics functions: division\n")


(parametrise ((check-test-name	'fixnums))

  (let-syntax ((test (make-test / $div-fixnum-fixnum)))
    (test 0 1 0)
    (test 0 -1 0)
    (test FX1 FX1 1)
    (test FX2 FX1 -1)
    (test FX3 FX1 536870911)
    (test FX4 FX1 -536870912)
    (test FX1 FX2 -1)
    (test FX2 FX2 1)
    (test FX3 FX2 -536870911)
    (test FX4 FX2 536870912)
    (test FX1 FX3 1/536870911)
    (test FX2 FX3 -1/536870911)
    (test FX3 FX3 1)
    (test FX4 FX3 -536870912/536870911)
    (test FX1 FX4 -1/536870912)
    (test FX2 FX4 1/536870912)
    (test FX3 FX4 -536870911/536870912)
    (test FX4 FX4 1)
    #f)

  (let-syntax ((test (make-test / #;$div-fixnum-bignum)))
    (test FX1 BN1 1/536870912)
    (test FX2 BN1 -1/536870912)
    (test FX3 BN1 536870911/536870912)
    (test FX4 BN1 -1)
    (test FX1 BN2 1/536871011)
    (test FX2 BN2 -1/536871011)
    (test FX3 BN2 536870911/536871011)
    (test FX4 BN2 -536870912/536871011)
    (test FX1 BN3 -1/536870913)
    (test FX2 BN3 1/536870913)
    (test FX3 BN3 -536870911/536870913)
    (test FX4 BN3 536870912/536870913)
    (test FX1 BN4 -1/536871012)
    (test FX2 BN4 1/536871012)
    (test FX3 BN4 -536870911/536871012)
    (test FX4 BN4 134217728/134217753)
    #f)

  (let-syntax ((test (make-test / #;$div-fixnum-ratnum)))
    (test FX1 RN01 123)
    (test FX2 RN01 -123)
    (test FX3 RN01 66035122053)
    (test FX4 RN01 -66035122176)
    (test FX1 RN02 -123)
    (test FX2 RN02 123)
    (test FX3 RN02 -66035122053)
    (test FX4 RN02 66035122176)
    (test FX1 RN03 -123)
    (test FX2 RN03 123)
    (test FX3 RN03 -66035122053)
    (test FX4 RN03 66035122176)
    (test FX1 RN04 -123/536870912)
    (test FX2 RN04 123/536870912)
    (test FX3 RN04 -66035122053/536870912)
    (test FX4 RN04 123)
    #f)

  (let-syntax ((test (make-flonum-test / $div-fixnum-flonum)))
    (test FX1 FL1 +inf.0)
    (test FX2 FL1 -inf.0)
    (test FX3 FL1 +inf.0)
    (test FX4 FL1 -inf.0)
    (test FX1 FL2 -inf.0)
    (test FX2 FL2 +inf.0)
    (test FX3 FL2 -inf.0)
    (test FX4 FL2 +inf.0)
    (test FX1 FL3 0.4710315591144606)
    (test FX2 FL3 -0.4710315591144606)
    (test FX3 FL3 252883142.25153083)
    (test FX4 FL3 -252883142.72256237)
    (test FX1 FL4 -0.4710315591144606)
    (test FX2 FL4 0.4710315591144606)
    (test FX3 FL4 -252883142.25153083)
    (test FX4 FL4 252883142.72256237)
    #f)

  (let-syntax ((test (make-cflonum-test / $div-fixnum-cflonum)))
    (test FX1 CFL01 +nan.0+nan.0i)
    (test FX2 CFL01 +nan.0+nan.0i)
    (test FX3 CFL01 +nan.0+nan.0i)
    (test FX4 CFL01 +nan.0+nan.0i)
    (test FX1 CFL02 +nan.0+nan.0i)
    (test FX2 CFL02 +nan.0+nan.0i)
    (test FX3 CFL02 +nan.0+nan.0i)
    (test FX4 CFL02 +nan.0+nan.0i)
    (test FX1 CFL03 +nan.0+nan.0i)
    (test FX2 CFL03 +nan.0+nan.0i)
    (test FX3 CFL03 +nan.0+nan.0i)
    (test FX4 CFL03 +nan.0+nan.0i)
    (test FX1 CFL04 +nan.0+nan.0i)
    (test FX2 CFL04 +nan.0+nan.0i)
    (test FX3 CFL04 +nan.0+nan.0i)
    (test FX4 CFL04 +nan.0+nan.0i)
    (test FX1 CFL05 -0.8333333333333333+0.0i)
    (test FX2 CFL05 0.8333333333333333-0.0i)
    (test FX3 CFL05 -447392425.8333333+0.0i)
    (test FX4 CFL05 447392426.6666666-0.0i)
    (test FX1 CFL06 -0.8333333333333333-0.0i)
    (test FX2 CFL06 0.8333333333333333+0.0i)
    (test FX3 CFL06 -447392425.8333333-0.0i)
    (test FX4 CFL06 447392426.6666666+0.0i)
    (test FX1 CFL07 0.0+0.8333333333333333i)
    (test FX2 CFL07 -0.0-0.8333333333333333i)
    (test FX3 CFL07 0.0+447392425.8333333i)
    (test FX4 CFL07 -0.0-447392426.6666666i)
    (test FX1 CFL08 -0.0+0.8333333333333333i)
    (test FX2 CFL08 0.0-0.8333333333333333i)
    (test FX3 CFL08 -0.0+447392425.8333333i)
    (test FX4 CFL08 0.0-447392426.6666666i)
    (test FX1 CFL09 -0.0+nan.0i)
    (test FX1 CFL10 -0.0+nan.0i)
    (test FX1 CFL11 +nan.0+0.0i)
    (test FX1 CFL12 +nan.0+0.0i)
    (test FX1 CFL13 +nan.0+nan.0i)
    (test FX1 CFL14 +nan.0+nan.0i)
    (test FX1 CFL15 +nan.0+nan.0i)
    (test FX1 CFL16 +nan.0+nan.0i)
    #f)

  (let-syntax ((test (make-test / #;$div-fixnum-compnum)))
    (test 1 10+20i 1/50-1/25i)
    (test 1 1+20.0i 0.0024937655860349127-0.04987531172069826i)
    (test 1 10.0+2i 0.09615384615384616-0.019230769230769232i)
    (test 1 1/2+20i 2/1601-80/1601i)
    (test 1 10+2/3i 45/452-3/452i)
    (test 1 (C BN1 20) 33554432/18014398509482009-5/72057594037928036i)
    (test 1 (C 10 BN1) 5/144115188075855922-134217728/72057594037927961i)
    #f)

;;; --------------------------------------------------------------------

  (let-syntax ((test (make-test / $div-fixnum-bignum)))
    (test FX1 VBN1 1/1152921504606846976)
    (test FX2 VBN1 -1/1152921504606846976)
    (test FX3 VBN1 536870911/1152921504606846976)
    (test FX4 VBN1 -1/2147483648)
    (test FX1 VBN2 1/1152921504606847075)
    (test FX2 VBN2 -1/1152921504606847075)
    (test FX3 VBN2 536870911/1152921504606847075)
    (test FX4 VBN2 -536870912/1152921504606847075)
    (test FX1 VBN3 -1/1152921504606846977)
    (test FX2 VBN3 1/1152921504606846977)
    (test FX3 VBN3 -536870911/1152921504606846977)
    (test FX4 VBN3 536870912/1152921504606846977)
    (test FX1 VBN4 -1/1152921504606847076)
    (test FX2 VBN4 1/1152921504606847076)
    (test FX3 VBN4 -536870911/1152921504606847076)
    (test FX4 VBN4 134217728/288230376151711769)
    #f)

  (let-syntax ((test (make-test / $div-fixnum-ratnum)))
    (test FX1 VRN01 123)
    (test FX2 VRN01 -123)
    (test FX3 VRN01 66035122053)
    (test FX4 VRN01 -66035122176)
    (test FX1 VRN02 -123)
    (test FX2 VRN02 123)
    (test FX3 VRN02 -66035122053)
    (test FX4 VRN02 66035122176)
    (test FX1 VRN03 -123)
    (test FX2 VRN03 123)
    (test FX3 VRN03 -66035122053)
    (test FX4 VRN03 66035122176)
    (test FX1 VRN04 -123/536870912)
    (test FX2 VRN04 123/536870912)
    (test FX3 VRN04 -66035122053/536870912)
    (test FX4 VRN04 123)
    #f)

  (let-syntax ((test (make-test / $div-fixnum-compnum)))
    (test 1 (C VBN1 20) 72057594037927936/83076749736557242056487941267521561-5/332306998946228968225951765070086244i)
    (test 1 (C 10 VBN1) 5/664613997892457936451903530140172338-288230376151711744/332306998946228968225951765070086169i)
    #f)

  #t)


(parametrise ((check-test-name	'bignums))

  (let-syntax ((test (make-test / #;$div-bignum-fixnum)))
    (test BN1 FX1 536870912)
    (test BN2 FX1 536871011)
    (test BN3 FX1 -536870913)
    (test BN4 FX1 -536871012)
    (test BN1 FX2 -536870912)
    (test BN2 FX2 -536871011)
    (test BN3 FX2 536870913)
    (test BN4 FX2 536871012)
    (test BN1 FX3 536870912/536870911)
    (test BN2 FX3 536871011/536870911)
    (test BN3 FX3 -536870913/536870911)
    (test BN4 FX3 -536871012/536870911)
    (test BN1 FX4 -1)
    (test BN2 FX4 -536871011/536870912)
    (test BN3 FX4 536870913/536870912)
    (test BN4 FX4 134217753/134217728)
    #f)

  (let-syntax ((test (make-test / #;$div-bignum-bignum)))
    (test BN1 BN1 1)
    (test BN2 BN1 536871011/536870912)
    (test BN3 BN1 -536870913/536870912)
    (test BN4 BN1 -134217753/134217728)
    (test BN1 BN2 536870912/536871011)
    (test BN2 BN2 1)
    (test BN3 BN2 -536870913/536871011)
    (test BN4 BN2 -536871012/536871011)
    (test BN1 BN3 -536870912/536870913)
    (test BN2 BN3 -536871011/536870913)
    (test BN3 BN3 1)
    (test BN4 BN3 178957004/178956971)
    (test BN1 BN4 -134217728/134217753)
    (test BN2 BN4 -536871011/536871012)
    (test BN3 BN4 178956971/178957004)
    (test BN4 BN4 1)
    #f)

  (let-syntax ((test (make-test / #;$div-bignum-ratnum)))
    (test BN1 RN01 66035122176)
    (test BN2 RN01 66035134353)
    (test BN3 RN01 -66035122299)
    (test BN4 RN01 -66035134476)
    (test BN1 RN02 -66035122176)
    (test BN2 RN02 -66035134353)
    (test BN3 RN02 66035122299)
    (test BN4 RN02 66035134476)
    (test BN1 RN03 -66035122176)
    (test BN2 RN03 -66035134353)
    (test BN3 RN03 66035122299)
    (test BN4 RN03 66035134476)
    (test BN1 RN04 -123)
    (test BN2 RN04 -66035134353/536870912)
    (test BN3 RN04 66035122299/536870912)
    (test BN4 RN04 16508783619/134217728)
    #f)

  (let-syntax ((test (make-flonum-test / #;$div-bignum-flonum)))
    (test BN1 FL1 +inf.0)
    (test BN2 FL1 +inf.0)
    (test BN3 FL1 -inf.0)
    (test BN4 FL1 -inf.0)
    (test BN1 FL2 -inf.0)
    (test BN2 FL2 -inf.0)
    (test BN3 FL2 +inf.0)
    (test BN4 FL2 +inf.0)
    (test BN1 FL3 252883142.72256237)
    (test BN2 FL3 252883189.35468674)
    (test BN3 FL3 -252883143.19359395)
    (test BN4 FL3 -252883189.82571828)
    (test BN1 FL4 -252883142.72256237)
    (test BN2 FL4 -252883189.35468674)
    (test BN3 FL4 252883143.19359395)
    (test BN4 FL4 252883189.82571828)
    #f)

  (let-syntax ((test (make-cflonum-test / #;$div-bignum-cflonum)))
    (test BN1 CFL01 +nan.0+nan.0i)
    (test BN2 CFL01 +nan.0+nan.0i)
    (test BN3 CFL01 +nan.0+nan.0i)
    (test BN4 CFL01 +nan.0+nan.0i)
    (test BN1 CFL02 +nan.0+nan.0i)
    (test BN2 CFL02 +nan.0+nan.0i)
    (test BN3 CFL02 +nan.0+nan.0i)
    (test BN4 CFL02 +nan.0+nan.0i)
    (test BN1 CFL03 +nan.0+nan.0i)
    (test BN2 CFL03 +nan.0+nan.0i)
    (test BN3 CFL03 +nan.0+nan.0i)
    (test BN4 CFL03 +nan.0+nan.0i)
    (test BN1 CFL04 +nan.0+nan.0i)
    (test BN2 CFL04 +nan.0+nan.0i)
    (test BN3 CFL04 +nan.0+nan.0i)
    (test BN4 CFL04 +nan.0+nan.0i)
    (test BN1 CFL05 -447392426.6666666+0.0i)
    (test BN2 CFL05 -447392509.1666666+0.0i)
    (test BN3 CFL05 447392427.5-0.0i)
    (test BN4 CFL05 447392510.0-0.0i)
    (test BN1 CFL06 -447392426.6666666-0.0i)
    (test BN2 CFL06 -447392509.1666666-0.0i)
    (test BN3 CFL06 447392427.5+0.0i)
    (test BN4 CFL06 447392510.0+0.0i)
    (test BN1 CFL07 0.0+447392426.6666666i)
    (test BN2 CFL07 0.0+447392509.1666666i)
    (test BN3 CFL07 -0.0-447392427.5i)
    (test BN4 CFL07 -0.0-447392510.0i)
    (test BN1 CFL08 -0.0+447392426.6666666i)
    (test BN2 CFL08 -0.0+447392509.1666666i)
    (test BN3 CFL08 0.0-447392427.5i)
    (test BN4 CFL08 0.0-447392510.0i)
    (test BN1 CFL09 -0.0+nan.0i)
    (test BN1 CFL10 -0.0+nan.0i)
    (test BN1 CFL11 +nan.0+0.0i)
    (test BN1 CFL12 +nan.0+0.0i)
    (test BN1 CFL13 +nan.0+nan.0i)
    (test BN1 CFL14 +nan.0+nan.0i)
    (test BN1 CFL15 +nan.0+nan.0i)
    (test BN1 CFL16 +nan.0+nan.0i)
    #f)

  (let-syntax ((test (make-test / #;$div-bignum-compnum)))
    (test BN1 10+20i 268435456/25-536870912/25i)
    (test BN1 1+20.0i 1338830.204488778-26776604.089775562i)
    (test BN1 10.0+2i 51622203.07692308-10324440.615384616i)
    (test BN1 1/2+20i 1073741824/1601-42949672960/1601i)
    (test BN1 10+2/3i 6039797760/113-402653184/113i)
    (test BN1 (C BN2 20) 288230429301932032/288230482452162521-10737418240/288230482452162521i)
    (test BN1 (C 10 BN2) 5368709120/288230482452162221-288230429301932032/288230482452162221i)
    #f)

;;; --------------------------------------------------------------------

  (let-syntax ((test (make-test / $div-bignum-fixnum)))
    (test VBN1 FX1 1152921504606846976)
    (test VBN2 FX1 1152921504606847075)
    (test VBN3 FX1 -1152921504606846977)
    (test VBN4 FX1 -1152921504606847076)
    (test VBN1 FX2 -1152921504606846976)
    (test VBN2 FX2 -1152921504606847075)
    (test VBN3 FX2 1152921504606846977)
    (test VBN4 FX2 1152921504606847076)
    (test VBN1 FX3 1152921504606846976/536870911)
    (test VBN2 FX3 1152921504606847075/536870911)
    (test VBN3 FX3 -1152921504606846977/536870911)
    (test VBN4 FX3 -1152921504606847076/536870911)
    (test VBN1 FX4 -2147483648)
    (test VBN2 FX4 -1152921504606847075/536870912)
    (test VBN3 FX4 1152921504606846977/536870912)
    (test VBN4 FX4 288230376151711769/134217728)
    #f)

  (let-syntax ((test (make-test / $div-bignum-bignum)))
    (test VBN1 VBN1 1)
    (test VBN2 VBN1 1152921504606847075/1152921504606846976)
    (test VBN3 VBN1 -1152921504606846977/1152921504606846976)
    (test VBN4 VBN1 -288230376151711769/288230376151711744)
    (test VBN1 VBN2 1152921504606846976/1152921504606847075)
    (test VBN2 VBN2 1)
    (test VBN3 VBN2 -1152921504606846977/1152921504606847075)
    (test VBN4 VBN2 -1152921504606847076/1152921504606847075)
    (test VBN1 VBN3 -1152921504606846976/1152921504606846977)
    (test VBN2 VBN3 -1152921504606847075/1152921504606846977)
    (test VBN3 VBN3 1)
    (test VBN4 VBN3 1152921504606847076/1152921504606846977)
    (test VBN1 VBN4 -288230376151711744/288230376151711769)
    (test VBN2 VBN4 -1152921504606847075/1152921504606847076)
    (test VBN3 VBN4 1152921504606846977/1152921504606847076)
    (test VBN4 VBN4 1)
    #f)

  (let-syntax ((test (make-test / $div-bignum-ratnum)))
    (test VBN1 VRN01 141809345066642178048)
    (test VBN2 VRN01 141809345066642190225)
    (test VBN3 VRN01 -141809345066642178171)
    (test VBN4 VRN01 -141809345066642190348)
    (test VBN1 VRN02 -141809345066642178048)
    (test VBN2 VRN02 -141809345066642190225)
    (test VBN3 VRN02 141809345066642178171)
    (test VBN4 VRN02 141809345066642190348)
    (test VBN1 VRN03 -141809345066642178048)
    (test VBN2 VRN03 -141809345066642190225)
    (test VBN3 VRN03 141809345066642178171)
    (test VBN4 VRN03 141809345066642190348)
    (test VBN1 VRN04 -264140488704)
    (test VBN2 VRN04 -141809345066642190225/536870912)
    (test VBN3 VRN04 141809345066642178171/536870912)
    (test VBN4 VRN04 35452336266660547587/134217728)
    #f)

  (let-syntax ((test (make-flonum-test / $div-bignum-flonum)))
    (test VBN1 FL1 +inf.0)
    (test VBN2 FL1 +inf.0)
    (test VBN3 FL1 -inf.0)
    (test VBN4 FL1 -inf.0)
    (test VBN1 FL2 -inf.0)
    (test VBN2 FL2 -inf.0)
    (test VBN3 FL2 +inf.0)
    (test VBN4 FL2 +inf.0)
    (test VBN1 FL3 5.430624138515529e+17)
    (test VBN2 FL3 5.430624138515529e+17)
    (test VBN3 FL3 -5.430624138515529e+17)
    (test VBN4 FL3 -5.430624138515529e+17)
    (test VBN1 FL4 -5.430624138515529e+17)
    (test VBN2 FL4 -5.430624138515529e+17)
    (test VBN3 FL4 5.430624138515529e+17)
    (test VBN4 FL4 5.430624138515529e+17)
    #f)

  (let-syntax ((test (make-cflonum-test / $div-bignum-cflonum)))
    (test VBN1 CFL01 +nan.0-nan.0i)
    (test VBN2 CFL01 +nan.0-nan.0i)
    (test VBN3 CFL01 -nan.0+nan.0i)
    (test VBN4 CFL01 -nan.0+nan.0i)
    (test VBN1 CFL02 +nan.0-nan.0i)
    (test VBN2 CFL02 +nan.0-nan.0i)
    (test VBN3 CFL02 +nan.0-nan.0i)
    (test VBN4 CFL02 +nan.0-nan.0i)
    (test VBN1 CFL03 +nan.0-nan.0i)
    (test VBN2 CFL03 +nan.0-nan.0i)
    (test VBN3 CFL03 +nan.0-nan.0i)
    (test VBN4 CFL03 +nan.0-nan.0i)
    (test VBN1 CFL04 +nan.0-nan.0i)
    (test VBN2 CFL04 +nan.0-nan.0i)
    (test VBN3 CFL04 +nan.0-nan.0i)
    (test VBN4 CFL04 +nan.0-nan.0i)
    (test VBN1 CFL05 -9.607679205057059e+17+0.0i)
    (test VBN2 CFL05 -9.607679205057059e+17+0.0i)
    (test VBN3 CFL05 9.607679205057059e+17-0.0i)
    (test VBN4 CFL05 9.607679205057059e+17-0.0i)
    (test VBN1 CFL06 -9.607679205057059e+17-0.0i)
    (test VBN2 CFL06 -9.607679205057059e+17-0.0i)
    (test VBN3 CFL06 9.607679205057059e+17+0.0i)
    (test VBN4 CFL06 9.607679205057059e+17+0.0i)
    (test VBN1 CFL07 0.0+9.607679205057059e+17i)
    (test VBN2 CFL07 0.0+9.607679205057059e+17i)
    (test VBN3 CFL07 -0.0-9.607679205057059e+17i)
    (test VBN4 CFL07 -0.0-9.607679205057059e+17i)
    (test VBN1 CFL08 -0.0+9.607679205057059e+17i)
    (test VBN2 CFL08 -0.0+9.607679205057059e+17i)
    (test VBN3 CFL08 0.0-9.607679205057059e+17i)
    (test VBN4 CFL08 0.0-9.607679205057059e+17i)
    (test VBN1 CFL09 -0.0+nan.0i)
    (test VBN1 CFL10 -0.0+nan.0i)
    (test VBN1 CFL11 +nan.0+0.0i)
    (test VBN1 CFL12 +nan.0+0.0i)
    (test VBN1 CFL13 +nan.0+nan.0i)
    (test VBN1 CFL14 +nan.0+nan.0i)
    (test VBN1 CFL15 +nan.0+nan.0i)
    (test VBN1 CFL16 +nan.0+nan.0i)
    #f)

  (let-syntax ((test (make-test / $div-bignum-compnum)))
    (test VBN1 (C VBN2 20) 53169119831396639481721440654327808/53169119831396644047290598897442241-4611686018427387904/265845599156983220236452994487211205i)
    (test VBN1 (C 10 VBN2) 2305843009213693952/265845599156983220236452994487211145-53169119831396639481721440654327808/53169119831396644047290598897442229i)
    #f)

  #t)


(parametrise ((check-test-name	'ratnums))

  (let-syntax ((test (make-test / $div-ratnum-fixnum)))
    (test 1/2 10 1/20)
    (test 1/2 GREATEST-FX-32-bit 1/1073741822)
    (test 1/2 LEAST-FX-32-bit -1/1073741824)
    #f)

  (let-syntax ((test (make-test / #;$div-ratnum-bignum)))
    (test 1/2 BN1 1/1073741824)
    (test 1/2 BN2 1/1073742022)
    (test 1/2 BN3 -1/1073741826)
    (test 1/2 BN4 -1/1073742024)
    (test -1/2 BN1 -1/1073741824)
    (test -1/2 BN2 -1/1073742022)
    (test -1/2 BN3 1/1073741826)
    (test -1/2 BN4 1/1073742024)
    #f)

  (let-syntax ((test (make-test / $div-ratnum-ratnum)))
    (test 1/2 3/4 2/3)
    (test -1/2 3/4 -2/3)
    (test -1/2 -3/4 2/3)
    #f)

  (let-syntax ((test (make-flonum-test / #;$div-ratnum-flonum)))
    (test 1/2 3.4 0.14705882352941177)
    (test -1/2 3.4 -0.14705882352941177)
    (test RN01 FL1 +inf.0)
    (test RN02 FL1 -inf.0)
    (test RN03 FL1 -inf.0)
    (test RN04 FL1 -inf.0)
    (test RN01 FL2 -inf.0)
    (test RN02 FL2 +inf.0)
    (test RN03 FL2 +inf.0)
    (test RN04 FL2 +inf.0)
    (test RN01 FL3 0.0038295248708492737)
    (test RN02 FL3 -0.0038295248708492737)
    (test RN03 FL3 -0.0038295248708492737)
    (test RN04 FL3 -2055960.5099395318)
    (test RN01 FL4 -0.0038295248708492737)
    (test RN02 FL4 0.0038295248708492737)
    (test RN03 FL4 0.0038295248708492737)
    (test RN04 FL4 2055960.5099395318)
    #f)

  (let-syntax ((test (make-cflonum-test / #;$div-ratnum-cflonum)))
    (test RN01 CFL01 +nan.0+nan.0i)
    (test RN02 CFL01 +nan.0+nan.0i)
    (test RN03 CFL01 +nan.0+nan.0i)
    (test RN04 CFL01 +nan.0+nan.0i)
    (test RN01 CFL02 +nan.0+nan.0i)
    (test RN02 CFL02 +nan.0+nan.0i)
    (test RN03 CFL02 +nan.0+nan.0i)
    (test RN04 CFL02 +nan.0+nan.0i)
    (test RN01 CFL03 +nan.0+nan.0i)
    (test RN02 CFL03 +nan.0+nan.0i)
    (test RN03 CFL03 +nan.0+nan.0i)
    (test RN04 CFL03 +nan.0+nan.0i)
    (test RN01 CFL04 +nan.0+nan.0i)
    (test RN02 CFL04 +nan.0+nan.0i)
    (test RN03 CFL04 +nan.0+nan.0i)
    (test RN04 CFL04 +nan.0+nan.0i)
    (test RN01 CFL05 -0.006775067750677508+0.0i)
    (test RN02 CFL05 0.006775067750677508-0.0i)
    (test RN03 CFL05 0.006775067750677508-0.0i)
    (test RN04 CFL05 3637336.8021680224-0.0i)
    (test RN01 CFL06 -0.006775067750677508-0.0i)
    (test RN02 CFL06 0.006775067750677508+0.0i)
    (test RN03 CFL06 0.006775067750677508+0.0i)
    (test RN04 CFL06 3637336.8021680224+0.0i)
    (test RN01 CFL07 0.0+0.006775067750677508i)
    (test RN02 CFL07 -0.0-0.006775067750677508i)
    (test RN03 CFL07 -0.0-0.006775067750677508i)
    (test RN04 CFL07 -0.0-3637336.8021680224i)
    (test RN01 CFL08 -0.0+0.006775067750677508i)
    (test RN02 CFL08 0.0-0.006775067750677508i)
    (test RN03 CFL08 0.0-0.006775067750677508i)
    (test RN04 CFL08 0.0-3637336.8021680224i)
    (test RN01 CFL09 -0.0+nan.0i)
    (test RN01 CFL10 -0.0+nan.0i)
    (test RN01 CFL11 +nan.0+0.0i)
    (test RN01 CFL12 +nan.0+0.0i)
    (test RN01 CFL13 +nan.0+nan.0i)
    (test RN01 CFL14 +nan.0+nan.0i)
    (test RN01 CFL15 +nan.0+nan.0i)
    (test RN01 CFL16 +nan.0+nan.0i)
    #f)

  (let-syntax ((test (make-compnum-test / #;$div-ratnum-compnum)))
    (test RN01 10+20i 1/6150-1/3075i)
    (test RN01 1+20.0i 2.027451695963344e-5-4.054903391926688e-4i)
    (test RN01 10.0+2i 7.817385866166355e-4-1.563477173233271e-4i)
    (test RN01 1/2+20i 2/196923-80/196923i)
    (test RN01 10+2/3i 15/18532-1/18532i)
    (test RN01 (C RN02 20) -1/6051601-2460/6051601i)
    (test RN01 (C 10 RN02) 1230/1512901+1/1512901i)
    #f)

;;; --------------------------------------------------------------------

  (let-syntax ((test (make-test / $div-ratnum-bignum)))
    (test 1/2 VBN1 1/2305843009213693952)
    (test 1/2 VBN2 1/2305843009213694150)
    (test 1/2 VBN3 -1/2305843009213693954)
    (test 1/2 VBN4 -1/2305843009213694152)
    (test -1/2 VBN1 -1/2305843009213693952)
    (test -1/2 VBN2 -1/2305843009213694150)
    (test -1/2 VBN3 1/2305843009213693954)
    (test -1/2 VBN4 1/2305843009213694152)
    #f)

  (let-syntax ((test (make-flonum-test / $div-ratnum-flonum)))
    (test VRN01 FL1 +inf.0)
    (test VRN02 FL1 -inf.0)
    (test VRN03 FL1 -inf.0)
    (test VRN04 FL1 -inf.0)
    (test VRN01 FL2 -inf.0)
    (test VRN02 FL2 +inf.0)
    (test VRN03 FL2 +inf.0)
    (test VRN04 FL2 +inf.0)
    (test VRN01 FL3 0.0038295248708492737)
    (test VRN02 FL3 -0.0038295248708492737)
    (test VRN03 FL3 -0.0038295248708492737)
    (test VRN04 FL3 -2055960.5099395318)
    (test VRN01 FL4 -0.0038295248708492737)
    (test VRN02 FL4 0.0038295248708492737)
    (test VRN03 FL4 0.0038295248708492737)
    (test VRN04 FL4 2055960.5099395318)
    #f)

  (let-syntax ((test (make-cflonum-test / $div-ratnum-cflonum)))
    (test VRN01 CFL01 +nan.0-nan.0i)
    (test VRN02 CFL01 +nan.0-nan.0i)
    (test VRN03 CFL01 +nan.0-nan.0i)
    (test VRN04 CFL01 +nan.0-nan.0i)
    (test VRN01 CFL02 +nan.0-nan.0i)
    (test VRN02 CFL02 +nan.0-nan.0i)
    (test VRN03 CFL02 +nan.0-nan.0i)
    (test VRN04 CFL02 +nan.0-nan.0i)
    (test VRN01 CFL03 +nan.0-nan.0i)
    (test VRN02 CFL03 +nan.0-nan.0i)
    (test VRN03 CFL03 +nan.0-nan.0i)
    (test VRN04 CFL03 +nan.0-nan.0i)
    (test VRN01 CFL04 +nan.0-nan.0i)
    (test VRN02 CFL04 +nan.0-nan.0i)
    (test VRN03 CFL04 +nan.0-nan.0i)
    (test VRN04 CFL04 +nan.0-nan.0i)
    (test VRN01 CFL05 -0.006775067750677508+0.0i)
    (test VRN02 CFL05 0.006775067750677508-0.0i)
    (test VRN03 CFL05 0.006775067750677508-0.0i)
    (test VRN04 CFL05 3637336.8021680224-0.0i)
    (test VRN01 CFL06 -0.006775067750677508-0.0i)
    (test VRN02 CFL06 0.006775067750677508+0.0i)
    (test VRN03 CFL06 0.006775067750677508+0.0i)
    (test VRN04 CFL06 3637336.8021680224+0.0i)
    (test VRN01 CFL07 0.0+0.006775067750677508i)
    (test VRN02 CFL07 -0.0-0.006775067750677508i)
    (test VRN03 CFL07 -0.0-0.006775067750677508i)
    (test VRN04 CFL07 -0.0-3637336.8021680224i)
    (test VRN01 CFL08 -0.0+0.006775067750677508i)
    (test VRN02 CFL08 0.0-0.006775067750677508i)
    (test VRN03 CFL08 0.0-0.006775067750677508i)
    (test VRN04 CFL08 0.0-3637336.8021680224i)
    (test VRN01 CFL09 -0.0+nan.0i)
    (test VRN01 CFL10 -0.0+nan.0i)
    (test VRN01 CFL11 +nan.0+0.0i)
    (test VRN01 CFL12 +nan.0+0.0i)
    (test VRN01 CFL13 +nan.0+nan.0i)
    (test VRN01 CFL14 +nan.0+nan.0i)
    (test VRN01 CFL15 +nan.0+nan.0i)
    (test VRN01 CFL16 +nan.0+nan.0i)
    #f)

  (let-syntax ((test (make-compnum-test / $div-ratnum-compnum)))
    (test VRN01 10+20i 1/6150-1/3075i)
    (test VRN01 1+20.0i 2.027451695963344e-05-0.0004054903391926688i)
    (test VRN01 10+2.0i 0.0007817385866166355-0.0001563477173233271i)
    (test VRN01 1/2+20i 2/196923-80/196923i)
    (test VRN01 10+2/3i 15/18532-1/18532i)
    (test VRN01 (C VRN02 20) -1/6051601-2460/6051601i)
    (test VRN01 (C 10 VRN02) 1230/1512901+1/1512901i)
    #f)

  #t)


(parametrise ((check-test-name	'flonums))

  (let-syntax ((test (make-inexact-test / $div-flonum-fixnum)))
    (test FL1 FX1 0.0)
    (test FL2 FX1 -0.0)
    (test FL3 FX1 2.123)
    (test FL4 FX1 -2.123)
    (test FL1 FX2 -0.0)
    (test FL2 FX2 0.0)
    (test FL3 FX2 -2.123)
    (test FL4 FX2 2.123)
    (test FL1 FX3 0.0)
    (test FL2 FX3 -0.0)
    (test FL3 FX3 3.954395659182958e-9)
    (test FL4 FX3 -3.954395659182958e-9)
    (test FL1 FX4 -0.0)
    (test FL2 FX4 0.0)
    (test FL3 FX4 -3.954395651817322e-9)
    (test FL4 FX4 3.954395651817322e-9)
    #f)

  (let-syntax ((test (make-inexact-test / #;$div-flonum-bignum)))
    (test FL1 BN1 0.0)
    (test FL2 BN1 -0.0)
    (test FL3 BN1 3.954395651817322e-9)
    (test FL4 BN1 -3.954395651817322e-9)
    (test FL1 BN2 0.0)
    (test FL2 BN2 -0.0)
    (test FL3 BN2 3.954394922619505e-9)
    (test FL4 BN2 -3.954394922619505e-9)
    (test FL1 BN3 -0.0)
    (test FL2 BN3 0.0)
    (test FL3 BN3 -3.954395644451687e-9)
    (test FL4 BN3 3.954395644451687e-9)
    (test FL1 BN4 -0.0)
    (test FL2 BN4 0.0)
    (test FL3 BN4 -3.954394915253872e-9)
    (test FL4 BN4 3.954394915253872e-9)
    #f)

  (let-syntax ((test (make-inexact-test / #;$div-flonum-ratnum)))
    (test FL1 RN01 0.0)
    (test FL2 RN01 -0.0)
    (test FL3 RN01 261.129)
    (test FL4 RN01 -261.129)
    (test FL1 RN02 -0.0)
    (test FL2 RN02 0.0)
    (test FL3 RN02 -261.129)
    (test FL4 RN02 261.129)
    (test FL1 RN03 -0.0)
    (test FL2 RN03 0.0)
    (test FL3 RN03 -261.129)
    (test FL4 RN03 261.129)
    (test FL1 RN04 -0.0)
    (test FL2 RN04 0.0)
    (test FL3 RN04 -4.863906651735306e-7)
    (test FL4 RN04 4.863906651735306e-7)
    #f)

  (let-syntax ((test (make-flonum-test / $div-flonum-flonum)))
    (test FL1 FL1 +nan.0)
    (test FL2 FL1 +nan.0)
    (test FL3 FL1 +inf.0)
    (test FL4 FL1 -inf.0)
    (test FL1 FL2 +nan.0)
    (test FL2 FL2 +nan.0)
    (test FL3 FL2 -inf.0)
    (test FL4 FL2 +inf.0)
    (test FL1 FL3 0.0)
    (test FL2 FL3 -0.0)
    (test FL3 FL3 1.0)
    (test FL4 FL3 -1.0)
    (test FL1 FL4 -0.0)
    (test FL2 FL4 0.0)
    (test FL3 FL4 -1.0)
    (test FL4 FL4 1.0)
    #f)

  (let-syntax ((test (make-cflonum-test / $div-flonum-cflonum)))
    (test FL1 CFL01 +nan.0+nan.0i)
    (test FL2 CFL01 +nan.0+nan.0i)
    (test FL3 CFL01 +nan.0+nan.0i)
    (test FL4 CFL01 +nan.0+nan.0i)
    (test FL1 CFL02 +nan.0+nan.0i)
    (test FL2 CFL02 +nan.0+nan.0i)
    (test FL3 CFL02 +nan.0+nan.0i)
    (test FL4 CFL02 +nan.0+nan.0i)
    (test FL1 CFL03 +nan.0+nan.0i)
    (test FL2 CFL03 +nan.0+nan.0i)
    (test FL3 CFL03 +nan.0+nan.0i)
    (test FL4 CFL03 +nan.0+nan.0i)
    (test FL1 CFL04 +nan.0+nan.0i)
    (test FL2 CFL04 +nan.0+nan.0i)
    (test FL3 CFL04 +nan.0+nan.0i)
    (test FL4 CFL04 +nan.0+nan.0i)
    (test FL1 CFL05 -0.0+0.0i)
    (test FL2 CFL05 0.0-0.0i)
    (test FL3 CFL05 -1.7691666666666668+0.0i)
    (test FL4 CFL05 1.7691666666666668-0.0i)
    (test FL1 CFL06 -0.0-0.0i)
    (test FL2 CFL06 0.0+0.0i)
    (test FL3 CFL06 -1.7691666666666668-0.0i)
    (test FL4 CFL06 1.7691666666666668+0.0i)
    (test FL1 CFL07 0.0+0.0i)
    (test FL2 CFL07 -0.0-0.0i)
    (test FL3 CFL07 0.0+1.7691666666666668i)
    (test FL4 CFL07 -0.0-1.7691666666666668i)
    (test FL1 CFL08 -0.0+0.0i)
    (test FL2 CFL08 0.0-0.0i)
    (test FL3 CFL08 -0.0+1.7691666666666668i)
    (test FL4 CFL08 0.0-1.7691666666666668i)
    (test FL1 CFL09 -0.0+nan.0i)
    (test FL1 CFL10 -0.0+nan.0i)
    (test FL1 CFL11 +nan.0+0.0i)
    (test FL1 CFL12 +nan.0+0.0i)
    (test FL1 CFL13 +nan.0+nan.0i)
    (test FL1 CFL14 +nan.0+nan.0i)
    (test FL1 CFL15 +nan.0+nan.0i)
    (test FL1 CFL16 +nan.0+nan.0i)
    #f)

  (let-syntax ((test (make-inexact-test / #;$div-flonum-compnum)))
    (test FL3 10+20i 0.042460000000000005-0.08492000000000001i)
    (test FL3 1+20.0i 0.00529426433915212-0.1058852867830424i)
    (test FL3 10.0+2i 0.20413461538461541-0.04082692307692308i)
    (test FL3 1/2+20i 0.0026520924422236106-0.10608369768894442i)
    (test FL3 10+2/3i 0.21136061946902657-0.014090707964601771i)
    (test FL3 (C RN02 20) -4.315039937365336e-5-0.10614998245918725i)
    (test FL3 (C 10 RN02) 0.21229985967356754+1.726015119297297e-4i)
    #f)

;;; --------------------------------------------------------------------

  (let-syntax ((test (make-inexact-test / $div-flonum-bignum)))
    (test FL1 VBN1 0.0)
    (test FL2 VBN1 -0.0)
    (test FL3 VBN1 1.841408969749381e-18)
    (test FL4 VBN1 -1.841408969749381e-18)
    (test FL1 VBN2 0.0)
    (test FL2 VBN2 -0.0)
    (test FL3 VBN2 1.841408969749381e-18)
    (test FL4 VBN2 -1.841408969749381e-18)
    (test FL1 VBN3 -0.0)
    (test FL2 VBN3 0.0)
    (test FL3 VBN3 -1.841408969749381e-18)
    (test FL4 VBN3 1.841408969749381e-18)
    (test FL1 VBN4 -0.0)
    (test FL2 VBN4 0.0)
    (test FL3 VBN4 -1.841408969749381e-18)
    (test FL4 VBN4 1.841408969749381e-18)
    #f)

  (let-syntax ((test (make-inexact-test / $div-flonum-ratnum)))
    (test FL1 VRN01 0.0)
    (test FL2 VRN01 -0.0)
    (test FL3 VRN01 261.129)
    (test FL4 VRN01 -261.129)
    (test FL1 VRN02 -0.0)
    (test FL2 VRN02 0.0)
    (test FL3 VRN02 -261.129)
    (test FL4 VRN02 261.129)
    (test FL1 VRN03 -0.0)
    (test FL2 VRN03 0.0)
    (test FL3 VRN03 -261.129)
    (test FL4 VRN03 261.129)
    (test FL1 VRN04 -0.0)
    (test FL2 VRN04 0.0)
    (test FL3 VRN04 -4.863906651735306e-07)
    (test FL4 VRN04 4.863906651735306e-07)
    #f)

  (let-syntax ((test (make-inexact-test / $div-flonum-compnum)))
    (test FL3 (C VRN02 20) -4.3150399373653355e-05-0.10614998245918726i)
    (test FL3 (C 10 VRN02) 0.21229985967356757+0.0001726015119297297i)
    #f)

  #t)


(parametrise ((check-test-name	'cflonums))

  (let-syntax ((test (make-inexact-test / $div-cflonum-fixnum)))
    (test CFL01 FX1 0.0+0.0i)
    (test CFL02 FX1 -0.0+0.0i)
    (test CFL03 FX1 0.0-0.0i)
    (test CFL04 FX1 -0.0-0.0i)
    (test CFL01 FX2 -0.0-0.0i)
    (test CFL02 FX2 0.0-0.0i)
    (test CFL03 FX2 -0.0+0.0i)
    (test CFL04 FX2 0.0+0.0i)
    (test CFL01 FX3 0.0+0.0i)
    (test CFL02 FX3 -0.0+0.0i)
    (test CFL03 FX3 0.0-0.0i)
    (test CFL04 FX3 -0.0-0.0i)
    (test CFL01 FX4 -0.0-0.0i)
    (test CFL02 FX4 0.0-0.0i)
    (test CFL03 FX4 -0.0+0.0i)
    (test CFL04 FX4 0.0+0.0i)
    #f)

  (let-syntax ((test (make-inexact-test / #;$div-cflonum-bignum)))
    (test CFL01 BN1 0.0+0.0i)
    (test CFL02 BN1 -0.0+0.0i)
    (test CFL03 BN1 0.0-0.0i)
    (test CFL04 BN1 -0.0-0.0i)
    (test CFL01 BN2 0.0+0.0i)
    (test CFL02 BN2 -0.0+0.0i)
    (test CFL03 BN2 0.0-0.0i)
    (test CFL04 BN2 -0.0-0.0i)
    (test CFL01 BN3 -0.0-0.0i)
    (test CFL02 BN3 0.0-0.0i)
    (test CFL03 BN3 -0.0+0.0i)
    (test CFL04 BN3 0.0+0.0i)
    (test CFL01 BN4 -0.0-0.0i)
    (test CFL02 BN4 0.0-0.0i)
    (test CFL03 BN4 -0.0+0.0i)
    (test CFL04 BN4 0.0+0.0i)
    #f)

  (let-syntax ((test (make-inexact-test / #;$div-cflonum-ratnum)))
    (test CFL01 RN01 0.0+0.0i)
    (test CFL02 RN01 -0.0+0.0i)
    (test CFL03 RN01 0.0-0.0i)
    (test CFL04 RN01 -0.0-0.0i)
    (test CFL01 RN02 -0.0-0.0i)
    (test CFL02 RN02 0.0-0.0i)
    (test CFL03 RN02 -0.0+0.0i)
    (test CFL04 RN02 0.0+0.0i)
    (test CFL01 RN03 -0.0-0.0i)
    (test CFL02 RN03 0.0-0.0i)
    (test CFL03 RN03 -0.0+0.0i)
    (test CFL04 RN03 0.0+0.0i)
    (test CFL01 RN04 -0.0-0.0i)
    (test CFL02 RN04 0.0-0.0i)
    (test CFL03 RN04 -0.0+0.0i)
    (test CFL04 RN04 0.0+0.0i)
    #f)

  (let-syntax ((test (make-inexact-test / $div-cflonum-flonum)))
    (test CFL01 FL1 +nan.0+nan.0i)
    (test CFL02 FL1 +nan.0+nan.0i)
    (test CFL03 FL1 +nan.0+nan.0i)
    (test CFL04 FL1 +nan.0+nan.0i)
    (test CFL01 FL2 +nan.0+nan.0i)
    (test CFL02 FL2 +nan.0+nan.0i)
    (test CFL03 FL2 +nan.0+nan.0i)
    (test CFL04 FL2 +nan.0+nan.0i)
    (test CFL01 FL3 0.0+0.0i)
    (test CFL02 FL3 -0.0+0.0i)
    (test CFL03 FL3 0.0-0.0i)
    (test CFL04 FL3 -0.0-0.0i)
    (test CFL01 FL4 -0.0-0.0i)
    (test CFL02 FL4 0.0-0.0i)
    (test CFL03 FL4 -0.0+0.0i)
    (test CFL04 FL4 0.0+0.0i)
    #f)

  (let-syntax ((test (make-cflonum-test / $div-cflonum-cflonum)))
    (test CFL01 CFL01 +nan.0+nan.0i)
    (test CFL02 CFL01 +nan.0+nan.0i)
    (test CFL03 CFL01 +nan.0+nan.0i)
    (test CFL04 CFL01 +nan.0+nan.0i)
    (test CFL01 CFL02 +nan.0+nan.0i)
    (test CFL02 CFL02 +nan.0+nan.0i)
    (test CFL03 CFL02 +nan.0+nan.0i)
    (test CFL04 CFL02 +nan.0+nan.0i)
    (test CFL01 CFL03 +nan.0+nan.0i)
    (test CFL02 CFL03 +nan.0+nan.0i)
    (test CFL03 CFL03 +nan.0+nan.0i)
    (test CFL04 CFL03 +nan.0+nan.0i)
    (test CFL01 CFL04 +nan.0+nan.0i)
    (test CFL02 CFL04 +nan.0+nan.0i)
    (test CFL03 CFL04 +nan.0+nan.0i)
    (test CFL04 CFL04 +nan.0+nan.0i)
    (test CFL01 CFL05 -0.0+0.0i)
    (test CFL02 CFL05 0.0-0.0i)
    (test CFL03 CFL05 0.0+0.0i)
    (test CFL04 CFL05 0.0+0.0i)
    (test CFL01 CFL06 0.0-0.0i)
    (test CFL02 CFL06 0.0+0.0i)
    (test CFL03 CFL06 -0.0+0.0i)
    (test CFL04 CFL06 0.0+0.0i)
    (test CFL01 CFL07 0.0+0.0i)
    (test CFL02 CFL07 -0.0+0.0i)
    (test CFL03 CFL07 0.0+0.0i)
    (test CFL04 CFL07 0.0-0.0i)
    (test CFL01 CFL08 -0.0+0.0i)
    (test CFL02 CFL08 0.0-0.0i)
    (test CFL03 CFL08 0.0+0.0i)
    (test CFL04 CFL08 0.0+0.0i)
    (test CFL01 CFL09 +nan.0+nan.0i)
    (test CFL01 CFL10 +nan.0+nan.0i)
    (test CFL01 CFL11 +nan.0+nan.0i)
    (test CFL01 CFL12 +nan.0+nan.0i)
    (test CFL01 CFL13 +nan.0+nan.0i)
    (test CFL01 CFL14 +nan.0+nan.0i)
    (test CFL01 CFL15 +nan.0+nan.0i)
    (test CFL01 CFL16 +nan.0+nan.0i)
    #f)

  (let-syntax ((test (make-inexact-test / #;$div-cflonum-compnum)))
    (test CFL01 10+20i 0.0+0.0i)
    (test CFL01 1+20.0i 0.0+0.0i)
    (test CFL01 10.0+2i 0.0+0.0i)
    (test CFL01 1/2+20i 0.0+0.0i)
    (test CFL01 10+2/3i 0.0+0.0i)
    (test CFL01 (C RN02 20) 0.0-0.0i)
    (test CFL01 (C 10 RN02) 0.0+0.0i)
    #f)

;;; --------------------------------------------------------------------

  (let-syntax ((test (make-inexact-test / $div-cflonum-bignum)))
    (test CFL01 VBN1 0.0+0.0i)
    (test CFL02 VBN1 -0.0+0.0i)
    (test CFL03 VBN1 0.0-0.0i)
    (test CFL04 VBN1 -0.0-0.0i)
    (test CFL01 VBN2 0.0+0.0i)
    (test CFL02 VBN2 -0.0+0.0i)
    (test CFL03 VBN2 0.0-0.0i)
    (test CFL04 VBN2 -0.0-0.0i)
    (test CFL01 VBN3 -0.0-0.0i)
    (test CFL02 VBN3 0.0-0.0i)
    (test CFL03 VBN3 -0.0+0.0i)
    (test CFL04 VBN3 0.0+0.0i)
    (test CFL01 VBN4 -0.0-0.0i)
    (test CFL02 VBN4 0.0-0.0i)
    (test CFL03 VBN4 -0.0+0.0i)
    (test CFL04 VBN4 0.0+0.0i)
    #f)

  (let-syntax ((test (make-inexact-test / $div-cflonum-ratnum)))
    (test CFL01 VRN01 0.0+0.0i)
    (test CFL02 VRN01 -0.0+0.0i)
    (test CFL03 VRN01 0.0-0.0i)
    (test CFL04 VRN01 -0.0-0.0i)
    (test CFL01 VRN02 -0.0-0.0i)
    (test CFL02 VRN02 0.0-0.0i)
    (test CFL03 VRN02 -0.0+0.0i)
    (test CFL04 VRN02 0.0+0.0i)
    (test CFL01 VRN03 -0.0-0.0i)
    (test CFL02 VRN03 0.0-0.0i)
    (test CFL03 VRN03 -0.0+0.0i)
    (test CFL04 VRN03 0.0+0.0i)
    (test CFL01 VRN04 -0.0-0.0i)
    (test CFL02 VRN04 0.0-0.0i)
    (test CFL03 VRN04 -0.0+0.0i)
    (test CFL04 VRN04 0.0+0.0i)
    #f)

  (let-syntax ((test (make-inexact-test / $div-cflonum-compnum)))
    (test CFL01 (C VRN02 20) 0.0-0.0i)
    (test CFL01 (C 10 VRN02) 0.0+0.0i)
    #f)

  #t)


(parametrise ((check-test-name	'compnums))

  (letrec-syntax ((test (make-inexact-test / #;$div-compnum-fixnum)))
    (test 10+20i 12 5/6+5/3i)
    (test 1+20.0i 12 1/12+1.6666666666666667i)
    (test 10.0+2i 12 0.8333333333333334+1/6i)
    (test 1/2+20i 12 1/24+5/3i)
    (test 10+2/3i 12 5/6+1/18i)
    (test (C BN1 20) 12 134217728/3+5/3i)
    (test (C 10 BN1) 12 5/6+134217728/3i)
    #f)

  (letrec-syntax ((test (make-test / #;$div-compnum-bignum)))
    (test 10+20i BN1 5/268435456+5/134217728i)
    (test 1+20.0i BN1 1/536870912+3.725290298461914e-8i)
    (test 10.0+2i BN1 1.862645149230957e-8+2/536870912i)
    (test 1/2+20i BN1 1/1073741824+5/134217728i)
    (test 10+2/3i BN1 5/268435456+1/805306368i)
    (test (C BN2 20) BN1 536871011/536870912+5/134217728i)
    (test (C 10 BN2) BN1 5/268435456+536871011/536870912i)
    #f)

  (letrec-syntax ((test (make-inexact-test / #;$div-compnum-ratnum)))
    (test 10+20i RN01 1230+2460i)
    (test 1+20.0i RN01 123+2459.9999999999995i)
    (test 10.0+2i RN01 1229.9999999999998+246i)
    (test 1/2+20i RN01 123/2+2460i)
    (test 10+2/3i RN01 1230+82i)
    (test (C RN02 20) RN01 -1+2460i)
    (test (C 10 RN02) RN01 1230-1i)
    #f)

  (letrec-syntax ((test (make-test / #;$div-compnum-flonum)))
    (test 10+20i FL1 +inf.0+inf.0i)
    (test 1+20.0i FL1 +inf.0+inf.0i)
    (test 10.0+2i FL1 +inf.0+inf.0i)
    (test 1/2+20i FL1 +inf.0+inf.0i)
    (test 10+2/3i FL1 +inf.0+inf.0i)
    (test (C BN2 20) FL1 +inf.0+inf.0i)
    (test (C 10 BN2) FL1 +inf.0+inf.0i)
    #f)

  (letrec-syntax ((test (make-inexact-test / #;$div-compnum-cflonum)))
    (test 10+20i CFL01 +nan.0+nan.0i)
    (test 1+20.0i CFL01 +nan.0+nan.0i)
    (test 10.0+2i CFL01 +nan.0+nan.0i)
    (test 1/2+20i CFL01 +nan.0+nan.0i)
    (test 10+2/3i CFL01 +nan.0+nan.0i)
    (test (C BN2 20) CFL01 +nan.0+nan.0i)
    (test (C 10 BN2) CFL01 +nan.0+nan.0i)

    (test 10+20i CFL05 -8.333333333333334-16.666666666666668i)
    (test 1.0+20.0i CFL05 -0.8333333333333334-16.666666666666668i)
    (test 10.0+2.0i CFL05 -8.333333333333334-1.6666666666666667i)
    (test 1/2+20i CFL05 -0.4166666666666667-16.666666666666668i)
    (test 10+2/3i CFL05 -8.333333333333334-0.5555555555555556i)
    (test (C BN2 20) CFL05 -447392509.1666666-16.666666666666668i)
    (test (C 10 BN2) CFL05 -8.333333333333334-447392509.1666666i)
    #f)

;;; --------------------------------------------------------------------

  (letrec-syntax ((test (make-inexact-test / $div-compnum-fixnum)))
    (test (C VBN1 20) 12 288230376151711744/3+5/3i)
    (test (C 10 VBN1) 12 5/6+288230376151711744/3i)
    #f)

  (letrec-syntax ((test (make-test / $div-compnum-bignum)))
    (test 10+20i VBN1 5/576460752303423488+5/288230376151711744i)
    (test 1+20.0i VBN1 1/1152921504606846976+1.734723475976807e-17i)
    (test 10.0+2i VBN1 8.673617379884035e-18+1/576460752303423488i)
    (test 1/2+20i VBN1 1/2305843009213693952+5/288230376151711744i)
    (test 10+2/3i VBN1 5/576460752303423488+1/1729382256910270464i)
    (test (C VBN2 20) VBN1 1152921504606847075/1152921504606846976+5/288230376151711744i)
    (test (C 10 VBN2) VBN1 5/576460752303423488+1152921504606847075/1152921504606846976i)
    #f)

  (letrec-syntax ((test (make-inexact-test / $div-compnum-ratnum)))
    (test 10+20i VRN01 1230+2460i)
    (test 1+20.0i VRN01 123.0+2460.0i)
    (test 10.0+2i VRN01 1230.0+246i)
    (test 1/2+20i VRN01 123/2+2460i)
    (test 10+2/3i VRN01 1230+82i)
    (test (C VRN02 20) VRN01 -1+2460i)
    (test (C 10 VRN02) VRN01 1230-1i)
    #f)

  (letrec-syntax ((test (make-inexact-test / $div-compnum-cflonum)))
    (test (C VBN2 20) CFL01 +nan.0+nan.0i)
    (test (C 10 VBN2) CFL01 +nan.0+nan.0i)
    (test (C VBN2 20) CFL05 -9.607679205057059e+17-16.666666666666668i)
    (test (C 10 VBN2) CFL05 -8.333333333333334-9.607679205057059e+17i)
    #f)

  #t)


;;;; done

(check-report)

;;; end of file
