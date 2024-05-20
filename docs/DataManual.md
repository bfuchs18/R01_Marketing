# Data Manual - REACH Study

- [Data Manual - REACH Study](#data-manual---reach-study)
- [Github security token transfer for all data](#github-security-token-transfer-for-all-data)
- [Introduction](#introduction)
  - [Overview of Study](#overview-of-study)
  - [Inclusion/Exclusion Criteria](#inclusionexclusion-criteria)
- [Study Design](#study-design)
  - [Baseline (ses-1)](#baseline-ses-1)
    - [Visit 1](#visit-1)
    - [Visit 2](#visit-2)
    - [Visit 3](#visit-3)
    - [Visit 4](#visit-4)
  - [Follow-up (ses-2)](#follow-up-ses-2)
    - [Visit 5](#visit-5)
- [Outcome Measures: Descriptions and Protocols](#outcome-measures-descriptions-and-protocols)
  - [Laboratory Eating Paradigms](#laboratory-eating-paradigms)
    - [Test Meal](#test-meal)
    - [Eating in the Absence of Hunger](#eating-in-the-absence-of-hunger)
      - [EAH wanting questionnaire](#eah-wanting-questionnaire)
  - [Fullness](#fullness)
  - [Anthropometrics](#anthropometrics)
    - [Height and Weight](#height-and-weight)
    - [Dual-Energy X-Ray Absorptiometry (DXA)](#dual-energy-x-ray-absorptiometry-dxa)
  - [Actigraphy](#actigraphy)
  - [Behavioral tasks](#behavioral-tasks)
    - [Reward-Related Decision-Making (Space Game)](#reward-related-decision-making-space-game)
    - [Relative Reinforcing Value Task (RRV)](#relative-reinforcing-value-task-rrv)
    - [Pavlovian-to-Instrumental Transfer Task (PIT)](#pavlovian-to-instrumental-transfer-task-pit)
  - [MRI protocol](#mri-protocol)
    - [Mock-Scan Protocol](#mock-scan-protocol)
    - [State Anxiety Ratings (CAMS)](#state-anxiety-ratings-cams)
    - [Structural scan](#structural-scan)
    - [Functional scans - Food View Task](#functional-scans---food-view-task)
    - [Functional Scans - Stop Signal Task ("Plate Sorting Game")](#functional-scans---stop-signal-task-plate-sorting-game)
    - [Field maps](#field-maps)
    - [Post-scan fMRI behavioral assessment](#post-scan-fmri-behavioral-assessment)
  - [NIH toolbox](#nih-toolbox)
  - [WASI](#wasi)
  - [Child-Reported Questionnaires](#child-reported-questionnaires)
    - [Kid's Brand Awareness Survey (KBAS)](#kids-brand-awareness-survey-kbas)
    - [Child Screen Time Questionnaire (STQ)](#child-screen-time-questionnaire-stq)
    - [Loss of Control Eating Questionnaire (LOC)](#loss-of-control-eating-questionnaire-loc)
    - [Pictorial Personality Trains Questionnaire (PPTQ)](#pictorial-personality-trains-questionnaire-pptq)
    - [Stress in Children Questionnaire (SIC)](#stress-in-children-questionnaire-sic)
  - [Parent-Reported Questionnaires](#parent-reported-questionnaires)
    - [Visit 1 Demographics](#visit-1-demographics)
    - [Parent Household Demographics Questionnaire](#parent-household-demographics-questionnaire)
    - [Alcohol Use Disorders Identification Test (AUDIT)](#alcohol-use-disorders-identification-test-audit)
    - [Behavioral Inhibition System/Behavioral Activation System (BIS/BAS)](#behavioral-inhibition-systembehavioral-activation-system-bisbas)
    - [Behavioral Rating Inventory of Executive Function-2 (BRIEF-2)](#behavioral-rating-inventory-of-executive-function-2-brief-2)
    - [Binge Eating Scale (BES)](#binge-eating-scale-bes)
    - [Child Behavior Questionnaire (CBQ) - Short Form Version 1](#child-behavior-questionnaire-cbq---short-form-version-1)
    - [Children's Leisure Activities Study Survey (CLASS)](#childrens-leisure-activities-study-survey-class)
    - [Community Childhood Hunger Identification Project (CCHIP)](#community-childhood-hunger-identification-project-cchip)
    - [Child Feeding Quesstionnaire (CFQ)](#child-feeding-quesstionnaire-cfq)
    - [Children's Eating Behavior Quesstionnaire (CEBQ)](#childrens-eating-behavior-quesstionnaire-cebq)
    - [Children's Sleep Habits Questionnaire - Abreviated (CSHQ-A)](#childrens-sleep-habits-questionnaire---abreviated-cshq-a)
    - [Comprehensive Feeding Practices Questionnaire (CFPQ)](#comprehensive-feeding-practices-questionnaire-cfpq)
    - [Confusion, Hubbub, and Order Scale (CHAOS)](#confusion-hubbub-and-order-scale-chaos)
    - [Dutch Eating Behavior Questionnaire (DEBQ)](#dutch-eating-behavior-questionnaire-debq)
    - [External Food Cues Responsiveness Scale (EFCR)](#external-food-cues-responsiveness-scale-efcr)
    - [Family Food Behvior Survey (FFBS)](#family-food-behvior-survey-ffbs)
    - [Feeding Strategies Questionnaire (FSQ)](#feeding-strategies-questionnaire-fsq)
    - [Fulkerson Home Food Inventory (FHFI)](#fulkerson-home-food-inventory-fhfi)
    - [Household Food Insecurity Access Scale (HFIAS)](#household-food-insecurity-access-scale-hfias)
    - [Household Food Security Survey Module (HFSSM)](#household-food-security-survey-module-hfssm)
    - [Lifestyle Behavior Checklist (LBC)](#lifestyle-behavior-checklist-lbc)
    - [Problematic Media Use Measure (PMUM)](#problematic-media-use-measure-pmum)
    - [Perceived Stress Scale (PSS)](#perceived-stress-scale-pss)
    - [Parental Strategies to Teach Children about Advertising (PSTCA)](#parental-strategies-to-teach-children-about-advertising-pstca)
    - [Parent Weight Loss Behavior Questionnaire (PWLB)](#parent-weight-loss-behavior-questionnaire-pwlb)
    - [Ranking Food Item Questionnaire (RANK)](#ranking-food-item-questionnaire-rank)
    - [Structure and Control in Parent Feeding (SCPF)](#structure-and-control-in-parent-feeding-scpf)
    - [Sensitivity to Punishment and Reward Questionnaire (SPSRQ)](#sensitivity-to-punishment-and-reward-questionnaire-spsrq)
    - [Three Factor Eating Questionnaire - Revised (TFEQ)](#three-factor-eating-questionnaire---revised-tfeq)
    - [US Household Food Security Survey Module: Three Stage (HFSSM)](#us-household-food-security-survey-module-three-stage-hfssm)
- [Using the data](#using-the-data)
  - [Locating the data you want](#locating-the-data-you-want)
  - [Using the data](#using-the-data-1)
    - [General usage notes](#general-usage-notes)
    - [Using phenotype data](#using-phenotype-data)
      - [Combining datasets](#combining-datasets)
    - [Using rawdata](#using-rawdata)
    - [Using derivative data](#using-derivative-data)
  - [Correcting data entry/collection errors](#correcting-data-entrycollection-errors)
- [Data Management](#data-management)
  - [Directory Organization](#directory-organization)
    - [untouchedRaw](#untouchedraw)
    - [bids](#bids)
    - [bids/sourcedata](#bidssourcedata)
    - [bids/rawdata](#bidsrawdata)
    - [bids/phenotype](#bidsphenotype)
    - [bids/derivatives](#bidsderivatives)
    - [bids/code](#bidscode)
  - [Data Processing Software](#data-processing-software)
    - [R01\_Marketing](#r01_marketing)
    - [dataREACHr](#datareachr)
    - [dataprepr](#dataprepr)
    - [dcm2bids](#dcm2bids)
    - [pydeface](#pydeface)
    - [mriqc](#mriqc)
    - [fmriprep](#fmriprep)
    - [afni](#afni)
  - [Data Processing Pipeline](#data-processing-pipeline)
    - [Overview](#overview)
    - [Required access](#required-access)
    - [Retriving data from the source](#retriving-data-from-the-source)
      - [Survey (redcap) data](#survey-redcap-data)
      - [Task data](#task-data)
      - [MRI data](#mri-data)
    - [Running data processing scripts](#running-data-processing-scripts)
      - [Survey and Task Data](#survey-and-task-data)
    - [Neuroimaging data](#neuroimaging-data)
    - [Software Required](#software-required)
  - [Data Quality Control](#data-quality-control)
  - [Data Documentation](#data-documentation)
  - [Pre-Processing Pipeline](#pre-processing-pipeline)
    - [Installation Instructions](#installation-instructions)
      - [Python](#python)
      - [R](#r)
      - [Matlab](#matlab)
      - [LaTex](#latex)
    - [Pipeline Execution](#pipeline-execution)
      - [1) Raw Data](#1-raw-data)
        - [1a) Exporting](#1a-exporting)
        - [1b) Quality Control](#1b-quality-control)
      - [2) ...](#2-)
- [Interactive Reports and Tables](#interactive-reports-and-tables)
- [Analyses: Guidelines for Reproducibility and Documentation](#analyses-guidelines-for-reproducibility-and-documentation)

# Github security token transfer for all data

# Introduction

## Overview of Study

  
## Inclusion/Exclusion Criteria


# Study Design

## Baseline (ses-1)
### Visit 1

The first visit takes place in Noll Lab. During the visit, the parent and child complete consent and assent, respectively. Child and parent [height and weight](#height-and-weight) are measured by a research and children complete a [Dual-Energy X-Ray Absorptiometry (DXA)](#dual-energy-x-ray-absorptiometry-dxa) scan. 
Children then complete the [test meal](#test-meal) protocol with the neutral advertisment condition. This test meal is recorded to code [meal microstructure](#). The children also rate their fullness using [Freddy Fullness](#) and [liking](#) and [wanting](#) of foods. Children complete the [NIH toolbox](#nih-toolbox) and [Relative Reinforceing Value task](#relative-reinforcing-value-task-rrv) and watch a [mock fMRI video](#mock-scan-protocol). Both parents and children also complete questionnaires on REDCap.

Child Measures:
* [Height and Weight](#height-and-weight)
* [Dual-Energy X-Ray Absorptiometry (DXA)](#dual-energy-x-ray-absorptiometry-dxa)
* [Test Meal](#test-meal)
* [Kid's Brand Awareness Survey](#kids-brand-awareness-survey-kbas)
* [Child Screen Time Questionnaire](#child-screen-time-questionnaire-stq)
* [NIH toolbox](#nih-toolbox)
* [Relative Reinforceing Value task](#relative-reinforcing-value-task-rrv)
* [Mock fMRI video](#mock-scan-protocol)

Parent Measures:
* [Height and Weight](#height-and-weight)
* [Visit 1 Demographics Questionnaire](#visit-1-demographics)
* [Parent Household Demographics Questionnaire](#parent-household-demographics-questionnaire)
* [Pubertal Development Scale](#)
* [Tanner Scale](#)
* [Child Feeding Questionnaire](#child-feeding-quesstionnaire-cfq)
* [Children's Eating Behavior Questionnaire](#childrens-eating-behavior-quesstionnaire-cebq)
* [External Food Cues Responsiveness Scale](#external-food-cues-responsiveness-scale-efcr)
* [Confusion, Hubbub, and Order Scale](#confusion-hubbub-and-order-scale-chaos)
* [Percieved Stress Scale](#perceived-stress-scale-pss)
* [Lifestyle Behavioral Checklist](#lifestyle-behavior-checklist-lbc)

### Visit 2

The second visit takes place in Chandlee Laboratory. Upon arrival, the children rate their [fullness](#fullness) to ensure they are in a neutral state prior to completing the (functional magnetic resonance imaging (fMRI) paradigm)[#]. If they rate their fullness below 25%, they are given a snack and then rate their fullness again. This is repeated one more time if fullness remains below 25% (i.e., maximum of 2 snacks administered). Then, children complete a practice run and 2 behavioral runs of the [SST ('Plate Sorting Game')](#functional---stop-signal-task-plate-sorting-game) before heading to SLEIC's MRI suite. In the MRI suite, children complete a [mock fMRI scan](#mock-scan-protocol) and then rate their [fullness](#fullness) and [state anxiety](#) before entering the MRI. In the scanner, children complete []. After the scan, children rate [state anxiety](#) and complete the [fMRI behavioral assessment](#post-scan-fmri-behavioral-assessment). Prior to the behavioral assessment, children are provided a snack (small pizza, bag of chips, apple juice; intake not measured). Parents complete questionnaires on REDCap.

Child Measures:
* [fMRI Protocol](#functional-magnetic-resonance-imaging)

Parent Measures:
* [Children's Behavior Questionnaire](#child-behavior-questionnaire-cbq---short-form-version-1)
* [Behavior Rating Inventory of Executive Function](#behavioral-rating-inventory-of-executive-function-2-brief-2)
* [Children's Sleep Habit Questionnaire](#childrens-sleep-habits-questionnaire---abreviated-cshq-a)
* [Binge Eating Scale](#binge-eating-scale-bes)
* [Family Food Behavior Survey](#family-food-behvior-survey-ffbs)
* [Feeding Strategies Questionnaire](#feeding-strategies-questionnaire-fsq)

### Visit 3

The third visit takes place in Chandlee Laboratory. During the visit, the consumes one of the [portion size meals](#), which is video recorded to code [meal microstructure](#). The children also rate their [fullness](#fullness) and [liking](#) of foods. 

Child Measures:
* [Test Meal](#test-meal)
* [EAH food wanting questionnaire](#)
* [Eating in the Absense of Hunger](#)
* [Reward-Related Decision-Making Task](#reward-related-decision-making-space-game)


Parent Measures:
* [Children's Leisure Activities Study Survey](#childrens-leisure-activities-study-survey-class)
* [Sensitivity to Punishment/Sensitivity to Reward Questionnaire](#sensitivity-to-punishment-and-reward-questionnaire-spsrq)
* [Behavioral Inhibition System/Behavioral Activation System](#behavioral-inhibition-systembehavioral-activation-system-bisbas)
* [Parent Weight-Loss Beahvior Questionnaire](#parent-weight-loss-behavior-questionnaire-pwlb)
* [Three-Factor Eating Questionnaire](#three-factor-eating-questionnaire---revised-tfeq)
* [Parental Strategies to Teach Children about Advertising](#parental-strategies-to-teach-children-about-advertising-pstca)
* [Dutch Eating Behavior Questionnaire](#dutch-eating-behavior-questionnaire-debq)
* [Structure and Control in Parent Feeding Questionnaire](#structure-and-control-in-parent-feeding-scpf)

### Visit 4

The fourth visit takes place in Chandlee Laboratory. During the visit, the consumes one of the [portion size meals](#), which is video recorded to code [meal microstructure](#). The children also rate their fullness using [Freddy Fullness](#) and [liking](#) of foods. In addition to the meal, children complete an [IQ assessment](#) and the ['Space Game'](#reinforcement-learning-space-game), which is a two-stage reinforcement learning task. Both parents and chidlren also complete questionnaires on Qualtrics. Lastly, the child completes a [mock-scan protocol](#) to become familiar with the scanner.

Child Measures:
* [Test Meal](#test-meal)
* [EAH food wanting questionnaire](#)
* [Eating in the Absense of Hunger](#)
* [Loss of Control Eating Questionnaire](#loss-of-control-eating-questionnaire-loc)
* [Pavlovian-to-Instrumental Transfer Task](#pavlovian-to-instrumental-transfer-task-pit)
* [Pictorial Personality Traits Questionnaire](#pictorial-personality-trains-questionnaire-pptq)
* [Stress in Children Questionnaire](#stress-in-children-questionnaire-stq)
* [WASI (IQ)](#wasi)

Parent Measures:
* [Household Food Security Survey Module](#household-food-security-survey-module-hfssm)
* [Household Food Insecurity Access Scale](#household-food-insecurity-access-scale-hfias)
* [Problematic Media Use Measure](#problematic-media-use-measure-pmum)
* [Community Childhood Hunger Identification Project](#community-childhood-hunger-identification-project-cchip)
* [Alcohol Use Disorders Identification Test](#alcohol-use-disorders-identification-test-audit)
* [Fulkerson Home Food Inventory](#fulkerson-home-food-inventory-fhfi)
* [Comprehensive Feeding Practices Questionnaire](#comprehensive-feeding-practices-questionnaire-cfpq)

## Follow-up (ses-2)
### Visit 5

The fifth visit takes place in Noll Laboratory 1 year after [Visit 1](#visit-1). The children compelte a Dual-Energy X-Ray Absorptiometry (DXA) scan prior to a [standard laboratory meal](#) and the [Eating in the Absence of Hunger (EAH)](#) protocol. Eating paradigms are video recorded to code [meal microstructure](#) and [EAH behaivor](#). The children also rate their fullness using [Freddy Fullness](#) and [liking](#) and [wanting](#) of foods. Children also complete the [N-Back Task](#letter-n-back) and the ['Space Game'](#reinforcement-learning-space-game). Both parents and chidlren also complete questionnaires on Qualtrics.

Child Measures:
* [Height and Weight](#height-and-weight)
* [Dual-Energy X-Ray Absorptiometry (DXA)](#dual-energy-x-ray-absorptiometry-dxa)
* [TICTACH task](#)
* [Test Meal](#test-meal)
* [EAH food wanting questionnaire](#)
* [Eating in the Absense of Hunger](#)
* [Kid's Brand Awareness Survey](#kids-brand-awareness-survey-kbas)
* [Child Screen Time Questionnaire](#child-screen-time-questionnaire-stq)
* [Loss of Control Eating Questionnaire](#loss-of-control-eating-questionnaire-loc)
* [NIH toolbox](#nih-toolbox)
* [Puberty/Tanner](#)

Parent Measures:
* [Height and Weight](#height-and-weight)
* [Parent Household Demographics Questionnaire](#parent-household-demographics-questionnaire)
* [Pubertal Development Scale](#)
* [Tanner Scale](#)
* [Children's Eating Behavior Questionnaire](#childrens-eating-behavior-quesstionnaire-cebq)
* [Children's Behavior Questionnaire](#child-behavior-questionnaire-cbq---short-form-version-1)
* [Children's Sleep Habit Questionnaire](#childrens-sleep-habits-questionnaire---abreviated-cshq-a)
* [Children's Leisure Activities Study Survey](#childrens-leisure-activities-study-survey-class)
* [Parental Strategies to Teach Children about Advertising](#parental-strategies-to-teach-children-about-advertising-pstca)
* [Problematic Media Use Measure](#problematic-media-use-measure-pmum)
* [Alcohol Use Disorders Identification Test](#alcohol-use-disorders-identification-test-audit)
* [Comprehensive Feeding Practices Questionnaire](#comprehensive-feeding-practices-questionnaire-cfpq)

# Outcome Measures: Descriptions and Protocols

## Laboratory Eating Paradigms

### Test Meal

### Eating in the Absence of Hunger

#### EAH wanting questionnaire

## Fullness

150 mm visual analgue scale referred to as "Freddy Fullness." 

References:
* [Keller KL, Assur SA, Torres M, Lofink HE, Thornton JC, Faith MS, Kissileff HR. Potential of an analog scaling device for measuring fullness in children: development and preliminary testing. Appetite. 2006 Sep;47(2):233-43. doi: 10.1016/j.appet.2006.04.004. Epub 2006 Jul 7. PMID: 16828929.](#https://pubmed.ncbi.nlm.nih.gov/16828929/)

## Anthropometrics

### Height and Weight

### Dual-Energy X-Ray Absorptiometry (DXA)

## Actigraphy

## Behavioral tasks

### Reward-Related Decision-Making (Space Game)

Theoretical background...(brief)

<!-- omit in toc -->
#### Task Design

Instructions…  
Design...  
Stim images...

<!-- omit in toc -->
#### Outcomes of Interest

General  

Decision-making model

### Relative Reinforcing Value Task (RRV)

Theoretical background...(brief)

<!-- omit in toc -->
#### Task Design

Instructions…  
Design...  
Stim images...

<!-- omit in toc -->
#### Outcomes of Interest

General  


### Pavlovian-to-Instrumental Transfer Task (PIT)

Theoretical background...(brief)

<!-- omit in toc -->
#### Task Design

Instructions…  
Design...  
Stim images...

<!-- omit in toc -->
#### Outcomes of Interest

General  



## MRI protocol

### Mock-Scan Protocol

* Video
* Mock-Scan protocol
 
### State Anxiety Ratings (CAMS)

Reference = 'Ersig AL, Kleiber C, McCarthy AM, Hanrahan K. Validation of a clinically useful measure of children's state anxiety before medical procedures. J Spec Pediatr Nurs. 2013 Oct;18(4):311-9. doi: 10.1111/jspn.12042. Epub 2013 Jun 25. PMID: 24094126; PMCID: PMC4282760.'),

### Structural scan

### Functional scans - Food View Task

The Food View Task was developed to characterize the effects of food (vs. toy) commercials on children’s neural processing of food-cues. During the task, children were presented with food images after viewing toy and food commercials. 


<!-- omit in toc -->
#### Task Design

The Food View Task was administered using [Matlab2018b and Psychtoolbox3]. 

The Food View Task included 4 functional MRI runs (~3.7 min each). Each run included 4 commercial blocks (2 food, 2 toy) and 4 food image blocks (2 high-ED, 2 low-ED). Commercial and food image blocks were presented in alternating order, always starting with a commercial block. Commercial blocks contained 2 commercials (~30 seconds total) and food image blocks contained 5 images (1.5 seconds each with 0.5s fixation following each image). Between blocks, a fixation cross was presented on the screen for 6-8 seconds (jittered). Within a run, toy and food commercial blocks were presented in alternating order. For each subject, 2 runs started with toy commercials and 2 started with food commericals; which runs these were varied by subject (counterbalanced?).


Within each run, 2 food image blocks contained high-ED foods and 2 contained low-ED foods. Therefore a 2 (after toy commercial, after food commercial) x 2 (high-ED foods, low-ED foods) design could be used to explore the effects of commercials on children’s neural processing of food-cues by energy density. 

Instructions…  
Design...  

Food images were selected from Dr. Jens Blechert's Food Pics database. Images were selected based on .... Categorized into High/Low ED based on ...

<!-- omit in toc -->
#### Outcome Metrics

### Functional Scans - Stop Signal Task ("Plate Sorting Game")

The stop-signal task (SST) assesses inhibitory control by measuring the latency of response inhibition. To assess the effects of food (vs. toy) commercials on inhibitory control, children performed rounds of the SST after viewing toy and food commercials. 

The SST was adapted from the implementation in (Verbruggen, Logan, & Stevens, 2008). For a thorough discussion of the theoretical basis for the race-horse model of response inhibition see (Verbruggen & Logan, 2009). The basic premise is that participants will first activate a go-response to a stimuli. After seeing the stop stimuli, they will activate a nogo-response. If they are successful in inhibiting the go-response, the nogo-response was faster. If they fail to inhibit the go-response, the nogo-response was too slow. In this task, inhibition can be measured by manipulating the delay of the stop signal using a step-like function to hold successful stopping at a .5 probability. 


![Racehorse_Model](./images/sst_racehorse_model.png)

<!-- omit in toc -->
#### Task Design

The SST was administered using [Matlab2018b and Psychtoolbox3]. 

The SST included 6 functional MRI runs (~XX min each). Each run included XX commerical blocks and stop signal blocks. Commercial and stop signal blocks were presented in alternating order, always starting with a commercial block. Commercial blocks contained 1 commercial (~15 seconds). Within a run, commercials blocks were either all food or all toy commericals. 

[During stop signal blocks, plates of food were presented with a triangle-folded napkin on either the left or right side of the plate (go stimulus; see Figure 1) for 1500 ms with an inter-stimulus-interval of 50 ms (i.e., fixation). Children were asked to sort the plates according to which side of the plate the napkin was on and to press the left or right arrow keys when the napkin appeared on the left or right side of the plate, respectively. They were encouraged to respond as quickly as possible. They were also told that the plate would be sometimes get covered with a warmer dome (i.e., stop-signal; see Figure 1) and were instructed not to respond if the dome appeared.  The warmer dome (i.e., stop-signal) was presented after variable delay on 25% of trials. The variable stop-signal delay (SSD) was determined by a step-wise adaptive procedure which increased the SSD 50ms after each successful stop trial and reduced the SSD by 50 ms after each unsuccessful stop trial with the first SSD = 250 ms. This adaptive procedure maintained ~0.50 probability of successful response inhibition. The task parameters were based on specifications articulated by Verbruggen and colleagues (2019) for best practices in measuring stop-signal reaction time according to the theoretical racehorse model. ]

The task consisted of N trials across 4 randomized blocks (i.e., N trials per block), two of which included foods with high-energy density (ED; i.e. a chocolate brownie) and two of which included foods with low-ED (i.e. blueberries). 

Prior to the task, children completed 32 practice trials to ensure they understood the instructions. After the practice, children were reminded to respond quickly and told that they may be encourage to respond quickly during the task. To prevent children from slowing throughout the task, which is a known issue, the message ‘Faster’ was presented after trials in which they responded slower than 1.5 standard deviations below their mean reaction time in practice. Between each block, children were given the opportunity to take a break and were shown their average response time (e.g., ‘How Fast Were You?’), given encouragement for how quickly the were responding (e.g., ‘Wow, that is faster than a second’), and were reminded not to press the arrow keys if the dome covered the plate.  

Stim images...

<!-- omit in toc -->
#### Outcomes of Interest

<!-- omit in toc -->
#### Outcome Metrics

### Field maps

### Post-scan fMRI behavioral assessment

## NIH toolbox

## WASI

## Child-Reported Questionnaires

All child questionnaires were administered by a trained research assistant using REDCap. The research assistant read all questions to children and children responded by indicating their answers verbally or by pointing at a selection on the computer screen.


### Kid's Brand Awareness Survey (KBAS)

The KBAS is 50-item (25 per condition: toy, food), child-report measure, where children are asked to match the correct picture with food and toy logos. Two versions of the survey were administered (counterbalanced) which varied by category (food, toy) order. The KBAS was developed in the Keller Lab for Project REACH. 

Scale: 

Scoring: Correctly matched items are scored as a 1. Incorrectly matched items are scored as a 0. The number of correct responses are determined within a category. Scoring was implemented in REDCap.

Subscales:
  * Toy score
  * Food score

Database and meta-data in bids/phenotype: 
  * kbas.tsv and kbas.json


### Child Screen Time Questionnaire (STQ)

description...

Scale:

Scoring: 

Subscales:

Database and Code Book/Dictionairy: 

References:

### Loss of Control Eating Questionnaire (LOC)

description...

Scale:

Scoring: 

Subscales:

Database and Code Book/Dictionairy: 

References:

### Pictorial Personality Trains Questionnaire (PPTQ)

description...

Scale: The PPTQ was adminisered using the 3-point scale for younger children (6-9 years old)

Scoring: 
Scoring was implemented using [dataprepr](#dataprepr). 

Subscales: 
* extraversion
  * Items: 
* neuroticism
  * Items: 
* openness to experience
  * Items:
* agreeableness
  * Items:
* conscientiousness
  * Items:

Database and meta-data in bids/phenotype: 
  * pptq.tsv and pptq.json

References:
[Maćkiewicz M, Cieciuch J. Pictorial Personality Traits Questionnaire for Children (PPTQ-C)-A New Measure of Children's Personality Traits. Front Psychol. 2016 Apr 14;7:498. doi: 10.3389/fpsyg.2016.00498. PMID: 27252661; PMCID: PMC4879772.](#https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4879772/)

### Stress in Children Questionnaire (SIC)

description...
Child-report questionnaire

Scale:

Scoring: 

Subscales:
  * Lack of Well being
  * Distress
  * Lack of Social Support
  * Total score (grand mean)


Database and meta-data in bids/phenotype: 
  * sic.tsv and sic.json

References: [Osika W, Friberg P, Wahrborg P. A new short self-rating questionnaire to assess stress in children. Int J Behav Med. 2007;14(2):108-117. doi:10.1007/BF03004176](#https://link.springer.com/article/10.1007/BF03004176)

## Parent-Reported Questionnaires

All parent questionnaires were administered using REDCap.

### Visit 1 Demographics

The Visit 1 Demographics form assesses child demographics and items related to birth and infancy (e.g., birth weight, infant feeding practices). This questionnaire was developed within the Keller Lab for Study REACH.

Items from this questionnaire are reported in 2 databases in bids/phenotype: 
  * Child demographic variables (race, ethnicity) are reported in:
    * demographics.tsv and demographics.json
  * Items related to birth and infancy are reported in:
    * infancy.tsv and infancy.json

### Parent Household Demographics Questionnaire

The Parent Household Demographics Questionnaire assesses parent demographics and the household environment. This questionnaire was developed within the Keller Lab for Study REACH.

Database and meta-data in bids/phenotype: 
  * household.tsv and household.json

Items from this questionnaire that are commonly reported in papers or used as covariates (i.e., maternal education, family income) have also been included in demographics.tsv and demographics.json.

### Alcohol Use Disorders Identification Test (AUDIT)

The Alcohol Use Disorders Identification Test (AUDIT) is a 10-item screening instrument for hazardous and/or harmful alcohol consumption. A score of 8 or more indicates a strong likelihood of harmful alcohol consumption.

Scale: The majority of questions follow the stated scale with alternative responses of equal weight in parentheses

0) Never (1-2 drinks; No)
1) Less than Monthly (Monthly or Less; 3 or 4 drinks)
2) Monthly (2-4 Times a Month; 5 or 6 drinks; Yes, but not in the last year)
3) Weekly (2-3 Times a Week; 7 to 9 drinks)
4) Daily or Almost Daily (4 or More Times a Week; 10 or more drinks; Yes, during the last year)

Outcome Measures:
* Total Score
* Category (Not Harmful Consumtion or Likely Harmful Consumption)

Database and meta-data in bids/phenotype: 
  * audit.tsv and audit.json
  
References:
* [Saunders JB, Aasland OG, Babor TF, De La Fuente JR, Grant M. Development of the Alcohol Use Disorders Identification Test (AUDIT): WHO Collaborative Project on Early Detection of Persons with Harmful Alcohol Consumption-II. Addiction. 1993;88(6):791-804. doi:10.1111/j.1360-0443.1993.tb02093.x](#https://pubmed.ncbi.nlm.nih.gov/8329970/)

### Behavioral Inhibition System/Behavioral Activation System (BIS/BAS)

description...

Scale:
1) Very True for Me
2) Somewhat True for Me
3) Somewhat False for Me
4) Very False for Me

Scoring: The mean of the responses is computed if there are no missing responses. Note, although there are 24 items, only 20 are used in scoring as there are 4 filler items. Scoring was implemented using [dataprepr](#dataprepr). 


Subscales:
* Behavioral Inhibition System (BIS)
* Behavioral Activation System (BAS)
* Funseeking
* Drive 
* Reward Responsiveness

Database and meta-data in bids/phenotype: 
  * bisbas.tsv and bisbas.json
  
References:
* Muris P, Meesters C, de Kanter E, Timmerman PE. Behavioural inhibition and behavioural activation system scales for children: relationships with Eysenck’s personality traits and psychopathological symptoms. Personality and Individual Differences. 2005;38(4):831-841. doi:10.1016/j.paid.2004.06.007
* Carver CS, White TL. Behavioral inhibition, behavioral activation, and affective responses to impending reward and punishment: The BIS/BAS Scales. Journal of Personality and Social Psychology. 1994;67(2):319-333. doi:http://dx.doi.org/10.1037/0022-3514.67.2.319.

### Behavioral Rating Inventory of Executive Function-2 (BRIEF-2)

The Behavioral Rating Index of Executive Function-2 (BRIEF-2) is a parent-report measure of everyday executive behaviors that is normed for age and gender. T scores of 60 or greater indicate high risk/clinical relevance for symptoms. 

Scale: 
1) Never
2) Sometimes
3) Always

Scoring: The sume of responses for a scale is computed if all responses were completed. Scoring was implemented using [dataprepr](#dataprepr). 


Subscales:

* Inhibit
* Self-Monitor
* Shift
* Emotional Control
* Initiate
* Working Memory
* Plan/Organize
* Task-Monitor
* Organization of Materials
* Behavioral Regulation Index - Inhibit and Self-Monitor
* Emotional Regulation Index - Shift and Emotional Control
* Cognitive Regulation Index - Initiate, Working Memory, Plan/Organize, and Task-Monitor
* General Executive Composite - All Subscales
* Inconsistency
* Negativity
* Infrequency

Database and meta-data in bids/phenotype: 
  * brief2.tsv and brief2.json
  
References:
* Gioia GA, Isquith PK, Guy SC, Kenworthy L. BRIEF-2: Behavior Rating Inventory of Executive Function: Professional Manual. Psychological Assessment Resources; 2015.
  
### Binge Eating Scale (BES)

Parent-report scale of child binge eating behaviors. The items in this questionnaire were adapted from Gormally et al., to ask about child behavior. 

Scale:

Scoring: The sum of the responses is computed if there are no missing responses. Scoring was implemented using [dataprepr](#dataprepr). 


Outcome Measures:
* Total Score

Database and meta-data in bids/phenotype: 
  * bes.tsv and bes.json
  
References:
* [Gormally, J., Black, S., Daston, S., & Rardin, D. (1982). The assessment of binge eating severity among obese persons. Addictive Behaviors, 7(1), 47–55. https://doi.org/10.1016/0306-4603(82)90024-7](#https://pubmed.ncbi.nlm.nih.gov/7080884/)
* Timmerman, G. M. (1999). Binge Eating Scale: Further Assessment of Validity and Reliability. Journal of Applied Biobehavioral Research, 4(1), 1–12. https://doi.org/10.1111/j.1751-9861.1999.tb00051.x


### Child Behavior Questionnaire (CBQ) - Short Form Version 1

The Child Behavior Questionnaire ask parents to rate 94 statements from 'Extremely Untrue of Your Child' (1) to 'Extremely True of Your Child' (7).

Scale:

1) Extremely Untrue of Your Child
2) Quite Untrue of Your Child
3) Slightly Untrue of Your Child
4) Neither True nor False of Your Child
5) Slightly True of of Your Child
6) Quite True of of Your Child
7) Extremely True of Your Child

Items were collected using base-0 (values 0-7) and rescaled to base-1 (values 1-7) before scoring.

Scoring: The mean of responses in each scale is computed, ignoring skipped items. Scoring was implemented using [dataprepr](#dataprepr). 


Subscales:
* Activity Level
* Anger/Frustration
* Approach/Positive Anticipation
* Attentional Focusing
* Discomfort
* Falling Reactivity/Soothability
* Fear
* High Intesity Pleasure
* Impulsivity
* Inhibitory Control
* Low Intensity Pleasure
* Perceptual Sensitivity
* Sadness
* Shyness
* Smiling and Laughter
* Big 3 Surgency - average of the scale scores for Activity Level, High-Intensity Pleasure, Impulsivity, and Shyness-reversed
* Big 3 Negative Affect - average of the scale scores for Anger, Discomfort, Fear, Sadness, and Soothability-reversed
* Big 3 Effortful Control - average of the scale scores for Attention Focusing, Inhibitory Control, Low-Intesity Pleasure, and Perceptual Sensitivity

Database and meta-data in bids/phenotype: 
  * cbq.tsv and cbq.json
  
References:
* [Putnam SP, Rothbart MK. Development of Short and Very Short Forms of the Children’s Behavior Questionnaire. Journal of Personality Assessment. 2006;87(1):102-112. doi:10.1207/s15327752jpa8701_09 doi.org/10.1097/00004703-200112000-00007](#https://pubmed.ncbi.nlm.nih.gov/16856791/)
* [Rothbart MΚ, Ahadi SA, Hershey KL. Temperament and Social Behavior in Childhood. Merrill-Palmer Quarterly. 1994;40(1):21-39](#https://www.jstor.org/stable/23087906)











### Children's Leisure Activities Study Survey (CLASS)

description...

Scale: 

Scoring: 

Subscales:

Database and Code Book/Dictionairy: 

References:

### Community Childhood Hunger Identification Project (CCHIP)

description...

Scale:
0) No
1) Yes

Scoring: The mean of the responses is computed if there are no missing responses. Only items 1, 5, 9, 13, 17, 21, 25, and 29 contribute to the total score.

Outcome Measures:
* Total Score
* Categorical Score (Not Hungry, At Risk for Hunger, Hungry)

Database and meta-data in bids/phenotype: 
  * cchip.tsv and cchip.json

References:
* Wehler CA, Scott RI, Anderson JJ. The community childhood hunger identification project: A model of domestic hunger—Demonstration project in Seattle, Washington. Journal of Nutrition Education. 1992;24(1):29S-35S. doi:10.1016/S0022-3182(12)80135-X

### Child Feeding Quesstionnaire (CFQ)

description...

Scale: The scale differed based on section of the questionnaire

* Perceived Weight:
  1) Markedly Underweight
  2) Underweight
  3) Average
  4) Overweight 
  5) Markedly Overweight
* Child Weight Concerns: 
  1) Unconcerned
  2) Slightly Unconcerned
  3) Neutral
  4) Slightly Concerned
  5) Very Concerned
* Restriction and Pressure to Eat: 
  1) Disagree
  2) Slightly Disagree
  3) Neutral
  4) Slightly Agree
  5) Agree
* Monitoring: 
  1) Never
  2) Rarely
  3) Sometimes
  4) Mostly
  5) Always

Scoring: The mean of the responses is computed if there are no missing responses. Scoring was implemented using [dataprepr](#dataprepr). 


Subscales:
* Perceived Responsibility
* Perceived Child Weight
* Perceived Parent Weight
* Child Weight Concerns
* Restriction
* Pressure to Eat
* Monitoring

Database and meta-data in bids/phenotype: 
  * cfq.tsv and cfq.json
  
References:
* [Birch, L. L., Fisher, J. O., Grimm-Thomas, K., Markey, C. N., Sawyer, R., & Johnson, S. L. (2001). Confirmatory factor analysis of the Child Feeding Questionnaire: A measure of parental attitudes, beliefs and practices about child feeding and obesity proneness. Appetite, 36(3), 201–210. https://doi.org/10.1006/appe.2001.0398](#https://pubmed.ncbi.nlm.nih.gov/11358344/)


### Children's Eating Behavior Quesstionnaire (CEBQ)

description...

Scale:
1) Never
2) Rarely
3) Sometimes
4) Often
5) Always

Items were collected using base-0 (values 0-4) and rescaled to base-1 (values 1-5) before scoring.

Scoring: The mean of the responses is computed for each subscale if there are no missing responses. Scoring was implemented using [dataprepr](#dataprepr). 

Wardle Subscales:
* Food Responsiveness
  * items: 12, 14, 19, 28, 34
* Emotional Overeating
  * items: 2, 13, 15, 27
* Enjoyment of Food
  * items: 1, 5, 20, 22
* Desire to Drink
  * items: 6, 29, 31
* Satiety Responsiveness
  * items (* = reverse scored): 3*, 17, 21, 26, 30
* Slowness in Eating 
  * items (* = reverse scored): 4*, 8, 18, 35
* Emotional Undereating 
  * items: 9, 11, 23, 25
* Food Fussiness
  * items (* = reverse scored): 7, 10*, 16*, 24, 32*, 33
* Appraoch Behaviors
  * items in FR, EOE, EF, DD subscales
* Avoidant Behaviors
  * items in SR, SE, EUE, FF subscales

Manzano (3-factor) Subscales:
* Reward-based eating
  * items (* = reverse scored): 1, 3*, 4*, 5, 8*, 12, 14, 19, 20, 22, 28, 34
* Picky Eating
  * items: 7, 10, 16, 24, 32, 33
* Emotional eating
  * items: 2, 9, 13, 15, 23, 25

Database and meta-data in bids/phenotype: 
  * cebq.tsv and cebq.json
  
References:
* [Wardle, J., Guthrie, C. A., Sanderson, S., & Rapoport, L. (2001). Development of the children’s eating behaviour questionnaire. Journal of Child Psychology and Psychiatry, 42, 963–970. https://doi.org/10.1017/S0021963001007727](#https://pubmed.ncbi.nlm.nih.gov/11693591/)
* [Manzano MA, Strong DR, Kang Sim DE, Rhee KE, Boutelle KN. Psychometric properties of the Child Eating Behavior Questionnaire (CEBQ) in school age children with overweight and obesity: A proposed three‐factor structure. Pediatric Obesity. 2021;16(10):e12795. doi:10.1111/ijpo.12795')](#https://onlinelibrary.wiley.com/doi/abs/10.1111/ijpo.12795)

### Children's Sleep Habits Questionnaire - Abreviated (CSHQ-A)

description...

Scale: 
1) Never
2) Rarely
3) Sometimes
4) Usually
5) Always

Scoring: The mean of the responses is computed if there are no missing responses. 
* The last section of the abreviated version of this scale was not administered (questions 19-22) so we are unable to use the reference cutoff for total score and we do not have the Daytime Sleepness subscale
* We are still resolving subscale scoring as it is unclear which subscale the following items correspond to: 5, 6, 16, and 20

Subscales:
* Bedtime Resistance
* Sleep Onset Delay
* Sleep Duration
* Sleep Anxiety
* Night Wakings
* Parasomnias
* Sleep Disordered Breathing
* Total

Database and meta-data in bids/phenotype: 
  * cshq.tsv and cshq.json

References:
* [Owens, J. A., Spirito, A., & McGuinn, M. (2000). The Children’s Sleep Habits Questionnaire (CSHQ): Psychometric Properties of A Survey Instrument for School-Aged Children. SLEEP, 23(8), 1043–1052.](#https://pubmed.ncbi.nlm.nih.gov/11145319/)
* [Chawla, J. K., Howard, A., Burgess, S., & Heussler, H. (2021). Sleep problems in Australian children with Down syndrome: The need for greater awareness. Sleep Medicine, 78, 81–87. https://doi.org/10.1016/j.sleep.2020.12.022](#https://pubmed.ncbi.nlm.nih.gov/33412456/)



### Comprehensive Feeding Practices Questionnaire (CFPQ)

description...

Scale: 

Scoring: 

Subscales:

Database and meta-data in bids/phenotype: 
  * cfpq.tsv and cfpq.json

References:

### Confusion, Hubbub, and Order Scale (CHAOS)

description...

Scale: 

Scoring: 

Subscales:

Database and meta-data in bids/phenotype: 
  * chaos.tsv and chaos.json

References:

### Dutch Eating Behavior Questionnaire (DEBQ)

description...

Scale: 

Scoring: 

Subscales:

Database and meta-data in bids/phenotype: 
  * debq.tsv and debq.json

References:

### External Food Cues Responsiveness Scale (EFCR)

description...

Scale: 

Scoring: 

Subscales:

Database and meta-data in bids/phenotype: 
  * efcr.tsv and ecfr.json

References:

### Family Food Behvior Survey (FFBS)

description...

Scale: 
0) Never True
1) Rarely True
2) Sometimes
3) Often True
4) Always True

Scoring: The sum of the responses is computed if there are no missing responses. 
  
Subscales:
* Maternal Control
* Maternal Presences
* Child Choice
* Organization

Database and meta-data in bids/phenotype: 
  * ffbs.tsv and ffbs.json

References:
* [Baughcum, A. E., Powers, S. W., Johnson, S. B., Chamberlin, L. A., Deeks, C. M., Jain, A., & Whitaker, R. C. (2001). Maternal Feeding Practices and Beliefs and Their Relationships to Overweight in Early Childhood: Journal of Developmental & Behavioral Pediatrics, 22(6), 391–408. doi.org/10.1097/00004703-200112000-00007](#https://pubmed.ncbi.nlm.nih.gov/11773804/)
* [McCurdy, K., & Gorman, K. S. (2010). Measuring family food environments in diverse families with young children. Appetite, 54(3), 615–618. doi.org/10.1016/j.appet.2010.03.004](#https://pubmed.ncbi.nlm.nih.gov/20227449/)


### Feeding Strategies Questionnaire (FSQ)

description...

Scale: 

Scoring: 

Subscales:

Database and meta-data in bids/phenotype: 
  * fsq.tsv and fsq.json

References:

### Fulkerson Home Food Inventory (FHFI)

description...

Scale: 

Scoring: 

Subscales:

Database and meta-data in bids/phenotype: 
  * fhfi.tsv and fhfi.json

References:

### Household Food Insecurity Access Scale (HFIAS)

description...

Scale: the scale differed depending on the item
* Scale 1:
  0) No 
  1) Yes
  -99) I don't know or Don't want to answer 
* Scale 2:
  1) Rarely
  2) Sometimes
  3) Often
  -99) I don't know or Don't want to answer

Scoring: The sum of the responses is computed after omitting any missing or skipped responses.
  
Outcome Measure:
* Total Score
* Category Score

Database and meta-data in bids/phenotype: 
  * hfias.tsv and hfias.json

References:
* Bickel G, Nord M, Price C, Hamilton W, Cook J, others. Guide to measuring household food security, revised 2000. US Department of Agriculture, Food and Nutrition Service.
* Nord M. Measuring Children’s Food Security in US Households, 1995-99. US Department of Agriculture, Economic Research Service; 2002.



### Household Food Security Survey Module (HFSSM)

description...

Scale: 

Scoring: 

Subscales:

Database and meta-data in bids/phenotype: 
  * hfssm.tsv and hfssm.json

References:

### Lifestyle Behavior Checklist (LBC)

description...

Scale: 

Scoring: 

Subscales:

Database and meta-data in bids/phenotype: 
  * lbc.tsv and lbc.json

References:


### Problematic Media Use Measure (PMUM)

description...

Scale: 

Scoring: 

Subscales:

Database and meta-data in bids/phenotype: 
  * pmum.tsv and pmum.json

References:

### Perceived Stress Scale (PSS)

description...

Scale: 

Scoring: 

Subscales:

Database and meta-data in bids/phenotype: 
  * pss.tsv and pss.json

References:


### Parental Strategies to Teach Children about Advertising (PSTCA)

description...

Scale: 

Scoring: 

Subscales:

Database and meta-data in bids/phenotype: 
  * pstca.tsv and pstca.json

References:



### Parent Weight Loss Behavior Questionnaire (PWLB)

description...

Scale: 

Scoring: 

Subscales:

Database and meta-data in bids/phenotype: 
  * pwlb.tsv and pwlb.json

References:



### Ranking Food Item Questionnaire (RANK)

description...

Scale: 

Scoring: 

Subscales:

Database and meta-data in bids/phenotype: 
  * rank.tsv and rank.json

References:

### Structure and Control in Parent Feeding (SCPF)

description...
34-item parent-report of child feeding practices. 

Note, this scale was administered with the incorrect phrase for item 17. Therefore, data for item have been marked as missing.

Scale: 
0) Never
1) Rarely
2) Sometimes
3) Often
4) Always

Scoring: 

Subscales:
* Limit Exposure
  * Items: 1, 2, 3, 4, 6, 8, 13, 22, 31, 32, 33
* Consistent feeding routines
  * Items: 5, 7, 15, 16, 20, 23, 25, 26, 27, 28, 30
* Restriction
  * Items: 9, 10, 12, 14, 34
* Pressure to eat
  * Items: 17, 18, 19, 21, 24, 29

Database and meta-data in bids/phenotype: 
  * scpf.tsv and scpf.json

References: [avage, J.S., Rollins, B.Y., Kugler, K.C. et al. Development of a theory-based questionnaire to assess structure and control in parent feeding (SCPF). Int J Behav Nutr Phys Act 14, 9 (2017). https://doi.org/10.1186/s12966-017-0466-2](#https://ijbnpa.biomedcentral.com/articles/10.1186/s12966-017-0466-2)

### Sensitivity to Punishment and Reward Questionnaire (SPSRQ)

description...

Scale: 

Scoring: 
0) Strongly Disagree
1) Disagree
2) Neither Agree Nor Disagree
3) Agree
4) Strongly Agree

Subscales:

Database and meta-data in bids/phenotype: 
  * spsrq.tsv and spsrq.json

References:

### Three Factor Eating Questionnaire - Revised (TFEQ)

description...

Scale: 

Scoring: 

Subscales:

Database and meta-data in bids/phenotype: 
  * tfeq.tsv and tfeq.json

References:


### US Household Food Security Survey Module: Three Stage (HFSSM)

description...

Scale: the scale differed depending on the item
* Scale 1:
  0) No 
  1) Yes
  -99) I don't know or Don't want to answer 
* Scale 2:
  0) Never
  1) Sometimes True
  1) Often True
  -99) I don't know or Don't want to answer
* Scale 3:
  0) Only 1 or 2 months
  1) Some Months but not Every Month
  1) Almost Every Month
  -99) I don't know or Don't want to answer

Scoring: The sum of the responses is computed if there are no missing responses. Categorical scores are also provided for each subscale.
  
Subscales:
* Household Food Security Scale
* U.S. Adult Food Security Scale
* Six-Item Food Security Scale
* Children’s Food Security Scale.

Database and meta-data in bids/phenotype: 
  * hfssm.tsv and hfssm.json

References:
* Bickel G, Nord M, Price C, Hamilton W, Cook J, others. Guide to measuring household food security, revised 2000. US Department of Agriculture, Food and Nutrition Service.
* Nord M. Measuring Children’s Food Security in US Households, 1995-99. US Department of Agriculture, Economic Research Service; 2002.

# Using the data 

## Locating the data you want

Data in [bids/rawdata/](#bidsrawdata), [bids/phenotype/](#bidsphenotype), [bids/derivatives/](#bidsderivatives) are ready for use. [The server and folder](#directory-organization) data is stored in depends on the specific type of data (Table 1). For details about how the data got into these folders, see the section on [data processing](#data-processing-pipeline).

Table 1. Datasets and where to find them
| Data you want | Server with data | Folder or files with data |
| -------- | ------- | ------- |
| Raw (minimally processed) MRI data | Roar Collab | bids/rawdata/ |
| Raw (minimally processed) task data (e.g., item responses, onset times) for: sst, food view, NIH toolbox, spacegame, rrv| Roar Collab; OneDrive |  bids/rawdata/ |
| MRI data preprocessed with fmriprep | Roar Collab |  bids/derivatives/fmriprep_2320 |
| Datasets with task summary metrics (excluding NIH toolbox*) | Roar Collab, OneDrive|  separate .tsv in bids/derivatives/beh/ |
| Dataset with NIH toolbox scores* | Roar Collab, OneDrive |  bids/phenotype/toolbox.tsv |
| Demographic data | Roar Collab, OneDrive |  bids/phenotype/demographics.tsv |
| Intake data | Roar Collab, OneDrive|  bids/phenotype/intake.tsv |
| Anthropometric data |Roar Collab, OneDrive |  bids/phenotype/anthropometrics.tsv |
| Dexa data |Roar Collab, OneDrive |  bids/phenotype/dexa.tsv |
| Questionnaire data | Roar Collab, OneDrive|  separate .tsv in bids/phenotype/ |
| WASI scores |Roar Collab, OneDrive |  bids/phenotype/wasi.tsv |
| Other visit data entered into REDCap (e.g., notes)| Roar Collab, OneDrive|  separate .tsv in bids/phenotype/ |
| Enrollment info and visit dates |Roar Collab, OneDrive |  bids/participants.tsv/ |

\*  Task datasets in bids/derivatives/ were derived from response data in bids/rawdata using code in bids/code. NIH toolbox scores are in /phenotype because they were not computed from data in rawdata, but were automatically produced by the toolbox and then compiled into a dataset.

## Using the data

### General usage notes


1. Never manually edit datasets in bids/rawdata, bids/phenotype, and bids/derivatives. 
   - This is because: (1) data are organized and processed using scripts found in bids/code. When datasets are re-processed or updated using these scripts, manual edits will be overwritten; and (2) these data are shared. Someone else using the datasets may be unaware of changes you made.
2. Reference .json files to understand the datasets.
   - JSON files (i.e., files with .json extension) contain metadata for corresponding .tsv files. Meta-data includes information such as variable descriptions and citations.
   - Within bids/phenotypes/, each TSV file is accompanied by a corresponding JSON file with the same basename 
   - Within bids/rawdata/, meta-data for task TSV files in subject/session sub-folders are stored directly in bids/rawdata.
     - E.g., metadata for /bids/rawdata/sub-001/ses-1/beh/sub-001_ses-1_task-sst_beh.tsv can be found within /bids/rawdata/task-sst_beh.json 
3. ??? Reference notes to understand the data ??? 
   1. To do: add something about where qualitative notes will be kept?? in specific databases or a notes database?? 
4. Specify 'n/a' as the value for missing data
  - In compliance with BIDS, 'n/a' is used to indicate missing data in rawdata and derivatives datasetes. To prevent software from interpreting 'n/a' as a string rather than missing data, it can be helpful to specify 'n/a' as the value to set as missing.

In R missing values can be specified at import:
```
# specify file path (update path to file)
path_to_file <- paste0('path/to/file.tsv')

# import data from TSV, specifying missing data values as "n/a"
data <- read.delim(path_to_file, na.strings = "n/a")
```

In SPSS missing values can be specified using the MISSING VALUES command. 


### Using phenotype data

#### Combining datasets
All datasets in bids/phenotype/ contain participant_id and session_id columns that indicate the subject identifier (e.g., sub-001) and when data were collected (i.e., ses-1/baseline or ses-2/follow-up), respectively. Data collected across multiple visits are stored in long format, meaning that within a dataset, a subject has a separate row for each session. Therefore, datasets can be merged by both participant_id and session_id columns.

Example: merge data in R, matching on participant_id and session_id
```
# load demo data
demo_data <- read.delim('path/to/demographics.tsv')

#  example demo_data:
#  participant_id session_id age
#           1     1          7
#           2     1          7
#           1     2          8
#           2     2          8

# load cebq data
cebq_data <- read.delim('path/to/cebq.tsv')

#  example cebq_data:
#  participant_id session_id cebq_value
#           1     1          3
#           2     1          2
#           1     2          1
#           2     2          5

# merge demographic and cebq data
merged_data <- merge(demo_data, cebq_data, by=c("participant_id","session_id"))

#  example merged_data:
#  participant_id session_id age  cebq_value
#           1     1          7      3
#           2     1          7      2
#           1     2          8      1
#           2     2          8      5

```

Example: merge data in SPSS
```

```

### Using rawdata

To do: recommendations for creating derivative datasets from rawdata? 

### Using derivative data


## Correcting data entry/collection errors

Data in bids/ are organized and processed using scripts found in bids/code. When datasets are re-processed or updated using these scripts, manual edits will be overwritten. Therefore data entry errors need to be fixed where data are stored prior to processing:
- For errors in phenotype/survey data, data need to be updated in REDCap. Then, REDCap data can be re-downloaded and reprocessed using dataREACHr
  - Example error in REDCap data: Values that were incorrectly transferred from paper to REDCap (e.g., anthropometrics, intake measurements)
- For errors in task data, data need to be updated in untouchedRaw. Then, they can be reprocessed into bids using dataREACHr
  - Example error in task data: data was improperly exported from task software  



# Data Management

##  Directory Organization

Data are stored on 2 servers:

1. OneDrive (The cloud storage service used by Penn State)
2. Roar Collab (Penn State's High Performance Computing Cluster)

Survey and task data are stored on both servers, while imaging data is stored on Roar Collab only (due to file size).

Data on OneDrive are stored in the folder: 
b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData

Data on Roar Collab are stored in the folder:
storage/group/klk37/default/R01_Marketing

On OneDrive, the directory structure looks like:
- b-childfoodlab_Shared
  - Active_Studies
    - MarketingResilienceRO1_8242020
      - ParticipantData
         - **untouchedRaw**
         - **bids**
           - **sourcedata**
           - **rawdata**
           - **phenotype**
           - **derivatives**
           - **code**
  
On Roar Collab, the directory structure looks like:
- storage
  - group
    - klk37
      - default
        - R01_Marketing 
           - **untouchedRaw**
           - **bids**
             - **sourcedata**
             - **rawdata**
             - **phenotype**
             - **derivatives**
             - **code**

Notice that the sub-directories within ParticipantData/ (on OneDrive) and R01_Marketing/ (on Roar Collab) are the same. This enables syncing files in untouchedRaw/ and bids/ between the servers. The contents of these folders are summarized in Table 2 and detailed in subsections below.

Table 2. Data directories and descriptions
| Directory    | Description |
| -------- | ------- |
| untouchedRaw  |  Contains task data in its rawest form. Data in this folder serves as a backup and should never be directly worked from.  |
| bids | Contains survey*, task, and neuroimaging data across differnt stages of processing, organized according to BIDS standards   |
| bids/sourcedata    | Contains copies of task and neuroimaging data from untouchedRaw and survey data downloaded from redcap. Data in this folder will be organized into bids/rawdata and bids/phenotype 
| bids/rawdata    | Contains task and neuroimaging data organized according to BIDS standards|
| bids/phenotype    | Contains survey data organized according to BIDS standards |
| bids/derivatives    | Contains processed data or generated datasets |
| bids/code    | Contains code to organize and process data within bids/ |

\* Survey refers to data collected in survey format via redcap, including questionnaires and researcher-entered data (e.g., intake measurements) 


### untouchedRaw

untouchedRaw/ contains task and MRI data transferred directly from the source. For task data, the source is where the task program exports the data; for imaging (DICOM) data, the source is where SLEIC uploads the data. untouchedRaw/ is organized by task, such that data for each task is found within a task-specific folder:

  - untouchedRaw
    - foodview_task
    - hrv
    - nih-toolbox
    - pit_task
    - rrv_task
    - rsa
    - space_game
    - sst
    - tictach_task
    - DICOMS * 

*DICOMS are stored on Roar Collab only due to size

### bids

Data within bids/ are organized to comply with the [Brain Imaging Data Structure](https://bids.neuroimaging.io/). 

### bids/sourcedata

bids/sourcedata/ contains copies of data from untouchedRaw/. However, data are now organized by subject and session: each subject has a folder (sub-{label}) in /sourcedata, and within each subject folder are session folders (ses-{label}). Session folders  separate data collected at baseline (REACH visits 1 through 4) and follow-up (REACH visit 5). Within session folders, task data are stored in beh/ and MRI data are stored in dicom/. 

bids/sourcedata/ also contains survey data downloaded from REDCap, stored in /phenotype.

This looks like: 
- bids
  - sourcedata
    - sub-{label}
      - ses-1
        - dicom
          - [Imaging data collected at baseline]
        - beh
          - [Task files collected at baseline]
      - ses-2
        - beh
          - [Task files collected at follow-up]
    - phenotype
      - [redcap .tsv files]


### bids/rawdata

This folder contains "raw" task and MRI data that has been minimally processed from [bids/sourcedata/](#bidssourcedata) to comply with BIDS standards. When publically sharing task and MRI data, this is the data that gets shared. Similar to bids/sourcedata/, bids/rawdata/ is organized by subject and session. However, subdirectories will differ by modality: MRI data is stored in fmap/, func/, and anat/. Task data is stored in func/ if it was collected alongside fMRI data and beh/ if it was not.

Meta-data for files in bids/rawdata are stored in corresponding JSON files. For MRI data (i.e., nii.gz files), JSONS are subject specific, so they are stored in subject folders alongside the MRI data. For task data (i.e., TSV files), JSONS are stored directly in rawdata/ and apply to all corresponding files in subject and session directories.

This looks like: 
- bids
  - rawdata/
    - [Behavioral task meta-data JSONS]
    - sub-{label}/
      - ses-1/
        - fmap/
          - [Field map MRI data - these will end with *.nii.gz]
          - [Field map meta-data JSON files]
        - func/
          - [fMRI data for Food View Task and SST - these will end with *.nii.gz]
          - [fMRI meta-data JSON files]
          - [Behavioral data for Food View task and fMRI SST - these will end with *_events.tsv]
        - anat/
          - [Structural MRI data - these will end with *.nii.gz]
          - [Structural MRI meta-data JSON file]
        - beh/
          - [Behavioral data for tasks *not* collected alongside fMRI data - these will end with *_beh.tsv]
      - ses-2/
        - beh/
          - [Behavioral data for tasks *not* collected alongside fMRI data - these will end with *_beh.tsv]

Remember, MRI data (i.e., nii.gz files) will only exist on Roar Collab due to size. Task data (i.e., TSV files) can be synced between OneDrive and Roar Collab. 

### bids/phenotype

This folder contains questionnaire, intake, anthropometrics, and dexa data stored in .tsv files. Data for each survey is saved in its own file. TSVs contain raw data, and can also contain derivative data (e.g., questionnaire scores, computed variables). Each data file is accompanied by a JSON meta-data file.

For example:

- bids
  - phenotype
    - {survey-name}.tsv
    - {survey-name}.json


### bids/derivatives

This folder contains datasets that have been processed or derived from data in [bids/rawdata/](#bidsrawdata). The following derivative datasets have been created:

- bids
  - derivatives
    - fmriprep_v2320
      - [Preprocessed fmri data, output of fmriprep version 23.2.0]
    - beh
      - [TSV files with summary metrics for each behavioral task]



### bids/code


## Data Processing Software

### R01_Marketing
* [https://github.com/bfuchs18/R01_Marketing](https://github.com/bfuchs18/R01_Marketing)
* This github repository contains a collection of scripts developed to processess and analyze REACH data. The scripts in this repositiory use the software outlined below. 



### dataREACHr
* [https://github.com/bfuchs18/dataREACHr](https://github.com/bfuchs18/dataREACHr)
* This is an R package that contains functions to process and organize survey and task data into bids/phenotype and bids/rawdata, respectively.
    * Use of this package requires the directory structure described [here](#directory-organization)

  * dataREACHr can be installed from github in R using the devtools package:
```
devtools::install_github("bfuchs18/datareachr")
```


### dataprepr

* [https://github.com/alainapearce/dataprepr](https://github.com/alainapearce/dataprepr)
* This is an R package that contains functions to score a variety of validated questionnaires
  * This is a dependecy of [dataREACHr](#datareachr)
  * Dataprepr can be installed from github in R using the devtools package:

```
devtools::install_github("alainapearce/dataprepr")
```

### dcm2bids
*  [https://unfmontreal.github.io/Dcm2Bids/3.1.1/](https://unfmontreal.github.io/Dcm2Bids/3.1.1/)
*  This is a program that reorganises NIfTI files into the Brain Imaging Data Structure (BIDS).
*  Data processing scripts expect dcm2bids to be loaded via a conda environment described in /bids/code/dcm2bids/dcm2bids.yml. 

The conda env can be created from the yml file using the following commands on Roar Collab
```
# if conda has not been initialized, may need to run this first and then close and reopen terminal
conda init bash 

# Navigate to yml file
cd /storage/group/klk37/default/R01_Marketing/bids/code/dcm2bids/

# Load anaconda
module load anaconda

# Create a conda environment based on yml file
## Note, this will create the conda env in a user-specific directory, so every user has to create their own environemnt
conda env create -f dcm2bids.yml

# activate enviroment
conda activate dcm2bids
```


### pydeface
*  [https://github.com/poldracklab/pydeface](https://github.com/poldracklab/pydeface)
*  This is a tool to remove facial structure from (i.e., "deface") MRI images. 
*  Data processing scripts expect pydeface to be loaded via a conda environment described in /bids/code/dcm2bids/dcm2bids.yml. See the [dcm2bids](#dcm2bids) section for details on how to create the conda environment.

### mriqc
* [https://mriqc.readthedocs.io/en/stable/index.html](https://mriqc.readthedocs.io/en/stable/index.html)
* MRIQC extracts no-reference IQMs (image quality metrics) from structural (T1w and T2w) and functional MRI (magnetic resonance imaging) data. 

The container (will be) created by running the following command on Roar Collab
```
singularity build /storage/group/klk37/default/sw/mriqc-24.0.0.simg  docker://nipreps/mriqc:24.0.0
```


### fmriprep
* [https://fmriprep.org/en/stable/outputs.html](https://fmriprep.org/en/stable/outputs.html)
* fMRIprep is a preprocessing software for MRI data
* On Roar Collab, fMRIprep version 23.2.0 is available in a Singularity Container within /storage/group/klk37/default/sw/fmriprep-23.2.0.simg. By using this singularity container, we can use a version of fMRIprep that is not presently available to all users of Roar Collab.

The container was created by running the following command on Roar Collab
```
singularity build /storage/group/klk37/default/sw/fmriprep-23.2.0.simg docker://nipreps/fmriprep:23.2.0
```

* Version 23.2.0 was selected for processing because it is (or was) the most recent version available, however, v23.2.0 does not have the pediatric MNI template available for normalization. For use of other versions, a separate singularity container can be prepared by specifying a different version number in the command above

### afni

## Data Processing Pipeline

### Overview
Here, data processing refers to the steps required to get data from its source into [bids/phenotype](#bidsphenotype) and [bids/rawdata](#bidsrawdata). 

Broadly, this involves:
1. Retrieving data from the source
   1. This typically involves manual transfer of data onto OneDrive or RoarCollab
2. Running processing scripts

While survey and task data could be processed on OneDrive or Roar Collab, the pipeline outlined below involves processing survey and task data "locally" (i.e., from one's own computer with synced OneDrive files) and then syncing processed data with Roar Collab. MRI data is processed on Roar Collab. 

<img src="./images/REACH_processing_pipeline.png" alt="drawing" width="600"/>

### Required access
Implementing the described pipeline will require access to projects/folders in:
- REDCap (online data collection software)
- OneDrive (Microsoft's cloud storage service used by Penn State)
- Hoth (server where SLEIC uploads imaging data)
- Roar Collab (Penn State's High Performance Computing Cluster)

Steps to aquire access are outlined in Table X.

Table X. Access required for data processing
<div style="font-size: 12px;">

| Server | Project/Folder | Getting Server Access | Getting project/folder access | Required To... |
| -------- | ------- | ------- | ------- | ------- |
| REDCap | 'Food Marketing Resilience/Project REACH' and 'REACH Data Double Entry' projects | Go to https://ctsi.psu.edu/research-support/redcap/ and select "REQUEST REDCAP ACCESS (NEW USERS"; Requires REDCap training | ask Kathleen Keller (klk37@psu.edu) to grant access | retrieve Survey data from source |
| OneDrive |  b-childfoodlab_Shared/ | ?? | ask Kathleen Keller (klk37@psu.edu) to grant access | store task and survey data in shared location |
| Hoth |  /nfs/imaging-data/3Tusers/klk37/mrkt/ | email	l-sleic-helpdesk@lists.psu.edu and request access, cc Kathleen Keller (klk37@psu.edu)  | email	l-sleic-helpdesk@lists.psu.edu and request access, cc Kathleen Keller (klk37@psu.edu) | retrieve MRI data from source |
| Roar Collab |  storage/group/klk37/ | follow instructions at https://www.icds.psu.edu/account-setup/  | email iask@ics.psu.edu and request access, cc Kathleen Keller (klk37@psu.edu) | store MRI data in shared location; process MRI data; sync task and survey data from OneDrive |

<div style="font-size: 16px;">

### Retriving data from the source

#### Survey (redcap) data

To transfer survey data from source (REDCap) to OneDrive:
   1. Log in to redcap
   2. Download visit data
      1. Navigate to the REDCap project: Food Marketing Resilience/Project REACH
      2. Select 'Data Exports, Reports, and Stats'
      3. Select 'Export data' for the Report Name '**All data** (all records and fields)'
      4. Choose export format: 'CSV/Microsoft Excel (raw data)'
      5. Select export then click icon to download
      6. Transfer file to OneDrive Folder: b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/bids/sourcedata/phenotype
   3. Download double-entry data
      1. Navigate to the REDCap project: REACH Data Double Entry
      2. Select 'Data Exports, Reports, and Stats'
      3. Select 'Export data' for the Report Name '**All data** (all records and fields)'
      4. Choose export format: 'CSV/Microsoft Excel (raw data)'
      5. Select export then click icon to download
      6. Transfer file to OneDrive Folder: b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/bids/sourcedata/phenotype

#### Task data

To copy task data from its source to OneDrive:
   1. Locate task data at the source
      1. This location is task-specfic; it is typically on the computer used to administer the task (Table X)
   2. Copy data onto OneDrive into the task-specific folder in [untouchedRaw/](#untouchedraw) (i.e., b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/untouchedRaw/)
      1. This should happen as soon as possible after data is collected. 
         1. Unlike OneDrive, the computers used for task data collection are not permanent storage locations and are not backed up. 
         2. Do not delete the data from the source. It can remain in that location as a backup until computer resources require files to be removed.
   3. If needed, rename the file in untouchedRaw to adhere to the expected file naming convention (Table X),
  
Table X. Copying Task Data to untouchedRaw
<div style="font-size: 12px;">

| Task    | Data to tranfer | Where data is initially exported | Folder in untouchedRaw | untouchedRaw Naming Convenction |
| ------ | ------ | ------ | ------ | ----- |
| Reinforcing Value of Food Task | | On the laptop used for administation in XXX | rrv_task |
| Stop Signal Task | stop_onsets-{ID}.txt <br> stop-{ID}.txt | On the laptop used for administation in XX| sst | stop_onsets-{ID}.txt <br> stop-{ID}.txt
| Food View Task | foodview_onsets-{ID}.txt <br> foodview-{ID}.txt | On the laptop used for administation in XX | foodview_task | foodview_onsets-{ID}.txt <br> foodview-{ID}.txt
| NIH Toolbox | '{Date} Assessment Data.csv' <br> '{Date} Assessment Scores.csv'  <br> '{Date} Registration Data.csv' | | nih-toolbox |
| Space Game | | |  space_game |
| Pavlovian-to-Intrumental Transfer Task | | On the laptop used for administration in: C:\Project REACH\PIT_Task\Food_PIT| pit_task |

<div style="font-size: 16px;">

#### MRI data
To copy MRI data from its source (Hoth) to Roar Collab:

### Running data processing scripts

#### Survey and Task Data

Survey and task data are both processed using the script [beh_into_bids.R](https://github.com/bfuchs18/R01_Marketing/blob/master/ParticipantData/bids/code/beh_into_bids.R) which is shared in the [R01_Marketing GitHub Repository](##r01_marketing).

beh_into_bids.R was written to process files stored in OneDrive, provided they are synced to a local computer and the script is run locally. After processing data locally, beh_into_bids.R syncs data to Roar Collab.

Therefore, running beh_into_bids.R requires:
1. That [R](#r) is installed
2. That the R package [dataREACHr](#datareachr) its dependencies, including [dataprepr](#dataprepr), are installed. Details about installing dataREACHr and dataprepr can be found [here](#data-processing-software).
3. That the user has OneDrive files synced to their computer
4. That the script correctly specifies (1) the path to ParticipantData on OneDrive, (2) the names of REDCap files in sourcedata, and (3) the PSU user ID. To specify this information, modify the following lines of code in beh_into_bids.R:
```
#### user setup (modify variables here) ####

# set path to ParticipantData directory on OneDrive (contains bids/ and untouchedRaw/)
base_dir = "/Users/baf44/Library/CloudStorage/OneDrive-ThePennsylvaniaStateUniversity/b-childfoodlab_Shared/Active_Studies/MarketingResilienceRO1_8242020/ParticipantData/"

# set redcap file names
visit_file_name =  "FoodMarketingResilie_DATA_2024-05-03_1132.csv"
double_entry_file_name = "REACHDataDoubleEntry_DATA_2024-04-08_1306.csv"

# Penn State user ID
## needed for syncing data between OneDrive and Roar Collab
user_id = "baf44"

```


Overview of beh_into_bids.R:

- Survey data is processed using dataREACHr::proc_redcap(). This function:
  * Imports visit and double-entry data downloaded from redcap
  * Calls dataREACHr and dataprepr functions to extract, process, and score data
  * Exports participants.tsv data files and participants.json meta-data files into [bids/](#bids).
  * Exports {survey}.tsv data files and {survey}.json meta-data files into [bids/phenotype/](#bidsphenotype).
- Task data is processed using dataREACHr::proc_task(). This function:
  * Copies task data from [bids/untouchedRaw](#untouchedraw) into [bids/sourcedata/](#bidssourcedata)
    * This is done with util_org_sourcedata(), which presently copies data for: food view task, stop signal task
  * Processes and exports task data into [bids/rawdata/](#bidsrawdata) for:
    * food view task (using util_task_foodview())
    * SST (using util_task_sst())
  * Exports a meta-data JSON file into bids/rawdata for the following tasks: foodview_bold, sst_bold, sst_beh
    * Done using write_task_jsons()
- Survey and Task data in untouchedRaw/ and bids/ on OneDrive are synced to Roar Collab using rsync

### Neuroimaging data



### Software Required

* Python

Mac

Windows


* Matlab

Mac

Windows

* R

Mac

Windows

* LaTex

Mac

Windows


## Data Quality Control


## Data Documentation

details on codebook (need to make) and variable descriptions (.jsons)

## Pre-Processing Pipeline

narative overview with steps...  
image of pipeline  

### Installation Instructions

#### Python

Mac

Windows

#### R

Mac

Windows

#### Matlab

Mac

Windows

#### LaTex

Mac

Windows

### Pipeline Execution

#### 1) Raw Data

##### 1a) Exporting

##### 1b) Quality Control

#### 2) ...

# Interactive Reports and Tables

description or reports through .Rmd

# Analyses: Guidelines for Reproducibility and Documentation

