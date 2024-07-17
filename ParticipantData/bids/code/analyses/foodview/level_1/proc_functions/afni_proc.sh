#!/bin/bash
#usage: ./afni_proc.sh $1 $2 $3
# 
# $1 : sub (int) -- e.g., 1 
# $2 : fmriprep_dir (string) -- e.g., "/storage/group/klk37/default/R01_Marketing/bids/derivatives/preprocessed/fmriprep_v2320"
# $3 : analysis_dir (string) -- e.g., "/storage/group/klk37/default/R01_Marketing/bids/derivatives/analyses/foodview"	

########## Define directories ##########

# set sub from arg 1
ID_nozero=$(echo $1 | sed 's/^0*//') #remove leading zeros from arg 1 if they were included -- trying to add leading zeros to numbers with leading zeros can lead to issues (https://stackoverflow.com/questions/8078167/printf-in-bash-09-and-08-are-invalid-numbers-07-and-06-are-fine)
ID=`printf %03d $ID_nozero` # add leading zeros back
subID="sub-$ID" # add sub- prefix

# set fmriprep_dirs for arg 2
fmriprep_dir=$2
func_fmriprep_dir="$fmriprep_dir/$subID/ses-1/func/"
anat_fmriprep_dir="$fmriprep_dir/$subID/ses-1/anat/"

# set analysis_dirs from arg 3
analysis_dir=$3
sub_analysis_dir="$analysis_dir/level_1/$subID/"

# set onsetdir
onset_dir="$sub_analysis_dir/onsets_uncensored/"

########## afniproc ##########

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
            $func_fmriprep_dir/${subID}*foodview*-preproc_bold.nii.gz \
        -blur_size 4.0                                                                   \
        -regress_motion_file                                                             \
            $sub_analysis_dir/${subID}_ses-1_task-foodview_all-runs_nuisance-regressors.tsv                 \
        -regress_stim_times                                                              \
            $onset_dir/${subID}_ad_food_onsets.txt             			 				\
			$onset_dir/${subID}_ad_toy_onsets.txt             			 				\
            $onset_dir/${subID}_hed_savory_food_cond_onsets.txt              			 			\
            $onset_dir/${subID}_hed_savory_toy_cond_onsets.txt								\
            $onset_dir/${subID}_hed_sweet_food_cond_onsets.txt 								\
            $onset_dir/${subID}_hed_sweet_toy_cond_onsets.txt 								\
            $onset_dir/${subID}_led_savory_food_cond_onsets.txt              			 			\
            $onset_dir/${subID}_led_savory_toy_cond_onsets.txt								\
            $onset_dir/${subID}_led_sweet_food_cond_onsets.txt 								\
            $onset_dir/${subID}_led_sweet_toy_cond_onsets.txt 								\
        -regress_stim_labels                                                             \
            ad_food ad_toy hed_sav_food hed_sav_toy hed_sw_food hed_sw_toy led_sav_food led_sav_toy led_sw_food led_sw_toy     \
        -regress_basis_multi 															\
			'BLOCK(30,1)' 'BLOCK(30,1)' 'BLOCK(10,1)' 'BLOCK(10,1)' 'BLOCK(10,1)' 'BLOCK(10,1)' 'BLOCK(10,1)' 'BLOCK(10,1)' 'BLOCK(10,1)' 'BLOCK(10,1)' \
        -regress_motion_per_run                                  \
        -regress_opts_3dD                                        \
            -jobs 10                                              \
            -gltsym 'SYM: +hed_sav_food +hed_sw_food +led_sav_food +led_sw_food -hed_sav_toy -hed_sw_toy -led_sav_toy -led_sw_toy ' -glt_label 1 image_FvT           \
            -gltsym 'SYM: +ad_food -ad_toy ' -glt_label 2 comm_FvT           \
        -regress_compute_fitts                                   \
        -regress_make_ideal_sum sum_ideal.1D                     \
        -regress_est_blur_epits                                  \
        -regress_est_blur_errts                                  \
        -regress_run_clustsim no                                 \
        -html_review_style pythonic                              