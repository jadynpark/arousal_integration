% Binarize thresholded matrix

% Input:        NxN thresholded matrix where values below threshold==0
% Output:       NxN binarized matrix

clc; clear all;

dirs.thresholded = '../../data/1_fmri/4_thresholded';
dirs.graph = '../../data/1_fmri/5_binarized';
addpath(genpath('../99_BCT'));

% Specify threshold (0<p<1)
p = 0.15;
threshold = sprintf('%03d', p*100);

subjects = [1,2,7,8,9,10,11,12,13,14,16,17,18,19,20];
nSub = length(subjects);

for s = 1:nSub
    sub = sprintf('%02d', subjects(s));
    prefix = 'sub-';
    bidsid = [prefix sub];

    fprintf('Running %s \n', bidsid);


    for ev = 1:68

        subj_path = fullfile(dirs.thresholded, 'movie', sprintf('threshold_%s', threshold), ...
            bidsid, sprintf('%s_movie_event%i_thr%s.mat', bidsid, ev, threshold));
        load(subj_path);

        % Make output directory if it doesn't exist
        savepath = fullfile(dirs.graph, 'movie', sprintf('threshold_%s', threshold), bidsid);
        if ~exist(savepath), mkdir(savepath); end

        % Load thresholded matrix
        W = W_thr;

        % Binarize weights
        W_bin = weight_conversion(W, 'binarize');

        % Save graph with binarized weights
        save(fullfile(savepath, sprintf('%s_movie_event%i_thr%s_bin', bidsid, ev, threshold)), 'W_bin');

    end

end
