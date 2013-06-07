function plotEnergyLevels(QDOA)
% plotEnergyLevels(QDOA)
%   plots all energy levels of an array of quantum dot objects highlighting
%   the band gap

    global config;
    
    N = length(QDOA);
    % Plot width
    pwdth = 5;
    % Number of horizontal points
    npt   = 100;
    % Max number of subplots in one figure
    nsubp = 6;
    % Figure counter
    openfig = get(0,'children')
    if isempty(openfig)
        figcnt = 1;
    else
        figcnt = max(round(openfig))+1;
    end
    
    minCB = zeros(N,1);
    maxCB = zeros(N,1);
    minVB = zeros(N,1);
    maxVB = zeros(N,1);
    BGap  = zeros(N,1);
    
    % For scaling purposes
    for k=1:N
        %get XB_E
        if QDOA(k).update_bs_target == 0
            load([config.simulations, QDOA(k).path, '/CB_E_0_0.dat']);
            load([config.simulations, QDOA(k).path, '/VB_E_0_0.dat']);
        else
            [CB_E_0_0, VB_E_0_0,~,~] = splitCBVBE(QDOA(k));
        end
            
        maxCB(k) = max(CB_E_0_0);
        minVB(k) = min(VB_E_0_0);
    end
    ymin = min(minVB);
    ymax = max(maxCB);
    
    
    % Calculate band gaps
    for k=1:N
        %get XB_E
        if QDOA(k).update_bs_target == 0
            load([config.simulations, QDOA(k).path, '/CB_E_0_0.dat']);
            load([config.simulations, QDOA(k).path, '/VB_E_0_0.dat']);
        else
            [CB_E_0_0, VB_E_0_0,~,~] = splitCBVBE(QDOA(k));
        end
        
        
        
        minCB(k) = min(CB_E_0_0);
        maxCB(k) = max(CB_E_0_0);
        minVB(k) = min(VB_E_0_0);
        maxVB(k) = max(VB_E_0_0);
        BGap(k)  = minCB(k)-maxVB(k);
        
        NM(k)    = max(length(CB_E_0_0),length(VB_E_0_0));    % Number of modes
        
        % Make CB_E and VB_E of equal length (fill shorter vector up)
        diff = length(CB_E_0_0) - length(VB_E_0_0);
        if diff > 0
            VB_E_0_0(end+1:end+diff) = ones(diff,1)*VB_E_0_0(end);
        elseif diff < 0
            diff = abs(diff);
            CB_E_0_0(end+1:end+diff) = ones(diff,1)*CB_E_0_0(end);
        end
        
        
        M = zeros(3,NM(k));
        M(2,:) = CB_E_0_0;
        M(3,:) = VB_E_0_0;
        M = repmat(M,1,npt);
        x0 = linspace(-pwdth,pwdth,npt);
        x0 = sort(repmat(x0,1,NM(k)));
        M(1,:) = x0;
        
        x = repmat(x0,1,2);
        y = [M(2,:),M(3,:)];
        group = [zeros(1,npt*NM(k)),ones(1,npt*NM(k))];
        
        % Plotting
        if mod(k,nsubp) == 1
            figure(figcnt);
            suptitle('Bandgap and energy levels of Quantum Dots');
            figcnt = figcnt + 1;
        end
        subplot(2,3,mod(k-1,nsubp)+1)
            gscatter(x, y, group,'kg','..');
            hold on;
            if length(QDOA(k).geometry) > 1
                radius = num2str(QDOA(k).geometry(1).radius);
                for l=2:length(QDOA(k).geometry)
                    radius = [radius, ', ', num2str(QDOA(k).geometry(l).radius)];
                end
            else
                radius = num2str(QDOA(k).geometry.radius)
            end
            % Figure properties
            stitle = [QDOA(k).mat_name,', Radius: ', ...
                      radius, ', Volt: ',...
                      num2str(QDOA(k).Vdmin)];
            title(stitle, 'Interpreter', 'none');
            set(gca,'XTickLabel',[]);
            ylabel('Energy in eV');
            axis([-pwdth, pwdth, ymin, ymax]);
            fill([-pwdth pwdth pwdth -pwdth], [minCB(k) minCB(k) maxVB(k) maxVB(k)], 'r');
            legend('CB levels', 'VB levels', 'Bandgap', 'Location', 'East');
            text(0,0.5*(minCB(k)+maxVB(k)), ['Bandgap = ', num2str(BGap(k)), 'eV'], ...
                        'VerticalAlignment','middle',...
                        'HorizontalAlignment','center');
            hold off;
    end
end