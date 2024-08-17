# SCALP-DynamicNoise
EEG Experiment written with [Matlab](https://www.mathworks.com/products/matlab.html) and [Psychtoolbox](http://psychtoolbox.org/) for the Reed College [SCALP Lab](https://www.reed.edu/psychology/scalp/). 

Close to the threshold of detection, participants' ability to detect critical stimuli varies non-linearly with the strength of the stimulus, reflecting the so-called bifurcation of conscious experience. This experiment is designed to present near-threshold stimuli so that an electroencephalogram can record neural activity that might covary with bifurcated behavioral performance. To produce stronger event-related potentials from stimuli at the threshold of detection, continuous dynamic noise, like static on a TV, is presented to obscure the critical stimuli without introducing confounding ERPs (as other techniques like temporal masking do). Additionally, this experiment implements a no-report condition with a distractor task so that stimulus-related brain activity can be observed in the absence of task-related brain activity.

The experiment requires about an hour of active participant attention, although participants should be encouraged to take at least 20-30 second breaks at every opportunity so that the total time including breaks might approach 2 hours. 

# This Repo Contains:
- Matlab 2022b code for running the above experiment.
- A series of small feature demos for the critical stimuli and distractor stimuli
- A behavioral pilot experiment (much shorter, and not designed for EEG data collection)
- Some scripts for data analysis and "notebook" style analyses of pilot data

# How to Run.
Just run "mainExperiment.m" from the Matlab IDE making sure that the "Helpers" and "Utilities" folders as well as all .yaml config files are in the same working directory. Then what happens?

You'll be prompted if you want to run the experiment in dev mode: clicking "Yes" will prompt you with a series of settings (mostly for testing), to run participants you probably wont want to change these and you can just press "No". You'll be shown a gui to enter participant info, and then the experiment will begin. At any time, the experiment can be cancelled by clicking "Cancel" in a gui or by hitting the escape key during the main experiment. Data is saved at the end of every section (quest, report, no report), but not before, so quitting the experiment mid-section will lose all data from that section.

## Quest
The Experiment has 3 main sections with instrutions before each. The "Quest" section is always first and is the shortest; Quest refers to the interleaved staircase method, see the [1983 paper](https://link.springer.com/article/10.3758/BF03202828) by Watson and Pelli or the [Psychtoolbox documentation](http://psychtoolbox.org/docs/Quest). In this section the participant is introduced to the main task of detecting gabor patch orientations in a two way forced choice and their psychometric threshold for detection (such that they see the stimulus half the time) is determined from the accuracy of their responses over 3 blocks of 60 trials; EEG data does not need to be collected during this section. 

## Report
The order of the remaining two sections, "Report" and "No Report" is randomized for each participant, and both sections contain 18 blocks of 42 trials. The "Report" section begins with instructions for the PAS subjective scale (see [2015 paper](https://doi.org/10.1093/acprof:oso/9780199688890.003.0011) by Sandberg and Overgaard) and proceeds much like the Quest section, now using 6 fixed contrast levels: 2 levels below threshold, one at the threshold obtained in the Quest section, 2 above threshold, and one blank. Participants are shown stimuli presented with continuous dynamic noise and on each trial participants are asked to perform a two way forced choice about the stimulus orientation and now they are also asked to subjectively gauge their experience on a 4 point PAS measure. 

## No Report
In the "No Report" section participants are shown continuous noise with the critical gabor stimuli occasionally appearing in the noise at 6 contrast levels described in the report section, however, participants are not asked to respond to the critical stimuli with either the two way forced choice task or the PAS task. Instead, participants are instructed to pay attention to a distractor task that is spatially colocalized with the gabor stimuli but appears at different times. The distractor is a coherent motion effect also embedded in the dynamic noise. Participants press a key when they see this.

# How is the code organized?
Badly! Haha jk... unless....


# Changelog
- 8-16-24 wrote Readme
