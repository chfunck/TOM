function [p0,p1] = BandGapFitting(r, BGap, Volt)
%[p0,p1] = BandGapFitting(r, BGap, Volt)
%   Fits a set of radius r and Bandgaps BGap to the function:
%     y = p0 + p1 * x^-2
%   for Volt == 0, using the method of least squares.
%
%   CAN ONLY BE USED FOR SINGLE MATERIAL QUANTUM DOTS!

    if length(r) ~= length(BGap)
        disp('BGap and radius have to have same length!');
    else
        
        % Use only entries with Volt == 0 for the fitting
        idx  = find(Volt == 0);
        r    = r(idx);
        BGap = BGap(idx);
        Volt = Volt(idx);
        
        
        % Make column vectors
        if size(r,1) < size(r,2)
            r = r';
        end
        if size(BGap,1) < size(BGap,2)
            BGap = BGap';
        end
        if size(BGap,1) < size(BGap,2)
            Volt = Volt';
        end
        
        b = r.^2 .* BGap;
        A = ones(length(r),2);
        A(:,1) = r.^2;
        
        % Solving the system of equations using method of least squares
        x = A\b; 
        p0 = x(1);
        p1 = x(2);
    end
end