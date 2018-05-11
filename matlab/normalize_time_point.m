function [tp_out, stats] = normalize_time_point(mat_per_tp, ...
                                      normalize_method, group, fit_domain, scrsz, ...
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
    
    elseif strcmp(normalize_method, 'nonneg')
        normStr = 'Non-negative';
        min_y_per_subject = nanmin(y);
        min_y_per_column = repmat(min_y_per_subject, no_of_timepoints, 1);
        y = y - min_y_per_column;
        
        
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
                
        [mean_in,~,~] = importdata(filename_mean,',',1) 
        [SD_in,~,~] = importdata(filename_SD,',',1)
        
        mean_per_tp = mean_in.data(:,1+tp_index); % 1 from lambda in data
        stdev_per_tp = SD_in.data(:,1+tp_index);
        
    else
        mean_per_tp = nanmean(y,2);
        stdev_per_tp = nanstd(y,0,2);    
    end
    
    % OUTPUT
    tp_out = y;
    stats.x = x;
    stats.n = no_of_subjects;
    
    stats.stdev_relative = abs(stdev_per_tp ./ mean_per_tp);
    stats.variance = stdev_per_tp .^ 2;
    stats.variance_relative = abs(stats.variance ./ mean_per_tp);
    
    if strcmp(normalize_method, 'nonneg_maxnorm')
        normStr = 'Non-negative_normToUnity';
        
        min_v = nanmin(mean_per_tp);
        mean_per_tp = mean_per_tp - min_v;
        max_v = nanmax(mean_per_tp);
        mean_per_tp = mean_per_tp / max_v;
        
        

    end 
    
    stats.no_weighing = ones(length(stats.variance_relative), 1);       
    
    if strcmp(fit_domain, 'log')
       
        mean_per_tp;
        range = max(mean_per_tp(:)) - min(mean_per_tp(:));
        
        % remove negative values
        min_v = min(mean_per_tp(:));
        
        
        
        if min_v > 0
            % get ratio between the smallest and second smallest
            sorted = sort(mean_per_tp);
            percentage_of_range = (sorted(2) - sorted(1)) / range;
            ratio_min = min_v ./ sorted(2);
            ratio_max1 = min_v ./ sorted(end);
        else
            sorted = sort(mean_per_tp);
            percentage_of_range = (sorted(2) - sorted(1)) / range;
            if sorted(1) < 0 && sorted(2) < 0
                % TODO!
                offset = 0.01;
            else % only sorted(1) is negative
                % TODO!                
                offset = 0.01;
            end            
        end
        
        % https://stats.stackexchange.com/questions/1444/how-should-i-transform-non-negative-data-including-zeros
        % http://robjhyndman.com/researchtips/transformations/
        % https://en.wikipedia.org/wiki/Power_transform#Box–Cox_transformation
        mean_per_tp = mean_per_tp - min_v;
        
        % define the desired offset so that the ratio between the smallest
        % and second smallest value stays the same
        if min_v > 0
            sorted1 = sort(mean_per_tp);
            offset = ratio_min * sorted1(2);
            mean_per_tp = mean_per_tp + offset;
            sorted2 = sort(mean_per_tp);
            ratio_max2 = sorted2(1) ./ sorted2(end);
        else
            mean_per_tp = mean_per_tp + offset;
        end
        
        mean_per_tp = log10(mean_per_tp);
        
        % normalize
        mean_per_tp = mean_per_tp - max(mean_per_tp(:));
        
        % TODO! convert stdevs to LOG if you really want to, but we can
        % still use the weights from fractional stdevs
        
    end
    
    % OUTPUT AS WELL
    stats.y = mean_per_tp;    
    
    % recompute the stdev assuming that the stdev_relative should stay
    % the same after the min subtraction and max scaling
    stats.stdev = stats.stdev_relative .* mean_per_tp;
    stats.variance = stats.stdev .^ 2;
    % pause
    
    
    % PLOT AVERAGED TRACE
    if plot_ON == 1
        
        if strcmp(fit_domain, 'log')
            subplot(1,3,3); plot(x, mean_per_tp, '-o', 'MarkerFaceColor', 'k'); title('Averaged LOG')
        else
            subplot(1,3,3); errorbar(x, mean_per_tp, stdev_per_tp, '-o', 'MarkerFaceColor', 'k'); title('Averaged')
        end
    
        % Save to disk
        filename_out = [group, '_', timeP, '_', normStr, '.png'];    
        path_Data = fullfile(path_Code, '..', 'figures_out', filename_out);
        
        saveas(fig, path_Data)
        
    end
    
    

    