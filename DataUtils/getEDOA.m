function [EDOA, ExpDataDirs] = getEDOA()
%[EDOA, ExpDataDirs] = getEDOA()
%   creates an array of EDO from all experimental data

    % get experimental data folder
    global config;
    ExpDataDirs = dir([config.experimentalData 'EDOs/EDO*']);
    [N,~] = size(ExpDataDirs);

    % initialize EDOA
    if N<1
        EDOA = ExpData;
        return;
    end

    % load data into EDOA
    EDOA(N) = ExpData;
    for k=1:N    
        load([config.experimentalData, 'EDOs/' , ExpDataDirs(k).name]);
        EDOA(k) = EDO;
    end
end