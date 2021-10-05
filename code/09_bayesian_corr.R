# ==============================================================
# === Carry out Bayesian correlations and save Bayes factors ===
# ==============================================================

# set working directory
setwd('/Users/philippe/Desktop/projects/emotion')

# activate R environment
source("renv/activate.R")
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
  'ERQ_reap', 'ERQ reappraisel',
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

# save results
write.table(output, file = 'code/tables/corr_regulate_inhibit_ies_bayes.txt', quote = FALSE, row.names = F, sep = '\t')
