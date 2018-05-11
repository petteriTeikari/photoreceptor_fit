# SUBFUNCTIONS ----------------------------------------------------------------  
import.matlab.results = function(files_points, files_spectra, files_stats, files_contribs) {

  # group these into one dataframe (or list)
  fit = list()
  point = list()
  stat = list()
  contrib = list()
    
  for (i in 1:length(files_points)) {
    
    # get filename
    filename_sep = strsplit(files_points[i], .Platform$file.sep)[[1]]
    just_filename = tail(filename_sep, n=1)
    just_path = gsub(just_filename, '', files_points[i])
    
    # get field names from filename
    name_sep = strsplit(just_filename, '___')[[1]]
    model_name = name_sep[2]
    group = name_sep[3]
    timepoint = name_sep[4]
    
    # import data
    points = read.csv(files_points[i])
    spectrum = read.csv(files_spectra[i])
    stats = read.csv(files_stats[i])
    contribs = read.csv(files_contribs[i])
    
    # RE-GROUP
    
    # constant for all the different groups and models
    fit$wavelength = spectrum$Wavelength
    point$wavelength = points$Wavelength
    contrib$OD_Rods = contribs$dens_R
    contrib$OD_Cones = contribs$dens_C
    contrib$OD_SCones = contribs$dens_CS
    contrib$OD_Melanopsin = contribs$dens_M
    
    # SPECTRUM FIT
    fit[[group]][[timepoint]][[model_name]] = spectrum$Spectrum.Fit
    
    # POINTS (input vs. fit)
    point[[group]][[timepoint]][[model_name]]$Melatonin.CA. = points$Melatonin.CA.
    point[[group]][[timepoint]][[model_name]]$Standard.Deviation = points$Standard.Deviation
    point[[group]][[timepoint]][[model_name]]$Fit = points$Fit
    
    point[[group]][[timepoint]][[model_name]]$Residual = points$Residual
    point[[group]][[timepoint]][[model_name]]$Residual.ABS = points$Residual.ABS
    point[[group]][[timepoint]][[model_name]]$Variance.in = points$Variance.in # check this!
    point[[group]][[timepoint]][[model_name]]$Weights.normalized = points$Weights.normalized
    
    # STATS 
    stat[[group]][[timepoint]][[model_name]]$N = stats$N
    stat[[group]][[timepoint]][[model_name]]$K = stats$K
    
      # Recompute fit stats
      stat[[group]][[timepoint]][[model_name]] = 
        recompute.fit.stats(stat[[group]][[timepoint]][[model_name]],
                            stats$N, stats$K, 
                            point[[group]][[timepoint]][[model_name]]$Melatonin.CA.,
                            point[[group]][[timepoint]][[model_name]]$Fit, 
                            point[[group]][[timepoint]][[model_name]]$Standard.Deviation,
                            point[[group]][[timepoint]][[model_name]]$Weights.normalized)
      
    # CONTRIBUTIONS
    contrib[[group]][[timepoint]][[model_name]]$k1 = contribs$k1
    contrib[[group]][[timepoint]][[model_name]]$k2 = contribs$k2
    contrib[[group]][[timepoint]][[model_name]] = 
      concontribution.wrapper(contribs, contrib[[group]][[timepoint]][[model_name]], model_name)
    
  }
  
  return(list(fit, point, stat, contrib))
}

