# ====================================================================
# === Draw scatter plots for ER variables and inhibition abilities ===
# ====================================================================

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
library(ggplot2)
library(cowplot)
library(dplyr)
library(grid)
library(gridExtra)
library(mgcv)
library(patchwork)

# set random number seed
set.seed(2737)

# load data
df = read.delim('code/derivatives/main.txt', sep = '\t', header = TRUE)

# ---------------------------
# -- makescatter function ---
# ---------------------------

makescatter = function(df, xvar, yvar, xlabel, ylabel, fillcol, show.y = TRUE, dotalpha = 1, dotsize = 1) {

  # prepare data.frame
  df = df[,c(yvar,xvar)]
  df = df[complete.cases(df),]

  # linear or generalized additive model?
  names(df) = c('ERsucc', 'Inhibition')
  mod_lm = gam(ERsucc ~ Inhibition, data = df)
  mod_gam = gam(ERsucc ~ s(Inhibition), data = df)
  anova.tmp = anova(mod_lm, mod_gam, test = 'Chisq')
  if (summary(mod_gam)$s.pv < 0.05 & anova.tmp$Df[2] >= 1 & anova.tmp[2, 'Pr(>Chi)'] < 0.05) {
    geom.smooth = geom_smooth(method = mgcv::gam, formula = y ~ s(x), se = TRUE, size = 0.25, color = "black", fill = 'red', alpha = 0.2)
  } else {
    geom.smooth = geom_smooth(method = mgcv::gam, formula = y ~ x, se = TRUE, size = 0.25, color = "black", alpha = 0.2)
  }
  names(df) = c(yvar,xvar)
  
  # get some statistics
  lm.R2 = format(round(summary(mod_lm)$r.sq,3), nsmall = 3)
  gam.R2 = format(round(summary(mod_gam)$r.sq,3), nsmall = 3)
  if (summary(mod_lm)$p.pv[[2]] < 0.01) { lm.p = formatC(summary(mod_lm)$p.pv[[2]], format = 'e', digits = 0) } else { lm.p = format(round(summary(mod_lm)$p.pv[[2]],2), nsmall = 2) }
  if (summary(mod_gam)$s.pv < 0.01) { gam.p = formatC(summary(mod_gam)$s.pv, format = 'e', digits = 0) } else { gam.p = format(round(summary(mod_gam)$s.pv,2), nsmall = 2) }
  if (anova.tmp$Df[2] < 1) { anova.p = '1.00' } else if (anova.tmp[2, 'Pr(>Chi)'] < 0.01) { anova.p = formatC(anova.tmp[2, 'Pr(>Chi)'], format = 'e', digits = 0) } else { anova.p = format(round(anova.tmp[2, 'Pr(>Chi)'],2), nsmall = 2) }
  info = paste0('LM vs. GAM: p = ',  anova.p, '\nLM: R2 = ', lm.R2, ', p = ', lm.p, ' | GAM: R2 = ', gam.R2, ', p = ', gam.p)
  
  # show y axis title?
  if (show.y == TRUE) {
    show.y = theme(axis.title.y = element_text(size = 10, hjust = 0.5, angle = 90, margin = margin(t = 0, r = 5, b = 0, l = 0)))
  } else {
    show.y = theme(axis.title.y = element_blank())
  }
  
  # draw plot
  ggplot(df, aes_string(x = xvar, y = yvar)) +
    ggtitle(info) +
    geom.smooth +
    geom_rug(colour = fillcol, alpha = 0.5) +
    geom_point(shape = 20, alpha = dotalpha, colour = fillcol, size = dotsize) +
    ylab(ylabel) +
    xlab(xlabel) +
    theme_bw(base_size=10) +
    theme(plot.margin = unit(c(3, 3, 3, 3), "mm"),
          panel.border = element_rect(size = 0.25),
          line = element_line(size=0.25),
          plot.title = element_text(size = 4, angle = 0, hjust = 0.5, vjust = -2, lineheight = 1.1),
          axis.title.x = element_text(size = 10, angle = 0, hjust = 0.5),
          axis.title.y = element_blank(),
          axis.text.x = element_text(size = 8),
          axis.text.y = element_text(size = 8),
          axis.ticks = element_line(size = 0.25),
          ) +
    show.y
}

