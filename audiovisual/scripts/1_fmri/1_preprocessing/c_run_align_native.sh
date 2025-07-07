#!/bin/bash

subjID=("1001" "1002" "1003" "1004")
design_movie="movie"
mkdir 'z_design/'$design_movie
mkdir 'z_design/'$design_recall

for bidsid in "${subjID[@]}"
    do
    feat_dir="../../data/1_fmri/3_feat"
    mkdir $feat_dir/sub-${bidsid}
    
    for r in 1 2    
        do
        	runnum=$(printf "%02d" $r)
            thisFile="../../data/1_fmri/2_aligned/sub-${bidsid}/sub-${bidsid}_task-movie_run-${runnum}_bold.nii.gz"
	      	nvols=$(fslnvols $thisFile)
            
            \cp z_templates/paranoia_template.fsf z_design/sub-${bidsid}_task-movie_run-${runnum}.fsf

			sed -i -e 's/ChangeMyRun/'$r'/' z_design/sub-${bidsid}_task-movie_run-${runnum}.fsf  #Swap "ChangeMyRun" with run number
        	sed -i -e 's/ChangeMySubj/'$bidsid'/' z_design/sub-${bidsid}_task-movie_run-${runnum}.fsf
			sed -i -e 's/ChangeMySubj/'$bidsid'/' z_design/sub-${bidsid}_task-movie_run-${runnum}.fsf
        	sed -i -e 's/ChangeMyVolumes/'$nvols'/' z_design/sub-${bidsid}_task-movie_run-${runnum}.fsf
        	sed -i -e 's/ChangeMyDesign/'$design_movie'/' z_design/sub-${bidsid}_task-movie_run-${runnum}.fsf

            # Remove excess schmutz
            rm z_design/*-e

        	echo Running Subj $bidsid run $r of movie task
        	feat z_design/sub-${bidsid}_task-movie_run-${runnum}.fsf

		done
done
