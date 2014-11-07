## Ph.D. thesis, Trevor King

Final copies:

+ [Color PDF](TrevorKingDissertationColor.pdf?raw=true)
+ [Black & White PDF](TrevorKingDissertation.pdf?raw=true)

This is a reduced version of original thesis source, much of the raw data text files have been removed for space.
Please see the original here (with version commits):

+ LaTeX source for this thesis can be found here: http://git.tremily.us/?p=thesis.git
+ The original source for the drexel-thesis package: http://git.tremily.us/?p=drexel-thesis.git
+ A sparse drexel-thesis example: http://blog.tremily.us/posts/drexel-thesis/

--------------------------------------------------------------------------

#### Abstract 

> Single molecule force spectroscopy (SMFS) experiments provide an experimental benchmark for testing simulated and theoretical predictions of protein unfolding behavior. Despite it use since 1997, the labs currently engaged in SMFS use in-house software and procedures for critical tasks such as cantilever calibration and Monte Carlo unfolding simulation. Besides wasting developer time producing and maintaining redundant implementations, the lack of transparency makes it more difficult to share data and techniques between labs, which slows progress. In some cases it can also lead to ambiguity as to which of several similar approaches, correction factors, etc. were used in a particular paper.

> In this thesis, I introduce an SMFS sofware suite for cantilever calibration (calibcant), experiment control (unfold-protein), analysis (Hooke), and postprocessing (sawsim) in the context of velocity clamp unfolding of I27 octomers in buffers with varying concentrations of CaCl. All of the tools are licensed under open source licenses, which allows SMFS researchers to centralize future development. Where possible, care has been taken to keep these packages operating system (OS) agnostic. The experiment logic in unfold-protein and calibcant is still nominally OS agnostic, but those packages depend on more fundamental packages that control the physical hardware in use. At the bottom of the physical-interface stack are the Comedi drivers from the Linux kernel. Users running other operating systems should be able to swap in analogous low level physical-interface packages if Linux is not an option.
