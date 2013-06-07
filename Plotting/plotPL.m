function plotPL(EDOA)
%plotPL(EDOA)
%   Plots the photoluminescence of an array of experimental data

    N = length(EDOA);
    entries = cell(N,1);
    
    figure;
    hold on;
    color = 'brgcmky';
    for k=1:N
        if ~isempty(EDOA(k).PL)
            xWL = EDOA(k).PL(:,1);
            yPL = EDOA(k).PL(:,2)/max(EDOA(k).PL(:,2));
            plot(xWL,yPL,color(k));
            entries{k} = [EDOA(k).mat_name, ' - ', num2str(EDOA(k).type), ' Diameter in nm: ', num2str(EDOA(k).size)];
        end
    end
    xlabel('Wavelength in nm');
    ylabel('Photoluminescence');
    entries = delEmptyRows(entries);
    legend(entries, 'Location', 'NorthEast');
end