recompute.fit.stats = function(stat_in, n, K, y_in, y_fit, error, w) {
  
  res = abs(y_in - y_fit)
  
  # Rsquare in R
  # https://stats.stackexchange.com/questions/230556/calculate-r-square-in-r-for-two-vectors
  R2 = 1 - (sum((y_in-y_fit)^2)/sum((y_in-mean(y_in))^2))
  RMSE = sqrt(mean((y_fit-y_in)^2))
  stat_in$R2 = R2
  stat_in$RMSE = RMSE
  
  # We need to compute the BIC, AIC "by hand" as R has many functions if we would
  # have created the model in R, but now our model was defined in Matlab
  # n = number of data points (observations)
  # K = was the number of free parameters
  # w = weights used when fitting the model
  
  # https://stats.stackexchange.com/questions/87345/calculating-aic-by-hand-in-r
  
  # or: 
  # Calculating the log likelihood requires a vector of residuals, 
  # the number of observations in the data, 
  # and a vector of weights (if applicable)
  
  # log likelihood
  ll<-0.5 * (sum(log(w)) - n * (log(2 * pi) + 1 - log(n) + log(sum(w * res^2))))
  
  # Calculating the BIC or AIC requires ll, and additionally requires the df associated with the calculation of the log likelihood, 
  # which is equal to the original number of parameters being estimated plus 1.
  df.ll = K + 1
  
  # BIC
  bic = -2 * ll + log(n) * df.ll
  
  # AIC
  aic = -2 * ll + 2 * df.ll
  
  stat_in$ll = ll
  stat_in$df.ll = df.ll
  stat_in$BIC = bic
  stat_in$AIC = aic
  
  return(stat_in)
  
}

concontribution.wrapper = function(contribs, contrib, model_name) {
  
  # Now in Matlab we had all the parameters always in the matrix x0
  # used by fmincon, but depending on the model, not all the variables
  # were changed during the optimization so we need this wrapper to add
  # some intelligence to this part then
  
  # And if you look at "poolingModel_function.m", it is a bit messy
  # between different models, so we try to harmonize it now, and mark
  # the variables with NA if they were not optimized in that model
  
  # Original from McDougal and Gamlin (2010)
  # "Simple Quick Pooling model"
  if (identical(model_name, 'simple')) {
    contrib$melanopsin = contribs$m0
    contrib$rods = contribs$r0
    contrib$SWS = NA
    contrib$MWS = NA
    contrib$MWSplusLWS = contribs$c0
    contrib$LWS = NA
    contrib$opponentWeight = NA
      
  # Opponent term, from Kurtenbach et al. (1999) 
  # http://dx.doi.org/10.1364/JOSAA.16.001541  
  } else if (identical(model_name, 'opponent_(L-M)')) {
    contrib$melanopsin = contribs$m0
    contrib$rods = contribs$r0
    contrib$SWS = NA
    contrib$MWS = NA
    contrib$Cones = contribs$c0
    contrib$MWSplusLWS = NA # in opponent term
    contrib$LWS = NA
    contrib$opponentWeight = contribs$fD0
  
  # Opponent term, from  Woelders et al. (2018)
  # https://doi.org/10.1073/pnas.1716281115
  } else if (identical(model_name, 'opponent_(+L-M)-S')) {
    contrib$melanopsin = contribs$m0
    contrib$rods = contribs$r0
    contrib$SWS = contribs$fB0
    contrib$MWS =  contribs$inhMWS
    contrib$Cones = contribs$c0
    contrib$MWSplusLWS = NA # in opponent term
    contrib$LWS = contribs$fE0
    contrib$opponentWeight = contribs$fD0
    
  # Opponent term, from  Spitschan et al. (2014)
  # https://dx.doi.org/10.1073/pnas.1400942111
  } else if (identical(model_name, 'opponent_(M+L)-S')) {
    contrib$melanopsin = contribs$m0
    contrib$rods = contribs$r0
    contrib$SWS = contribs$fB0
    contrib$MWS = NA
    contrib$Cones = contribs$c0
    contrib$MWSplusLWS = contribs$fE0 # in opponent term
    contrib$LWS = NA
    contrib$opponentWeight = contribs$fD0
    
  } else {
    warning('your model name should never be here = ', model_name)
  }
  
  return(contrib)
}

plot.wrapper = function(fit, point, stat, contrib, orig_list) {
  
  
  
  # plot the model fits
  plot.the.model.fits(fit$wavelength, fit, point, point$wavelength, stat, orig_list)
  
}

