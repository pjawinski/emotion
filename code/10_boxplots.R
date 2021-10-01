# =======================================================
# === Draw boxplots for emotion regulation conditions ===
# =======================================================

# set working directory
setwd('/Users/philippe/desktop/projects/emotion')

# activate R environment
renv::activate()
renv::restore(prompt = FALSE)

# attach packages to current R session
library(ggplot2)
library(cowplot)
library(patchwork)

# set random number seed
set.seed(2737)

# load data
df = read.delim('code/derivatives/main.txt', sep = '\t', header = TRUE)

# calculate negative vs. neutral and permit vs. distancing contrasts
measure = c('ER_valence', 'ER_arousal', 'Corru', 'HP', 'SCR')
for (i in measure) {
  df[[paste0(i,'_neg_minus_neu')]] = as.vector(df[paste0(i,'_neg')] - df[paste0(i,'_neu')])[[1]]
  df[[paste0(i,'_permit_minus_distancing')]] = as.vector(df[paste0(i,'_permit')] - df[paste0(i,'_distancing')])[[1]]
}

# ---------------------------
# -- makeboxplot function ---
# ---------------------------

make.boxplot = function(df, vars, xlabel, ylabel, ylimit, fillcol) {
  
  # prepare data.frame
  df.boxplot = df[,vars]
  df.boxplot = df.boxplot[complete.cases(df.boxplot),]
  colnames(df.boxplot) = c(1:4)
  df.boxplot = stack(df.boxplot)
  names(df.boxplot) = c('score','group')
  df.boxplot = df.boxplot[,c('group','score')]
  df.boxplot$group = factor(df.boxplot$group, levels = c(1:4), labels = xlabel)
  
  # draw plot
  ggplot(df.boxplot, aes(x = group, y = score, fill = fillcol)) +
    stat_boxplot(geom = "errorbar", width = 0.5, lwd = 0.2) +       
    geom_boxplot(fill = fillcol, alpha = 1, outlier.shape = NA, lwd = 0.2) +
    geom_point(alpha= 0.15, size = 0.6, shape = 16, position = position_jitterdodge(), show.legend = FALSE) +
    scale_x_discrete(name = "") +
    scale_y_continuous(limits = ylimit, name = ylabel) +
    theme_bw() +
    theme(plot.margin=margin(5.5,5.5,-1,5.5),
          axis.title = element_text(size = 8),
          axis.title.x = element_text(margin = margin(t = 5, r = 0, b = 0, l = 0)),
          axis.title.y = element_text(size=9,margin = margin(t = 0, r = 0, b = 0, l = 0)),
          axis.text.x = element_text(size=8, angle = 90, hjust=1, vjust=0.5),
          axis.text.y = element_text(size=8),
          #panel.grid.major = element_blank(),
          #panel.grid.minor = element_blank(),
          panel.border = element_rect(size = 0.25),
          line = element_line(size=0.25))
}

# create boxplots for task conditions
suffix = c('_neg_permit', '_neg_distancing', '_neu_permit', '_neu_distancing')
xlabel = c('neg-permit', 'neg-distancing', 'neu-permit', 'neu-distancing')

valence = make.boxplot(df = df, vars = paste0('ER_valence', suffix), xlabel = xlabel, ylabel = expression(paste('Valence rating')), ylimit = c(-4,4), fillcol = "#1B99C1")
arousal = make.boxplot(df = df, vars = paste0('ER_arousal', suffix), xlabel = xlabel, ylabel = expression(paste('Arousal rating')), ylimit = c(-4,4), fillcol = "#1B99C1")
corru = make.boxplot(df = df, vars = paste0('Corru', suffix), xlabel = xlabel, ylabel = expression(paste('Corrugator EMG ',Delta,' (mV)')), ylimit = c(-1.5,3), fillcol = "#1B99C1")
hp = make.boxplot(df = df, vars = paste0('HP', suffix), xlabel = xlabel, ylabel = expression(paste('Heart period ',Delta,' (ms)')), ylimit = c(-50, 125), fillcol = "#1B99C1")
scr = make.boxplot(df = df, vars = paste0('SCR', suffix), xlabel = xlabel, ylabel = expression(paste('SCR (arbitrary units)')), ylimit = c(0,3), fillcol = "#1B99C1")

# create boxplots for contrasts
xlabel = c('negative vs. neutral', 'permit vs. distancing', 'ER success (negative)', 'ER success')
contr_valence = make.boxplot(df = df, vars = c('ER_valence_neg_minus_neu', 'ER_valence_permit_minus_distancing', 'ERsucc_neg_valence', 'ERsucc_valence'), xlabel = xlabel, ylabel = expression(paste('Valence rating')), ylimit = c(-1.5,6), fillcol = "#c05353")
contr_arousal = make.boxplot(df = df, vars = c('ER_arousal_neg_minus_neu', 'ER_arousal_permit_minus_distancing', 'ERsucc_neg_arousal', 'ERsucc_arousal'), xlabel = xlabel, ylabel = expression(paste('Arousal rating')), ylimit = c(-1.5,6), fillcol = "#c05353")
contr_corru = make.boxplot(df = df, vars = c('Corru_neg_minus_neu', 'Corru_permit_minus_distancing', 'ERsucc_neg_corru', 'ERsucc_corru'), xlabel = xlabel, ylabel = expression(paste('Corrugator EMG ',Delta,' (mV)')), ylimit = c(-1.5,4), fillcol = "#c05353")
contr_hp = make.boxplot(df = df, vars = c('HP_neg_minus_neu', 'HP_permit_minus_distancing', 'ERsucc_neg_hp', 'ERsucc_hp'), xlabel = xlabel, ylabel = expression(paste('Heart period ',Delta,' (ms)')), ylimit = c(-100,100), fillcol = "#c05353")
contr_scr = make.boxplot(df = df, vars = c('SCR_neg_minus_neu', 'SCR_permit_minus_distancing', 'ERsucc_neg_scr', 'ERsucc_scr'), xlabel = xlabel, ylabel = expression(paste('SCR (arbitrary units)')), ylimit = c(-1.5,2.1), fillcol = "#c05353")

# merge boxplots
bp = valence + arousal + corru + hp + scr +
contr_valence + contr_arousal + contr_corru + contr_hp + contr_scr + 
plot_layout(nrow = 2, ncol = 5, byrow = TRUE)

# save as pdf and png
# pdf('code/figures/boxplots.pdf', width=6.93, height=6.54); bp; dev.off()
png('code/figures/boxplots.png', width=6.93, height=6.54, units = "in", res = 600); bp; dev.off()

