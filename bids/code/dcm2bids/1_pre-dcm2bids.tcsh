#!/bin/tcsh
#  
#Useage: 1_dcm2bids           $1	      
#                        participantID	
#
#
# The purpose of this script is to copy DICOMS from untouchedRaw to bids/sourcedata
# and generate subjects config file (sub_dcm2bids_config.json)
#

###################### set up initial variables  ###########################   
#set input argument 1 to variable 'parID' and make sure it has leading zeros
set parID = "$1"

###################### setup ###########################   
#go to and set path to project directory
cd ../../../
set projDir = "$cwd"

#set path to BIDS directory
set bidsDir = "$projDir/bids"

#set path to untouchRaw/DICOMS directory
set untouchedDICOMS = "$projDir/untouchedRaw/DICOMS"

#set path to sourcedata directory
set sourceDir = "$bidsDir/sourcedata"

#set path to participant dicom sourcedata directory
set parDicom_source = "$sourceDir/sub-${parID}/ses-1/dicom"

#set path to raw_data directory -- this is where files in BIDS format are stored
set rawDir = "$bidsDir/raw_data"

#set path to parID/ses-1 raw_data directory
set parRawDir = "$rawDir/sub-${parID}/ses-1"

#set dcm2bids config files directory
set dcm2bidsDir = "$bidsDir/code/dcm2bids"

#set dcm2bids config files directory
set configDir = "$dcm2bidsDir/config_files"


###################### Organize into sourcedata ######################

#check if participant's dicoms have been moved to sourcedata

if ( -d $parDicom_source) then

	echo "sourcedata dicom directory already exists. delete to re-copy"

else
	# make participant sourcedata directory
	mkdir -p $sourceDir/sub-$parID/ses-1/dicom

	# copy dicoms into sourcedata directory
	cp -r $untouchedDICOMS/mrkt_$parID/. $sourceDir/sub-$parID/ses-1/dicom

endif


###################### Set permission  ###########################
# Set permissions
echo "setting permissions"
chgrp -R -f klk37_collab $sourceDir/sub-${parID} 
chmod -R 775 $sourceDir/sub-${parID}