plot.the.model.fits = function(fit_wavelength, fit, point, point_wavelength, stat, orig_list) {
  
  # get the variables in the list
  groups = names(point)
  groups = groups[groups != "wavelength"];
  timepoints = names(point[[groups[1]]])
  models = names(point[[groups[1]]][[timepoints[1]]])
  
  for (i in 1:1) { #length(groups)) { # YOUNG, OLD
    
    plot.model.fit.per.group(groups[i], 
                             fit_wavelength, fit[[groups[i]]], 
                             point_wavelength, point[[groups[i]]],
                             stat[[groups[i]]], orig_list)
  }
}

plot.model.fit.per.group = function(group, fit_wavelength, fit_g, 
                                    point_wavelength, point_g, stat_g, orig_list) {
  
  no_of_cols = length(fit_g)
  timepoints = names(fit_g)
  p = list()
  
  for (i in 1:length(fit_g)) {
    
    p[[i]] = plot.model.fit.per.timepoint(group, timepoints[i], 
                                 fit_wavelength, fit_g[[i]], 
                                 point_g[[i]], point_wavelength, stat_g[[i]], orig_list)
  }
  
  # 4 columns here, 1 row, arrange
  do.call(grid.arrange, c(p, list(ncol=length(fit_g)/2)))
  
}


convert.lists.to.df.for.timepoint.plot = function(model_names,
                                                  fit_wavelength,
                                                  fit_tp,
                                                  point_wavelength,
                                                  point_tp) {
  
  # convert the list into a dataframe
  
  # THE WHOLE SPECTRUM FITS
  fits_to_plot = data.frame(x = fit_wavelength)
  for (var in 1:length(model_names)) {
    fits_to_plot[[model_names[var]]] = fit_tp[[model_names[var]]]
  }
  
  # POINTS IN
  
  points_in = data.frame(x            = point_wavelength, 
                         y            = point_tp[[model_names[1]]]$Melatonin.CA.,
                         
                         variance     = point_tp[[model_names[1]]]$Variance.in,
                         stdev        = point_tp[[model_names[1]]]$Standard.Deviation,
                         
                         rel_variance = point_tp[[model_names[1]]]$Variance.in /
                                        point_tp[[model_names[1]]]$Melatonin.CA.,
                         rel_stdev    = point_tp[[model_names[1]]]$Standard.Deviation /
                                        point_tp[[model_names[1]]]$Melatonin.CA.)
  
  # plot(points_in$x, points_in$y)
  
  # POINTS FITTED
  points_of_fit = data.frame(x = point_wavelength)
  for (var in 1:length(model_names)) {
    points_of_fit[[model_names[var]]] = point_tp[[model_names[var]]]$Fit
  }
  
  return(list(fits_to_plot, points_in, points_of_fit))
  
}

import.orig.points = function(data_path_study) {
  
  # filenames
  young_mean = 'young_mean.csv'
  young_SD = 'young_SD.csv'
  old_mean = 'old_mean.csv'
  old_SD = 'old_SD.csv'
  
  # read
  y_m = read.csv(file.path(data_path_study, young_mean))
  wavelength = y_m$Wavelength
  y_m = y_m[ , !(names(y_m) %in% "Wavelength")]
  y_sd = read.csv(file.path(data_path_study, young_SD))
  y_sd = y_sd[ , !(names(y_sd) %in% "Wavelength")]
  o_m = read.csv(file.path(data_path_study, old_mean))
  o_m = o_m[ , !(names(o_m) %in% "Wavelength")]
  o_sd = read.csv(file.path(data_path_study, old_SD))
  o_sd = o_sd[ , !(names(o_sd) %in% "Wavelength")]
  
  # Depending what you want to do later
  orig_mean = data.frame(wavelength=wavelength,
                         young=y_m, old=o_m)
  
  orig_SD = data.frame(wavelength=wavelength,
                       young_SD=y_sd, young_hi=y_m+y_sd, young_lo=y_m-y_sd,
                       old_SD=o_sd, old_hi=o_m+o_sd, old_lo=o_m-o_sd)
  
  orig_all = cbind(orig_mean, orig_SD[ , !(names(orig_SD) %in% "wavelength")])
  
  return(list(orig_mean, orig_SD, orig_all))
  
}