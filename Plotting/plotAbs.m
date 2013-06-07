function plotAbs(EDOA)
%plotAbs(EDOA)
%   Plots the absorption spectrum of an array of experimental data
    N = length(EDOA);
    entries = cell(N,1);
    
    figure;
    hold on;
    color = 'brgcmky';
    for k=1:N
        if isempty(EDOA(k).abs) == 0
            xWL = EDOA(k).abs(:,1);
            yPL = EDOA(k).abs(:,2);
            plot(xWL,yPL,color(k));
            entries{k} = [EDOA(k).mat_name, ' - ', num2str(EDOA(k).type), ' Diameter in nm: ', num2str(EDOA(k).size)];
        end
    end
    xlabel('Wavelength in nm');
    ylabel('Absorption');
    entries = delEmptyRows(entries);
    legend(entries, 'Location', 'NorthEast');
    axis([200 1500 0 1]);
end