function TRY_melatonin_models() 

    % Petteri Teikari, 2018
    close all    
    scrsz = get(0,'ScreenSize'); % get screen size for plotting
    
    % Fix the paths
    fileName = mfilename; 
    fullPath = mfilename('fullpath');
    path_Code = strrep(fullPath, fileName, '');
    path_Data = fullfile(path_Code, '..', 'data');
    
    % add subfunctions
    addpath(fullfile(path_Code, 'pooling_model'))
    addpath(fullfile(path_Code, 'pooling_model', 'nomogram'))
    addpath(fullfile(path_Code, 'pooling_model', 'templates'))
    addpath(fullfile(path_Code, 'pooling_model', 'ocularmedia'))


    
%% IMPORT THE DATA
    
    pattern = '*.csv';
    [OLD, YOUNG, OLD_headers, YOUNG_header] = import_the_data(path_Data, pattern);
    
    
%% Normalize the data going through all the time points

    % Parameters
    normalize_method = {'raw'};    
    model_strings = {'opponent_(M+L)-S'};
    error_for_fit_string = 'no_weighing'; % 'variance_relative'; % ; % 'variance_relative';
    
    % Settings
    timepoints_strings = {'15 min'; '30 min'; '45 min'; '60min'};
    read_experim_stats_from_disk = 1;
    plot_ON_norm = 0;
    plot_ON_fit = 0;
    
    for norm = 1 : length(normalize_method)
        for model = 1 : length(model_strings)
            for tp = 1 : length(OLD)            

                % NORMALIZE, always the same independent of the model type                
                [OLD_norm{tp}{norm}, OLD_stats{tp}{norm}] = normalize_time_point(OLD{tp}, ...
                                    normalize_method{norm}, 'OLD', scrsz, ...
                                    read_experim_stats_from_disk, tp, ...
                                    timepoints_strings{tp}, plot_ON_norm, path_Code, path_Data);
                
                [YOUNG_norm{tp}{norm}, YOUNG_stats{tp}{norm}] = normalize_time_point(YOUNG{tp}, ... 
                                     normalize_method{norm}, 'YOUNG', scrsz, ...
                                     read_experim_stats_from_disk, tp, ...
                                     timepoints_strings{tp}, plot_ON_norm, path_Code, path_Data);
                

                % FIT
                
                OLD_FIT{tp}{norm}{model} = fit_model_to_melatonin_wrapper(OLD_norm{tp}{norm}, ...
                                            OLD_stats{tp}{norm}, OLD_stats{tp}{norm}.(error_for_fit_string), ...
                                            model_strings{model}, 'OLD', plot_ON_fit, ...
                                            timepoints_strings{tp}, scrsz, path_Code);
                
                
                YOUNG_FIT{tp}{norm}{model} = fit_model_to_melatonin_wrapper(YOUNG_norm{tp}{norm}, ...
                                            YOUNG_stats{tp}{norm}, YOUNG_stats{tp}{norm}.(error_for_fit_string), ...
                                            model_strings{model}, 'YOUNG', plot_ON_fit, ...
                                            timepoints_strings{tp}, scrsz, path_Code);
                
                             

            end
            
            % Visualize the results per model
            visualize_pooling_models(OLD_FIT, YOUNG_FIT, OLD_stats, YOUNG_stats, ...
                                     model_strings{model}, normalize_method{norm}, ... 
                                     tp, norm, model, error_for_fit_string, ...
                                     timepoints_strings, scrsz)
            
        end
    end
    
    
