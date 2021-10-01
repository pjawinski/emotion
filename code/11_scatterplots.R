# ====================================================================
# === Draw scatter plots for ER variables and inhibition abilities ===
# ====================================================================

# set working directory
setwd('/Users/philippe/desktop/projects/emotion')

# activate R environment
renv::activate()
renv::restore(prompt = FALSE)

# attach packages to current R session
library(ggplot2)
library(cowplot)
library(patchwork)
library(grid)
library(gridExtra)

# set random number seed
set.seed(2737)

# load data
df = read.delim('code/derivatives/main.txt', sep = '\t', header = TRUE)

# ---------------------------
# -- makescatter function ---
# ---------------------------

makescatter = function(df, xvar, yvar, xlabel, ylabel, fillcol, show.y = TRUE, dotalpha = 1, dotsize = 1) {

  # prepare data.frame
  df. = df[,c(xvar,yvar)]
  df = df[complete.cases(df),]

  # show y axis title?
  if (show.y == TRUE) {
    show.y = theme(axis.title.y = element_text(size = 10, hjust = 0.5, angle = 90, margin = margin(t = 0, r = 5, b = 0, l = 0)))
  } else {
    show.y = theme(axis.title.y = element_blank())
  }
  
  # draw plot
  ggplot(df, aes_string(x = xvar, y = yvar)) +
    geom_point(shape = 20, alpha = dotalpha, colour = fillcol, size = dotsize) +
    geom_rug(colour = fillcol, alpha = 0.5) +
    geom_smooth(method = 'loess', formula = y ~ x, span = 1, se = TRUE, size = 0.25, color = "black", alpha = 0.2) +
    ylab(ylabel) +
    xlab(xlabel) +
    theme_bw(base_size=10) +
    theme(plot.margin = unit(c(3, 3, 3, 3), "mm"),
          panel.border = element_rect(size = 0.25),
          line = element_line(size=0.25),
          axis.title.x = element_text(size = 10, angle = 0, hjust = 0.5),
          axis.title.y = element_blank(),
          axis.text.x = element_text(size = 8),
          axis.text.y = element_text(size = 8),
          axis.ticks = element_line(size = 0.25),
          ) +
    show.y
}

# set x variables
xvars = c('Inhibit_antisaccade', 'Inhibit_stroop', 'Inhibit_stopsignal', 'Inhibit_flanker', 'Inhibit_shapematching', 'Inhibit_wordnaming',       
          'Inhibit_ies_antisaccade', 'Inhibit_ies_stroop', 'Inhibit_stopsignal', 'Inhibit_ies_flanker', 'Inhibit_ies_shapematching', 'Inhibit_ies_wordnaming', 'Inhibit_ies_latent')
xlabels = c('Antisaccade (%)','Stroop (ms)', 'Stop-signal (ms)', 'Flanker (ms)', 'Shape matching (ms)', 'Word naming (ms)',
            'Antisaccade', 'Stroop', 'Stop signal', 'Flanker', 'Shape matching ', 'Word naming', 'Inhibition')
xabbrev = c('as', 'st', 'ss', 'fl', 'sm', 'wn', 'as.ies', 'st.ies', 'ss.ies', 'fl.ies', 'sm.ies', 'wn.ies', 'latent')

# set y variables
ylabels = c('ER success (negative)', 'ER success')

# make scatter plots
measure = c('valence', 'arousal', 'corru', 'hp', 'scr')
for (i in measure) {
  yvars = paste0(c('ERsucc_neg_', 'ERsucc_'),i)
  for (j in 1:length(xvars)) {
    for (k in 1:length(yvars)) {
      tmp = makescatter(df = df, xvar = xvars[j], yvar = yvars[k], xlabel = xlabels[j], ylabel = ylabels[k], fillcol = "#13848F", show.y = FALSE)
      assign(paste0(yvars[k], '_', xabbrev[j]),tmp)
    }
  }
}

yvars = c('ERQ_reap', 'ERQ_supp')
ylabels = c('ERQ reappraisal', 'ERQ suppresion')

for (j in 1:length(xvars)) {
  for (k in 1:length(yvars)) {
    tmp = makescatter(df = df, xvar = xvars[j], yvar = yvars[k], xlabel = xlabels[j], ylabel = ylabels[k], fillcol = "#13848F", show.y = FALSE)
    assign(paste0(yvars[k], '_', xabbrev[j]),tmp)
  }
}

# merge plots
blank = ggplot()+geom_blank(aes(1,1)) + cowplot::theme_nothing()

