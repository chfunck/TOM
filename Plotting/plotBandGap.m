function plotBandGap(QDOA)
%plotBandGap(QDOA)
%   Plots the Band Gaps of a QDOA

    if nargin < 1
        QDOA = getQDOA();
    end
    [n,m] = size(QDOA);
    Radius = zeros(length(QDOA),2);
    
    % Get Band Gaps and further information
    for i=1:m
        [BGap(i), Radius(i,:), Volt(i), Mat(i)] = getBandGap(QDOA(i));
    end
    
    Col = Volt/max(Volt);
    S = 20;
    [cMat,iMat,icMat] = unique(Mat);
    nMat = length(cMat);
    for k=1:nMat
        if cMat(k) ~= 3
            idx = find(Mat == cMat(k));
            figure;
            if max(Volt(idx)) == 0
                Col = 0*Volt(idx);
            else
                Col = Volt(idx)/max(Volt(idx));
            end
            scatter(Radius(idx,1),BGap(idx),S,Col,'filled');
            xlabel('Radius of Quantum Dot in nm');
            ylabel('Band Gap in eV');
            axis([0 max(Radius(:,1)) 0 max(BGap)]);
            hcb = colorbar('Location','SouthOutside','XTickLabel',linspace(min(Volt(idx)),max(Volt(idx)),11));
            caxis(hcb,[min(Col), max(Col)]);
            xlabel(hcb, 'Voltage in V');
            set(hcb,'XTickMode','manual');
            stitle = QDOA(idx(1)).mat_name;
            title(stitle,'interpreter','none');
            hold on;
            % Fit r^-2 dependence to data points where Volt=0
            r = [min(Radius(:,1)):0.01:max(Radius(:,1))];
            [A,B] = BandGapFitting(Radius(idx,1),BGap(idx),Volt(idx));
            f = @(x) A+B*x.^-2;
            plot(r,f(r),'-r');
            xpos = max(Radius(:,1));
            ypos = max(BGap);
            text(xpos,ypos,['Band Gap = ',num2str(A), ' + ' num2str(B), ' * r^{-2}'],...
            'VerticalAlignment','top',...
            'HorizontalAlignment','right',...
            'FontSize',10);
        end

        
    end
    
    for k=1:nMat
        if cMat(k) == 3
            idx = find(Mat == cMat(k));
            [cVolt,iVolt,icVolt] = unique(Volt(idx));
            for l=1:length(cVolt)
                idxV = find(Volt == cVolt(l));
                if length(idx) > length(idxV)
                    idxV=idxV(ismember(idxV,idx));
                else
                    idxV=idxV(ismember(idxV,idx));
                end
                figure;
                scatter(Radius(idxV,1),Radius(idxV,2),S,BGap(idxV),'filled');
                xlabel('Inner radius of Quantum Dot in nm');
                ylabel('Outer radius of Quantum Dot in nm');
                axis([0 max(Radius(:,1)) 0 max(Radius(:,2))]);
                cBGap = Volt(idx)/max(Volt(idx));
                hcb = colorbar('Location','SouthOutside','XTickLabel',linspace(min(iVolt),max(iVolt),11));
                xlabel(hcb, 'Band Gap in eV');
                set(hcb,'XTickMode','manual');
                stitle = [QDOA(idxV(1)).mat_name, ', Voltage in V = ', num2str(Volt(idxV(1)))];
                title(stitle,'interpreter','none');
            end
        end
    end
end