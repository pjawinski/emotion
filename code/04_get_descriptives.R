# ==================================
# === get descriptive statistics ===
# ==================================

# set working directory
setwd('/Users/philippe/Desktop/projects/emotion')

# activate R environment
renv::activate()
renv::restore(prompt = FALSE)

# attach packages to current R session
library(psych)

# load data
raw = read.delim('code/derivatives/main.txt', sep = '\t', header = TRUE)
df = raw[raw$ER_Filename != ' ',]

# ------------------------------------------------
# --- inhibition variables (inverse efficiency) ---
# -------------------------------------------------

# define vars of interest
vars = c('Inhibit_ies_antisaccade', 'Inhibit_ies_stroop', 'Inhibit_stopsignal', 'Inhibit_ies_flanker', 'Inhibit_ies_shapematching', 'Inhibit_ies_wordnaming') # 'Inhibit_antisaccade', 'Inhibit_stroop', 'Inhibit_stopsignal', 'Inhibit_flanker', 'Inhibit_shapematching', 'Inhibit_wordnaming',    
varlabels = c('Antisaccade', 'Stroop', 'Stop-signal', 'Flanker', 'Shape-matching', 'Word-naming') # 'Antisaccade (%)','Stroop (ms)', 'Stop-signal (ms)', 'Flanker (ms)', 'Shape-matching (ms)', 'Word-naming (ms)'

# get descriptive statistics
descr = describe(df[,vars], type = 2)
descr = cbind(descr, as.data.frame(t(sapply(df[,vars], quantile, na.rm = TRUE))))
descr = descr[,c('mean', 'sd', 'min', 'max', '25%', '50%', '75%', 'skew', 'kurtosis')] # descr = descr[,c('mean', 'sd', 'min', 'max', 'skew', 'kurtosis')] 
names(descr) = c('M', 'SD', 'Min', 'Max', 'Q1', 'Q2', 'Q3', 'Skew', 'Kurt') # names(descr) = c('M', 'SD', 'Min', 'Max', 'Skew', 'Kurt') # 
row.names(descr) = varlabels

# write table
write.table(data.frame(Task = row.names(descr), descr), 'code/tables/descr_inhibition_ies.txt', row.names = FALSE, quote = FALSE, sep = '\t')

# ------------------------------------------------
# --- inhibition variables (inverse efficiency) ---
# -------------------------------------------------

# define vars of interest
vars = c('Inhibit_antisaccade', 'Inhibit_stroop', 'Inhibit_stopsignal', 'Inhibit_flanker', 'Inhibit_shapematching', 'Inhibit_wordnaming') # 'Inhibit_antisaccade', 'Inhibit_stroop', 'Inhibit_stopsignal', 'Inhibit_flanker', 'Inhibit_shapematching', 'Inhibit_wordnaming',    
varlabels = c('Antisaccade (%)', 'Stroop (ms)', 'Stop-signal (ms)', 'Flanker (ms)', 'Shape-matching (ms)', 'Word-naming (ms)') # 'Antisaccade (%)','Stroop (ms)', 'Stop-signal (ms)', 'Flanker (ms)', 'Shape-matching (ms)', 'Word-naming (ms)'

# get descriptive statistics
descr = describe(df[,vars], type = 2)
descr = cbind(descr, as.data.frame(t(sapply(df[,vars], quantile, na.rm = TRUE))))
descr = descr[,c('mean', 'sd', 'min', 'max', '25%', '50%', '75%', 'skew', 'kurtosis')] # descr = descr[,c('mean', 'sd', 'min', 'max', 'skew', 'kurtosis')] 
names(descr) = c('M', 'SD', 'Min', 'Max', 'Q1', 'Q2', 'Q3', 'Skew', 'Kurt') # names(descr) = c('M', 'SD', 'Min', 'Max', 'Skew', 'Kurt') # 
row.names(descr) = varlabels

# write table
write.table(data.frame(Task = row.names(descr), descr), 'code/tables/descr_inhibition_rt.txt', row.names = FALSE, quote = FALSE, sep = '\t')

# -------------------------------
# --- ER regulation variables ---
# -------------------------------

# define vars of interest
vars = c(apply(expand.grid(c('neu', 'neg', 'permit', 'distancing', 'neu_permit', 'neu_distancing', 'neg_permit', 'neg_distancing'),c('ER_valence', 'ER_arousal', 'Corru', 'HP', 'SCR'))[c(2,1)], 1, paste, collapse="_"),
         apply(expand.grid(c('valence', 'arousal', 'corru', 'hp', 'scr'),c('ERsucc_neg', 'ERsucc'))[c(2,1)], 1, paste, collapse="_")) # 'ERsucc_neu'

# get descriptive statistics
descr = describe(df[,vars], type = 2)
descr = cbind(descr, as.data.frame(t(sapply(df[,vars], quantile, na.rm = TRUE))))
descr = descr[,c('mean', 'sd', 'min', 'max', '25%', '50%', '75%', 'skew', 'kurtosis')] # descr = descr[,c('mean', 'sd', 'min', 'max', 'skew', 'kurtosis')] 
names(descr) = c('M', 'SD', 'Min', 'Max', 'Q1', 'Q2', 'Q3', 'Skew', 'Kurt') # names(descr) = c('M', 'SD', 'Min', 'Max', 'Skew', 'Kurt') # 

# add measure and condition variables
descr$measure = descr$condition = ""
descr$measure[grep('arousal',rownames(descr))] = 'arousal'
descr$measure[grep('valence',rownames(descr))] = 'valence'
descr$measure[grep('Corru|corru',rownames(descr))] = 'corrugator'
descr$measure[grep('HP|hp',rownames(descr))] = 'heart period'
descr$measure[grep('SCR|scr',rownames(descr))] = 'scr'

descr$condition[grep('neu',rownames(descr))] = 'neutral'
descr$condition[grep('neg',rownames(descr))] = 'negative'
descr$condition[grep('permit',rownames(descr))] = 'permit'
descr$condition[grep('distancing',rownames(descr))] = 'distancing'
descr$condition[grep('neu_permit',rownames(descr))] = 'neutral-permit'
descr$condition[grep('neu_distancing',rownames(descr))] = 'neutral-distancing'
descr$condition[grep('neg_permit',rownames(descr))] = 'negative-permit'
descr$condition[grep('neg_distancing',rownames(descr))] = 'negative-distancing'
descr$condition[grep('ERsucc',rownames(descr))] = 'ER success'
descr$condition[grep('ERsucc_neg',rownames(descr))] = 'ER success (negative)'

# order by measure and condition
descr$measure = factor(descr$measure, levels = c('valence', 'arousal', 'corrugator', 'heart period', 'scr'))
descr$condition = factor(descr$condition, levels = c('negative-permit', 'negative-distancing', 'neutral-permit', 'neutral-distancing', 'negative', 'neutral', 'permit', 'distancing', 'ER success (negative)', 'ER success'))
descr = descr[order(descr$measure, descr$condition),]

# order columns
descr = descr[,c('measure', 'condition','M', 'SD', 'Min', 'Max', 'Q1', 'Q2', 'Q3', 'Skew', 'Kurt')]
names(descr) = c('Measure', 'Condition', names(descr)[3:ncol(descr)])

# write table
write.table(descr, 'code/tables/descr_regulation.txt', row.names = FALSE, quote = FALSE, sep = '\t')
