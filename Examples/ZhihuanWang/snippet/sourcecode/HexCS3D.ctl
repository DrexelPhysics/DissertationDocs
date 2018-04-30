; Calculating GaAs/AlGaAs single Hexagon core-shell nanowire excitation mode
; By Zhihuan Wang 07-01-2013
; Will examine the diameter varing from 20 50 90 130 170 210 250 290 330
; Incident light source wavelength is 532 nm fcen=0.1879
;------------------------Parameter Setup-----------------------------------
(reset-meep)
(define-param n 3.4) ; index of waveguide
(define-param ns 3.3) ; index of waveguide shell

(define-param w 0) ; width of waveguide
(define-param r 1.65) ; outer radius of ring
(define-param l 10)   ; length of the nanowire
(define-param rc (* 0.4 r)) ; inner radius of ring

(define-param pad 0.5) ; padding between waveguide and edge of PML
(define-param dpml 1) ; thickness of PML

;-----------------Dimension and size of the computational cell-------------
(define C->L (compose cartesian->lattice vector3))
(define sxy (* 2 (+ r w pad dpml))) ; cell size y
(define sxz (* 2 (+ l w pad dpml))) ; cell size z

;-----------------------Geometric Setup-----------------------------------
(set! geometry-lattice (make lattice (size sxy sxy sxz)))
(set! geometry (append
	(list
     (make block (center 0 0) (size (* r (sqrt (/ 4 3))) (* 2 r) l)
     (e1  (C->L 1 0)) (e2  (C->L 0 1)) 
	   (material (make dielectric (index ns))))
     (make block (center 0 0) (size (* r (sqrt (/ 4 3))) (* 2 r) l)
     (e2 ( C->L (/ (sqrt 3) 2) 0.5)) (e1  (C->L -0.5 (/ (sqrt 3) 2) ))
     (material (make dielectric (index ns))))

   	 (make block (center 0 0) (size (* r (sqrt (/ 4 3))) (* 2 r) l)
	   (e2  ( C->L (/ (sqrt 3) 2) -0.5)) (e1  (C->L 0.5 (/ (sqrt 3) 2)) )
     (material (make dielectric (index ns))))
	 	 (make block (center 0 0) (size (* rc (sqrt (/ 4 3))) (* 2 rc) l)
     (e1  (C->L 1 0)) (e2  (C->L 0 1))
     (material (make dielectric (index n))))
     (make block (center 0 0) (size (* rc (sqrt (/ 4 3))) (* 2 rc) l)
     (e2 ( C->L (/ (sqrt 3) 2) 0.5)) (e1  (C->L -0.5 (/ (sqrt 3) 2) ))
     (material (make dielectric (index n))))
     (make block (center 0 0) (size (* rc (sqrt (/ 4 3))) (* 2 rc) l)
     (e2  ( C->L (/ (sqrt 3) 2) -0.5)) (e1  (C->L 0.5 (/ (sqrt 3) 2)) )
     (material (make dielectric (index n)))))))

;----------------------------PML layers set up-----------------------------
(set! pml-layers (list (make pml (thickness dpml))))
(set-param! resolution 10)
;------------------------------Source set up-------------------------------
(define-param fcen 0.1879) ; pulse center frequency
(define-param df 0.02)  ; pulse width (in frequency)
(set! sources (list
           (make source
             (src (make gaussian-src (frequency fcen) (fwidth df)))
             (component Ez) (center (+ r 0.1) 0))))

;---------------------------run meep----------------------------------------
(run-sources+ 300
              (at-beginning output-epsilon)
              (after-sources (harminv Ez (vector3 (+ r 0.1)) fcen df)))
(run-until (/ 1 fcen) (at-every (/ 1 fcen 20) output-efield-z output-tot-pwr))
