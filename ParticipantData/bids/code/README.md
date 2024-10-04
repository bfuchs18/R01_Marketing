---
editor_options: 
  markdown: 
    wrap: 72
---

This folder contains code to process and analyze survey, behavioral, and
MRI data for the Resiliency to the Effects of Advertising in Children
(REACH) Study at Penn State (PI: Keller). An overview of the pipeline
can be seen in Figure 1. Additional details about pipeline
implementation can be found in
[../../../docs/reach_data_management_manual.md](docs/reach_data_management_manual.md).

![Figure 1. Overview of data processing and analysis pipeline Project
Reach](../../../docs/images/REACH_processing_steps.png)

Processing scripts:

-   code/beh_into_bids.R: script to process and organize survey and task
    data into [BIDS](https://bids.neuroimaging.io/) using
    [dataREACHr](https://github.com/bfuchs18/dataREACHr)

-   code/dcm2bids/: directory with code to organize MRI data into BIDS
    (<https://bids.neuroimaging.io/>)

-   code/mriqc/: directory with code to run
    [MRIQC](https://mriqc.readthedocs.io/en/latest/) on MRI data

-   code/fmriprep/: contains code to preprocess MRI data with
    [fmriprep](https://fmriprep.org/en/stable/index.html)
