# Emotional arousal enhances narrative memories through functional integration of large-scale brain networks

This repository contains analysis code for our manuscript, *Emotional arousal enhances narrative memories trhough functional integration of large-scale brain networks*. If you have any questions or encounter any bugs/broken links, please email me at jadynpark@uchicago.edu.

The repository follows the data structure outlined below.

```
project/
├── audiovisual/
│   ├── data/
│   │   ├── 1_filmfestival/
│   │   │   └── arousal_ratings
│   │   └── 2_sherlock/
│   │       └── arousal_ratings
│   └── scripts/
│       ├── 1_fmri/
│       ├── 2_behav/
│       └── 3_stats/
└── audio/
    ├── data/
    │   └── pupil/
    └── scripts/
        └── pupil/

```

## System requirements  
1. FSL: Preprocessing of the functional and structural MRI data were performed using FSL/FEAT v.6.00 (FMRIB software library)  
2. MATLAB: For the analysis of brain data, custom MATLAB (R2022b) scripts were used  
3. Python: For the analysis of recall and behavioral data, python (version 3.9) was used  
4. R: For statistical analysis, R (version 4.3.2) was used  

## Data
arousal_ratings: contains model-generated and human arousal ratings   
fmri: raw data for [Film Festival](https://openneuro.org/datasets/ds004042/versions/1.0.1) and [Paranoia](https://openneuro.org/datasets/ds001338/versions/1.0.0) are available on Openneuro. Preprocessed data for [Sherlock](https://dataspace.princeton.edu/handle/88435/dsp01nz8062179) is available on Princeton DataSpace.

## Scripts (audiovisual)
1_fmri: contains scripts for preprocessing fMRI data (1_preprocessing), running graph theoretic analysis (2_bct), and running intersubject correlation analysis (3_isc)  
2_behav: contains script for calculating recall fidelity  
3_stats: contains scripts for running Bayesian mixed effects models  

## Scripts (audio)
pupil: contains scripts for preprocessing pupil data  




