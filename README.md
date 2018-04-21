# photoreceptor_fit

Init `simple` fit (meaning the model from [McDougal and Gamlin (2010)](https://doi.org/10.1016/j.visres.2009.10.012) for the spectral sensitivity:

![Init fit](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/quickpool_simple_init.png "Init fit")

## Background

### McDougal and Gamlin (2010): No Spectral Opponency

[McDougal and Gamlin (2010)](https://doi.org/10.1016/j.visres.2009.10.012) modeled the PLR dynamics using the Quick pooling model ([Quick (1974)](https://doi.org/10.1007/BF00271628))

![Model](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/mcdougalGamlin2010_quickPoolingModel.png "Model")

![Idea](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/mcdougalGamlin2010_quickPoolingIdea.png "Idea")

_Illustration of the effect of changing the curve fitting parameters of Eq. (4) on the composite spectral sensitivity derived from the combination of rod and cone spectral sensitivities. Panels A, C, and E demonstrate the effect of changing the value of the parameter k in Eq. (4) to 1 (A), 2 (C), and 100 (E). Panels B, D, and F demonstrate the effect of changing the relative contribution of the rod and cone signals on the spectral sensitivity of the overlying function, by setting c = 0.5r (B), c = 0.1r (D), and c = 0.03r (F)._

![Results](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/mcdougalGamlin2010_quickPoolingResults.png "Results")

_Relative contribution of the rod, cone, and melanopsin photoresponse to the spectral sensitivity of the PLR over time. The time course of light adaptation of the rod (■), cone (♦), and melanopsin (●) photoresponses while maintaining a half maximal PLR with (A) no background present, (B) a 50 td adapting background, and (C) a three-quarter maximal PLR with a 50 td adapting background. Light adaptation was calculated by the combining the difference in absolute irradiance necessary to maintain these responses with the change in relative contribution of each of the photoresponses to the composite spectral sensitivity function generated for each duration condition of each of the three experiments (see Section 2.4 for details). Each point is relative to the most sensitive photoresponse at the shortest duration condition. The smooth line through each data set is the best fit of a three parameter single exponential decay function to the data._

![Results Table](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/mcdougalGamlin2010_quickPoolingResultsTable.png "Results Table")

### Kurtenbach et al.(1999): Spectral Opponency

[Kurtenbach et al. (1999)](http://dx.doi.org/10.1364/JOSAA.16.001541) demonstrated some color opponency "compound action spectra" for trichromatic, deuteranopic and protanopic individuals:

![Trichromatic](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/kurtenbach1999_trichromatic.png "Trichromatic")

![deuteranopic](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/kurtenbach1999_deuteranopic.png "Deuteranopic")

![protanopic](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/kurtenbach1999_protanopic.png "Protanopic")

### Rea et al. (2005)

Now with spectral opponency, we can start seeing these notches as shown by [Rea et al. (2005)[https://doi.org/10.1016/j.brainresrev.2005.07.002] {[cited by 245](https://scholar.google.com.sg/scholar?client=ubuntu&um=1&ie=UTF-8&lr&cites=6946614197753444320)}; [Rea et al. 2011](https://doi.org/10.1177/1477153511430474)

![Rea et al. 2011](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/rea2011_model.png "Rea et al. 2011")

### Enter the "notches" and "bumps"

From : _"[Krastel, Alexandridis, and Gertz (1985)](https://doi.org/10.1159/000309536) provided the **first evidence that the pupillary system has access to a "color opponent" visual process**. Krastel et al. showed that the pupillary action spectrum for chromatic flashes on a steady-white background was virtually identical to the spectral sensitivity curve obtained psychophysically under the same stimulus conditions. That is, the action spectrum has **three prominent lobes** with maxima in a long, middle, and short wavelength region and has a **prominent dip** in sensitivity near 570 nm, resembling what visual psychophysicists call the **"Sloan notch"** (see also [Schwartz 2002](https://doi.org/10.1046/j.1475-1313.2000.00535.x), [Calkins et al. 1992](https://doi.org/10.1016/0042-6989(92)90098-4))."_


![Sloan Notch](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/teikari2012_thesis_sloanNotch.png "Sloan Notch")

### Kimura and Young (1995)

[Kimura and Young (1995)](http://dx.doi.org/10.1016/0042-6989(94)00188-R)

![Sloan Notch](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/
kimuraYoung1995_sloanNotch.png "Sloan Notch")

_. Action spectra derived from the ON, OFF, and steady-state portions of the pupillary response waveform. **(A) Action spectra for individual observers**. The ON action spectra for all observers are plotted in actual quantal sensitivity (reciprocal quanta sec -t deg-2). The psychophysical spectral sensitivity curve (bold solid lines) and other action spectra, however, were shifted vertically to illustrate their similarities and differences. The OFF and steady-state spectra for observer A were shifted by + 0.2 and -0.45, respectively. The steady-state spectrum for observer J was shifted by -0.65. The psychophysical spectral sensitivity curve, OFF and the steady-state spectra for observer M were shifted by -0.5, +0.2 and
-0.3, respectively. Thee action spectra derived from the **high criterion ON amplitude** and from the **steady-state amplitudes**  can be reasonably described as a **linear sum** of the quantized scotopic and photopic luminous efficiency functions. The relative weights for the photopic function were 49% for observer A, 13% for observer J, and 20% for observer M. **Alternatively**, the two action spectra can be described as a **linear sum of the LWS-,MWS-, and SWS-cone spectra** (thin dotted line; Smith & Pokorny, 1975). The relative weights for LWS- and MWS-cones were 30% and 37% for observer A, 3% and 41% for observer J, and 14% and 20% for observer M, respectively. _


