%====================================================================
%  ahp_eig  —  Crisp AHP priority vector via principal‑eigen method
%--------------------------------------------------------------------
% INPUT  : A  —  n×n reciprocal Saaty matrix (λ_max ≥ n)
% OUTPUT : w  —  1×n normalised weight vector  (∑w = 1)
%          CR —  Consistency Ratio   (acceptable if CR < 0.10)
% STEPS  :
%   1. Eigen‑decompose A  →  largest λ_max & eigenvector
%   2. Normalise that eigenvector  →  weights
%   3. Compute Consistency Index  CI = (λ_max–n)/(n–1)
%   4. CR = CI / RI(n)      (RI = random consistency index table)
%====================================================================
function [w, CR] = ahp_eig(A)
    n        = size(A,1);
    [V,D]    = eig(A);                       % 1) eigen‑decompose
    [~,k]    = max(diag(D));                 % principal λ_max
    w        = V(:,k)./sum(V(:,k));          % 2) normalise
    CI       = (real(D(k,k))-n)/(n-1);       % 3) CI
    RI       = [0 0 0.58 0.90 1.12 1.24 1.32 1.41 1.45 1.49];
    CR       = CI / RI(n);                   % 4) CR
end
