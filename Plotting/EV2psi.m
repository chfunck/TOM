function psi2 = EV2psi(EV, NOrb, NMod)
    % psi2 = EV2psi(EV , NOrb, NMod)
    % compute psi^2 from eigenvector from OMEN, for NMod modes
    % EV: collumns: mode1,realpart || mode2,immag.part || mode2,realpart...

    [N,~] = size(EV);
    NAtom = N/NOrb;

    psi2 = zeros(NAtom,NMod);
    complEV = zeros(N, NMod);

    for k = 1:NMod
        complEV(:,k)=EV(:,2*k-1)+1i*EV(:,2*k);
        psi2(:,k) = sum( reshape( abs( complEV(:,k) ).^2, NOrb, NAtom))';
    end    
end