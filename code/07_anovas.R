# ==================
# === Run anovas ===
# ==================

# set working directory
setwd('/Users/philippe/Desktop/projects/emotion')

# activate R environment
renv::activate()
renv::restore(prompt = FALSE)

# attach packages to current R session
library(reshape2)
library(rstatix)
library(dplyr)

# ------------------------------------------------
# --- ER success - picture x strategy rm-ANOVA ---
# ------------------------------------------------

# load data
df = read.delim('code/derivatives/main_winsor_longlist.txt', sep = '\t', header = TRUE)

# create list of variables
measure = c('ER_valence', 'ER_arousal', 'Corru', 'HP', 'SCR', 'Wins_ER_valence', 'Wins_ER_arousal', 'Wins_Corru', 'Wins_HP', 'Wins_SCR')

for (i in measure) {
  
  vars = paste0(i, c('_neg_permit', '_neg_distancing', '_neu_permit', '_neu_distancing'))
  
  # create data.frame for anova
  df.anova = df[, c('id', vars)]
  df.anova = df.anova[complete.cases(df.anova),]
  df.anova = melt(df.anova, id="id", variable.name="condition", value.name="score", na.rm = F)
  df.anova$picture = ""
  df.anova$strategy = ""
  df.anova$picture[grep('neg',df.anova$condition)] = 'negative'
  df.anova$picture[grep('neu',df.anova$condition)] = 'neutral'
  df.anova$strategy[grep('permit',df.anova$condition)] = 'permit'
  df.anova$strategy[grep('distancing',df.anova$condition)] = 'distancing'

  # carry out repeated-measures anova and save results
  tmp = anova_test( data = df.anova, dv = score, wid = id, within = c(picture,strategy), effect.size = 'pes')
  assign(paste0(i, '.anova'), tmp)
}

# create results data frame
results = data.frame(matrix(NA, nrow = length(measure), ncol = 15))
colnames(results) = apply(expand.grid(c('F', 'dfn', 'dfd', 'p', 'eta2'),c('picture', 'strategy', 'picture_by_strategy'))[c(2,1)], 1, paste, collapse=".")

k = 0
for (i in measure) {
  k = k +1
  tmp = get(paste0(i,'.anova'))
  results[k,c(1,6,11,2,7,12,3,8,13,4,9,14,5,10,15)] = c(tmp$F,tmp$DFn, tmp$DFd, tmp$p, tmp$pes)
  rownames(results)[k] = i
}

# write.table
write.table(data.frame(measure = rownames(results), results), 'code/tables/anova_ERsucc.txt', sep = '\t', row.names = F, quote = F)

# -------------------------------------------------
# --- ER success (negative) - strategy rm-ANOVA ---
# -------------------------------------------------

# load data
df = read.delim('code/derivatives/main_winsor_longlist.txt', sep = '\t', header = TRUE)

# create list of variables
measure = c('ER_valence', 'ER_arousal', 'Corru', 'HP', 'SCR', 'Wins_ER_valence', 'Wins_ER_arousal', 'Wins_Corru', 'Wins_HP', 'Wins_SCR')

for (i in measure) {
  
  vars = paste0(i, c('_neg_permit', '_neg_distancing'))
  
  # create data.frame for anova
  df.anova = df[, c('id', vars)]
  df.anova = df.anova[complete.cases(df.anova),]
  df.anova = melt(df.anova, id="id", variable.name="condition", value.name="score", na.rm = F)
  df.anova$strategy = ""
  df.anova$strategy[grep('permit',df.anova$condition)] = 'permit'
  df.anova$strategy[grep('distancing',df.anova$condition)] = 'distancing'
  
  # carry out repeated-measures anova and save results
  tmp = anova_test( data = df.anova, dv = score, wid = id, within = c(strategy), effect.size = 'pes')
  assign(paste0(i, '.anova'), tmp)
}

# create results data frame
results = data.frame(matrix(NA, nrow = length(measure), ncol = 5))
colnames(results) = paste0('strategy_', c('F', 'dfn', 'dfd', 'p', 'eta2'))

k = 0
for (i in measure) {
  k = k +1
  tmp = get(paste0(i,'.anova'))
  results[k,] = c(tmp$F,tmp$DFn, tmp$DFd, tmp$p, tmp$pes)
  rownames(results)[k] = i
}

# write.table
write.table(data.frame(measure = rownames(results), results), 'code/tables/anova_ERsucc_neg.txt', sep = '\t', row.names = F, quote = F)

