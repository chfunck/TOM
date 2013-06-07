function plotVoltBandGap(QDOA)
%plotVoltBandGap(QDOA)
%   Plots the band gap against voltage for a constant radius
%   THE QDOs have to have the same radius/radii

    % For no function parameter plot whole database
    if nargin < 1
        QDOA = getQDOA();
    end
    
    N = length(QDOA);
    Radii = zeros(N,2);
    
    % Get all radii
    for k=1:N
         % Core-shell materials
        if length(QDOA(k).geometry) == 2
            Radii(k,1) = QDOA(k).geometry(1).radius;
            Radii(k,2) = QDOA(k).geometry(2).radius;
        % Single materials
        else
            Radii(k,1) = QDOA(k).geometry.radius;
        end
    end
    
    % uRadii: unique Radii
    [uRadii,IRadii,IuRadii] = unique(Radii,'rows');
    
    for k=1:length(uRadii(:,1))
        % Get all QDOs with the same radii
        idx = ismember(Radii, uRadii(k,:),'rows');
        sameRadiusQDOA = QDOA(idx);
        for l=1:length(sameRadiusQDOA)
            [BGap(l), Radius, Volt(l), Mat(l)] = getBandGap(sameRadiusQDOA(l));
        end
        [uMat, IMat, IuMat] = unique(Mat);
        
        %% Plotting
        % Get the mat_names for lagend entries
        for m=1:length(IMat)
            sMat(m) = {sameRadiusQDOA(IMat(m)).mat_name};
        end
        
        figure
        gscatter(Volt,BGap,Mat);
        stitle = ['Radius = ', num2str(Radius), ' nm'];
        title(stitle,'interpreter','none');
        xlabel('Voltage in V');
        ylabel('Band Gap in eV');
        legend(sMat,'interpreter','none');
        clearvars BGap Radius Volt Mat uMat IMat IuMat sMat
    end
end