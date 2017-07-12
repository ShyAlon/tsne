function permutate = permutate(permutate, maxFeatures, minFeatures)
% Permutate changes the feature selection based on the progression
% The options are feature deletion, feature addition and feature
% renumbering
    delta = 0;
    while delta == 0
        % select a permutation
        action = rand;
        temp = permutate;
        if action < 0.33
           % remove features 
            permutate = remove_features(maxFeatures, minFeatures, permutate);
        elseif action > 0.66
            % add features 
            permutate = add_features(maxFeatures, permutate);
        else
            % replace features 
            permutate = remove_features(maxFeatures, minFeatures, permutate);
            permutate = add_features(maxFeatures, permutate);
        end
        delta = temp - permutate
    end
end

% add up to 3 features
function result = add_features(maxFeatures, permutate)
    for sz = 1 : size(permutate) % number of samples
        permutate(sz) = permutate(sz) || rand > 0.5;
    end 
%     result = permutate;
%     limit = min(maxFeatures, features+3);
%     while features < limit
%         digit = ceil(rand * maxFeatures);
%         if bitand(result, 2^digit) == 0
%             result = result + 2^digit;
%             features = features + 1;
%         end
%     end
end

% remove up to 3 features
function result = remove_features(maxFeatures, minFeatures, permutate)
    for sz = 1 : size(permutate) % number of samples
        permutate(sz) = permutate(sz) && rand > 0.5;
    end 
%     result = permutate;
%     limit = max(minFeatures, features-3);
%     while features > limit
%         digit = ceil(rand * maxFeatures);
%         if bitand(result, 2^digit) > 0
%             result = result - 2^digit;
%             features = features - 1;
%         end
%     end
end
