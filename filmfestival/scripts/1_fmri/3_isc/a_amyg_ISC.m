% Run one-to-average ISC

clear all; clc;

dirs.arr = '../../data/1_fmri/control_analysis/ISC';
dirs.out = '.../../data/1_fmri/control_analysis/ISC';
addpath(genpath('../../99_help_scripts'));

% Load timestamps
load('../../data/1_fmri/filmfest_timestamps.mat');

subjects = [1,2,7,8,9,10,11,12,13,14,16,17,18,19,20];
nSub = length(subjects);

% Load data
load(fullfile(dirs.arr, 'amyg_timeseries_allEvents_allSub.mat'));

% Loop over subjects
for s = 1:nSub
    sub = sprintf('%02d', subjects(s));
    prefix = 'sub-';
    bidsid = [prefix sub];

    fprintf('Running %s \n', bidsid);

    % Create empty array to store ISC for each subject
    ISC = NaN(68,1);

    % Calculate one-to-average ISC for each event
    for event = 1:length(allEventsArray)

        % Timeseries data for this event
        thisEvent = allEventsArray{event};

        % This subject's this event timecourse data
        thisSubject = thisEvent(:,s);

        % The remaining subjects' index
        n_minus_one_mask = ~ismember(thisEvent, thisSubject);

        n_minus_one = thisEvent.*n_minus_one_mask;
        n_minus_one_average = mean(n_minus_one, 2, "omitmissing");

        ISC(event, :) = corr(thisSubject, n_minus_one_average);

    end

    outputDir = fullfile(dirs.out, bidsid);
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end

    % Save ISC for each subject
    save(fullfile(dirs.out, bidsid, sprintf("%s_ISC_amyg.mat", bidsid)), "ISC");
end






