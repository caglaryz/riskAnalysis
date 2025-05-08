%====================================================================
%  gra  —  Grey Relational Analysis (Deng’s γ–relation)
%--------------------------------------------------------------------
% INPUT  : X, w, isCost
% OUTPUT : gamma  m×n γ‑matrix
%          grade  m×1 aggregated γ (higher ⇒ better)
% METHOD : 0‑1 normalisation → absolute difference to ref(1) → 
%          Grey coefficient → weighted aggregation.
%====================================================================
function [gamma,grade] = gra(X,w,isCost)
    Xn = X;
    for j=1:size(X,2)
        rng = (max(X(:,j))-min(X(:,j)));
        if isCost(j)
            num = max(X(:,j))-X(:,j);
        else
            num = X(:,j)-min(X(:,j));
        end
        Xn(:,j) = safeDiv(num,rng);
    end
    ref  = ones(1,size(X,2));
    delta= abs(ref - Xn);
    delmin=min(delta(:)); delmax=max(delta(:));
    gamma= (delmin + 0.5*delmax)./(delta + 0.5*delmax);
    grade= gamma*w';
end
