#!/bin/bash
#  
#Useage: gen_sub_fmriprep       $1..$n   
#                           participantID
#
#
#The purpose of this script is to generate fmriprep scripts that can be run
#on the ACI cluster. 
#

###################### set up initial variables  ###########################

#set topdir as current working directory (bids/code/fmriprep)
topdir="$PWD"

###################### LOOP ######################
#below the script loops through participant numbers entered as arguments 
#   "$@" will give the full list of input arguments
for par in ${@}
do
    ###################### set up participant variables  ###########################

    #make participant number have leading zeros (001)
    parID_num=$(printf "%03d" $par)
        
    #set participant script folder name
    par_ScriptDir=$topdir/sub-${parID_num}

    #check to see if participant has script directory and if not, make one
    if [ ! -d $par_ScriptDir ]
    then
	mkdir $par_ScriptDir
    fi
    
    #go to participant script folder
    cd $par_ScriptDir

    #generate participant specific scripts by replacing place-holder 
    #text with participant specific information.
    #loop through all needed scripts.
    
    #list of all script names
    templates=( template_fmriprep.slurm template_fmriprep_synsdc.slurm)
    for template_script in "${templates[@]}"
    do
    
    # remove 'template_' substring
    script="${template_script//template_/}"

	#set script name
	parScript=sub-${parID_num}_$script

	#replace PARNUM with participant ID number in all scripts
	#note: sed stands for stream editor--it takes text input
	#and performs specific operations on lines of input

	#replace PARNUM with participant ID number
	sed "s|PARNUM|${parID_num}|g" $topdir/$template_script > $parScript
	
	#make executable
	chmod 775 $parScript
    done
done
