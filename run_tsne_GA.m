%% Define the data source
clear('all')
for trial = 3:6
    % filename = websave('mnist_train.mat', 'https://github.com/awni/cs224n-pa4/blob/master/Simple_tSNE/mnist_train.mat?raw=true');
    %% Financial Ratios
    if trial == 1
        local = 'D:\DropBox\Dropbox\Avi_and_the_Gang\Shy\large_files\financialratios.data.csv';
        name = 'financialratios';
    elseif trial == 2     
    %% Qualitative bankruptcy
        local = 'D:\DropBox\Dropbox\Avi_and_the_Gang\Shy\large_files\Qualitative_Bankruptcy.data.csv';
        name = 'QualitativeBankruptcy';
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
    t = 6;
    p = 10;
    q = 0;
    old_q = -inf;
    old_t = 0;
    top_seed = 0;
    jumps = 0;
    iSeed = 1;
    iQuality = 2;
    iTrust = 3;
    iQuality3 = 4;
    iQuality5 = 5;
    population = []
    population_size = 20;
    
    % Create the seed population
    for sz = 1 : population_size % number of samples
        num = floor(rand * 2^n);
        [map, q, q3, q5,  trust, features] = singletsne(new, num, n, labels);
        population(sz, iSeed) = num;
        population(sz, iQuality) = q;
        population(sz, iQuality3) = q3;
        population(sz, iQuality5) = q5;
        population(sz, iTrust) = trust;
    end
    % Sort the existing population
    population = sortrows(population, -iQuality);
    top_q = 0;
    for generations = 1 : 128
        % create the mutations
        for index = 1 : population_size * 0.2
            population(population_size + 1 - index, iSeed) = permutate(population(index, iSeed), n, 5);
        end
        % create the hybrids
        for index = population_size/2 : 2 : 2
            parent1 = population(population_size/2 + 1 - index, iSeed);
            parent2 = population(population_size/2 + 2 - index, iSeed);
            population(index + population_size*0.3, iSeed) = cross(parent1, parent2, n);
            population(index + population_size*0.3 -1, iSeed) = cross(parent2, parent1, n);
        end
        % calculate for the bottom 14
        inter_q = 0;
        inter_map = [];
        top_num = 0;
        for sz = population_size*0.3 + 1 : population_size % number of samples
            num = population(sz, iSeed);
            [map, q, q3, q5, trust, features] = singletsne(new, num, n, labels);
            population(sz, iSeed) = num;
            population(sz, iQuality) = q;
            population(sz, iQuality3) = q3;
            population(sz, iQuality5) = q5;
            population(sz, iTrust) = trust;
            if q > inter_q
                inter_q = q;
                inter_map = map;
                top_num = num;
                top_q = q;
                top_q3 = q3;
                top_q5 = q5;
                top_trust = trust;
                top_features = features;
            end
        end
        % Sort the existing population
        population = sortrows(population, -iQuality);
        
        legend('off');
        % Genetic algorithm implementation
        if inter_q > top_q  % there was improvement or overcoming local maximum        
            try
                top_q = inter_q;
                csvwrite(sprintf('results/%s_population_%0.3f.csv',name, generations), population);
                h = gscatter(inter_map(:,1), inter_map(:,2), labels);
                scatter3(inter_map(:,1), inter_map(:,2), inter_map(:,2),3,labels)
                view(40,35)
                csvwrite(sprintf('results/%s_population_%0.3f.csv',name, generations), population);
                filename = sprintf('results/%s_q_%0.3f_q3_%0.3f_q5_%0.3f_trustworthiness_%0.3f_number_%0.0f_features_%0.0f.png',name, top_q, top_q3, top_q5, top_trust, top_num, top_features);
                title(sprintf('%s q %0.3f q3 %0.3f q5 %0.3f trustworthiness %0.3f number %0.0f features %0.0f.png',name,  top_q, top_q3, top_q5, top_trust, top_num, top_features));
                saveas(h1, filename);
                figfilename = sprintf('results/%s_q_%0.3f_q3_%0.3f_q5_%0.3f_trustworthiness_%0.3f_number_%0.0f_features_%0.0f.fig',name, top_q, top_q3, top_q5, top_trust, top_num, top_features);
                savefig(h1,figfilename);
                csvwrite(sprintf('results/%s_q_%0.3f_q3_%0.3f_q5_%0.3f_trustworthiness_%0.3f_number_%0.0f_features_%0.0f.csv',name,  top_q, top_q3, top_q5, top_trust, top_num, top_features), map);
            catch ME
                disp('Failed writing the result files');
            end 
        end
    end   
end