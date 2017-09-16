function [quality classes] = quality(X, Y, neighbors)
% Quality tests the dimentionality reduction quality
%
% It takes the results and calculates a score: 
% for each point if the nearest neighbour is of the same label it adds one
% and returns the ratio of those points.
% We take into account only the point we want to cluster
    quality = 0;
    [m,l] = size(X);
    [mY,lY] = size(Y);
    outOf = max(l, neighbors+1); % since we ignore the 1st one
    [n,d]=knnsearch(X,X,'k',outOf);
    total = 0;
    if iscellstr(Y)
        classes = containers.Map('KeyType','char', 'ValueType','any');
        for i = 1 : mY
           if ~isKey(classes,Y{i}) 
               classes(Y{i}) = [0, 0]; % instancess, successes
           end
        end
    else
        classes = containers.Map('KeyType','uint64', 'ValueType','any');
        for i = 1 : mY
            if ~isKey(classes,Y(i)) 
               classes(Y(i)) = [0, 0]; % instancess, successes
            end
        end
    end
    for i = 1 : m 
        if iscellstr(Y)
            vec = classes(Y{i});
            vec(1) = vec(1) + 1;
            if Y{i} == 0 % meaning it's the mode
                total = total + 1;
                close = 0;
                for op = 2 : outOf
                    if strcmp(Y{i},Y{n(i,op)})
                        close = close + 1;
                    end
                end
                if(close >= outOf/2)   
                    quality = quality +1;
                    vec(2) = vec(2) + 1;
                end
            end 
            classes(Y{i}) = vec;
        else
            vec = classes(Y(i));
            vec(1) = vec(1) + 1;
            if Y(i) == 0
                total = total + 1;
                close = 0;
                for op = 2 : outOf
                    if Y(i) == Y(n(i,op))
                        close = close +1;
                    end
                end
                if(close >= outOf/2)   
                    quality = quality +1;
                    vec(2) = vec(2) + 1;
                end 
            end
            classes(Y(i)) = vec;
        end          
    end
    quality = quality / total; % m;
end
