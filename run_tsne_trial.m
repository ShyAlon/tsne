% filename = websave('mnist_train.mat', 'https://github.com/awni/cs224n-pa4/blob/master/Simple_tSNE/mnist_train.mat?raw=true');
% local = 'D:\DropBox\Dropbox\Avi_and_the_Gang\Shy\large_files\Qualitative_Bankruptcy.data.csv';
clear('all')
% local = 'D:\DropBox\Dropbox\Avi_and_the_Gang\Shy\large_files\financialratios.data.csv';
local = 'D:\DropBox\Dropbox\Avi_and_the_Gang\Shy\large_files\CMC_DataBase.csv';
tags = 'D:\DropBox\Dropbox\Avi_and_the_Gang\Shy\large_files\CMC_DataBase_labels.csv';
% local = 'D:\DropBox\Dropbox\Avi_and_the_Gang\Shy\large_files\solar_cells_DataBase.csv';

% local = 'D:\DropBox\Dropbox\Avi_and_the_Gang\Shy\large_files\bitter_dataBase.csv';
% load(filename);

new = csvread(local);
data = new(:, 1:end-1);
% labels = new(:, end);
[m,n] = size(new)

fid = fopen(tags,'r');
labels = textscan(fid, '%q');
labels = cellstr( labels{1});
% labels = labels';
fclose(fid);

results = [];


% data = new()
% numDims = 2; pcaDims = 50; perplexity = 3; theta = .5; alg = 'svd'; good
% result
h1 = figure;



%% Score the features

% 1. Randomly select features
% 2. Get a score
% 3. Adjust the average score of every feature involved.

%for t = 1:2:5
    %for p = 1:5:15
t = 6;
p = 10;
q = 0;
old_q = 0;
seeds = [];
qualities = []
iterations = 20;
for t = 1: iterations
    data = [];
    features = 0;
    num = ceil(rand * (2^(n+1)-1));
    seeds = [seeds num]
    for digit = 1:n
        if bitand(num, 2^(digit-1)) > 0
            data = horzcat(data, new(:, digit));
            features = features + 1;
        end
    end
    [columns,rows] = size(data);
    % data
    numDims = 2; pcaDims = 50; perplexity = p*5; theta = .1 + t/8; alg = 'svd';
    map = fast_tsne(data, numDims, pcaDims, perplexity, theta, alg);
    q = quality(map, labels)
    for digit = 1:n
        if bitand(num, 2^digit) > 0
            qualities(t, digit) = q;
        else
            qualities(t, digit) = 0;
        end
    end
end

%% 

scores = []
for digit = 1:n
    counter = 1;
    for t = 1: iterations
        if qualities(t, digit) > 0
            if counter == 1
                scores(digit) = qualities(t, digit);
            else
                scores(digit) = qualities(t, digit) / (counter + 1) + scores(digit)*counter/(counter+1);
            end
            counter = counter + 1;
        end
    end
end
threshold = median(scores)
num = 0
for digit = 1:n
    if scores(digit) > threshold
        num = num + 2^(digit-1)
    end
end
data = []
for digit = 1:n
    if bitand(num, 2^(digit-1)) > 0
        data = horzcat(data, new(:, digit));
        features = features + 1;
    end
end
[columns,rows] = size(data);
% data
numDims = 2; pcaDims = 50; perplexity = p*5; theta = .1 + t/8; alg = 'svd';
map = fast_tsne(data, numDims, pcaDims, perplexity, theta, alg);
final_q = quality(map, labels)
