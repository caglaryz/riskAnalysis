%====================================================================
%  vikor  —  VIKOR Compromise Ranking
%--------------------------------------------------------------------
% INPUT  : X, w, isCost, v (0≤v≤1, default 0.5)
% OUTPUT : Qi   m×1 VIKOR index      (lower ⇒ better)
% METHOD : Compute utility (S) and regret (R); linear compromise with v.
%====================================================================
function Qi = vikor(X,w,isCost,v)
    if nargin<4, v=0.5; end
    fstar = isCost.*min(X) + (~isCost).*max(X);
    fmin  = isCost.*max(X) + (~isCost).*min(X);
    rng = fstar - fmin;             
    frac = safeDiv(fstar - X, rng); 
    S = frac * w';
    R = max(frac .* w , [], 2);
    Sstar=min(S); Smin=max(S); Rstar=min(R); Rmin=max(R);
    Qi = v*(S - Sstar)/(Smin - Sstar) + ...
         (1-v)*(R - Rstar)/(Rmin - Rstar);
end
