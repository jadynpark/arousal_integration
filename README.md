# Emotional arousal enhances narrative memories through functional integration of large-scale brain networks

This repository contains analysis code for our manuscript, *Emotional arousal enhances narrative memories trhough functional integration of large-scale brain networks*. If you have any questions or encounter any bugs/broken links, please email me at jadynpark@uchicago.edu.

The repository follows the data structure outlined below.

```
project/
├── filmfestival/
│   ├── data/
│   │   ├── 1_fmri
│   │   ├── 2_behav
│   │   └── 3_llm
│   └── scripts/
│       ├── 1_fmri
│       ├── 2_behav
│       └── 3_stats
├── paranoia/
│   ├── data/
│   │   ├── 1_fmri
│   │   └── 2_pupil
│   └── scripts/
│       └── 1_pupil
└── sherlock/
    ├── data/
    │   ├── 1_fmri
    │   ├── 2_behav
    │   └── 3_llm
    └── scripts/
        ├── 1_fmri
        ├── 2_behav
        └── 3_stats

```

## Data
1_fmri: raw data for Film Festival, Sherlock, and Paranoia are available on Openneuro  
2_llm: model-generated ratings of arousal  
3_behav: human ratings of arousal  

## Scripts (Film Festival, Sherlock)
1_fmri  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1_preprocessing: preprocessing scripts  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2_bct: extracting graph theoretical metrics  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3_isc: for intersubject correlation analysis  
2_behav  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1_memory: for extracting memory metrics  
3_stats  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;stats.Rmd: for running Bayesian mixed effects models

## Scripts (paranoia)
1_pupil  



