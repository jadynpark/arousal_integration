% Uses Louvain community detection algorithm to find optimal community assignment
% Iterates the algorithm 1000 times

% Consensus: find most common (mode) module configuration
% Calculate PC based on consensus

% Average within network using Yeo atlas

clc; clear all;

dirs.binarized = '../../data/1_fmri/5_binarized';
dirs.pc = '../../data/1_fmri/6_metrics/pc';
addpath(genpath('../99_BCT'));

% Load pre-defined community index (M)
load('../../data/fmri/network_community_index.mat');

% specify threshold (0<p<1)
p = 0.15;
threshold = sprintf('%03d', p*100);

subjects = [1,2,7,8,9,10,11,12,13,14,16,17,18,19,20];
nSub = length(subjects);

% calculate local and global efficiency
for s = 1:nSub
    sub = sprintf('%02d', subjects(s));
    prefix = 'sub-';
    bidsid = [prefix sub];

    fprintf('Running %s \n', bidsid);

    % make output directory if it doesn't exist
    savepath = fullfile(dirs.pc, 'PC_louvain_yeo', sprintf('threshold_%s', threshold), bidsid);
    if ~exist(savepath), mkdir(savepath); end


    % Initialize vector
    P_visual = NaN(68,1);
    P_motor = NaN(68,1);
    P_attention = NaN(68,1);
    P_salience = NaN(68,1);
    P_limbic = NaN(68,1);
    P_control = NaN(68,1);
    P_default = NaN(68,1);
    P_subcortex = NaN(68,1);
    P_average = NaN(68,1);
    Mod_average = NaN(68, 1);

    % For each event:
    for ev = 1:68

        subj_path = fullfile(dirs.binarized, 'movie', sprintf('threshold_%s', threshold), ...
            bidsid, sprintf('%s_movie_event%i_thr%s_bin.mat', bidsid, ev, threshold));

        % Load thresholded graph
        load(subj_path);
        W = W_bin;

        % There is not predefined community; run community detection algorithm N times
        nIter = 1000;

        for i = 1:nIter

            n  = size(W,1);                                                 % number of nodes
            M  = 1:n;                                                       % initial community affiliations
            Q0 = -1; Q1 = 0;                                                % initialize modularity values

            while Q1-Q0>1e-5                                                % while modularity increases
                Q0 = Q1;                                                    % perform community detection
                [modules_list_mat(:,i), ~] = community_louvain(W, 1, M);    % run Louvain, create array after each iteration
                % suppress (~) computing modularity (Q)
            end

            % Code adopted from Ioannis Pappas (ipappas@usc.edu)
            % Find consensus among community partitions
            num_modules = max(modules_list_mat(:, i));                   % find max value in current column
            first_module_appearance = NaN(num_modules, 1);               % initialize array (size: num modules)
            modules_mat = NaN(n, num_modules);                           % initialize array (size: num nodes x num modules)

            for current_module = 1:num_modules
                % Find first occurrence of each module and store in first_module_appearance
                first_module_appearance(current_module) = min(find(modules_list_mat(:,i) == current_module));
                % modules_mat: 1 = node belongs to module; 0 = otherwise
                modules_mat(:, current_module) = (modules_list_mat(:, i) == current_module);
            end

            % Reorder such that col1 = module 1, col2 = module 2, etc
            [~, module_order] = sort(first_module_appearance);
            modules_mat_reordered = modules_mat(:, module_order);

            % Update modules_list_mat with reordered modules
            modules_list_mat(:, i) = sum(modules_mat_reordered.*repmat(1:num_modules, n, 1), 2);

            % Identify unique rows in modules_list_mat, assign to modules_list
            [modules_list, ~, modules_solution] = unique(modules_list_mat(:,:)','rows');

            % Identify most frequently occurring module configuration
            most_common_modules = mode(modules_solution);
            most_common_module_mat(:, 1) = modules_list(most_common_modules,:)';
        end

        % Compute participation coefficient based on the consensus
        ciu = most_common_module_mat;
        P = participation_coef(W, ciu, 0);

        % Average PC across all nodes
        mean_PC = mean(P);

        % Append after each event
        P_average(ev,1) = mean_PC;

        % Compute modularity based on the consensus
        [~,Q] = community_louvain_calcmod_only(W, 1, ciu);

        % Average modularity across all nodes
        mean_mod = mean(Q);

        % Append after each event
        Mod_average(ev,1) = mean_mod;

        % average PC across nodes within network
        P_network = accumarray(network7_ci, P, [], @mean);

        % PC by event
        P_visual(ev,1) = P_network(1);
        P_motor(ev,1) = P_network(2);
        P_attention(ev,1) = P_network(3);
        P_salience(ev,1) = P_network(4);
        P_limbic(ev,1) = P_network(5);
        P_control(ev,1) = P_network(6);
        P_default(ev,1) = P_network(7);
        P_subcortex(ev,1) = P_network(8);

    end

    % Save for each subject
    save(fullfile(savepath, sprintf('%s_movie_thr%s_pc_louvain_yeo', bidsid, threshold)), 'P_visual', 'P_motor', ...
        'P_attention', 'P_control', 'P_default', 'P_subcortex', 'P_salience', 'P_limbic', 'P_average', 'Mod_average');
end





