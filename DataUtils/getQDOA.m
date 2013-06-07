function [QDOA] = getQDOA()
% [QDOA] = getQDOA()
% creates an array of QDO from all simulation folders

    %get sim folders
    global config;            
    SimDirs = dir([config.simulations '/ID*']);
    [N,~] = size(SimDirs);

    %initialize DB
    if N<1
        QDOA = Qdot.empty;
        return;
    end            
    QDOA(N) = Qdot;
    k=1;

    %load data into DB 
    for i=1:N   
        path =[config.simulations, SimDirs(i).name, '/QDO.mat'];
        if exist(path) >0 %check if there is QDO.mat
            load(path);
            QDOA(k)=QDO;
            k=k+1;
        else 
            QDOA(end)=[]; %remove empty QDOA element if no QDO.mat
        end    
    end
    
    
end