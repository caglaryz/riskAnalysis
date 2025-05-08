%====================================================================
%  saw  —  Simple Additive Weighting (Weighted‑Sum Model)
%--------------------------------------------------------------------
% INPUT  : X      m×n crisp decision matrix
%          w      1×n weight row (Σw = 1)
%          isCost 1×n logical (1=cost, 0=benefit)
% OUTPUT : S      m×1 overall scores       (higher ⇒ better)
% METHOD : 0‑1 linear normalisation then weighted sum.
%====================================================================
function S = saw(X,w,isCost)
    Xn = X;
    for j = 1:size(X,2)
        rng = max(X(:,j))-min(X(:,j));       % denominator
        if isCost(j)
            num = max(X(:,j)) - X(:,j);      % numerator
        else
            num = X(:,j) - min(X(:,j));
        end
        Xn(:,j) = safeDiv(num,rng);
    end
    S = Xn * w';                    % weighted sum
end