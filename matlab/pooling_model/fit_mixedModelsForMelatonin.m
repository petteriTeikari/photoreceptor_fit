% wrapper function for the lightLab library's mixed models
function [spec, points, stats, actSpectra, x, fval, output_struct, statParam, x0_names] = ...
    fit_mixedModelsForMelatonin(x,y,err,model,options)

    %% CHECK THE INPUTS

        % if no model is given, use then 'all'
        if nargin == 3
            model = 'all';
            options = useDefaultOptionsForMixedModels();
        % if no options are given
        elseif nargin == 4
            options = useDefaultOptionsForMixedModels();       
        elseif nargin == 5
            % 
        else
            errordlg('Not enough input parameters!')
        end    

    %% Assign the variable names from the options to the input arguments to poolingModel_main

        mode    = model;
        comb_k  = options.poolingModel.comb_k; %[k1 k2]
        contr   = options.poolingModel.contr; % [m c r]
        p       = options.poolingModel.p; % M/L cone ratio
        densit  = options.poolingModel.densit; % [OPN4 Cone S-Cone Rod]
        fMe     = options.poolingModel.fMe;
        oppon   = options.poolingModel.oppon; % [fB0 fD0 fE0]
        bound   = options.poolingModel.bound;
        costF   = options.poolingModel.costF;
        linLog  = options.poolingModel.linLog;

        % Call the function
        [spec, points, stats, actSpectra, x, fval, output_struct, statParam, x0_names]  = ...
            poolingModel_main(x,y,err,mode,linLog,comb_k,contr,p,densit,fMe,oppon,bound,costF,options);
