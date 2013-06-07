function [BGap, Radius, Volt, Mat] = getBandGap(QDO)
%[BGap, Radius, Volt, Mat] = getBandGap(QDO)
%   Input:  QDO         - Quantum Dot Object in which Band Gap you are
%                         interested in
%   Output: BGap        - Band Gap in eV
%           Radius      - Inner and Outer Radius of the Qdot
%           Volt        - Applied Voltage
%           Mat         - Material name

    [n,m] = size(QDO.geometry);
    Radius = zeros(max(n,m),1);
    for i=1:max(n,m)
        Radius(i) = QDO.geometry(i).radius';
    end
    Radius = Radius';
    Volt = QDO.Vdmin;
    
    if strcmp(QDO.mat_name, 'PbSe_allan')
        Mat = 1;
    elseif strcmp(QDO.mat_name, 'PbSe_lent')
        Mat = 2;
    elseif strcmp(QDO.mat_name, 'CdS_CdSe')
        Mat = 3;
    elseif strcmp(QDO.mat_name, 'PbS_lent')
        Mat = 4;
    end
    
    global config;
    
    if QDO.update_bs_target ==1
        load([config.simulations, QDO.path, '/CB_E_0_0.dat']);
        %guess = QDO.bs_target;
        
        a = CB_E_0_0(1:end-1);
        b = CB_E_0_0(2:end);
        c=a-b;
        BGap = max(abs(c));
        if BGap<0.05
            BGap=0;
        end
    else    
        load([config.simulations, QDO.path, '/CB_E_0_0.dat']);
        load([config.simulations, QDO.path, '/VB_E_0_0.dat']);
        minCB = min(CB_E_0_0);
        maxVB = max(VB_E_0_0);
        BGap  = minCB - maxVB;
    end
end