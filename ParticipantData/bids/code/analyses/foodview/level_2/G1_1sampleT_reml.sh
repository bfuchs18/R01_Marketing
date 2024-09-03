#!/bin/tcsh
#
#useage: G1_1sampleT     	$1             			 $2
#		     		    afniproc folder   		deconvolve folder
#
# The purpose of this script is to create and run 1sample t-tests of all conditions of interest
# $1 - (optional, but required if using $2) the name of the afniproc folder that contains level 1 results (if not specified, "afniproc" will be set)
# $2 - (optional) the name of the deconvolve folder WITHIN the afniproc folder ($2) to retrieve stats files from. If this is not included, stats files will be taken directly from the afniproc folder (do not include full path to folder, just folder name)

###################### set up initial variables  ###########################   
#don't log AFNI programs in ~/.afni.log
setenv AFNI_DONT_LOGFILE YES

#dont try version checks
setenv ANFI_VRSION_CHECK NO

##don't auto-compress output files
setenv AFNI_COMPRESSOR NONE

###################### setup and check directories  ###########################   

# set bids directory
set bidsdir = "/storage/group/klk37/default/R01_Marketing/bids"

#set analysis project dir
set analysis_dir =  $bidsdir/derivatives/analyses/foodview/

#set level1 dir
set lev1_dir =  $analysis_dir/level_1

#set level2 directory
set lev2_dir =  $analysis_dir/level_2

# set test_dir 
set test_dir = $lev2_dir/1sampleT

# set folder names based on args
if ($#argv == 2) then

    #set directories
    set afniproc_folder = $1
    set deconvolve_folder = $2

else if ($#argv == 1) then

    #set directories
    set afniproc_folder = $1
    set deconvolve_folder = "" # set deconvolve_dir as empty string
else
    echo "No args supplied. Stats files will come from default afniproc results folder (level_1/sub-XXX/afniproc/sub-XXX.results/)"
	set afniproc_folder = "afniproc"
    set deconvolve_folder = "" # set deconvolve_dir as empty string
endif

#set output name
set today = `date +%m-%d-%y`

#set map_dir for results
set map_dir = $test_dir/REML_${today}

#create map_dir if it doesnt exist
if ( ! -d $map_dir ) then
    mkdir -p $map_dir
else
	echo "$map_dir already exists. delete or rename to re-run"
#	exit
endif

	
# copy index list and covariate file into output folder for reference
cp $lev2_dir/id_list.txt $map_dir
cp $lev2_dir/covariates.txt $map_dir


# set index list -- lists subjects to include in analyses
set index = `cat $map_dir/id_list.txt`

###################### generate whole group (WG) mask  ########################

if ( ! -f $map_dir/WG_mask0.8+tlrc) then
	
	# make temporary directory with participant masks for subjects included in analyses
	mkdir $map_dir/temp_mask
	foreach sub ( $index )

		# get ID with leading zeros so ID is 3 digits
		set ID_nozero = `echo $sub | sed 's/^0*//'` #remove leading zeros if they were included
		set ID = `printf %03d $ID_nozero` # add leading zeros back

		# copy masks from afniproc
		cp ${lev1_dir}/sub-${ID}/${afniproc_folder}/sub-${ID}.results/full_mask.sub-${ID}+tlrc* $map_dir/temp_mask/
	end

	# generate mask with 80% of participants overlapping
	3dmask_tool -input $map_dir/temp_mask/* \
     				-prefix $map_dir/WG_mask0.8+tlrc              \
      				-frac 0.8

	# remove temporary directory
	rm -r $map_dir/temp_mask
endif

###################### generate t-test scripts  ########################

# gen_group_command.py settings:
	# uncomment -Clustsim and -mask option to run cluster simulations

# note: REML sub-bricks do not contains "_GLT" 
set maps = ( comm_FvT image_FvT )

foreach map ( $maps )
	set output_name = $map

	# generate ttest script -- include covariates
	gen_group_command.py -command 3dttest++                                             \
		-write_script $map_dir/WG_1sampleT++_${output_name}_reml         \
		-prefix  WG_1sampleT++_${output_name}_reml                    \
		-dsets ${lev1_dir}/*/${afniproc_folder}/*results/${deconvolve_folder}/stats.sub-???_REML+tlrc.HEAD       \
	 	-set_labels $map                                                 \
		-dset_sid_list $index 					\
     	-subs_betas "${map}"'#'0_Coef                          \
		-options                                                   \
			-covariates $map_dir/covariates.txt"'[0..4,7]'" \ ## not working because covariates have 3 leading zeros and AFNI IDs do not                                              \
    #        -mask $map_dir/WG_mask0.8+tlrc.HEAD	\
	#		 -Clustsim    

	# generate ttest script --- no covariates or mask
	gen_group_command.py -command 3dttest++                                             \
		-write_script $map_dir/WG_1sampleT++_${output_name}_nocov_reml         \
		-prefix  WG_1sampleT++_${output_name}_nocov_reml                   \
		-dsets ${lev1_dir}/*/${afniproc_folder}/*results/${deconvolve_folder}/stats.sub-???_REML+tlrc.HEAD       \
    	-dset_sid_list $index 					\
	 	-set_labels $map                                                 \
     	-subs_betas "${map}"'#'0_Coef                                    \
#		-options    -Clustsim                                                 \
#            -mask $map_dir/WG_mask0.8+tlrc.HEAD	\

	# set permissions of map folder
    chmod 775 -R $map_dir

	# Execute
    cd $map_dir
    tcsh WG_1sampleT++_${output_name}_reml
	tcsh WG_1sampleT++_${output_name}_nocov_reml

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

