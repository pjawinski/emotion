# ==============================================================
# === Carry out Bayesian correlations and save Bayes factors ===
# ==============================================================

# set working directory
setwd('/Users/philippe/Desktop/projects/emotion')

# detach 'other packages' if there are any
if (!is.null(names(sessionInfo()$otherPkgs))) {
  invisible(lapply(paste('package:',names(sessionInfo()$otherPkgs),sep=""),detach,character.only=TRUE,unload=TRUE))
}

# activate R environment
if (exists('.rs.restartR', mode = 'function')) { .rs.restartR() }
source('renv/activate.R')
renv::activate(getwd())
renv::restore(prompt = FALSE)

# attach packages to current R session
library(BayesFactor)

# set random number seed
set.seed(81231)

# load data
raw = read.delim('code/derivatives/main.txt', sep = '\t', header = TRUE)
df = raw[raw$ER_Filename != ' ',]

# define vars of interest (varname + varlabel)
vars = as.data.frame(matrix(c(
  'ERsucc_neg_valence', 'Valence | ER success (negative)',
  'ERsucc_neg_arousal', 'Arousal | ER success (negative)',
  'ERsucc_neg_corru', 'Corrugator | ER success (negative)',
  'ERsucc_neg_scr', 'SCR | ER success (negative)',
  'ERsucc_neg_hp', 'Heart period | ER success (negative)',
  'ERsucc_valence', 'Valence | ER success',
  'ERsucc_arousal', 'Arousal | ER success',
  'ERsucc_corru', 'Corrugator | ER success',
  'ERsucc_scr', 'SCR | ER success',
  'ERsucc_hp', 'Heart period | ER success',
  'ERQ_reap', 'ERQ reappraisal',
  'ERQ_supp', 'ERQ suppression',
  'Inhibit_ies_antisaccade', 'IES Antisaccade',
  'Inhibit_stopsignal', 'Stop-signal',
  'Inhibit_ies_stroop', 'IES Stroop',
  'Inhibit_ies_flanker', 'IES Flanker',
  'Inhibit_ies_shapematching', 'IES Shape-matching',
  'Inhibit_ies_wordnaming', 'IES Word-naming',
  'Inhibit_ies_latent', 'Response-Distractor Inhibition'), ncol = 2, byrow = T))
names(vars) = c('varnames', 'varlabels')
colvars =  c('Inhibit_ies_antisaccade', 'Inhibit_stopsignal', 'Inhibit_ies_stroop', 'Inhibit_ies_flanker', 'Inhibit_ies_shapematching', 'Inhibit_ies_wordnaming', 'Inhibit_ies_latent')
rowvars = vars$varnames[!(vars$varnames %in% colvars)]

# create output data frame and get rho, p, and FDR
output = as.data.frame(matrix(NA, nrow = length(rowvars), ncol = length(colvars)*2+1))
colnames(output) = c('measure', apply(expand.grid( c('rho', 'BF'),colvars)[c(2,1)], 1, paste, collapse="."))
output$measure = vars$varlabels[vars$varnames %in% rowvars]

# calculate correlations
for (i in 1:length(rowvars)) {
  for (j in 1:length(colvars)) {
    message(paste0('\n', i, '.', j, ' - ', rowvars[i]), ' X ', colvars[j])
    temp = df[,c(rowvars[i],colvars[j])]
    temp = temp[complete.cases(temp),]
    bfmodel = correlationBF(rank(temp[1]), rank(temp[2]), rscale = 'medium')
    samples = posterior(bfmodel, iterations = 1000000)
    output[i,paste0(colvars[j],'.rho')] = mean(samples[,"rho"])
    output[i,paste0(colvars[j],'.BF')] = extractBF(bfmodel)$bf
  }
}

# calculate BF01
output[seq(3,ncol(output),2)] = 1/output[seq(3,ncol(output),2)]
names(output)[seq(3,ncol(output),2)] = paste0(names(output[seq(3,ncol(output),2)]),'01')

# how many BF01
BF = as.vector(unlist(output[seq(3,ncol(output),2)]))
sum(BF > 1 & BF < 3)/length(BF)
sum(BF > 3 & BF < 10)/length(BF)
median(BF)
sum(BF > 10)/length(BF)

# Bayes factor robustness checks (mainly for Supplement)

# range of prior scales from extremely narrow to ultrawide
priorScale = seq(.01, 1, by = .01)

# global plot parameters
par(mfrow = c(3, 4), mar = c(4, 4, 4, 2))

# calculate and plot Bayes factors 
BF10 = NULL
for (i in 1:length(rowvars)) {
  # empty plot
  plot(range(ps), c(.09,10.5), type = "n", xlab = "Prior Scale", ylab = "BF10", log="y", yaxt="n", main = vars[i, 2])
  axis(2, at = c(.10,1/3,1,3,10), c("1/10","1/3","1","3", "10"), las = 1)
  abline(h = c(.10, 1 / 3, 1, 3, 10), lty = c(3, 3, 1, 3, 3))
  abline(v = 1 / 3, col = 2)
  
  for (j in 1:length(colvars)) {
    # variables to correlate
    message(paste0('\n', i, '.', j, ' - ', rowvars[i]), ' X ', colvars[j])
    temp = df[, c(rowvars[i], colvars[j])]
    temp = temp[complete.cases(temp), ]
    
    # get range of BF10s depending on prior scale
    bf10 = NULL
    for (k in 1:length(ps)) {
      bf10 = c(bf10, as.vector(correlationBF(rank(temp[, 1]), rank(temp[, 2]), rscale = priorScale[k])))
    }
    # add to BF10
    BF10=rbind(BF10, bf10)
    
    # add line to plot
    lines(ps, 1/bf10, col = grey(j/10), lwd = 1.5)
    
    # add legend to first plot
    if (i == 1) {
      legend('bottomright', inset = .025, lwd = 1.5, col = grey((1:7) / 10), vars[13:19, 2], cex = .7)
    }
  }
}

# reset par
par(mfrow=c(1,1),mar=c(5,4,4,2))

# proportion of BF01 in robustness check at different thresholds 
# (used in main text)
BF01 = 1/BF10
propsBF10 = c(sum(BF01 >= 1/3 & BF01 < 1)/length(BF01),
              sum(BF01 >=   1 & BF01 < 3)/length(BF01),
              sum(BF01 >=   3 & BF01 < 10)/length(BF01),
              sum(BF01 >=  10)/length(BF01))
sum(propsBF10)
round(propsBF10*100)
median(BF01)

# save results
write.table(output, file = 'code/tables/corr_regulate_inhibit_ies_bayes.txt', quote = FALSE, row.names = F, sep = '\t')
