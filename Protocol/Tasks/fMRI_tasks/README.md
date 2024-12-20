Food View (marketing_foodviewing.m) and Stop Signal Tasks (marketing_sst.m) are administered on Windows laptop with Matlab 2021a and Psychtoolbox 3.0.19 during fMRI.

screen_calibration.pdf is used when setting up children inside MRI to make sure they have a full view of the screen.

MPRAGE_baby-animals.pptx is presented to children during the MPRAGE scan, which occurs prior to tasks. 

data_example/ contains sample output for FoodView and SST tasks for 1 subject (ID 999). These files get processed using [dataREACHr](https://github.com/bfuchs18/dataREACHr) functions (called by [beh_into_bids.R](../../../ParticipantData/bids/code/beh_into_bids.R)) to generate BIDS-compliant events.tsv files, see [here](../../../ParticipantData/bids/rawdata/sub-999/ses-1/func).
