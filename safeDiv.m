function y = safeDiv(num,den)
%SAFE DIVISION   y = num ./ den   ; if den==0 return zeros of num's size
    if isscalar(den)
        if den==0
            y = zeros(size(num));       % constant column → all zeros
        else
            y = num ./ den;
        end
    else                                % element‑wise case
        y = zeros(size(num));
        nz = den~=0;
        y(nz) = num(nz)./den(nz);
    end
end
