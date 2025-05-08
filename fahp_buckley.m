%====================================================================
%  fahp_buckley  —  Fuzzy AHP weights using Buckley’s geometric mean
%--------------------------------------------------------------------
% INPUT  : L,M,U  —  three n×n matrices  (lower, modal, upper TFNs)
% OUTPUT : w      —  1×n crisp weight vector (centroid defuzzified)
% STEPS  :
%   1. Geometric mean of each row  →  fuzzy priority GM_i = (l,m,u)
%   2. Fuzzy normalisation against grand totals
%   3. Defuzzify each fuzzy weight by centroid  →  crisp
%   4. Normalise crisp weights  →  final w
%====================================================================
function w = fahp_buckley(L,M,U)
    n   = size(L,1);
    GM  = [geomean(L,2) , geomean(M,2) , geomean(U,2)]; % 1
    St  = sum(GM,1);                                    % grand totals
    Wf  = [GM(:,1)./St(3) , GM(:,2)./St(2) , GM(:,3)./St(1)]; % 2
    w   = mean(Wf,2)';                                  % 3  (centroid)
    w   = w / sum(w);                                   % 4
end
