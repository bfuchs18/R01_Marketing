#!/bin/bash
#usage: ./afni_blur_scale.sh $1 $2 $3
# 
# $1 : sub (int) -- e.g., 1 
# $2 : fmriprep_dir (string) -- e.g., "/storage/group/klk37/default/R01_Marketing/bids/derivatives/preprocessed/fmriprep_v2320"
# $3 : analysis_dir (string) -- e.g., "/storage/group/klk37/default/R01_Marketing/bids/derivatives/analyses/foodview"	
#		    
#
### This script will smooth and scale preprocessed fmridata (fmriprep output) for a given sub and place the output in analysis_dir/level_1/sub-$sub/ ###
### AFNI code was derived from https://andysbrainbook.readthedocs.io/en/latest/OpenScience/OS/fMRIPrep_Demo_4_AdditionalPreproc.html
 
###################### set up and check arguments  ###########################

# check there are 3 arguments
if [ ! $# -eq 3 ]
  then
    echo "ERROR: Incorrect number of arguments supplied to afni_blue_scale.sh. Should be 3: sub, fmriprep_dir, anaysis_dir"
	exit
fi

# set sub from arg 1
ID_nozero=$(echo $1 | sed 's/^0*//') #remove leading zeros from arg 1 if they were included -- trying to add leading zeros to numbers with leading zeros can lead to issues (https://stackoverflow.com/questions/8078167/printf-in-bash-09-and-08-are-invalid-numbers-07-and-06-are-fine)
ID=`printf %03d $ID_nozero` # add leading zeros back
subID="sub-$ID" # add sub- prefix

# set fmriprep_dir from arg 2
if [ ! -d "$2" ]; then # check arg 2 is an existing directory
     echo "ERROR: arg 2 supplied to afni_blue_scale.sh (fmriprep_dir) does not reflect an existing directory"
     exit
else
	# set fmriprep_dir
	fmriprep_dir=$2

	# set subject fmriprep dir to retrieve files from
	sub_fmriprep_dir="$fmriprep_dir/$subID/ses-1/func/"

	# check for existance of subject fmriprep directory
	if [ ! -d "$sub_fmriprep_dir" ]; then
    	echo "ERROR: $sub_fmriprep_dir does not exist. Check arg 2 (fmriprep_dir) for accuracy and that fmriprep was run for $subID."
    	exit
	fi
fi

# set analysis_dir from arg 3
analysis_dir=$3
sub_analysis_dir="$analysis_dir/level_1/$subID/"

###################### AFNI: smoothing and scaling  ###########################

# get list of preprocessed files and extract basenames with everything from sub-XXX...to _desc 
cd $sub_fmriprep_dir
files=`find *foodview_run*desc-preproc*.nii.gz -type f -exec basename "{}" \; | sed 's/-[^-]*$//' | sort -u`

# set blur size
blursize="6"

# smooth and scale each file
for basename in $files; do

	if [ -f "$sub_analysis_dir/${basename}-blur${blursize}.nii" ]
	then
		echo "$sub_analysis_dir/${basename}-blur${blursize}.nii exists. skipping smoothing"
	else
		# apply smoothing to *preproc_bold.nii.gz
		3dmerge -1blur_fwhm $blursize -doall -prefix $sub_analysis_dir/${basename}-blur${blursize}.nii \
		$sub_fmriprep_dir/${basename}-preproc_bold.nii.gz
	fi

	if [ -f "$sub_analysis_dir/${basename}-blur${blursize}-scale.nii" ] 
	then
		echo "$sub_analysis_dir/${basename}-blur${blursize}-scale.nii exists. skipping scaling"
	else

		# apply scaling to blur*.nii to ensure that the mean BOLD signal across the run is 100

		# compute mean of each voxel timeseries in blurred data
		3dTstat -prefix $sub_analysis_dir/rm.mean_${basename}.nii $sub_analysis_dir/${basename}-blur${blursize}.nii

		# apply scaling to blur*.nii to ensure that the mean BOLD signal across the run is 100 (use mask from fmriprep)
		3dcalc -a $sub_analysis_dir/${basename}-blur${blursize}.nii -b $sub_analysis_dir/rm.mean_${basename}.nii \
			-c $sub_fmriprep_dir/${basename}-brain_mask.nii.gz \
			-expr 'c * min(200, a/b*100)*step(a)*step(b)' \
			-prefix $sub_analysis_dir/${basename}-blur${blursize}-scale.nii
	fi
done

rm rm*
