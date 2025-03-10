#!/bin/sh

# Copy data from bids format to local directory
# Also runs brain extraction for anatomical scan

subjID=("1001" "1002" "1003" "1004")

bids_dir="../../data/1_fmri/1_raw"  	 # EDIT THIS TO WHERE YOU SAVED YOUR BIDS FILE
analyses_dir="../../data/1_fmri/1_raw" # EDIT THIS TO WHERE YOU WANT TO SAVE YOUR FMRI FILES (folder must already exist) 

for subjNo in "${subjID[@]}"
	do
	echo Running subject $subjNo

	subj_dir_bids="${bids_dir}/sub-${subjNo}"

	subj_dir_output="${analyses_dir}/sub-${subjNo}"

	# Remove brain
	echo Running BET...
	bet ${subj_dir_bids}/anat/sub-${subjNo}_T1w.nii.gz ${subj_dir_output}/anat/sub-${subjNo}_T1w_brain.nii.gz -f 0.4 -c 92 144 162

done
