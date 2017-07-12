function [map, q1, q3, q5, trust, features, c1] = singletsne(new, num, n, labels)
% cross the numbers' bits
    [data, features] = dataForSeed(num, new, n);
    [columns,rows] = size(data);
    if columns < 3 % irrelevant
       trust = 0;
       q = 0;
       map = [];
    else
        % basic t-sne parameters
        numDims = 2; pcaDims = 50; perplexity = 30; theta = .1 + 6/8; alg = 'svd';
        % Run t-sne
        map = fast_tsne(data, numDims, pcaDims, perplexity, theta, alg);
        brr = size(map);
        if brr(1) > 0 
            [q1, c1] = quality(map, labels, 1);
            [q3, c3] = quality(map, labels, 3);
            [q5, c5] = quality(map, labels, 5);
            % if there is improvement over the best result keep the result.
            trust = trustworthiness(data, map);
        else
           trust = 0;
           q = 0;
        end
    end
end