function visualize_pooling_models(OLD_FIT, YOUNG_FIT, OLD_stats, YOUNG_stats, ...
                                     model_string, normalize_method, ...
                                     tp_ind, norm_ind, model_ind, ...
                                     timepoints_strings, scrsz)
    
    
   init_plot(OLD_FIT, YOUNG_FIT, OLD_stats, YOUNG_stats, ...
                                     model_string, normalize_method, ...
                                     tp_ind, norm_ind, model_ind, ...
                                     timepoints_strings, scrsz)
                                     
    
    
    
%% SUBFUNCTIONS  
function init_plot(OLD_FIT, YOUNG_FIT, OLD_stats, YOUNG_stats, ...
                                     model_string, normalize_method, ...
                                     tp_ind, norm_ind, model_ind, ...
                                     timepoints_strings, scrsz)

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
                              normalize_method, model_string, ...
                              tp)
                
            % Fractional error
            sp(2,tp) = subplot(rows, cols, tp+(2*cols));
                stem(YOUNG_stats{tp}{norm_ind}.x, ...
                             abs(YOUNG_stats{tp}{norm_ind}.err_relative), 'filled');
                             xlim([400 640]); % ylim([0 1.2])
            
        
        % OLD
        sp(3,tp) = subplot(rows, cols, [tp+(3*cols) tp+(4*cols)]);
            plot_each_subplot(OLD_FIT{tp}{norm_ind}{model_ind}, OLD_stats{tp}{norm_ind}, ...
                              normalize_method, model_string, ...
                              tp)
                          
            sp(4,tp) = subplot(rows, cols, tp+(5*cols));
                stem(YOUNG_stats{tp}{norm_ind}.x, ...
                             abs(YOUNG_stats{tp}{norm_ind}.err_relative), 'filled');
                             xlim([400 640]); % ylim([0 1.2])
        
    end

function plot_each_subplot(fit, stats, ...
                              normalize_method, model_string, ...
                              tp)
    
    % Easier and more intuitive names for plotting
    x = stats.x;
    y = stats.y;
    err = stats.err;
    lambda = fit.actSpectra{1}.lambda;
    spectrumFit = fit.spec;
    
    % set default style
    style = setDefaultFigureStyling();       
    
    
    
    hold on
    e(1) = errorbar(x, y, err, 'ko', 'MarkerFaceColor', [0 0.447 0.74], 'Color', [.3 .3 .3]);
    e(2) = plot(lambda, spectrumFit, 'LineWidth',2, 'Color',[1 0 0.6]);    
    hold off

    tit = title('Quick pooling model fit','FontWeight','bold','FontSize',12,...
                'FontName','Futura Book');
    lab(1) = xlabel('Wavelength [nm]','FontWeight','bold','FontSize',9,...
                    'FontName','Futura Book');
    lab(2) = ylabel('Relative sensitivity','FontWeight','bold','FontSize',9,...
                     'FontName','Futura Book');
                 
    % leg = legend('Original Data', 'Fit');
    %        legend('boxoff')

    set(gca, 'XLim', [400 640])
        set(gca, 'FontName', style.fontName, 'FontSize', style.fontBaseSize)  
        set(lab, 'FontName', style.fontName, 'FontSize', style.fontBaseSize, 'FontWeight', 'bold')    
        set(tit, 'FontName', style.fontName, 'FontSize', style.fontBaseSize+1, 'FontWeight', 'bold')            
        % set(leg, 'FontSize', style.fontBaseSize-1, 'FontName', style.fontName)

    drawnow