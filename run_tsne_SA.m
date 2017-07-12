%% Define the data source
clear('all')
for trial = 6:6
    % filename = websave('mnist_train.mat', 'https://github.com/awni/cs224n-pa4/blob/master/Simple_tSNE/mnist_train.mat?raw=true');

    %% Financial Ratios
    if trial == 1
        local = 'D:\DropBox\Dropbox\Avi_and_the_Gang\Shy\large_files\financialratios.data.csv';
        name = 'financialratios';
    elseif trial == 2     
    %% Qualitative bankruptcy
        local = 'D:\DropBox\Dropbox\Avi_and_the_Gang\Shy\large_files\Qualitative_Bankruptcy.data.csv';
        name = 'Qualitative_Bankruptcy';
    elseif trial == 3  
    %% CMC Database
        local = 'D:\DropBox\Dropbox\Avi_and_the_Gang\Shy\large_files\CMC_DataBase.csv';
        tags = 'D:\DropBox\Dropbox\Avi_and_the_Gang\Shy\large_files\CMC_DataBase_labels.csv';
        name = 'CMC';
    elseif trial == 4  
    %% Bitter Database
        local = 'D:\DropBox\Dropbox\Avi_and_the_Gang\Shy\large_files\bitter_dataBase.csv';
        name = 'bitter';
    elseif trial == 5  
    %% Solar Cells Database
        local = 'D:\DropBox\Dropbox\Avi_and_the_Gang\Shy\large_files\solar_cells_DataBase.csv';
        name = 'solar_cells';
    elseif trial == 6  
    %% LogBBB Database
        local = 'D:\DropBox\Dropbox\Avi_and_the_Gang\Shy\large_files\logbbb.csv';
        name = 'LogBBB';
    end

    %% Read the data source

    new = csvread(local);
    if trial == 3
        data = new(:, 1:end);
        fid = fopen(tags,'r');
        labels = textscan(fid, '%q');
        labels = cellstr( labels{1});
        fclose(fid);
    else
        data = new(:, 1:end-1);
        labels = new(:, end);
    end
    [m,n] = size(new)
    % labels = labels';

    %% Process the data
    h1 = figure;
    num = floor(rand * 2^n);
    t = 6;
    p = 10;
    q = 0;
    old_q = -inf;
    old_t = 0;
    top_seed = 0;
    jumps = 0;
    
    for sz = 1 : 1024 % number of samples
        % pick sz columns
        data = [];
        features = 0;
        old_num = num;
        % For genetic algorithm the permutate method creates a similar
        % seed.
        num = permutate(old_num, n, 5);
        % select the features based on the seed
        for digit = 1:n
            if bitand(num, 2^digit) > 0
                data = horzcat(data, new(:, digit));
                features = features + 1;
            end
        end
        [columns,rows] = size(data);
        % basic t-sne parameters
        numDims = 2; pcaDims = 50; perplexity = p*5; theta = .1 + t/8; alg = 'svd';
        % Run t-sne
        map = fast_tsne(data, numDims, pcaDims, perplexity, theta, alg);
        [q, c1] = quality(map, labels, 1);
        [nearest3, c3] = quality(map, labels, 3);
        nearest3 = nearest3/3;
        [nearest5, c5] = quality(map, labels, 5);
        nearest5 = nearest5/5;

        % if there is improvement over the best result keep the result.
        trust = trustworthiness(data, map);
        h = gscatter(map(:,1), map(:,2), labels); 
        xlabel('xlabel'),ylabel('ylabel')%(txt(i))

        filename = sprintf('results/%s_%0.3f_3n_%0.3f_6n_%0.3f_trustworthiness_%0.3f_number_%0.0f_features_%0.0f.png',name, q, nearest3, nearest5, trust, num, features);
        title(sprintf('%s %0.3f 3-neighbors %0.3f 6-neighbors %0.3f trustworthiness %0.3f number %0.0f features %0.0f.png',name, q, nearest3, nearest5, trust, num, features));

        legend('off');
        % Genetic algorithm implementation
        if q > old_q  % there was improvement or overcoming local maximum
            top_seed = num;
            saveas(h1, filename);
            csvwrite(sprintf('results/%s_quality_%0.3f_3n_%0.3f_6n_%0.3f_trustworthiness_%0.3f_number_%0.0f_features_%0.0f.csv',name, q, nearest3, nearest5, trust, num, features), map);
        elseif exp(q - old_q) > rand*5
            % num = old_num;
            jumps = jumps+1;
        else
            num = old_num;
        end

        old_q = max(q, old_q);
        old_t = max(t, old_t);
        if old_q == 1
            break
        end
    end
    %% Find the most differentiable classes and their values
    % c1 contains the last map
     val = values(c1) ;
     for i = 1:length(c1)
         final(i+1, :) = val{i};
     end
     csvwrite(sprintf('results/%s.csv', name),map);
     jumps_portion = jumps/sz
end