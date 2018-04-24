function [tp_out, stats] = normalize_time_point(mat_per_tp, ...
                                      normalize_method, group, scrsz, ...
                                      read_experim_stats_from_disk, tp_index, ...
                                      timeP, plot_ON, path_Code, path_Data)
       
    % disp(group)    
    if plot_ON == 1
        fig = figure('Color', 'white',... 
                        'Position', [0.05*scrsz(3) 0.48*scrsz(4) 0.90*scrsz(3) 0.4*scrsz(4)]);
    end

    % Easier variable names
    x = mat_per_tp.lambda;
    y = mat_per_tp.melatonin;
    
    [no_of_timepoints, no_of_subjects] = size(y);
    
    % Mean and stdev per time point
    mean_per_lambda = nanmean(y,2);
    mean_per_subject = nanmean(y,1);
    mean_rep_timepoint = repmat(mean_per_lambda, 1, no_of_subjects);
    mean_rep_subject = repmat(mean_per_subject, no_of_timepoints, 1);
    
    stdev_per_lambda = nanstd(y,0,2);
    stdev_per_subject = nanstd(y,0,1);
    stdev_rep_timepoint = repmat(stdev_per_lambda, 1, no_of_subjects);
    stdev_rep_subject = repmat(stdev_per_subject, no_of_timepoints, 1);
    
    % PLOT THE INPUT
    if plot_ON == 1
        subplot(1,3,1); plot(x, y); title([group, ': ', timeP])
    end
    
    % NORMALIZE
    if strcmp(normalize_method, 'raw')
        normStr = 'No normalization';
    
    elseif strcmp(normalize_method, 'z')
        normStr = 'Z-normalized';
        y = (y - mean_rep_timepoint) ./ stdev_rep_timepoint;
        
    elseif strcmp(normalize_method, 'max') || strcmp(normalize_method, 'max_min')
        
        for sub = 1 : no_of_subjects
            if strcmp(normalize_method, 'max_min')
                y(:,sub) = y(:,sub) - min(y(:,sub));
                normStr = 'Normalized to (max-min) range per subject';
            else
                normStr = 'Normalized to max per subject';
            end
            y(:,sub) = y(:,sub) / max(y(:,sub));
        end
    end
    
    % PLOT NORMALIZED RESULT
    if plot_ON == 1
        subplot(1,3,2); plot(x, y); title(normStr)
    end
    
    % Compute the stats (per time point)
    if read_experim_stats_from_disk == 1
        if strcmp(group, 'OLD')
            filename_mean = fullfile(path_Data, 'old_mean.csv');
            filename_SD = fullfile(path_Data, 'old_SD.csv'); 
        elseif strcmp(group, 'YOUNG')
            filename_mean = fullfile(path_Data, 'young_mean.csv'); 
            filename_SD = fullfile(path_Data, 'young_SD.csv'); 
        end
        
        [mean_in,~,~] = importdata(filename_mean,',',1);
        mean_per_tp = mean_in.data(:,1+tp_index); % 1 from lambda in data
        [SD_in,~,~] = importdata(filename_SD,',',1);
        stdev_per_tp = SD_in.data(:,1+tp_index);
        
    else
        mean_per_tp = nanmean(y,2);
        stdev_per_tp = nanstd(y,0,2);    
    end
    
    % PLOT AVERAGED TRACE
    if plot_ON == 1
        subplot(1,3,3); errorbar(x, mean_per_tp, stdev_per_tp, '-o', 'MarkerFaceColor', 'k'); title('Averaged')
        
    
        % Save to disk
        filename_out = [group, '_', timeP, '_', normStr, '.png'];    
        path_Data = fullfile(path_Code, '..', 'figures_out', filename_out);
        
        saveas(fig, path_Data)
        
    end
    
    % OUTPUT
    tp_out = y;
    stats.x = x;
    stats.y = mean_per_tp;
    stats.n = no_of_subjects;
    stats.stdev = stdev_per_tp;
    stats.stdev_relative = abs(stdev_per_tp ./ mean_per_tp);
    stats.variance = stdev_per_tp .^ 2;
    stats.variance_relative = abs(stats.variance ./ mean_per_tp);

    