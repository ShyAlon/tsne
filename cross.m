function cross = cross(parent1, parent2, maxFeatures)
% cross the numbers' bits
    cross = 0;
    for digit = 0:maxFeatures-1
        if digit < maxFeatures/2
            if bitand(parent1, 2^digit) > 0
                cross = cross + 2^digit;
            end
        else
            if bitand(parent2, 2^digit) > 0
                cross = cross + 2^digit;
            end
        end
    end
end