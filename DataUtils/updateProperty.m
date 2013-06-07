 function updateProperty(DIR, propertyName, value)
%% updateProperty(DIR, propertyName, value)
%   DIR             directory path relative to 'root/Simulations/'
%   propertyName    Qdot property in single quotes, i.e. 'OMENversion'
%   value           value that will be entered in the property
%                   abs2rel changes the path of the Qdot to a path relative to
%                   'root/Simulations' and moves the simulation set into the
%                   right folder

    global config;
    ctrStatus = 0;
    SimDirs = dir([config.simulations, DIR, '/ID*']);
    [N,~] = size(SimDirs);

    for i=1:N
        load([config.simulations, DIR, '/', SimDirs(i).name, '/QDO.mat']);

        %% Overwrite property

        % Change path from absolute to relative
        if strcmp(propertyName, 'path') && strcmp(value, 'abs2rel')
            newPath = ['ID', QDO.timestamp, '_', qdotObj.mat_name];
            eval( sprintf('QDO.%s = %s;',propertyName,'newPath') );
            save([config.simulations, DIR, '/', SimDirs(i).name, '/QDO.mat'], 'QDO');

            % Move simulation folder
            source = [config.simulations, DIR, '/',newPath];
            destination = [config.simulations, newPath];
            [status, msg, msgID] = movefile(source, destination,'f');
            ctrStatus = ctrStatus + status;
            if status == 0
                sprintf('Folder could not be moved from: \n   %s \n to: \n   \s', source, destination);
            end
            if i == N && ctrStatus == N
                rmdir([config.simulations, DIR]);
            end

        % Change a property
        else
            eval( sprintf('QDO.%s = %s;',propertyName,'value') );
            save([config.simulations, DIR, '/', SimDirs(i).name, '/QDO.mat'], 'QDO');
        end

    end
    addpath(genpath(config.root));
end