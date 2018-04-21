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

![deuteranopic](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/kurtenbach1999_deuteranopic.png "deuteranopic")

![protanopic](https://github.com/petteriTeikari/photoreceptor_fit/blob/master/figures_out/kurtenbach1999_protanopic.png "Tprotanopic")
