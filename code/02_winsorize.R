# ===========================
# === Winsorize variables ===
# ===========================

# set working directory
setwd('/Users/philippe/desktop/projects/emotion')

# activate R environment
renv::activate()
renv::restore(prompt = FALSE)

# attach packages to current R session
library(psych)

# load data
df = read.delim('code/derivatives/main.txt', sep = '\t', header = TRUE)

# create list of variables
vars = c(apply(expand.grid(c('neu', 'neg', 'permit', 'distancing', 'neu_permit', 'neu_distancing', 'neg_permit', 'neg_distancing'),c('ER_arousal', 'ER_valence', 'Corru', 'HP', 'SCR'))[c(2,1)], 1, paste, collapse="_"),
        apply(expand.grid(c('valence', 'arousal', 'corru', 'hp', 'scr'),c('ERsucc', 'ERsucc_neg', 'ERsucc_neu'))[c(2,1)], 1, paste, collapse="_"))

# winsorize
winsorized = as.data.frame(lapply(df[,vars], winsor, trim = 0.05))
dfshort.winsor = df
dfshort.winsor[,vars] = winsorized[,vars]
colnames(winsorized) = paste0('Wins_', colnames(winsorized))
dflong.winsor = cbind(df,winsorized)

# save data.frame
write.table(dfshort.winsor, 'code/derivatives/main_winsor.txt', sep ='\t', row.names = FALSE, quote = FALSE)
write.table(dflong.winsor, 'code/derivatives/main_winsor_longlist.txt', sep ='\t', row.names = FALSE, quote = FALSE)
