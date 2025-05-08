%====================================================================
%  aras  —  Additive Ratio Assessment
%--------------------------------------------------------------------
% INPUT  : X, w, isCost
% OUTPUT : Ki   m×1 utility ratio to ideal (higher ⇒ better)
% METHOD : Invert cost criteria → normalise → weight → additive score →
%          ratio to ideal alternative.
%====================================================================
function Ki = aras(X,w,isCost)
    Xp = X;
    for j=1:size(X,2), if isCost(j), Xp(:,j)=1./Xp(:,j); end, end
    A0 = max(Xp);                           % ideal row
    Xp = [A0; Xp];
    norm = Xp./sum(Xp);
    S = norm .* w;
    S = sum(S,2);
    Ki = S(2:end)/S(1);                     % utility ratio
end
