# INIT ----------------------------------------------------------------

  # Libraries
  library(ggplot2)
  library(grid)
  library(gridExtra)
  library(reshape2)

  # Define Paths
  script.dir <- dirname(sys.frame(1)$ofile)
  data_path = file.path(script.dir, '..', 'data_out_from_matlab', fsep = .Platform$file.sep)
  data_path_study = file.path(script.dir, '..', 'data', fsep = .Platform$file.sep)
  
  # Source subfunction(s)
  source(file.path(script.dir, 'plot_subfunctions.R', fsep = .Platform$file.sep))
  source(file.path(script.dir, 'plot_model_fit_per_timepoint.R', fsep = .Platform$file.sep))

    
# GET FILE LISTINGS ----------------------------------------------------------------
  
  # points
  pattern = '*._points.csv'
  files_points = list.files(path=data_path, pattern=pattern, recursive=FALSE, full.names = TRUE)
  
  # spectra
  pattern = '*._spectrum.csv'
  files_spectra = list.files(path=data_path, pattern=pattern, recursive=FALSE, full.names = TRUE)
  
  # stats
  pattern = '*._stats.csv'
  files_stats = list.files(path=data_path, pattern=pattern, recursive=FALSE, full.names = TRUE)
  
  # contributions
  pattern = '*._contributions.csv'
  files_contribs = list.files(path=data_path, pattern=pattern, recursive=FALSE, full.names = TRUE)
  
  
# IMPORT ----------------------------------------------------------------  
  
  imported = import.matlab.results(files_points, files_spectra, files_stats, files_contribs)
    fit = imported[[1]]
    point = imported[[2]]
    stat = imported[[3]]
    contrib = imported[[4]]
    
    # get original points 
    orig_list = import.orig.points(data_path_study)
    
# PLOT ----------------------------------------------------------------    
  
  plot.wrapper(fit, point, stat, contrib, orig_list)
    
  
  
  
