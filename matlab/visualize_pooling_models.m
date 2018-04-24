function visualize_pooling_models(OLD_FIT, YOUNG_FIT, OLD_stats, YOUNG_stats, ...
                                     model_string, normalize_method, ...
                                     tp_ind, norm_ind, model_ind, error_for_fit_string, ...
                                     timepoints_strings, scrsz)
    
   % load('visual_var.mat')
   close all
   
   plotStyle.xLims = [400 640];
   
   %{ 
   init_plot(OLD_FIT, YOUNG_FIT, OLD_stats, YOUNG_stats, ...
                                     model_string, normalize_method, ...
                                     tp_ind, norm_ind, model_ind, ...
                                     timepoints_strings, scrsz, plotStyle)
    %}
               
    % YOUNG
    group_plot(YOUNG_FIT, YOUNG_stats, 'YOUNG',...
                 model_string, normalize_method, ...
                 tp_ind, norm_ind, model_ind, error_for_fit_string, ...
                 timepoints_strings, scrsz, plotStyle)
             
    % OLD
    group_plot(OLD_FIT, OLD_stats, 'OLD',...
                 model_string, normalize_method, ...
                 tp_ind, norm_ind, model_ind, error_for_fit_string, ...
                 timepoints_strings, scrsz, plotStyle)
             
             
    
    
%% SUBFUNCTIONS 

%% "1st LEVEL"
function init_plot(OLD_FIT, YOUNG_FIT, OLD_stats, YOUNG_stats, ...
                                     model_string, normalize_method, ...
                                     tp_ind, norm_ind, model_ind, error_for_fit_string, ...
                                     timepoints_strings, scrsz, plotStyle)

    % Subplot layout 
    fig = figure('Color', 'w',... 
                 'Position', [0.05*scrsz(3) 0.05*scrsz(4) 0.92*scrsz(3) 0.8*scrsz(4)]);
        
    no_of_timepoints = length(timepoints_strings);
    rows = 6; % young, old
    cols = no_of_timepoints; % young, old
    
    for tp = 1 : no_of_timepoints
          
        % YOUNG
        sp(1,tp) = subplot(rows, cols, [tp tp+cols]);
            plot_each_subplot(YOUNG_FIT{tp}{norm_ind}{model_ind}, YOUNG_stats{tp}{norm_ind}, ...
                              normalize_method, model_string, 'YOUNG', ...
                              tp, timepoints_strings{tp})
                
            % Fractional error
            sp(2,tp) = subplot(rows, cols, tp+(2*cols));
                stem(YOUNG_stats{tp}{norm_ind}.x, ...
                             abs(YOUNG_stats{tp}{norm_ind}.err_relative), 'filled');                             
            
        
        % OLD
        sp(3,tp) = subplot(rows, cols, [tp+(3*cols) tp+(4*cols)]);
            plot_each_subplot(OLD_FIT{tp}{norm_ind}{model_ind}, OLD_stats{tp}{norm_ind}, ...
                              normalize_method, model_string, 'OLD', ...
                              tp, timepoints_strings{tp})
                          
            sp(4,tp) = subplot(rows, cols, tp+(5*cols));
                stem(YOUNG_stats{tp}{norm_ind}.x, ...
                             abs(YOUNG_stats{tp}{norm_ind}.err_relative), 'filled');                             
        
    end
    
    set(sp, 'XLim', plotStyle.xLims)

