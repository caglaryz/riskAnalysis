%====================================================================
%  topsis  —  Classical TOPSIS
%--------------------------------------------------------------------
% INPUT  : X, w, isCost      (as in saw)
% OUTPUT : Ci     m×1 closeness coefficients (0…1, higher ⇒ better)
% METHOD : Vector normalisation → weighted matrix → distances to
%          positive / negative ideal solutions (Euclidean).
%====================================================================
function Ci = topsis(X,w,isCost)
    R = X ./ vecnorm(X);                      % step 1 normalisation
    V = R .* w;                               % step 2 weighted
    Aplus  = maxmin(V,isCost,'best');
    Aminus = maxmin(V,isCost,'worst');
    Dp = vecnorm(V - Aplus,2,2);
    Dm = vecnorm(V - Aminus,2,2);
    Ci = Dm ./ (Dp + Dm);                     % closeness
end
function out = maxmin(V,isc,mode)
    out = zeros(1,size(V,2));
    for j = 1:length(isc)
        if mode=="best"
            out(j) = isc(j)*min(V(:,j)) + ~isc(j)*max(V(:,j));
        else
            out(j) = isc(j)*max(V(:,j)) + ~isc(j)*min(V(:,j));
        end
    end
end
