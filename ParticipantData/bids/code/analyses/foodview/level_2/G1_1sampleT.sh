#!/bin/tcsh
#
#useage: G1_1sampleT       $1       	$2              $3
#		     		    execute?  	afniproc folder    deconvolve folder
#
# The purpose of this script is to create and run 1sample t-tests of all conditions of interest
# $1 run or no
# $2 - the name of the afniproc folder that contains level 1 results (do not include full path to folder, just folder name)
# $3 - (optional) the name of the deconvolve folder WITHIN the afniproc folder ($2) to retrieve stats files from. If this is not included, stats files will be taken directly from the afniproc folder (do not include full path to folder, just folder name)

###################### set up initial variables  ###########################   
#don't log AFNI programs in ~/.afni.log
setenv AFNI_DONT_LOGFILE YES

#dont try version checks
setenv ANFI_VRSION_CHECK NO

##don't auto-compress output files
setenv AFNI_COMPRESSOR NONE

###################### setup and check directories  ###########################   
#go to and set BIDS main directory
cd ../../../
set bidsdir = "$cwd"

#set analysis project dir
set analysis_dir =  $bidsdir/derivatives/analyses/foodview/

#set level1 dir
set lev1_dir =  $analysis_dir/level_1

#set level2 directory
set lev2_dir =  $analysis_dir/level_2

# set index dir
set lev2_dir = $bidsdir/derivatives/analyses/foodcue-paper1/level2

# set test_dir 
set test_dir = $lev2_dir/1sampleT

# set folder names based on args
if ($#argv == 3) then

    #set directories
    set afniproc_folder = $2
    set deconvolve_folder = $3

else if ($#argv == 2) then

    #set directories
    set afniproc_folder = $2
    set deconvolve_folder = "" # set deconvolve_dir as empty string
else
    echo "Incorrect number of args supplied"
    exit
endif

#set output name
set today = `date +%m-%d-%y`

# set level1 string
set lev1_str = $2

# set lev1 results directory name
set lev1split = ($lev1_str:as/_/ /)
set lev1_results = $lev1split[1]_$lev1split[2]_$lev1split[4]

# get censor str for index file
set censor_str = $lev1split[1]_$lev1split[2]_$lev1split[3]

#set map_dir for results
set map_dir = $test_dir/${lev1_str}_${today}

#create map_dir if it doesnt exist
if ( ! -d $map_dir ) then
    mkdir -p $map_dir
else
	echo "$map_dir already exists. delete or rename to re-run"
	exit
endif


# set index list -- lists subjects to include in analyses
set index = `cat $lev2_dir/index_all_${censor_str}.txt`
	
# copy index list and covariate file into output folder for reference
cp $lev2_dir/index_all_${censor_str}.txt $map_dir
cp $lev2_dir/ttest-covariates.txt $map_dir


###################### generate whole group (WG) mask  ########################
if ( ! -f $map_dir/WG_mask0.8+tlrc) then
	
	# make temporary directory with participant masks for subjects included in analyses
	mkdir $map_dir/temp_mask
	foreach sub ( $index )
		cp ${bidsdir}/derivatives/preprocessed/fmriprep/sub-${sub}/ses-1/func/foodcue_full_mask-${temp}*.nii $map_dir/temp_mask/mask_sub-${sub}.nii
	end

	# generate mask with 80% of participants overlapping
	3dmask_tool -input $map_dir/temp_mask/mask* \
     				-prefix $map_dir/WG_mask0.8+tlrc              \
      				-frac 0.8

	# remove temporary directory
	rm -r $map_dir/temp_mask
endif

###################### generate t-test scripts  ########################

# gen_group_command.py settings:
	# add -Clustsim option to run 3dClustSim


# Note: the following line should?? take stats foldefiles from deconvolve_dir if $3 is provide as input, if not $3 will be blank and files will come from afniproc/results
#		-dsets ${lev1_dir}/*/${afniproc_dir}/*results/${deconvolve_dir}/stats.sub-???+tlrc.HEAD       \

set maps = ( comm_FvT image_FvT )

foreach map ( $maps )
	set output_name = $map

	# generate ttest script
	gen_group_command.py -command 3dttest++                                             \
		-write_script $map_dir/WG_1sampleT++_${output_name}         \
		-prefix  WG_1sampleT++_${output_name}                    \
		-dsets ${lev1_dir}/*/${afniproc_folder}/*results/${deconvolve_folder}/stats.sub-???+tlrc.HEAD       \
    	-dset_sid_list $index 					\
	 	-set_labels $map                                                 \
     	-subs_betas "${map}"'#'0_Coef                                    \
		-options                                                       \
            -mask $map_dir/WG_mask0.8+tlrc.HEAD	\
			-covariates $lev2_dir/ttest-covariates.txt"'[0..3,6]'"

	# set permissions of map folder
    chmod 775 -R $map_dir

	# Execute?
	if ( "$1" == "run" ) then
    	cd $map_dir
    	tcsh WG_1sampleT++_${output_name}_medimp
	endif

end


# Get pediatric template used in fmriprep into results folder 
set tpath = $bidsdir/derivatives/templates
set basedset = $tpath/tpl-MNIPediatricAsym/cohort-3/tpl-MNIPediatricAsym_cohort-3_res-1_T1w.nii.gz
set basedset_name = "tpl-MNIPediatricAsym_cohort-3_res-1_T1w.nii.gz"

if ( ! -f $basedset ) then
    echo "***** Failed to find $basedset :("
    exit 1
else
    if ( ! -f $map_dir/$basedset_name ) then
        cp ${basedset} $map_dir
    endif
endif

