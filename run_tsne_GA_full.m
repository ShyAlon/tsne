%% Define the data source
%% run the experiment 100 times
for experimentCount = 1:10
    % clear('all')
    for trial = 8:8
        % filename = websave('mnist_train.mat', 'https://github.com/awni/cs224n-pa4/blob/master/Simple_tSNE/mnist_train.mat?raw=true');
        %% Financial Ratios
        if trial == 1
            local = '../large_files/financialratios.data.csv';
            name = 'financialratios';
        elseif trial == 2     
        %% Qualitative bankruptcy
            local = '../large_files/Qualitative_Bankruptcy.data.csv';
            name = 'QualitativeBankruptcy';
        elseif trial == 3  
        %% CMC Database
            local = '../large_files/CMC_DataBase.csv';
            tags = '../large_files/CMC_DataBase_labels.csv';
            name = 'CMC';
        elseif trial == 4  
        %% Bitter Database
            local = '../large_files/bitter_dataBase.csv';
            name = 'bitter';
        elseif trial == 5  
        %% Solar Cells Database
            local = '../large_files/solar_cells_DataBase.csv';
            name = 'solar_cells';
        elseif trial == 6  
        %% LogBBB Database
            local = '../large_files/logbbb.csv';
            name = 'LogBBB';
        elseif trial == 7  
        %% FeGaPd Database
            local = '../large_files/FeGaPd_Exp_PP.csv';
            name = 'FeGaPd';
        elseif trial == 8  
        %% FeGaPd Database
            local = '../large_files/joined.csv';
            tags = '../large_files/joined_labels.csv';
            name = 'joined';
        end

        %% Read the data source

        new = csvread(local);
        if trial == 3 || trial == 8
            data = new(:, 1:end);
            fid = fopen(tags,'r');
            labels = textscan(fid, '%q');
            labels = cellstr( labels{1});
            fclose(fid);  
        else
            data = new(:, 1:end-1);
            labels = new(:, end);
        end

        y = unique(labels);
        n = zeros(length(y), 1);
        for iy = 1:length(y)
            % for cells n(iy) = length(find(strcmp(y{iy}, labels)));
            n(iy) = length(find(strcmp(y(iy), labels)));
        end
        
        % zero out according to the experiment)
        for zeroing = 1 : experimentCount
            if experimentCount > zeroing       
                [~, itemp] = max(n);
                n(itemp) = 0;
            end
        end
        [~, itemp] = max(n);
        mode = y(itemp);
        if trial == 3 || trial == 8
            labels = strcmp(labels, mode);
        else
            labels = labels == mode;
        end


        [m,n] = size(data)
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
        iMap = 6;
        iFeatures = 7;
        population = [];
        population_size = 10;
        maps = [];
        features = [];
        populationFeatures = {};

        % Create the seed population
        for sz = 1 : population_size % number of samples
            [map, q, q3, q5,  trust, features, c1, featuremap] = singletsne(new, n, labels);
            population{sz, iSeed} = featuremap;
            population{sz, iQuality} = q;
            population{sz, iQuality3} = q3;
            population{sz, iQuality5} = q5;
            population{sz, iTrust} = trust;
        end
        % Sort the existing population
        population = sortrows(population, -iQuality);
        top_q = 0;
        for generations = 1 : 128
            % create the mutations
            for index = 1 : population_size * 0.2
                population{population_size + 1 - index, iSeed} = permutate(population{sz, iSeed}, n, 5);
            end
            % create the hybrids
            for index = population_size/2 : 2 : 2
                parent1 = population{population_size/2 + 1 - index, iSeed};
                parent2 = population{population_size/2 + 2 - index, iSeed};
                population{index + population_size*0.3, iSeed} = cross(parent1, parent2, n);
                population{index + population_size*0.3 -1, iSeed} = cross(parent2, parent1, n);
            end
            % calculate for the bottom 14
            inter_map = [];
            inter_features = [];
            top_num = 0;
            top_classes = []
            for sz = population_size*0.3 + 1 : population_size % number of samples
                num = population(sz, iSeed);
                [map, q, q3, q5, trust, features, cl, featuremap] = singletsne(new, n, labels);
                population{sz, iSeed} = featuremap;
                population{sz, iQuality} = q;
                population{sz, iQuality3} = q3;
                population{sz, iQuality5} = q5;
                population{sz, iTrust} = trust;
                population{sz, iFeatures} = features;
                if q > top_q
                    inter_map = map;
                    inter_features = features;
                    top_q = q;
                    top_classes = cl;
                end
            end
            % Sort the existing population
            population = sortrows(population, -iQuality);

            legend('off');
            % Genetic algorithm implementation
            % if inter_q > top_q  % there was improvement or overcoming local maximum        
                try
                    top_num = population{1, iSeed};
                    top_q = population{1, iQuality};
                    top_q3 = population{1, iQuality3};
                    top_q5 = population{1, iQuality5};
                    top_trust = population{1, iTrust};
                    top_features = binaryVectorToHex(population{sz, iFeatures});
                    map = inter_map;

                    h = gscatter(inter_map(:,1), inter_map(:,2), labels);
                    % scatter3(inter_map(:,1), inter_map(:,2), inter_map(:,2),3,labels)
                    % view(40,35)
                    csvwrite(sprintf('results/%s_%s_population_%0.3f.csv',name, mode{1}, generations), population);
                    filename = sprintf('results/%s_%s_q_%0.3f_q3_%0.3f_q5_%0.3f_trust_%0.3f_number_%0.0f_features_%0.0f.png',name, mode{1}, top_q, top_q3, top_q5, top_trust, top_num, top_features);
                    title(sprintf('%s %s q %0.3f q3 %0.3f q5 %0.3f trust %0.3f number %0.0f features %0.0f.png',name, mode{1}, top_q, top_q3, top_q5, top_trust, top_num, top_features));
                    saveas(h1, filename);
                    figfilename = sprintf('results/%s_%s_q_%0.3f_q3_%0.3f_q5_%0.3f_trust_%0.3f_number_%0.0f_features_%0.0f.fig',name, mode{1}, top_q, top_q3, top_q5, top_trust, top_num, top_features);
                    savefig(h1,figfilename);
                    csvwrite(sprintf('results/%s_%s_q_%0.3f_q3_%0.3f_q5_%0.3f_trust_%0.3f_number_%0.0f_features_%0.0f.csv',name, mode{1}, top_q, top_q3, top_q5, top_trust, top_num, top_features), map);
                    allKeys = keys(top_classes);
                    csvClasses = []
                    row = 1;
                    for i = 1:size(allKeys, 2)
                        csvClasses(1, row) = i; %allKeys{i};
                        vec = top_classes(allKeys{i})
                        for j = 1: size(vec, 2)    
                            csvClasses(j+1, row) = vec(j);
                        end
                        row = row + 1;
                    end
                    csvwrite(sprintf('results/%s_q_%0.3f_classes.csv',name, top_q), csvClasses);
                catch ME
                    disp('Failed writing the result files');
                end 
            % end
        end   
    end
end
