#!/bin/tcsh
#  
#Useage: 2_dcm2bids           $1	      
#                        participantID with leading zeros	
#
#
# The purpose of this script is convert .dcm files to BIDS format using dcm2bids 
# This script was written to be used in the Food Marketing R01. 
# Written by Bari Fuchs Fall 2022.
#
# NOTE: prior to running this script for each participant, determine whether any extra scans exist in sourcedata/
# (e.g., extra MPRAGE or functional scans) that should not be organized into BIDS and processed via fmriprep.
# To prevent conversion of extra scans to BIDS format, cd to source/$parID and append "_extra" to the ser directory of extra scans.
# For example, if scan 17 was an extra MPRAGE >> mv ser17 ser17_extra

###################### set up initial variables  ###########################   
#set input argument 1 to variable 'parID'
set parID = "$1"

###################### setup ###########################   
#go to and set path to project directory
cd ../../../
set projDir = "$cwd"

#set path to BIDS directory
set bidsDir = "$projDir/bids"

#set path to untouchRaw/DICOMS directory
#set untouchedDICOMS = "$projDir/untouchedRaw/DICOMS"

#set path to sourcedata directory
set sourceDir = "$bidsDir/sourcedata"

#set path to participant dicom sourcedata directory
set parDicom_source = "$sourceDir/sub-${parID}/ses-1/dicom"

#set path to raw_data directory -- this is where files in BIDS format are stored
set rawDir = "$bidsDir/rawdata"

#set path to parID raw_data directory
set parRawDir = "$rawDir/sub-${parID}"

#set path to temporary source data
set parDir_source_temp = "$sourceDir/sub-$parID/ses-1/${parID}_temp"

#set dcm2bids config files directory
set dcm2bidsDir = "$bidsDir/code/dcm2bids"

#set dcm2bids config files directory
set configDir = "$dcm2bidsDir/config_files"

#set path to file with fieldmap seriesdescription names
set fmap_descriptions_file = "$dcm2bidsDir/fmap_descriptions.csv"

###################### Determine fieldmap descriptions ###########################

# script will exit if subject does not have fieldmap description in fmap_descriptions_file

# Use awk to check if the subject exists in fmap_descriptions_file (subject column 1) -- if yes, set sub_exists == "1"
set sub_exists = `awk -F ',' -v value="$parID" '$1 == value {print "1"; exit}' $fmap_descriptions_file`

if ( $sub_exists == "1" ) then # if subject exists in fmap_descriptions_file

	# set fmap SeriesDescriptions for parID from $fmap_descriptions_file
	set fv_fmap_desc = `awk -F',' '$1 == "'$parID'" {print $2}' $fmap_descriptions_file`
	set sst_fmap_desc = `awk -F',' '$1 == "'$parID'" {print $3}' $fmap_descriptions_file`

else
	echo "Subject $parID is not in fmap_descriptions.csv. add fieldmap SeriesDescriptions for subject and re-run"
	exit
endif 


###################### Generate subject config file  ###########################

# check for subject config file
if ( -f $configDir/sub-${parID}_dcm2bids_config.json ) then # if exists
	echo "Config file exists for $parID"
else # if does not exist
	# make copy of template config file for parID
	cp $configDir/template_dcm2bids_config.json $configDir/sub-${parID}_dcm2bids_config.json
	set sub_config_file = $configDir/sub-${parID}_dcm2bids_config.json
	
	# update SeriesDescription for fieldmaps in configuration file 
	# this code uses jq to modify the json. map() iterates over each element of "descriptions" and FIELDMAP_NAME_FV or FIELDMAP_NAME_SST will be replaced with variable set to fmap_desc
	/storage/group/klk37/default/sw/jq/jq-linux64 --arg fmap_desc "$fv_fmap_desc" '.descriptions |= map(if .criteria.SeriesDescription == "FIELDMAP_NAME_FV" then .criteria.SeriesDescription |= $fmap_desc else . end)' "$sub_config_file" > temp.json && mv temp.json "$sub_config_file"
	/storage/group/klk37/default/sw/jq/jq-linux64 --arg fmap_desc "$sst_fmap_desc" '.descriptions |= map(if .criteria.SeriesDescription == "FIELDMAP_NAME_SST" then .criteria.SeriesDescription |= $fmap_desc else . end)' "$sub_config_file" > temp.json && mv temp.json "$sub_config_file"
endif


###################### Check for directories ######################


# set anatomical files in bids
# note: if there are no files, there will be a "ls: No match." message -- figure out way to suppress?
set bids_anat_files = `ls $parRawDir/ses-1/anat/*`

