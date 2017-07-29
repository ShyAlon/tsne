function [map, q1, q3, q5, trust, features, c1, featuremap] = singletsne(new, n, labels)
% cross the numbers' bits
    brr = [0 0];
    while brr(1) == 0 
        [data, features, featuremap] = dataForSeed(new, n);
        [columns,rows] = size(data);
        while columns < 3 % irrelevant
           num = floor(rand * 2^n);
           [data, features, featuremap] = dataForSeed(new, n);
           [columns,rows] = size(data);
        end
        % basic t-sne parameters
        numDims = 2; pcaDims = 50; perplexity = 30; theta = .1 + 6/8; alg = 'svd';
        % Run t-sne
        map = fast_tsne(data, numDims, pcaDims, perplexity, theta, alg);
        brr = size(map);
    end
    [q1, c1] = quality(map, labels, 1);
    [q3, c3] = quality(map, labels, 3);
    [q5, c5] = quality(map, labels, 5);
    % if there is improvement over the best result keep the result.
    trust = trustworthiness(data, map);
end