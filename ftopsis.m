%====================================================================
%  ftopsis  —  Fuzzy TOPSIS (5‑level linguistic TFNs)
%--------------------------------------------------------------------
% INPUT  : X, w, isCost
% OUTPUT : CC     m×1 fuzzy closeness coefficients
% METHOD : See presentation — VL/L/M/H/VH TFN mapping, vertex distance.
%          Gives different magnitudes (and sometimes ranking) vs crisp
%          TOPSIS when criteria are not all mid‑range.
% Steps:
% 1. Normalise crisp X to 0‑1 range per benefit/cost rule.
% 2. Convert each entry to its nearest linguistic TFN.
% 3. Multiply by crisp weight w  →  weighted TFN matrix V(l,m,u).
% 4. FPIS = max‑u per column (benefit)  or min‑l (cost).
%    FNIS = min‑l per column (benefit)  or max‑u (cost).
% 5. Vertex distance to FPIS / FNIS.
% 6. Closeness CC_i = D_FNIS / (D_FPIS + D_FNIS).
%====================================================================
function CC = ftopsis(X,w,isCost)

    [m,n] = size(X);

    Xn = X;
    for j = 1:n
        rng = (max(X(:,j))-min(X(:,j)));
        if isCost(j)
            num = (max(X(:,j))-X(:,j));
        else
            num = (X(:,j)-min(X(:,j)));
        end
        Xn(:,j) = safeDiv(num,rng);
    end

    TFN = [ 0   0    0.25 ;     % VL
            0   0.25 0.5  ;     % L
            0.25 0.5  0.75 ;    % M
            0.5  0.75 1   ;     % H
            0.75 1    1   ];    % VH
    L = zeros(m,n);  M = zeros(m,n);  U = zeros(m,n);
    for i = 1:m
        for j = 1:n
            x = Xn(i,j);
            idx = min(floor(x/0.2)+1,5);   % 1..5
            L(i,j)=TFN(idx,1); M(i,j)=TFN(idx,2); U(i,j)=TFN(idx,3);
        end
    end

    L = L .* w;   M = M .* w;   U = U .* w;

    FPIS_L =  max(L);  FPIS_M =  max(M);  FPIS_U =  max(U);
    FNIS_L =  min(L);  FNIS_M =  min(M);  FNIS_U =  min(U);

    DP = sqrt(sum((L-FPIS_L).^2 + (M-FPIS_M).^2 + (U-FPIS_U).^2,2)/3);
    DN = sqrt(sum((L-FNIS_L).^2 + (M-FNIS_M).^2 + (U-FNIS_U).^2,2)/3);

    CC = DN ./ (DP + DN);
end
