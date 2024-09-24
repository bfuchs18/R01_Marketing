#!/bin/bash
#usage: ./afni_proc.sh $1 $2 $3
# 
# $1 : sub (int) -- e.g., 1 
# $2 : fmriprep_dir (string) -- e.g., "/storage/group/klk37/default/R01_Marketing/bids/derivatives/preprocessed/fmriprep_v2401"
# $3 : analysis_dir (string) -- e.g., "/storage/group/klk37/default/R01_Marketing/bids/derivatives/analyses/sst"	

########## Check args ##########

# check there are 3 arguments
if [ ! $# -eq 3 ]; then
    echo "ERROR: Incorrect number of arguments supplied to afni_proc.sh. Should be 3: sub, fmriprep_dir, anaysis_dir"
	exit
fi

# set sub from arg 1
ID_nozero=$(echo $1 | sed 's/^0*//') #remove leading zeros from arg 1 if they were included -- trying to add leading zeros to numbers with leading zeros can lead to issues (https://stackoverflow.com/questions/8078167/printf-in-bash-09-and-08-are-invalid-numbers-07-and-06-are-fine)
ID=`printf %03d $ID_nozero` # add leading zeros back
subID="sub-$ID" # add sub- prefix

# set fmriprep_dir from arg 2
if [ ! -d "$2" ]; then # check arg 2 is an existing directory
     echo "ERROR: arg 2 supplied to afni_proc.sh (fmriprep_dir) does not reflect an existing directory"
     exit
else
	# set fmriprep_dir
	fmriprep_dir=$2

	# set directories to retrieve files from
	func_fmriprep_dir="$fmriprep_dir/$subID/ses-1/func/"
	anat_fmriprep_dir="$fmriprep_dir/$subID/ses-1/anat/"

	# check for existance of subject fmriprep directory
	if [ ! -d "$func_fmriprep_dir" ]; then
    	echo "ERROR: $func_fmriprep_dir does not exist. Check arg 2 (fmriprep_dir) for accuracy and that fmriprep was run for $subID."
    	exit
	fi
fi

# set analysis_dir from arg 3
analysis_dir=$3
sub_analysis_dir="$analysis_dir/level_1/$subID/"


########## afniproc ##########
echo ""
echo "*****************************************************"
echo "************ Starting afniproc $subID **************"
echo "*****************************************************"
echo ""

# specifiy directory with onset files
onset_dir="$sub_analysis_dir/onsets_uncensored/"

# make outdir if it doesnt exist
outdir=${sub_analysis_dir}/afniproc

if [ ! -d "$outdir" ]; then
    mkdir -p "$outdir"
fi

# move to output directory
cd $outdir

# run afni_proc.py to create a single subject processing script
afni_proc.py -subj_id $subID                                 \
        -blocks mask blur scale regress                          \
        -radial_correlate_blocks tcat  regress                   \
	-copy_anat $anat_fmriprep_dir/${subID}_ses-1_desc-preproc_T1w.nii.gz                     \
        -dsets                                                                           \
            $func_fmriprep_dir/${subID}*sst*-preproc_bold.nii.gz \
        -blur_size 6.0                                                                   \
        -regress_motion_file                                                             \
            $sub_analysis_dir/${subID}_ses-1_task-sst_all-runs_nuisance-regressors.tsv                 \
        -regress_stim_times                                                              \
            $onset_dir/${subID}_ad_food_onsets.txt             			 				\
			$onset_dir/${subID}_ad_toy_onsets.txt             			 				\
            $onset_dir/${subID}_succ_stop_food_onsets.txt              			 			\
            $onset_dir/${subID}_succ_stop_toy_onsets.txt								\
            $onset_dir/${subID}_fail_stop_food_onsets.txt 								\
            $onset_dir/${subID}_fail_stop_toy_onsets.txt 								\
            $onset_dir/${subID}_succ_go_food_onsets.txt 								\
            $onset_dir/${subID}_succ_go_toy_onsets.txt              			 			\
            $onset_dir/${subID}_go_omis_food_onsets.txt								\
            $onset_dir/${subID}_go_omis_toy_onsets.txt 								\
            $onset_dir/${subID}_incor_go_food_onsets.txt 								\
            $onset_dir/${subID}_incor_go_toy_onsets.txt 								\
        -regress_stim_labels                                                             \
            ad_food ad_toy succ_stop_food succ_stop_toy fail_stop_food fail_stop_toy succ_go_food succ_go_toy go_omis_food go_omis_toy incor_go_food incor_go_toy      \
        -regress_basis_multi 															\
			 'BLOCK(15,1)' 'BLOCK(15,1)' 'BLOCK(1,1)' 'BLOCK(1,1)' 'BLOCK(1,1)' 'BLOCK(1,1)' 'BLOCK(1,1)' 'BLOCK(1,1)' 'BLOCK(1,1)' 'BLOCK(1,1)' 'BLOCK(1,1)' 'BLOCK(1,1)'\
        -regress_motion_per_run                                  \
        -regress_opts_3dD                                        \
            -jobs 10                                              \
            -censor $sub_analysis_dir/${subID}_ses-1_task-foodview_all-runs_censor_fd-0.9.1D    \
            -gltsym 'SYM: +ad_food -ad_toy ' -glt_label 1 comm_FvT           \
            -gltsym 'SYM: +fail_stop_food +fail_stop_toy -succ_go_food -succ_go_toy' -glt_label 2 overall_failstop_succgo           \
            -gltsym 'SYM: +succ_stop_food +succ_stop_toy -succ_go_food -succ_go_toy' -glt_label 3 overall_succstop_succgo           \
            -gltsym 'SYM: +succ_stop_food +succ_stop_toy -fail_stop_food -fail_stop_toy' -glt_label 4 overall_succstop_failstop           \
            -gltsym 'SYM: +fail_stop_toy -succ_go_toy' -glt_label 5 toy_failstop_succgo           \
            -gltsym 'SYM: +succ_stop_toy -succ_go_toy' -glt_label 6 toy_succstop_succgo           \
            -gltsym 'SYM: +succ_stop_toy -fail_stop_toy' -glt_label 7 toy_succstop_failstop           \
            -gltsym 'SYM: +fail_stop_food -succ_go_food' -glt_label 8 food_failstop_succgo           \
            -gltsym 'SYM: +succ_stop_food -succ_go_food' -glt_label 9 food_succstop_succgo           \
            -gltsym 'SYM: +succ_stop_food -fail_stop_food' -glt_label 10 food_succstop_failstop           \
        -regress_compute_fitts                                   \
        -regress_make_ideal_sum sum_ideal.1D                     \
        -regress_est_blur_epits                                  \
        -regress_est_blur_errts                                  \
        -regress_run_clustsim no                                 \
        -html_review_style pythonic                              \
        -execute