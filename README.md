# photoreceptor_fit

Init `simple` fit (meaning the model from [McDougal and Gamlin (2010)](https://doi.org/10.1016/j.visres.2009.10.012) for the spectral sensitivity:

![Init fit](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/quickpool_simple_init_with_CG_fix.png "Init fit")

_The stem plots are [fractional errors]() (stdev / mean of that wavelength), so noisy spectrum ends_
_**Top:** YOUNG, **Bottom:** OLD_

## Background

### McDougal and Gamlin (2010): No Spectral Opponency

[McDougal and Gamlin (2010)](https://doi.org/10.1016/j.visres.2009.10.012) modeled the PLR dynamics using the Quick pooling model ([Quick (1974)](https://doi.org/10.1007/BF00271628))

![Model](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/images_biblio/mcdougalGamlin2010_quickPoolingModel.png "Model")

![Idea](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/images_biblio/mcdougalGamlin2010_quickPoolingIdea.png "Idea")

_Illustration of the effect of changing the curve fitting parameters of Eq. (4) on the composite spectral sensitivity derived from the combination of rod and cone spectral sensitivities. Panels A, C, and E demonstrate the effect of changing the value of the parameter k in Eq. (4) to 1 (A), 2 (C), and 100 (E). Panels B, D, and F demonstrate the effect of changing the relative contribution of the rod and cone signals on the spectral sensitivity of the overlying function, by setting c = 0.5r (B), c = 0.1r (D), and c = 0.03r (F)._

![Results](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/images_biblio/mcdougalGamlin2010_quickPoolingResults.png "Results")

_Relative contribution of the rod, cone, and melanopsin photoresponse to the spectral sensitivity of the PLR over time. The time course of light adaptation of the rod (■), cone (♦), and melanopsin (●) photoresponses while maintaining a half maximal PLR with (A) no background present, (B) a 50 td adapting background, and (C) a three-quarter maximal PLR with a 50 td adapting background. Light adaptation was calculated by the combining the difference in absolute irradiance necessary to maintain these responses with the change in relative contribution of each of the photoresponses to the composite spectral sensitivity function generated for each duration condition of each of the three experiments (see Section 2.4 for details). Each point is relative to the most sensitive photoresponse at the shortest duration condition. The smooth line through each data set is the best fit of a three parameter single exponential decay function to the data._

![Results Table](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/images_biblio/mcdougalGamlin2010_quickPoolingResultsTable.png "Results Table")

### Kurtenbach et al.(1999): Spectral Opponency

[Kurtenbach et al. (1999)](http://dx.doi.org/10.1364/JOSAA.16.001541) demonstrated some color opponency "compound action spectra" for trichromatic, deuteranopic and protanopic individuals:

![Trichromatic](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/images_biblio/kurtenbach1999_trichromatic.png "Trichromatic")

![deuteranopic](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/images_biblio/kurtenbach1999_deuteranopic.png "Deuteranopic")

![protanopic](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/images_biblio/kurtenbach1999_protanopic.png "Protanopic")

### Rea et al. (2005)

Now with spectral opponency, we can start seeing these notches as shown by [Rea et al. (2005)[https://doi.org/10.1016/j.brainresrev.2005.07.002] {[cited by 245](https://scholar.google.com.sg/scholar?client=ubuntu&um=1&ie=UTF-8&lr&cites=6946614197753444320)}; [Rea et al. 2011](https://doi.org/10.1177/1477153511430474)

![Rea et al. 2011](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/images_biblio/rea2011_model.png "Rea et al. 2011")

#### Fitting the 65yrs old data (trying at LRC)

Data from [Thapan et al. 2001](), [Brainard et al. 2001](); and models from [Rea et al. (2005)[https://doi.org/10.1016/j.brainresrev.2005.07.002], [Takahashi et al. 2011](https://doi.org/10.2150/jlve.35.123), [Gall 2004](https://core.ac.uk/download/pdf/33447243.pdf) / [DIN Standard, Lang 2011](http://dx.doi.org/10.1117/2.1201101.003442), and Melanopic function from [Enezi et al. 2011](https://doi.org/10.1177/0748730411409719)

Fitting when normalized to unity in linear domain

![Init fit](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/melModel_comp_norm-toUnity_lin.png "Init fit")

The fitting residuals

![Init fit](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/melModel_residuals_norm-toUnity_lin.png "Init fit")

How this looks in LOG domain (not totally sure now, what is the difference between 2nd and 3rd row):

![Init fit](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/reaModel2005_monochromaticSpectra_LOG_FWHM1nm_res1nm_sharp_origWithCones.png "Init fit")

If one would actually remember the details, but the components of their model

![Init fit](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/reaModel2005_monochromaticComponents_1nm_irradRes0.25.png "Init fit")

#### Petteri's schematic

![Init fit](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/retinalCircuit.png "Init fit")

_See [the build-up](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/biblio/reaMelatonin_manuscript.pdf) on how this was imagined back in 2013

### Enter the "notches" and "bumps"

From : _"[Krastel, Alexandridis, and Gertz (1985)](https://doi.org/10.1159/000309536) provided the **first evidence that the pupillary system has access to a "color opponent" visual process**. Krastel et al. showed that the pupillary action spectrum for chromatic flashes on a steady-white background was virtually identical to the spectral sensitivity curve obtained psychophysically under the same stimulus conditions. That is, the action spectrum has **three prominent lobes** with maxima in a long, middle, and short wavelength region and has a **prominent dip** in sensitivity near 570 nm, resembling what visual psychophysicists call the **"Sloan notch"** (see also [Schwartz 2002](https://doi.org/10.1046/j.1475-1313.2000.00535.x), [Calkins et al. 1992](https://doi.org/10.1016/0042-6989(92)90098-4))."_


[![Sloan Notch](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/images_biblio/teikari2012_thesis_sloanNotch.png "Sloan Notch")](https://tel.archives-ouvertes.fr/file/index/docid/999326/filename/TH2012_Teikari_Petteri_ii.pdf)

### Kimura and Young (1995)

[Kimura and Young (1995)](http://dx.doi.org/10.1016/0042-6989(94)00188-R)

![Sloan Notch](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/images_biblio/kimuraYoung1995_sloanNotch.png "Sloan Notch")

_Action spectra derived from the ON, OFF, and steady-state portions of the pupillary response waveform. **(A) Action spectra for individual observers**. The ON action spectra for all observers are plotted in actual quantal sensitivity (reciprocal quanta sec -t deg-2). The psychophysical spectral sensitivity curve (bold solid lines) and other action spectra, however, were shifted vertically to illustrate their similarities and differences. The OFF and steady-state spectra for observer A were shifted by + 0.2 and -0.45, respectively. The steady-state spectrum for observer J was shifted by -0.65. The psychophysical spectral sensitivity curve, OFF and the steady-state spectra for observer M were shifted by -0.5, +0.2 and
-0.3, respectively. Thee action spectra derived from the **high criterion ON amplitude** and from the **steady-state amplitudes**  can be reasonably described as a **linear sum** of the quantized scotopic and photopic luminous efficiency functions. The relative weights for the photopic function were 49% for observer A, 13% for observer J, and 20% for observer M. **Alternatively**, the two action spectra can be described as a **linear sum of the LWS-,MWS-, and SWS-cone spectra** (thin dotted line; Smith & Pokorny, 1975). The relative weights for LWS- and MWS-cones were 30% and 37% for observer A, 3% and 41% for observer J, and 14% and 20% for observer M, respectively._

### Spitschan et al. (2014): PLR and spectral opponency revisited

[Spitschan et al. (2014)](https://dx.doi.org/10.1073/pnas.1400942111)

_Our work reveals a curious, opponent response to blue light in the otherwise familiar pupillary light response. Increased **stimulation of S cones can cause the pupil to dilate**, but this effect is usually masked by a stronger and opposite response from melanopsin-containing cells._

![Init fit](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/images_biblio/spitschan2014_opponency.png "Init fit")

### Woelders et al. (2018): PLR and spectral opponency revisited

[Woelders et al. (2018)](https://doi.org/10.1073/pnas.1716281115)

_We show that selectively activating **L-cones** or **melanopsin** constricts the pupil whereas **S-** or **M-cone** activation **paradoxically dilates** the pupil. Intrinsically photosensitive RGCs therefore appear to signal color on **yellow/blue** and **red/green scales**, with blue and green cone shifts being processed as brightness decrements._

### Stabio et al. (2018): M5 Color Opponency

[Stabio et al. (2018)](https://doi.org/10.1016/j.neuron.2017.11.030)

_Serial electron microscopic reconstructions revealed that **M5 cells receive selective UV-opsin drive** from **Type 9 cone bipolar cells** but also **mixed cone signals from bipolar Types 6, 7, and 8**. Recordings suggest that both excitation and inhibition are driven by the ON channel and that **chromatic opponency results from M-cone-driven** surround inhibition mediated by wide-field spiking GABAergic amacrine cells. We show that M5 cells send axons to the dLGN and are thus positioned to provide chromatic signals to visual cortex. These findings underscore that melanopsin's influence extends beyond unconscious reflex functions to encompass cortical vision, perhaps including the perception of color._

![Init fit](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/images_biblio/stabio2018_M5.png "Init fit")