# set x variables and labels
xvars = c('Inhibit_ies_antisaccade', 'Inhibit_ies_stroop', 'Inhibit_stopsignal', 'Inhibit_ies_flanker', 'Inhibit_ies_shapematching', 'Inhibit_ies_wordnaming', 'Inhibit_ies_latent')       
xlabels = c('Antisaccade', 'Stroop', 'Stop signal', 'Flanker', 'Shape matching', 'Word naming', 'Latent trait')
xabbrev = c('as.ies', 'st.ies', 'ss.ies', 'fl.ies', 'sm.ies', 'wn.ies', 'latent')

# make scatter plots
measure = c('valence', 'arousal', 'corru', 'hp', 'scr', 'ERQ_reap', 'ERQ_supp')
for (i in measure) {
  if (substring(i,1,3) != 'ERQ') { yvars = paste0(c('ERsucc_neg_', 'ERsucc_'),i); ylabels = c('ER success (negative)', 'ER success') } else { yvars = i; ylabels = c('ERQ reappraisal', 'ERQ suppresion') }
  for (j in 1:length(xvars)) {
    for (k in 1:length(yvars)) {
      tmp = makescatter(df = df, xvar = xvars[j], yvar = yvars[k], xlabel = xlabels[j], ylabel = ylabels[k], fillcol = "#13848F", show.y = FALSE)
      assign(paste0(yvars[k], '_', xabbrev[j]),tmp)
    }
  }
}

# merge plots for valence, arousal, corrugator, heart period and skin conductance response
blank = ggplot()+geom_blank(aes(1,1)) + cowplot::theme_nothing()
measure = c('valence', 'arousal', 'corru', 'hp', 'scr')
for (i in measure) {
  a = arrangeGrob(get(paste0('ERsucc_neg_',i,'_as.ies')), get(paste0('ERsucc_neg_',i,'_ss.ies')), get(paste0('ERsucc_neg_',i,'_st.ies')), get(paste0('ERsucc_neg_',i,'_fl.ies')), nrow = 1, left = textGrob('ER success (negative)', gp=gpar(fontsize=10), rot = 90))
  b = arrangeGrob(get(paste0('ERsucc_neg_',i,'_sm.ies')), get(paste0('ERsucc_neg_',i,'_wn.ies')), get(paste0('ERsucc_neg_',i,'_latent')), blank, nrow = 1, left = textGrob('ER success (negative)', gp=gpar(fontsize=10), rot = 90))
  c = arrangeGrob(get(paste0('ERsucc_',i,'_as.ies')), get(paste0('ERsucc_',i,'_ss.ies')), get(paste0('ERsucc_',i,'_st.ies')), get(paste0('ERsucc_',i,'_fl.ies')), nrow = 1, left = textGrob('ER success', gp=gpar(fontsize=10), rot = 90))
  d = arrangeGrob(get(paste0('ERsucc_',i,'_sm.ies')), get(paste0('ERsucc_',i,'_wn.ies')), get(paste0('ERsucc_',i,'_latent')), blank, nrow = 1, left = textGrob('ER success', gp=gpar(fontsize=10), rot = 90))
  assign(paste0(i,'.grid'), arrangeGrob(a, b, c, d, nrow = 4))
}

# merge plots for ERQ suppression and ERQ reappraisal
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

