#! /bin/bash

# This script (1) performs motion correction,
# (2) concantenates all runs for alignment, 
# (3) splits the concatenated runs into individual runs

subjID=("1001" "1002" "1003" "1004")
task=("task-movie")

# Loop over subjects
for subjNo in "${subjID[@]}"
	do
	echo Running subject $subjNo
	subj_dir="../../1_data/1_fmri/1_raw/sub-${subjNo}"

  # Make directory
    out_dir="../../1_data/1_fmri/2_aligned"
    mkdir $out_dir/sub-${subjNo}

    # Combine Files
	printf "Merge functional sessions to a single file. Check this order of runs !!!\n"
    echo
    echo $subj_dir/func/sub-${subjNo}_task-movie*.nii.gz
    echo
    fslmerge -t $out_dir/sub-${subjNo}/bold_brain.nii.gz $subj_dir/func/sub-${subjNo}_task-movie*.nii.gz


    for i in 1 2;
        do
        # Ensure $i is treated as a number
        runnum=$(printf "%02d" "$i")
        echo "Processing run $runnum"
        mkdir $out_dir/sub-${subjNo}/run-${runnum}
        
        # Brain Extraction
        echo "Extracting brain from bold"
        ls $subj_dir/func/sub-${subjNo}_${task}_run-${runnum}_bold.nii.gz
        bet $subj_dir/func/sub-${subjNo}_${task}_run-${runnum}_bold.nii.gz $out_dir/sub-${subjNo}/run-${runnum}/${task}_run-${runnum}_bold_brain.nii.gz -F -f 0.5 -g 0

        # Motion Correction
        echo "Motion correction"
        mcflirt -in $out_dir/sub-${subjNo}/run-${runnum}/${task}_run-${runnum}_bold_brain -out $out_dir/sub-${subjNo}/run-${runnum}/${task}_run-${runnum}_bold_brain_mc -plots -stats -rmsrel -rmsabs
        fsl_tsplot -i $out_dir/sub-${subjNo}/run-${runnum}/${task}_run-${runnum}_bold_brain_mc.par -t 'MCFLIRT estimated rotations (radians)' -u 1 --start=1 --finish=3 -a x,y,z -w 640 -h 144 -o $out_dir/sub-${subjNo}/run-${runnum}/rot.png
        fsl_tsplot -i $out_dir/sub-${subjNo}/run-${runnum}/${task}_run-${runnum}_bold_brain_mc.par -t 'MCFLIRT estimated translations (mm)' -u 1 --start=4 --finish=6 -a x,y,z -w 640 -h 144 -o $out_dir/sub-${subjNo}/run-${runnum}/trans.png
        fsl_tsplot -i $out_dir/sub-${subjNo}/run-${runnum}/${task}_run-${runnum}_bold_brain_mc_abs.rms -t 'MCFLIRT estimated mean displacement (mm)' -u 1 -w 640 -h 144 -a absolute -o $out_dir/sub-${subjNo}/run-${runnum}/disp.png     
        fsl_tsplot -i $out_dir/sub-${subjNo}/run-${runnum}/${task}_run-${runnum}_bold_brain_mc_rel.rms -t 'MCFLIRT estimated mean displacement (mm)' -u 1 -w 640 -h 144 -a relative -o $out_dir/sub-${subjNo}/run-${runnum}/disp.png
        
    # Split files
    echo "Splitting motion-corrected data into runs..."
    firstvol=0;
    for i in 1 2; do # raw data run prefixes
        runnum=$(printf "%02d" $i)
        epi="sub-${subjNo}_task-movie_run-${runnum}_bold.nii.gz";
        numVols=$(fslnvols $subj_dir/func/$epi);
        echo "Start at $firstvol, add $numVols volumes..."
        fslroi $out_dir/sub-${subjNo}/bold_brain_mc.nii.gz $out_dir/sub-${subjNo}/$epi $firstvol $numVols
        firstvol=$(($firstvol+$numVols));
        echo "Created ${i} runs of motion corrected task-main.nii.gz files..."
    done

    # Clean Files
    echo "Remove unused files"
    rm $out_dir/sub-${subjNo}/${task}_run-${runnum}_bold_brain_mask.nii.gz
    rm $out_dir/sub-${subjNo}/${task}_run-${runnum}_bold_brain_mc_meanvol.nii.gz
    rm $out_dir/sub-${subjNo}/${task}_run-${runnum}_bold_brain_mc_sigma.nii.gz
    rm $out_dir/sub-${subjNo}/${task}_run-${runnum}_bold_brain_mc_variance.nii.gz
    #rm $out_dir/sub-${subjNo}/{task}_run-${runnum}_bold_brain.nii.gz

done
echo "Done!"
