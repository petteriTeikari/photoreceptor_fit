function TRY_melatonin_models() 

    % Petteri Teikari, 2018
    close all    
    scrsz = get(0,'ScreenSize'); % get screen size for plotting
    
    fileName = mfilename; 
    fullPath = mfilename('fullpath');
    path_Code = strrep(fullPath, fileName, '');
    path_Data = fullfile(path_Code, '..', 'data');
    
%% IMPORT THE DATA
    
    pattern = '*.csv';
    [OLD, YOUNG, OLD_headers, YOUNG_header] = import_the_data(path_Data, pattern);
    
    
%% Normalize the data going through all the time points

    % Parameters
    normalize_method = {'max_min'};    
    model_strings = {'simple'};
    
    % Settings
    timepoints_strings = {'15 min'; '30 min'; '45 min'; '60min'};
    plot_ON_norm = 0;
    plot_ON_fit = 0;
    
    for norm = 1 : length(normalize_method)
        for model = 1 : length(model_strings)
            for tp = 1 : length(OLD)            

                % NORMALIZE, always the same independent of the model type
                [OLD_norm{tp}{norm}, OLD_stats{tp}{norm}] = normalize_time_point(OLD{tp}, ...
                                    normalize_method{norm}, 'OLD', scrsz, ...
                                    timepoints_strings{tp}, plot_ON_norm, path_Code);

                [YOUNG_norm{tp}{norm}, YOUNG_stats{tp}{norm}] = normalize_time_point(YOUNG{tp}, ... 
                                     normalize_method{norm}, 'YOUNG', scrsz, ...
                                     timepoints_strings{tp}, plot_ON_norm, path_Code);

                % FIT
                OLD_FIT{tp}{norm}{model} = fit_model_to_melatonin_wrapper(OLD_norm{tp}{norm}, ...
                                            OLD_stats{tp}{norm}, ...
                                            model_strings{model}, 'OLD', plot_ON_fit, ...
                                            timepoints_strings{tp}, scrsz, path_Code);
                                        
                YOUNG_FIT{tp}{norm}{model} = fit_model_to_melatonin_wrapper(YOUNG_norm{tp}{norm}, ...
                                            YOUNG_stats{tp}{norm}, ...
                                            model_strings{model}, 'YOUNG', plot_ON_fit, ...
                                            timepoints_strings{tp}, scrsz, path_Code);
                             

            end
            
            % Visualize the results per model
            visualize_pooling_models(OLD_FIT, YOUNG_FIT, OLD_stats, YOUNG_stats, ...
                                     model_strings{model}, normalize_method{norm}, ... 
                                     tp, norm, model, ...
                                     timepoints_strings, scrsz)
            
        end
    end
    
    