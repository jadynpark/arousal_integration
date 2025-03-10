% Binarize thresholded matrix

% Input:        NxN thresholded matrix where values below threshold==0
% Output:       NxN binarized matrix

clc; clear all;

dirs.thresholded = '../../data/1_fmri/3_thresholded';
dirs.graph = '../../data/1_fmri/4_binarized';
addpath(genpath('../99_BCT'));

% load events file
load('../../data/fmri/sherlock_allsubs_events.mat');

% specify threshold (0<p<1)
p = 0.15;
threshold = sprintf('%03d', p*100);

subjects = [1:17];
nSub = length(subjects);

for s = 1:nSub
    sub = sprintf('%02d', subjects(s));
    prefix = 'sub-';
    bidsid = [prefix sub];

    fprintf('Running %s \n', bidsid);

    for ev = 1:50

        subj_path = fullfile(dirs.thresholded, sprintf('threshold_%s', threshold), ...
            bidsid, sprintf('%s_movie_event%i_thr%s.mat', bidsid, ev, threshold));
        load(subj_path);

        % make output directory if it doesn't exist
        savepath = fullfile(dirs.graph, sprintf('threshold_%s', threshold), bidsid);
        if ~exist(savepath), mkdir(savepath); end

        % load thresholded matrix
        W = W_thr;

        % binarize weights
        W_bin = weight_conversion(W, 'binarize');

        % save graph with binarized weights
        save(fullfile(savepath, sprintf('%s_movie_event%i_thr%s_bin', bidsid, ev, threshold)), 'W_bin');

    end

end
