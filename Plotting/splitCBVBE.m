function [CB_E, VB_E, indCB, indVB] = splitCBVBE(dot)
% function [CB_E, VB_E] = splitCBVBE(dot)
% For update_bs_target = 1 mode: 
% Split the eigen energy vector in CB_E and VB_E

global config;

E = load([config.simulations dot.path '/CB_E_0_0.dat']);

[indCB, indVB] = BandEdge(E);

CB_E = E(indCB:end);
VB_E = E(1:indVB);

end


function [indCB, indVB] = BandEdge(E)
% function [indCB, indVB] = BandEdge(E)
% find the indices (E vector) of the energy levels at the bandedges
 
    a = E(1:end-1);
    b = E(2:end);
    c = abs(a-b);
    [~, indice] = max(c);

    indCB = indice+1;
    indVB = indice;
end