# =========================================================
# === Friedman Test for ER main and interaction effects ===
# =========================================================

# set working directory
setwd('/users/philippe/desktop/projects/emotion')

# activate R environment
renv::activate()
renv::restore(prompt = FALSE)

# attach packages to current R session
library(psych)

# load data
raw = read.delim('code/derivatives/main.txt', sep = '\t', header = TRUE)
df = raw[raw$ER_Filename != ' ',]

# ----------------------
# --- Friedman tests ---
# ----------------------

# calculate negative vs. neutral and permit vs. distancing contrasts
measure = c('ER_valence', 'ER_arousal', 'Corru', 'HP', 'SCR')
for (i in measure) {
  df[[paste0(i,'_neg_minus_neu')]] = as.vector(df[paste0(i,'_neg')] - df[paste0(i,'_neu')])[[1]]
  df[[paste0(i,'_permit_minus_distancing')]] = as.vector(df[paste0(i,'_permit')] - df[paste0(i,'_distancing')])[[1]]
}

# create run.friedman function
run.friedman = function(df, vars) {
  df = df[, vars]
  df = as.matrix(df[complete.cases(df),])
  fm = friedman.test(df)
  w = fm$statistic/(nrow(df))
  c(fm$parameter[[1]], fm$statistic[[1]], fm$p.value[[1]], w)
}

# create empty results data.frame
results = data.frame(matrix(NA, nrow = 16, ncol = length(measure)))
rownames(results) = apply(expand.grid(c('df', 'chi2', 'pval', 'w'), c('neg_neu', 'permit_distancing', 'ERsucc_neg', 'ERsucc'))[c(2,1)], 1, paste, collapse=".")
colnames(results) = measure

# run Friedman test
for (i in measure) {
  results[1:4,i] = run.friedman(df, paste0(i,c('_neg','_neu')))
  results[5:8,i] = run.friedman(df, paste0(i,c('_permit','_distancing')))
  results[9:12,i] = run.friedman(df, paste0(c('ERsucc_neg_', 'ERsucc_neu_'), gsub('.*_','',tolower(i))))
  results[13:16,i] = run.friedman(df, paste0(i,c('_neg_permit','_neg_distancing')))
}

# save results
write.table(data.frame(statistic = row.names(results),results), 'code/tables/friedman.txt', sep = '\t', row.names = F, quote = F)