# check if the bids_anat_files is non-empty, indicating that files exist and dcm2bids has been run
if ( "$bids_anat_files" != "" ) then

	#exit if anatomical files organized into bids
	echo "dcm-to-bids conversion has been run for participant $parID"
    	echo "Delete .nii.gz and corresponding json files in $parRawDir/func/ /anat and /fmap to rerun dcm2bids"
	set run_dcm2bids = 0

#check if dicom sourcedata directory exists for participant
else
	#continue with script if dicom sourcedata directory exists
	if ( -d "$parDicom_source" ) then
		set run_dcm2bids = 1
	#exit script if dicom sourcedata directory does not exist
	else
		echo "participant dicom sourcedata directory does not exist for $parID"
		echo "create $parDicom_source and copy untouchedRaw DICOMS into it:"
		echo ">> mkdir -p /gpfs/group/klk37/default/R01_Food_Brain_Study/BIDS/sourcedata/sub-$parID/ses-1/dicom"
		echo ">> cd /gpfs/group/klk37/default/R01_Food_Brain_Study/BIDS/sourcedata/sub-$parID/ses-1/dicom"
		echo ">> cp -a /gpfs/group/klk37/default/R01_Food_Brain_Study/untouchedRaw/DICOMS/R01_$parID/. ."
		exit
	endif
endif

#check if temporary dirs exists, delete if it exists
# Note: tmp_dcm2bids/ is created by dcm2bids_helper; dcm2bids_helper will not run if tmp_dcm2bids/helper already exisits
if ( -d "$parRawDir/tmp_dcm2bids" ) then
    echo "deleting tmp_dcm2bids"
    rm -r $parRawDir/tmp_dcm2bids
endif

if ( -d "$parDir_source_temp" ) then
    echo "deleting temp source dir"
    rm -r $parDir_source_temp
endif

###################### Organize into BIDS  ###########################

if ($run_dcm2bids == 1) then
	echo "Starting dcm to bids conversion for participant $parID"	

	# copy source data into $parDir_source_temp
	# NOTE: This step is to prevent dcm2bids conversion for extra scans that will remain unprocessed for R01 data analyses
	# "extra" should be manually appended to ser* directories in $parDir_source for repeated and unwanted scans prior to running this script

	cp -r $parDicom_source $parDir_source_temp
	
	# Remove ser directories with the suffix "extra"
	cd $parDir_source_temp
	set extra_scan_count = `ls -d *extra/ | wc -l`

	if ($extra_scan_count > 0) then
    		echo "removing $extra_scan_count extra scans from temporary directory"
	    	rm -r $parDir_source_temp/ser*extra
	else
    		echo "No extra scans found"
	endif
	
	#Run dcm2bids_helper and dcm2bids
	# Note: dcm2bids_helper will convert DICOMS in $parDir_source_temp to NIFTI and place them in the temporary directory $parRawDir/tmp_dcm2bids/helper
	# Note: /ser* directories removed from $parDir_source_temp in the previous step will not be placed in $parRawDir/tmp_dcm2bids/helper
	# Note: dcm2bids will reorganize scans in dcm2bids_helper into BIDS format in $topdir/$parID
	
	if (! -d "$parRawDir/ses-1/" ) then
		mkdir -p $parRawDir/ses-1
	endif

	# navigate to where we want to run the helper function from -- tmp_dcm2bids will be placed in this folder 
	cd $parRawDir
	
	#run dcm2bids_helper
	echo "running dcm2bids_helper"
	dcm2bids_helper -d $parDir_source_temp

	# run dcm2bids: -s 1 indicates ses-1
	echo "running dcm2bids"
	dcm2bids -d $parDir_source_temp -p $parID -s 1 -c $bidsDir/code/dcm2bids/config_files/sub-${parID}_dcm2bids_config.json
		
	#reorganize
	cp -a sub-$parID/. .
	rm -r sub-$parID/
	
	#copy log file into code/dcm2bids/bids_convert_logs
	cp $parRawDir/tmp_dcm2bids/log/sub-${parID}*log $bidsDir/code/dcm2bids/bids_convert_logs

	# Remove temporary directories
	rm -r $parRawDir/tmp_dcm2bids
	rm -r $parDir_source_temp
		
	##### run pydeface ####
	echo "Calling pydeface"
        
	cd $parRawDir/ses-1/anat	
	
    pydeface *T1w.nii.gz # call pydeface
    rm *T1w.nii.gz # remove un-defaced mprage from raw_data

    # remove _defaced from filename
	foreach file (*deface*.nii.gz)
		set new_name = `echo "$file" | sed 's/_defaced//'`
		mv "$file" "$new_name"
	end
