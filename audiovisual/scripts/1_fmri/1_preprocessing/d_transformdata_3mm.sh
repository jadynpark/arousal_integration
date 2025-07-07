#!/bin/bash
# Transform data to 3mm so that it's easier to work with

# Subject Numbers
subjNo=("1001" "1002" "1003" "1004")


REF_2MM="../../data/masks/standard/MNI152_T1_2mm_brain.nii.gz"
REF_3MM="../../data/masks/standard/2mmTo3mm.nii"
REF_MAT_2MM_TO_3MM="../../data/masks/standard/2mmTo3mm.mat"

for subjID in "${subjNo[@]}"
	do
    echo Running Subj $subjID
		mkdir "../../data/1_fmri/4_resampled/sub-$subjID"

    for r in 1 2
       do
        	runnum=$(printf "%02d" $r)
            design="movie"
					
            echo run $r

			FUNC_VOL="../../data/1_fmri/3_feat/$design/sub-${subjID}/sub-${subjID}_task-movie_run-${runnum}.feat/filtered_func_data.nii.gz"
			REF_MAT_F2S="../../data/1_fmri/3_feat/$design/sub-${subjID}/sub-${subjID}_task-movie_run-${runnum}.feat/reg/example_func2standard.mat"
							
			REF_MAT_F_TO_3MM="../../data/1_fmri/3_feat/$design/sub-${subjID}/sub-${subjID}_task-movie_run-${runnum}.feat/reg/example_func2standard_3mm.mat"
			VOL_3MM="../../data/1_fmri/4_resampled/sub-$subjID/sub-${subjID}_task-movie_run-${runnum}.nii.gz"

			# Combine movie transforms: convert_xfm -omat AtoC.mat -concat BtoC.mat AtoB.mat
            echo combine movie transforms
			convert_xfm -omat $REF_MAT_F_TO_3MM -concat $REF_MAT_2MM_TO_3MM $REF_MAT_F2S

			# Transform movie filtered_func_data to trans_filtered_func_data_3mm
            echo transform movie filtered func data
			flirt -in $FUNC_VOL -ref $REF_3MM -out $VOL_3MM -init $REF_MAT_F_TO_3MM -applyxfm
    done

done
