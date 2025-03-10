% Find hippocampus ISC for each event
clear all; clc;

dirs.timecourse = '../../../data/1_fmri/control_analysis/timecourse';
dirs.out = '../../../data/1_fmri/control_analysis/ISC';
addpath(genpath('../../99_help_scripts'));

subjects = [1:17];
nSub = length(subjects);

% Define atlas
atlas = 'Schaefer2018_Tian2020_216Parcels_7Network';

% Load events file
load('../../../data/fmri/sherlock_allsubs_events.mat');

% Array to save all subject's data
allSub_hip = [];

subjects = [1:17];
nSub = length(subjects);

for s = 1:nSub
    sub = sprintf('%02d', subjects(s));
    prefix = 'sub-';
    bidsid = [prefix sub];
    fprintf('Running %s \n', bidsid);

    % Make output directory if it doesn't exist
    savepath = fullfile(dirs.out, bidsid);
    if ~exist(savepath), mkdir(savepath); end

    % Load subject data
    hip_filename = fullfile(dirs.timecourse, 'Melbourne_Hip', bidsid, ...
        sprintf('%s_movie_hip_ts.mat', bidsid));

    if exist(hip_filename, 'file')

        load(hip_filename);

        hip_bilateral = mean(hip, 1); % 1 x 1976
        hip_bilateral = hip_bilateral'; % 1976 x 1

        % Save all subject's data
        allSub_hip = [allSub_hip hip_bilateral]; % 1976 x 17

    end
end

% Run ISC for each event
for s = 1:nSub
    sub = sprintf('%02d', subjects(s));
    prefix = 'sub-';
    bidsid = [prefix sub];
    fprintf('Running %s \n', bidsid);

    % Create empty array to store ISC for each subject
    ISC = NaN(50,1);

    for i = 1:50

        % Timeseries data for this event
        thisEvent = allSub_hip((movie_events(i,1):movie_events(i,2)), :);

        % This subject's this event timecourse data
        thisSubject = thisEvent(:,s);

        % The remaining subjects' index
        n_minus_one_mask = ~ismember(thisEvent, thisSubject);

        n_minus_one = thisEvent.*n_minus_one_mask;
        n_minus_one_average = mean(n_minus_one, 2, "omitmissing");

        ISC(i, :) = corr(thisSubject, n_minus_one_average);
    end

    % Save ISC for each subject
    save(fullfile(dirs.out, bidsid, sprintf("%s_ISC_hip.mat", bidsid)), "ISC");

end