for (i in measure) {
  a = arrangeGrob(get(paste0('ERsucc_neg_',i,'_as.ies')), get(paste0('ERsucc_neg_',i,'_ss.ies')), get(paste0('ERsucc_neg_',i,'_st.ies')), get(paste0('ERsucc_neg_',i,'_fl.ies')), nrow = 1, left = textGrob('ER success (negative)', gp=gpar(fontsize=10), rot = 90))
  b = arrangeGrob(get(paste0('ERsucc_neg_',i,'_sm.ies')), get(paste0('ERsucc_neg_',i,'_wn.ies')), get(paste0('ERsucc_neg_',i,'_latent')), blank, nrow = 1, left = textGrob('ER success (negative)', gp=gpar(fontsize=10), rot = 90))
  c = arrangeGrob(get(paste0('ERsucc_',i,'_as.ies')), get(paste0('ERsucc_',i,'_ss.ies')), get(paste0('ERsucc_',i,'_st.ies')), get(paste0('ERsucc_',i,'_fl.ies')), nrow = 1, left = textGrob('ER success', gp=gpar(fontsize=10), rot = 90))
  d = arrangeGrob(get(paste0('ERsucc_',i,'_sm.ies')), get(paste0('ERsucc_',i,'_wn.ies')), get(paste0('ERsucc_',i,'_latent')), blank, nrow = 1, left = textGrob('ER success', gp=gpar(fontsize=10), rot = 90))
  assign(paste0(i,'.grid'), arrangeGrob(a, b, c, d, nrow = 4))
}
   
a = arrangeGrob(ERQ_reap_as.ies, ERQ_reap_ss.ies, ERQ_reap_st.ies, ERQ_reap_fl.ies, nrow = 1, left = textGrob('ERQ reappraisal', gp=gpar(fontsize=10), rot = 90))
b = arrangeGrob(ERQ_reap_sm.ies, ERQ_reap_wn.ies, ERQ_reap_latent, blank, nrow = 1, left = textGrob('ERQ reappraisal', gp=gpar(fontsize=10), rot = 90))
c = arrangeGrob(ERQ_supp_as.ies, ERQ_supp_ss.ies, ERQ_supp_st.ies, ERQ_supp_fl.ies, nrow = 1, left = textGrob('ERQ suppresion', gp=gpar(fontsize=10), rot = 90))
d = arrangeGrob(ERQ_supp_sm.ies, ERQ_supp_wn.ies, ERQ_supp_latent, blank, nrow = 1, left = textGrob('ERQ suppression', gp=gpar(fontsize=10), rot = 90))
assign('erq.grid', arrangeGrob(a, b, c, d, nrow = 4))

# arrange grobs
valence = arrangeGrob(valence.grid, top = textGrob('Valence ratings', gp=gpar(fontsize=13, fontface='bold')))
arousal = arrangeGrob(arousal.grid, top = textGrob('Arousal ratings', gp=gpar(fontsize=13, fontface='bold')))
corru = arrangeGrob(corru.grid, top = textGrob('Corrugator', gp=gpar(fontsize=13, fontface='bold')))
hp = arrangeGrob(hp.grid, top = textGrob('Heart period', gp=gpar(fontsize=13, fontface='bold')))
scr = arrangeGrob(scr.grid, top = textGrob('Skin conductance response', gp=gpar(fontsize=13, fontface='bold')))
erq = arrangeGrob(erq.grid, top = textGrob('ERQ', gp=gpar(fontsize=13, fontface='bold')))

# save as png
png('code/figures/scatter_valence.png', width=7.03, height=9.20, units = "in", res = 600); grid.arrange(valence); dev.off()
png('code/figures/scatter_arousal.png', width=7.03, height=9.20, units = "in", res = 600); grid.arrange(arousal); dev.off()
png('code/figures/scatter_corru.png', width=7.03, height=9.20, units = "in", res = 600); grid.arrange(corru); dev.off()
png('code/figures/scatter_hp.png', width=7.03, height=9.20, units = "in", res = 600); grid.arrange(hp); dev.off()
png('code/figures/scatter_scr.png', width=7.03, height=9.20, units = "in", res = 600); grid.arrange(scr); dev.off()
png('code/figures/scatter_erq.png', width=7.03, height=9.20, units = "in", res = 600); grid.arrange(erq); dev.off()


# # code snippets
# for (i in measure) {
#   a = arrangeGrob(get(paste0('ERsucc_neg_',i,'_as.ies')), get(paste0('ERsucc_neg_',i,'_ss.ies')), get(paste0('ERsucc_neg_',i,'_st.ies')), get(paste0('ERsucc_neg_',i,'_fl.ies')),
#                   get(paste0('ERsucc_neg_',i,'_sm.ies')), get(paste0('ERsucc_neg_',i,'_wn.ies')), get(paste0('ERsucc_neg_',i,'_latent')), blank, nrow = 2, left = textGrob('ER success (negative)', gp=gpar(fontsize=14), rot = 90))
#   c = arrangeGrob(get(paste0('ERsucc_',i,'_as.ies')), get(paste0('ERsucc_',i,'_ss.ies')), get(paste0('ERsucc_',i,'_st.ies')), get(paste0('ERsucc_',i,'_fl.ies')),
#                   get(paste0('ERsucc_',i,'_sm.ies')), get(paste0('ERsucc_',i,'_wn.ies')), get(paste0('ERsucc_',i,'_latent')), blank, nrow = 2, left = textGrob('ER success', gp=gpar(fontsize=14), rot = 90))
#   assign(paste0(i,'.grid'), arrangeGrob(a, c, nrow = 2))
# }