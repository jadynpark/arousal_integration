% Apply threshold to connectivity matrix

% Input:        NxN connectivity matrix for each event
% Output:       NxN connectivity matrix where strongest nth percentile
%               connections are preserved; rest = 0

clc; clear all;

dirs.FC = '../../data/1_fmri/3_FC_events';
dirs.graph = '../../data/1_fmri/4_thresholded';
addpath(genpath('../99_BCT'));

% Load events file
load('../../data/fmri/filmfest_timestamps.mat');

subjects = [1,2,7,8,9,10,11,12,13,14,16,17,18,19,20];                                                    % Subjects with 2 recall runs
nSub = length(subjects);

% specify threshold (0<p<1)
p = 0.15;
threshold = sprintf('%03d', p*100);

for s = 1:nSub
    sub = sprintf('%02d', subjects(s));
    prefix = 'sub-';
    bidsid = [prefix sub];

    fprintf('Running %s \n', bidsid);


    for ev = 1:68

        subj_path = fullfile(dirs.FC, bidsid, sprintf('%s_movie_FC_event_%i.mat', bidsid, ev));
        load(subj_path);

        % make output directory if it doesn't exist
        savepath = fullfile(dirs.graph, 'movie', sprintf('threshold_%s', threshold), bidsid);
        if ~exist(savepath), mkdir(savepath); end

        % load connectivity matrix
        W = ev_corr;
        W_thr = threshold_proportional(W, p);

        save(fullfile(savepath, sprintf('%s_movie_event%i_thr%s', bidsid, ev, threshold)), 'W_thr');

    end

end



