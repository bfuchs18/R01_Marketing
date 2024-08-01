#!/bin/bash
#usage: ./afni_proc.sh $1 $2
# 
# $1 : sub (int) -- e.g., 1 
# $2 : analysis_dir (string) -- e.g., "/storage/group/klk37/default/R01_Marketing/bids/derivatives/analyses/foodview"	

########## Check args ##########

# check there are 3 arguments
if [ ! $# -eq 2 ]; then
    echo "ERROR: Incorrect number of arguments supplied to deconvolve.sh. Should be 2: sub, anaysis_dir"
	exit
fi

# set sub from arg 1
ID_nozero=$(echo $1 | sed 's/^0*//') #remove leading zeros from arg 1 if they were included -- trying to add leading zeros to numbers with leading zeros can lead to issues (https://stackoverflow.com/questions/8078167/printf-in-bash-09-and-08-are-invalid-numbers-07-and-06-are-fine)
ID=`printf %03d $ID_nozero` # add leading zeros back
subID="sub-$ID" # add sub- prefix

# set analysis_dir from arg 2
if [ ! -d "$2" ]; then # check arg 2 is an existing directory
     echo "ERROR: arg 2 supplied to deconvolve.sh (analysis_dir) does not reflect an existing directory"
     exit
else
	# set analysis_dir
	analysis_dir=$2
    sub_analysis_dir="$analysis_dir/level_1/$subID/"

	# set directories to retrieve files from
	afniproc_dir="$analysis_dir/level_1/$subID/afniproc_censored_trs/$subID.results/"

	# check for existance of afniproc_dir directory
	if [ ! -d "$afniproc_dir" ]; then
    	echo "ERROR: $afniproc_dir does not exist. Check arg 2 (analysis_dir) for accuracy and that afniproc was run for $subID."
    	exit
	fi
fi


########## deconvolve ##########
echo ""
echo "*****************************************************"
echo "************ Starting 3ddeconvolve $subID ***********"
echo "*****************************************************"
echo ""

# specifiy directory with onset files
#onset_dir="$sub_analysis_dir/onsets_uncensored/"

# make outdir if it doesnt exist
outdir=${sub_analysis_dir}/deconvolve

if [ ! -d "$outdir" ]; then
    mkdir -p "$outdir"
fi

# move to output directory
cd $outdir

# run 3ddeconvolve
3dDeconvolve -input $afniproc_dir/pb02.$subID.r*.scale+tlrc.HEAD                                                                                                          \
    -ortvec $afniproc_dir/mot_demean.r01.1D mot_demean_r01                                                                                                               \
    -ortvec $afniproc_dir/mot_demean.r02.1D mot_demean_r02                                                                                                               \
    -ortvec $afniproc_dir/mot_demean.r03.1D mot_demean_r03                                                                                                               \
    -ortvec $afniproc_dir/mot_demean.r04.1D mot_demean_r04                                                                                                               \
    -polort 2 -float                                                                                                                                       \
    -num_stimts 10                                                                                                                                         \
    -stim_times 1 $afniproc_dir/stimuli/${subID}_ad_food_onsets.txt 'BLOCK(30,1)'                                                                                         \
    -stim_label 1 ad_food                                                                                                                                  \
    -stim_times 2 $afniproc_dir/stimuli/${subID}_ad_toy_onsets.txt 'BLOCK(30,1)'                                                                                          \
    -stim_label 2 ad_toy                                                                                                                                   \
    -stim_times 3 $afniproc_dir/stimuli/${subID}_hed_savory_food_cond_onsets.txt                                                                                          \
    'BLOCK(10,1)'                                                                                                                                          \
    -stim_label 3 hed_sav_food                                                                                                                             \
    -stim_times 4 $afniproc_dir/stimuli/${subID}_hed_savory_toy_cond_onsets.txt                                                                                           \
    'BLOCK(10,1)'                                                                                                                                          \
    -stim_label 4 hed_sav_toy                                                                                                                              \
    -stim_times 5 $afniproc_dir/stimuli/${subID}_hed_sweet_food_cond_onsets.txt                                                                                           \
    'BLOCK(10,1)'                                                                                                                                          \
    -stim_label 5 hed_sw_food                                                                                                                              \
    -stim_times 6 $afniproc_dir/stimuli/${subID}_hed_sweet_toy_cond_onsets.txt 'BLOCK(10,1)'                                                                              \
    -stim_label 6 hed_sw_toy                                                                                                                               \
    -stim_times 7 $afniproc_dir/stimuli/${subID}_led_savory_food_cond_onsets.txt                                                                                          \
    'BLOCK(10,1)'                                                                                                                                          \
    -stim_label 7 led_sav_food                                                                                                                             \
    -stim_times 8 $afniproc_dir/stimuli/${subID}_led_savory_toy_cond_onsets.txt                                                                                           \
    'BLOCK(10,1)'                                                                                                                                          \
    -stim_label 8 led_sav_toy                                                                                                                              \
    -stim_times 9 $afniproc_dir/stimuli/${subID}_led_sweet_food_cond_onsets.txt                                                                                           \
    'BLOCK(10,1)'                                                                                                                                          \
    -stim_label 9 led_sw_food                                                                                                                              \
    -stim_times 10 $afniproc_dir/stimuli/${subID}_led_sweet_toy_cond_onsets.txt                                                                                           \
    'BLOCK(10,1)'                                                                                                                                          \
    -stim_label 10 led_sw_toy                                                                                                                              \
    -jobs 10                                                                                                                                               \
    -censor $sub_analysis_dir/${subID}_ses-1_task-foodview_all-runs_censor_fd-0.9.1D                                                                        \                                                                                                                                           \                                                                                                                                                     \
    -gltsym 'SYM: +hed_sav_food +hed_sw_food +led_sav_food +led_sw_food                                                                                    \
    -hed_sav_toy -hed_sw_toy -led_sav_toy -led_sw_toy '                                                                                                    \
    -glt_label 1 image_FvT                                                                                                                                 \
    -gltsym 'SYM: +ad_food -ad_toy '                                                                                                                       \
    -glt_label 2 comm_FvT                                                                                                                                  \
    -fout -tout -x1D X.xmat.1D -xjpeg X.jpg                                                                                                                \
    -errts errts.$subID                                                                                                                                   \
    -bucket stats.$subID


