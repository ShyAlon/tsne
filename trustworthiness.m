function trustworthiness = trustworthiness(X, XX)
% Trustworthiness tests the dimentionality reduction by checking whether
% the k nearest neighbors in original sample X are still the k nearest
% neighbors in the XX dimantionality reduced set
    [n,d]=knnsearch(X,X,'k',100);
    [nn,dd]=knnsearch(XX,XX,'k',100);
    trustworthiness = 0;
    [m,l] = size(n);
    for i = 1 : m % go over all points
        C = intersect(nn(i, :), n(i, :));
        trustworthiness = trustworthiness + (length(C) -1)/(l-1); % a point is always closest to itself
    end
    trustworthiness = trustworthiness / m;
end
