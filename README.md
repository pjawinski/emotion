# Individual differences in inhibitory control are not related to emotion regulation         
This page contains the analysis scripts referring to our Article entitled ['Individual differences in inhibitory control are not related to downregulation of negative emotion via distancing'](https://doi.org/10.1037/emo0001135) published in Emotion. We provide a reproducible and portable R environment, all statistical analysis scripts, and the original dataset to re-run our code. Please find [additional materials on the OSF](https://osf.io/9gwe7/).

## Abstract
Evidence suggests that cognitive control and emotional control share partly the same cognitive processes. For example, downregulation of negative emotions requires inhibiting or limiting the expression of a prepotent appraisal of a situation in favor of selecting an alternative appraisal. Although inhibitory control seems to be a particularly relevant process in emotion regulation (ER), previous studies reported inconsistent findings on their relationship, likely because of the application of single task measures in relatively small samples. Therefore, this study implemented a battery of six commonly used inhibitory control tasks in a large sample of young healthy adults (N = 190) and investigated whether inhibitory control is associated with the downregulation of negative emotion. ER was measured via self-reported reappraisal and suppression use and via a laboratory ER task where participants had to distance themselves from emotions in response to negative and neutral pictures. The ER task was accompanied by concurrent physiological measurements of corrugator electromyography (EMG), skin conductance response (SCR), and heart period (HP). Frequentist and Bayesian analyses indicated that inhibitory control was neither associated with self-reported reappraisal and suppression use, nor with successful downregulation of negative emotion via distancing. Compared with HP and SCR, corrugator EMG was the only peripheral physiological measure that was indicative of regulatory success. The findings question the view that inhibitory control represents an underlying process in emotion regulation via distancing, at least at the behavioral level. Further studies should investigate the generalizability of these findings to other ER strategies, tactics, paradigms, and participant groups. <br>

Keywords: emotion regulation; reappraisal; inhibitory control; cognitive control; peripheral physiology<br>

## Folder structure
[code/](code/) - contains all analysis scripts as well as their associated [derivatives](code/derivatives), [tables](code/tables) and [figures](code/figures)<br>
[data/](data/) - contains raw data or imported data files from completed projects on which the current analyses are based<br>
[renv/](renv/) - contains a single file to initiate the R environment (the scripts located in [code/](code/) refer to this file)<br>
[renv.lock](renv.lock) - a list of R packages automatically downloaded and attached to the R environment of this project<br>
[setwd.sh](setwd.sh) - a script to automatically set the working directory in all analysis scripts<br>

## How to use this repository
In order to reproduce our statistical analyses, you should first navigate to the folder where you want the data to be stored (avoid paths with spaces) and clone this repository via the following commands (to be entered in command line):
```
git clone https://github.com/pjawinski/emotion.git
cd emotion
```
You may then update the specified working directory in each analysis script via the following command:
```
./setwd.sh
```
You are now ready to run all scripts located in [code/](code/) according to their numbering one after another. R scripts can be run from command line or from within RStudio. The R environment is activated by the scripts and required packages are downloaded automatically. If you do not have an SPSS license, you may skip the respective SPSS script and continue with the next R script. Our repository comes along with all files derived from the scripts, so that you can basically start from wherever you wish.

## Teaser
![alt text](https://pjawinski.github.io/emotion/code/figures/boxplots.png "Figure 1")
**Figure 1.** Boxplots stratified by emotion regulation measure (valence ratings, arousal ratings, corrugator EMG, heart period, and skin conductance response SCR) and task conditions (top row), as well as examined effects (bottom row). Valence and arousal scores range from -4 ('highly pleasant'/'not at all aroused') to 4 ('highly unpleasant'/'very aroused'). Corrugator and heart period delta represent the difference between trial and baseline measures. Boxes represent the interquartile range (observations between the lower and upper quartile of the ascending distribution), with the solid horizontal line in the box corresponding to the median. Whiskers extend to the furthest observation within 1.5 times the interquartile range from the lower and upper quartile. Dots represent single observations, jittered horizontally to avoid overplotting.
