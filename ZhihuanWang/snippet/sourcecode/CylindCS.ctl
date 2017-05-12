; By Zhihuan Wang, 06-27-2013
; Calculating 1D cylindrical GaAs/AlGaAs core-shell nanowire excitation mode using cylindrical coordinates.

;%%% length unit %%%
; fundamental length unit in meep is um
;(define nm 0.001)    ; nano-meter unit
;(define um 1)        ; micro-meter unit

;-------------------------Parameter Setup---------------------------------
(define-param nc 3.4) ; index of nanowire core
(define-param ns 3.1349) ; index of nanowire shell
(define-param w 0) ; width of nanowire

(define-param r 1.1) ; radius of core
(define-param rtotal 1.5) ; radius of total (core+shell)

(define-param pad 0.5) ; padding between waveguide and edge of PML
(define-param gap 0.4) ; padding between cylinder and cell edge in XY plane  
(define-param dpml 1.5) ; thickness of PML

;------------------Dimension and size of the computational cell-----------
(define sxy (* 2 (+ rtotal w pad dpml))) ; cell size in XY plane  
(set! geometry-lattice (make lattice (size sxy sxy no-size)))

;------------------------Geometric Setup---------------------------------
(set! geometry (list
               (make cylinder (center 0 0) (height infinity)
               (radius rtotal ) (material (make dielectric (index ns))))

               (make cylinder (center 0 0) (height infinity)
               (radius r) (material (make dielectric (index nc))))))

;------------------------------PML layers set up--------------------------
(set! pml-layers (list (make pml (thickness dpml))))
(set-param! resolution 20)
;--------------------------------Source set up----------------------------
(define-param fcen 0.15) ; pulse center frequency
(define-param df 0.1)  ; pulse width (in frequency)
;(define-param nfreq 500); number of frequencies at which to compute flux

(set! sources (list
               (make source
                 (src (make gaussian-src (frequency fcen) (fwidth df)))
                 (component Ez) (center (+ rtotal 0.5) 0))))
; note that the r -> -r mirror symmetry is exploited automatically

;---------------------------run meep----------------------------------------
(run-sources+ 300
              (at-beginning output-epsilon)
              (after-sources (harminv Ez (vector3 (+ rtotal 0.5)) fcen df)))
(run-until (/ 1 fcen) (at-every (/ 1 fcen 20) output-efield-z))
