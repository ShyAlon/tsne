function [dataForSeed, features, hexfeatures] = dataForSeed(source, n)
% Permutate changes the feature selection based on the progression
% The options are feature deletion, feature addition and feature
% renumbering
    featuremap = [];
    dataForSeed = [];
    features = 0;
    % select the features based on the seed
    for digit = 1:n
        include = rand > 0.5;
        if include
            dataForSeed = horzcat(dataForSeed, source(:, digit));
            features = features + 1;
        end
        featuremap = [ include featuremap ];
    end
    hexfeatures = featuremap;
end