endif

###################### Add IntendedFor field ######################

# check if both strings are NOT empty ("")
if ( "$fv_fmap_desc" != "" && "$sst_fmap_desc" != "") then

	foreach task ("foodview" "sst")

		# Get array of fieldmap json files to modify
		set fieldmap_jsons=`ls $parRawDir/ses-1/fmap/*${task}*json`

		# Get array of functional scans to apply field map to
		set func_array_fullpath=`ls $parRawDir/ses-1/func/*$task*nii.gz`

		# Loop through each item in func_array_fullpath to remove first 65 characters (path prior to ses-1)
		set func_array=()
		foreach item ($func_array_fullpath)

			# Remove $parRawDir from $item and remove the leading /
			set modified_item = `echo $item | sed "s#$parRawDir##" | sed 's|^/||'`

			# Add the modified item to the new array
			set func_array=($func_array $modified_item)
		end

		# Loop through fieldmap jsons
		foreach json ($fieldmap_jsons)

				# check if json already has "IndendedFor" key (-e gets exit status: 1 if false, 0 if true)
				/storage/group/klk37/default/sw/jq/jq-linux64 -e 'has("IntendedFor")' $json > /dev/null

				# if does not have "Indended for key (exit status = 1)
				if ($? != 0) then
						echo "adding IndendedFor key to $json"
						# Loop through functional scans
						foreach func ($func_array)
								echo $func
								# add functional scan to "IntendedFor"
								cat $json | /storage/group/klk37/default/sw/jq/jq-linux64 --arg v "$func" '.IntendedFor += [$v]' > temp.json
								mv temp.json $json
						end
				# if does have "Indended for key (exit status != 1)
				else
						echo "$json already has IntendedFor key"
				endif
		end
	end

# else if one string is empty and the other is not (i.e., 1 fieldmap was collected)
else if ( ( "$fv_fmap_desc" == "" && "$sst_fmap_desc" != "") || ( "$sst_fmap_desc" == "" && "$fv_fmap_desc" != "") ) then

	# Get array of fieldmap json files to modify
	set fieldmap_jsons=`ls $parRawDir/ses-1/fmap/*json`

	# Get array of functional scans to apply field map to
	set func_array_fullpath=`ls $parRawDir/ses-1/func/*nii.gz`

	# Loop through each item in func_array_fullpath to remove first 65 characters (path prior to ses-1)
	set func_array=()
	foreach item ($func_array_fullpath)

		# Remove $parRawDir from $item and remove the leading /
		set modified_item = `echo $item | sed "s#$parRawDir##" | sed 's|^/||'`

		# Add the modified item to the new array
		set func_array=($func_array $modified_item)
	end

	# Loop through fieldmap jsons
	foreach json ($fieldmap_jsons)

			# check if json already has "IndendedFor" key (-e gets exit status: 1 if false, 0 if true)
			/storage/group/klk37/default/sw/jq/jq-linux64 -e 'has("IntendedFor")' $json > /dev/null

			# if does not have "Indended for key (exit status = 1)
			if ($? != 0) then
					echo "adding IntendedFor key to $json"
					# Loop through functional scans
					foreach func ($func_array)
							# add functional scan to "IntendedFor"
							cat $json | /storage/group/klk37/default/sw/jq/jq-linux64 --arg v "$func" '.IntendedFor += [$v]' > temp.json
							mv temp.json $json
					end
			# if does have "Indended for key (exit status != 1)
			else
					echo "$json already has IntendedFor key"
			endif
	end

endif

###################### Add TaskName field ######################

# Get array of func json files to modify
set func_jsons=`ls $parRawDir/ses-1/func/*json`

# Loop through fieldmap jsons
foreach json ($func_jsons)

    # check if json already has "TaskName" key
	/storage/group/klk37/default/sw/jq/jq-linux64 -e 'has("TaskName")' $json > /dev/null

    # if does not have "TaskName" key (exit status = 1)
    if ($? != 0) then
			echo "adding TaskName key to $json"
			if ( "$json" =~ *foodview* ) then
					cat $json | /storage/group/klk37/default/sw/jq/jq-linux64 --arg v "foodview" '.TaskName += $v' > temp.json
					mv temp.json $json
			else if ( "$json" =~ *sst* ) then
					cat $json | /storage/group/klk37/default/sw/jq/jq-linux64 --arg v "sst" '.TaskName += $v' > temp.json
					mv temp.json $json
			endif
	else
            echo "$json already has TaskName key"
	endif
end

###################### Set permission  ###########################
# Set permissions
chgrp -R -f klk37_collab $parRawDir 
chmod -R 775 $parRawDir