# get detailed results of comparisons between linear and nonlinear models
measure = c('valence', 'arousal', 'corru', 'hp', 'scr', 'ERQ_reap', 'ERQ_supp')
for (i in measure) {
  
  if (substring(i,1,3) != 'ERQ') {
    yvars = paste0(c('ERsucc_neg_', 'ERsucc_'),i)
  } else {
    yvars = i
  }
  
  results.tmp = data.frame(matrix(NA, nrow = length(yvars)*length(xvars), ncol = 25))
  names(results.tmp) = c('yvar', 'xvar', 'xlabel',
                         'lm.aic', 'lm.sp.criterion', 'lm.rsq', 'lm.intercept', 'lm.estimate', 'lm.estimate.se', 'lm.t.value', 'lm.p.value',
                         'gam.aic', 'gam.sp.criterion', 'gam.rsq', 'gam.edf', 'gam.Ref.df', 'gam.F', 'gam.p.value',
                         'anova.lm.resid.df', 'anova.gam.resid.df', 'anova.lm.resid.dev', 'anova.gam.resid.dev', 'anova.Df', 'anova.Deviance', 'anova.Pr(>Chi)')
  n.row = 0
  for (k in 1:length(yvars)) {
    for (j in 1:length(xvars)) {
      n.row = n.row + 1
      df.tmp = df[,c(yvars[k], xvars[j])]
      df.tmp = df.tmp[complete.cases(df.tmp),]
      names(df.tmp) = c('ERsucc', 'Inhibition')
      mod_lm = gam(ERsucc ~ Inhibition, data = df.tmp)
      mod_gam = gam(ERsucc ~ s(Inhibition), data = df.tmp)
      anova.tmp = anova(mod_lm, mod_gam, test = 'Chisq')
      results.tmp[n.row,] = c(yvars[k], xvars[j], xlabels[j],
                              mod_lm$aic, summary(mod_lm)$sp.criterion[[1]], summary(mod_lm)$r.sq, summary(mod_lm)$p.table[1,1], as.vector(summary(mod_lm)$p.table[2,]),
                              mod_gam$aic, summary(mod_gam)$sp.criterion[[1]], summary(mod_gam)$r.sq, as.vector(summary(mod_gam)$s.table),
                              anova.tmp[, 'Resid. Df'], anova.tmp[, 'Resid. Dev'], anova.tmp[2, 'Df'], anova.tmp[2, 'Deviance'], anova.tmp[2, 'Pr(>Chi)'])
    }
  }
  
  # make numeric and test if additive model outperforms linear model
  results.tmp[,4:ncol(results.tmp)] = sapply(results.tmp[,4:ncol(results.tmp)], as.numeric)
  results.tmp$nonlinear = 0
  results.tmp$nonlinear[results.tmp$gam.p.value < 0.05 & results.tmp$anova.Df > 1 & results.tmp[, 'anova.Pr(>Chi)'] < 0.05] = 1
  names(results.tmp)[ncol(results.tmp)] = 'LM<GAM'
  assign(paste0(i, '.gam'),results.tmp)
}

# save sparse output tables
measure = c('valence', 'arousal', 'corru', 'hp', 'scr', 'ERQ_reap', 'ERQ_supp')
for (i in measure) {
  tmp = get(paste0(i, '.gam'))
  tmp = tmp[,c('yvar', 'xlabel',
               'anova.lm.resid.df', 'anova.lm.resid.dev', 'lm.aic', 'lm.rsq', 'lm.p.value',  
               'anova.gam.resid.df', 'anova.gam.resid.dev', 'gam.aic', 'gam.rsq', 'gam.p.value', 
                'anova.Deviance', 'anova.Df', 'anova.Pr(>Chi)', 'LM<GAM')]
  assign(paste0(i,'.output'), tmp)
  write.table(tmp, paste0('code/tables/gam_', i, '.txt'), sep = '\t', row.names = FALSE, quote = FALSE)
}


# # code snippets
# for (i in measure) {
#   a = arrangeGrob(get(paste0('ERsucc_neg_',i,'_as.ies')), get(paste0('ERsucc_neg_',i,'_ss.ies')), get(paste0('ERsucc_neg_',i,'_st.ies')), get(paste0('ERsucc_neg_',i,'_fl.ies')),
#                   get(paste0('ERsucc_neg_',i,'_sm.ies')), get(paste0('ERsucc_neg_',i,'_wn.ies')), get(paste0('ERsucc_neg_',i,'_latent')), blank, nrow = 2, left = textGrob('ER success (negative)', gp=gpar(fontsize=14), rot = 90))
#   c = arrangeGrob(get(paste0('ERsucc_',i,'_as.ies')), get(paste0('ERsucc_',i,'_ss.ies')), get(paste0('ERsucc_',i,'_st.ies')), get(paste0('ERsucc_',i,'_fl.ies')),
#                   get(paste0('ERsucc_',i,'_sm.ies')), get(paste0('ERsucc_',i,'_wn.ies')), get(paste0('ERsucc_',i,'_latent')), blank, nrow = 2, left = textGrob('ER success', gp=gpar(fontsize=14), rot = 90))
#   assign(paste0(i,'.grid'), arrangeGrob(a, c, nrow = 2))
# }