function group_plot(FIT, STATS, group, ...
                 model_string, normalize_method, ...
                 tp_ind, norm_ind, model_ind, error_for_fit_string, ...
                 timepoints_strings, scrsz, plotStyle)

    % Subplot layout 
    fig = figure('Color', 'w',... 
                 'Position', [0.05*scrsz(3) 0.025*scrsz(4) 0.92*scrsz(3) 0.95*scrsz(4)]);
        
    no_of_timepoints = length(timepoints_strings);
    rows = 6; % young, old
    cols = no_of_timepoints; 
    
    for tp = 1 : no_of_timepoints
    
        sp(1,tp) = subplot(rows, cols, tp);
            weights_plot(STATS{tp}{norm_ind}, error_for_fit_string, ...
                              normalize_method, model_string, group, ...
                              tp, timepoints_strings{tp})
        
        sp(2,tp) = subplot(rows, cols, [tp+(1*cols) tp+(2*cols)]);
            plot_each_subplot(FIT{tp}{norm_ind}{model_ind}, STATS{tp}{norm_ind}, ...
                              normalize_method, model_string, group, ...
                              tp, timepoints_strings{tp})

        sp(3,tp) = subplot(rows, cols, tp+(3*cols));
            residual_plot(FIT{tp}{norm_ind}{model_ind}, STATS{tp}{norm_ind}, ...
                              normalize_method, model_string, group, ...
                              tp, timepoints_strings{tp})
                          
        sp(4,tp) = subplot(rows, cols, [tp+(4*cols) tp+(5*cols)]);
            spectral_fit(FIT{tp}{norm_ind}{model_ind}, STATS{tp}{norm_ind}, ...
                              normalize_method, model_string, group, ...
                              tp, timepoints_strings{tp})        
    end
    
    set(sp, 'XLim', plotStyle.xLims)

    
%% "2nd LEVEL"
%% i.e. that the 1st level ones call, "private functions" for these
function spectral_fit(fit_per_tp, stat_per_tp, ...
                          normalize_method, model_string, group, ...
                          tp, tp_string, plotStyle)   
      
      % TODO! If you want Melanopic here instead of the Gov. Nomogram
      header_names_simple = {'OPN4 R', 'Vl', 'RODS'};
      multiplier_indices_simple = [1 2 3]; % i.e. m0, c0, r0      
      output_names_simple = {'Melanopsin', 'Vlambda', 'Rod'};
      
      if strcmp(model_string, 'simple')          
          
          % Spectra contains each photoreceptor contribution, i.e.
          % the ocular media corrected spectra with the contribution weight
          spectra = populate_spectra(fit_per_tp.x0_names, ...
                                     fit_per_tp.final_x, ...
                                     fit_per_tp.actSpectra, ...
                                     header_names_simple, ...
                                     multiplier_indices_simple, ...
                                     output_names_simple);
                                 
      elseif strcmp(model_string, 'something else')
          
      else
          % error(['For some reason your model_string changed to unsupported one: ', model_string])
          spectra = populate_spectra(fit_per_tp.x0_names, ...
                                     fit_per_tp.final_x, ...
                                     fit_per_tp.actSpectra, ...
                                     header_names_simple, ...
                                     multiplier_indices_simple, ...
                                     output_names_simple);
      end      
      
      plot_usedSpectra(spectra, tp)

      
function plot_usedSpectra(spectra, tp)
      
    spectraUsed_names = fieldnames(spectra);
    no_of_spectra = length(spectraUsed_names);

    lambda = (380:1:780)'; % TODO HARD-CODED NOW!
    
    spectra_mat_raw = zeros(length(lambda), no_of_spectra+1);
    spectra_mat = spectra_mat_raw;
    
    for i = 1 : no_of_spectra          
      spectra_mat_raw(:,i) = spectra.(spectraUsed_names{i}).spec;
      spectra_mat(:,i) = spectra_mat_raw(:,i) .* spectra.(spectraUsed_names{i}).multiplier;
    end
    
    % Calculate the sums
    prev_columns_raw = spectra_mat_raw(:,1:i);
    sum_of_prev_raw = sum(prev_columns_raw,2);    
    spectra_mat_raw(:,i+1) = sum_of_prev_raw;
    
    prev_columns = spectra_mat(:,1:i);
    sum_of_prev = sum(prev_columns,2);    
    spectra_mat(:,i+1) = sum_of_prev;
    
    % Normalize
    max_value = max(spectra_mat(:));
    spectra_mat = spectra_mat / max_value;
    
    % Plot
    p = plot(lambda, spectra_mat);
    set(p(end), 'LineStyle', '--')
    
    style = setDefaultFigureStyling();   
    set(gca, 'FontSize',8, 'FontName', style.fontName,'FontWeight','normal')
      
    if tp == 1
        ylabel('Response Norm.','FontWeight','bold','FontSize',9,...
                     'FontName','Futura Book');        
    end
    
    xlabel('Wavelength [nm]','FontWeight','bold','FontSize',9,...
                     'FontName','Futura Book');
    
      
