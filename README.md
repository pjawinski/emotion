# Individual differences in inhibitory control are not related to emotion regulation         
This page contains the analysis scripts referring to our manuscript entitled ['Individual differences in inhibitory control are not related to emotion regulation' (PsyArXiv)](https://doi.org/10.31234/osf.io/cd8rx). We provide a reproducible and portable R environment, all statistical analysis scripts, and the original dataset to re-run our code. Please find [additional materials on the OSF](https://osf.io/9gwe7/).

## Abstract
Although cognitive control and emotional control have been proposed to rely on similar cognitive processes, their specific relationship is not well understood. Given that down-regulation of negative emotion requires inhibiting or limiting the expression of a prepotent appraisal of a situation in favor of selecting an alternative appraisal, inhibitory control seems to be a particularly relevant process. However, inconsistent findings on the relationship between inhibitory control and emotion regulation have been reported, likely because of the application of single task measures in relatively small samples. Therefore, this study applied a powerful within-subject design in a large sample (N = 190) and implemented a battery of six commonly used inhibitory control tasks. Emotion regulation was measured via self-reports (habitual use of reappraisal and suppression) and via a laboratory emotion regulation task where participants had to distance themselves from or to actively permit emotions in response to negative and neutral pictures. The emotion regulation task was accompanied by concurrent physiological measurements of corrugator electromyography (EMG), skin conductance response (SCR), and heart period (HP). Frequentist and Bayesian analyses indicated that inhibitory control was neither associated with self-reported reappraisal and suppression use, nor with successful down-regulation of negative emotion via distancing in our sample of young healthy adults. Compared to HP and SCR, corrugator EMG emerged as a suitable peripheral physiological indicator of regulatory success that was indicative of the regulation of negative emotion. <br>

Keywords: emotion regulation; reappraisal; inhibitory control; cognitive control; peripheral physiology<br>

## Folder structure
[code/](code/) - contains all analysis scripts as well as their associated [derivatives](code/derivatives), [tables](code/tables) and [figures](code/figures)<br>
[data/](data/) - contains raw data or imported data files from completed projects on which the current analyses are based<br>
[renv/](renv/) - contains a single file to initiate the R environment (the scripts located in [code/](code/) refer to this file)<br>
[renv.lock](renv.lock) - a list of R packages automatically downloaded and attached to the R environment of this project<br>
[setwd.sh](setwd.sh) - a script to automatically set the working directory in all analysis scripts<br>

## How to use this repository
In order to reproduce our statistical analyses, you should first navigate to the folder where you want the data be stored and the analyses run and clone this repository via the the following commands (to be entered e.g. in the RStudio console):
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
