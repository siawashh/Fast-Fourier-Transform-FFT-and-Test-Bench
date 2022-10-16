# Fast-Fourier-Transform-FFT-and-Test-Bench
#Fast Fourier Transform
The "Fast Fourier Transform" (FFT) is an important measurement method in the science of audio and acoustics measurement. It converts a signal into individual spectral components and thereby provides frequency information about the signal.
#How does an FFT work?
The FFT operates by decomposing an N point time domain signal into N time domain signals each composed of a single point. The second step is to calculate the N frequency spectra corresponding to these N time domain signals. Lastly, the N spectra are synthesized into a single frequency spectrum.
this code used Cooley Tukey algorithm
#Cooley Tukey Fast Fourier Transform
The Cooley-Tukey Fast Fourier Transform is often considered to be the most important numerical algorithm ever invented. This is the method typically referred to by the term “FFT.” The FFT can also be used for fast convolution, fast polynomial multiplication, and fast multiplication of large integers.
for this case we used butterfly structure
#butterfly structure
In the context of fast Fourier transform algorithms, a butterfly is a portion of the computation that combines the results of smaller discrete Fourier transforms (DFTs) into a larger DFT, or vice versa (breaking a larger DFT up into subtransforms).
# results are simulated via ISIM and match with MATLAB's result
just code fft(x) in matlab
# this is a synchronous and standard code with Synthesis Timing Report = 240.549MHz
Synthesis Timing Report is not an accured timing report for recive accured timing report you must check static timing report