function spectra_out = populate_spectra(names, x, actSpectra, ...
                        header_names, multiplier_indices, output_names)

    for i = 1 : length(actSpectra)
        header_names_actSpectra{i} = actSpectra{i}.header;
    end

    % find corresponding spectra from actSpectra to desired "header_names"
    for j = 1 : length(header_names)       
       
       IndexC = strfind(header_names_actSpectra, header_names{j});
       Index = find(not(cellfun('isempty', IndexC)));
       
       % If found, add to output structure
       if isempty(Index) == 0          
           
          spectra_out.(output_names{j}).spec = ...
              actSpectra{Index}.spectrum;
          
          spectra_out.(output_names{j}).multiplier = ...
              x(multiplier_indices(j));
          
       end
    end
          
    
function residual_plot(fit_per_tp, stat_per_tp, ...
                              normalize_method, model_string, group, ...
                              tp, tp_string, plotStyle)    
      
      residual = abs(fit_per_tp.points - stat_per_tp.y);      
      s = stem(stat_per_tp.x, residual, 'k', 'filled');
      
      % set(s, 'XLim', plotStyle.xLims)
      if tp == 1
        ylabel('Residuals','FontWeight','bold','FontSize',9,...
                     'FontName','Futura Book');
      end
    
    style = setDefaultFigureStyling();   
    set(gca, 'FontSize',8, 'FontName', style.fontName,'FontWeight','normal')
      
    if tp == 1
        ylabel('Residuals','FontWeight','bold','FontSize',9,...
                     'FontName','Futura Book');
    end
    
function weights_plot(stat_per_tp, error_for_fit_string, ...
                              normalize_method, model_string, group, ...
                              tp, tp_string)
           
    
    weights = 1 ./ stat_per_tp.(error_for_fit_string);
    weights_norm = weights ./ max(weights);
    
    s = stem(stat_per_tp.x, weights_norm, 'b', 'filled');       
    
    style = setDefaultFigureStyling();   
    set(gca, 'FontSize',8, 'FontName', style.fontName,'FontWeight','normal')
    
    if tp == 1
        ylabel('Weights Norm.','FontWeight','bold','FontSize',9,...
                     'FontName','Futura Book');
    end
    
    titleString = ['norm(1 / ', error_for_fit_string, ')'];
    tit = title(titleString,'FontWeight','bold','FontSize',8,...
                'FontName','Futura Book','interpreter','none');
    
    
    
      
function plot_each_subplot(fit, stats, ...
                              normalize_method, model_string, group, ...
                              tp, tp_string)
    
    % Easier and more intuitive names for plotting
    x = stats.x;
    y = stats.y;
    err = stats.stdev;
    lambda = fit.actSpectra{1}.lambda;
    spectrumFit = fit.spec;
    
    % set default style
    style = setDefaultFigureStyling();         
    
    % normalize
    y_max = max(y);
    y = y / y_max;
    multip = max(y) / y_max;
    err = err .* multip;
    
    hold on
    e(1) = errorbar(x, y, err, 'ko', 'MarkerFaceColor', [0 0.447 0.74], 'Color', [.3 .3 .3]);
    e(2) = plot(lambda, multip*spectrumFit, 'LineWidth',2, 'Color',[1 0 0.6]);    
    hold off

    titleString = [group, ': ', tp_string, ' (', model_string, ')'];
    set(gca, 'FontName', style.fontName, 'FontSize', style.fontBaseSize)  
    
    tit = title(titleString,'FontWeight','bold','FontSize',11,...
                'FontName','Futura Book');
            
    
    lab(1) = xlabel('','FontWeight','bold','FontSize',9,...
                    'FontName','Futura Book');
    
    lab(2) = ylabel('CA%','FontWeight','bold','FontSize',9,...
                     'FontName','Futura Book');
                 
    % leg = legend('Original Data', 'Fit');
    %        legend('boxoff')

    set(gca, 'XLim', [400 640])        
    set(gca, 'YLim', [-0.4 1.2])        
        %set(lab, 'FontName', style.fontName, 'FontSize', style.fontBaseSize, 'FontWeight', 'bold')    
        %set(tit, 'FontName', style.fontName, 'FontSize', style.fontBaseSize+1, 'FontWeight', 'bold')            
        % set(leg, 'FontSize', style.fontBaseSize-1, 'FontName', style.fontName)

    drawnow