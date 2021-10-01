# ==============================
# === Calculate correlations ===
# ==============================

# set working directory
setwd('/users/philippe/desktop/projects/emotion')

# activate R environment
renv::activate()
renv::restore(prompt = FALSE)

# attach packages to current R session
library(reshape2)
library(dplyr)
library(scales)
library(ggplot2)
library(ppcor)
library(plotly)
library(htmlwidgets)
library(pwr)

# load data
raw = read.delim('code/derivatives/main.txt', sep = '\t', header = TRUE)
df = raw[raw$ER_Filename != ' ',]

# -------------------------------------------------
# --- makecorr function to compute correlations ---
# -------------------------------------------------

# define function for correlation matrix
makecorr = function(df, varnames, varlabels, covnames = NULL, colvars = NULL, type) {
  
  # prepare data.frame
  if (!is.null(covnames)) { covs = df[,covnames] }
  df = df[,varnames]
  names(df) = varlabels
  
  # make empty data.frames for rho and pval
  df.rho = df.pval = df.n = data.frame(matrix(data = NA, nrow = length(df), ncol = length(df)))
  names(df.rho) = names(df.pval) = names(df.n) = names(df)
  
  # do calculations
  for (i in 1:(length(df)-1)) {
    for (j in (i+1):length(df)) {
      temp.df = df[!is.na(df[,i]) & !is.na(df[,j]),c(i,j)]
      
      if (is.null(covnames)) { 
        temp.corr = cor.test(temp.df[,1], temp.df[,2], method = type)
      } else {
        temp.corr = pcor.test(temp.df[,1], temp.df[,2], covs[!is.na(df[,i]) & !is.na(df[,j]),], method = type)
      }
      
      df.rho[i,j] = df.rho[j,i] = temp.corr$estimate
      df.pval[i,j] = df.pval[j,i] = temp.corr$p.value
      df.n[i,j] = df.n[j,i] = nrow(temp.df)
      
    }
  }
  
  # fill rho diagonal with ones and p diagonal with zeros
  for (i in 1:(length(df))) {
    df.rho[i,i] = 1 
    df.pval[i,i] = 0
    df.n[i,i] = sum(!is.na(df[,i]))
  }
  
  # only keep certain columns
  if (!is.null(colvars)) { 
    df.rho = df.rho[!(varnames %in% colvars), varnames %in% colvars]
    df.pval = df.pval[!(varnames %in% colvars), varnames %in% colvars]
    df.n = df.n[!(varnames %in% colvars), varnames %in% colvars]
    df = df[, !(varnames %in% colvars)]
  }
  
  # add row.names
  df.rho$id = df.pval$id = df.n$id = names(df)
  df.rho = df.rho[,c(length(df.rho),1:(length(df.rho)-1))]
  df.pval = df.pval[,c(length(df.pval),1:(length(df.pval)-1))]
  df.n = df.n[,c(length(df.n),1:(length(df.n)-1))]
  
  # format rho matrix for ggplot
  df.m = melt(df.rho, id="id", variable.name="id_y", value.name="rho", na.rm = F)
  df.m$id = as.character(df.m$id)
  df.m$id = factor(df.m$id, levels=unique(df.m$id))
  df.m$rho = df.m$rho_4color = as.numeric(df.m$rho)
  
  # get rho value where p = 0.05
  sign_threshold = pwr.r.test(n = nrow(df), r = NULL, sig.level = 0.05, power = 0.5, alternative = "two.sided")$r
  # sign_threshold = pwr.r.test(n = nrow(df), r = NULL, sig.level = 0.05/(length(varnames)*(length(varnames)-1)/2), power = 0.5, alternative = "two.sided")$r # Bonferroni-corrected
  
  # use rho as fill gradient - do not color if p value > 0.05
  df.m$pval = as.numeric(reshape2::melt(df.pval, id="id", variable.name="id_y", value.name="pval", na.rm = F)$pval)
  df.m$rho_4color[df.m$pval > 0.05] = NA # df.m$rho_4color[df.m$pval > 0.05/(length(df)*(length(df)-1)/2)] = NA # Bonferroni
  
  # add variables for ggplotly tooltip
  df.m$x = df.m$id
  df.m$y = df.m$id_y
  df.m$n = as.numeric(reshape2::melt(df.n, id="id", variable.name="id_y", value.name="n", na.rm = F)$n)
  df.m$p = sprintf("%.6f", as.numeric(df.m$pval))
  df.m$p[as.numeric(df.m$pval) < 0.000001] = sprintf("%.2g", as.numeric(df.m$pval[as.numeric(df.m$pval) < 0.000001]))
  df.m$r = sprintf("%.6f", as.numeric(df.m$rho))
  
  # draw plots
  for (type in c('plotly', 'ggplot')) {
    if (type == 'plotly') { nudgex = 0 } else { nudgex = 0.25 }
    
    tempplot = ggplot(df.m, aes(id_y, id, fill=rho_4color, textx = x, texty = y, textn = n, textr = r, textp = p)) + 
      geom_tile() + 
      geom_text(data = df.m, aes(label = sprintf("%0.2f", round(rho, 2) + 0)), size=1.8, hjust = 1, nudge_x = nudgex) +
      theme_bw(base_size=10) + 
      theme(legend.position="right",
            panel.grid = element_blank(),
            axis.text.x = element_text(size = 6, angle = 40, hjust = 0),
            axis.text.y = element_text(size = 6),
            panel.border = element_blank(),
            axis.title.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.title.y = element_blank(),
            axis.ticks.y = element_blank(),   
            plot.margin = unit(c(5, 25, 5, 7), "mm")) +
      scale_x_discrete(position = "top") +
      scale_y_discrete(limits = rev(levels(df.m$id))) +
      # scale_fill_gradientn(colours = c("#9E2013", "white", "#294979"), values = rescale(x = c(-1, 0, 1), to = c(0, 1)),  na.value="white", guide = "colourbar", breaks = c(-1, -0.5, 0, 0.5, 1), limits = c(-1,1)) +
      scale_fill_gradientn(colours = c("#9E2013", "#FFDAD8", "white", "white", "white", "#D1F8FF", "#294979"), values = rescale(x = c(-1, -sign_threshold-1E-6, -sign_threshold, sign_threshold, sign_threshold+1E-6, 1), to = c(0, 1)),  na.value="white", guide = "colourbar", breaks = c(-1, -0.5, 0, 0.5, 1), limits = c(-1,1)) +
      guides(fill = guide_colourbar(title = 'rho', direction = 'vertical', title.position = 'top', title.theme = element_text(size = 7, hjust = 0), label.theme = element_text(size = 6, hjust = 0.5), barwidth = 0.6, barheight = 7, ticks = F, limits = c(-1,1)))
    
    if (type == 'plotly') { 
      tempplot = ggplotly(tempplot, tooltip = c("textx", "texty", "textn", "textr", "textp", "textn"), dynamicTicks = FALSE, width = 400, height = 350)
      tempplot = tempplot %>% config(displayModeBar = F) %>% layout(xaxis=list(side = "top", fixedrange=TRUE)) %>% layout(yaxis=list(fixedrange=TRUE))
      tempplot$x$data[[3]]$marker$colorbar$outlinecolor = "transparent"
    }
    
    assign(paste0('df.', type), tempplot)
  }
  
  # return results (rho + pval + n + plot)
  results = list("rho" = df.rho, "pval" = df.pval, "n" = df.n, "ggplot" = df.ggplot, "plotly" = df.plotly)
  results
}

# -----------------------------------------------
# --- Intercorrelations ERsucc and ERsucc_neg ---
# -----------------------------------------------

# define vars of interest (varname + varlabel)
ERsucc_vars = as.data.frame(matrix(c(
  'ERsucc_valence', 'Valence',
  'ERsucc_arousal', 'Arousal',
  'ERsucc_corru', 'Corrugator',
  'ERsucc_hp', 'Heart period',
  'ERsucc_scr', 'SCR',
  'ERQ_reap', 'ERQ reappraisel',
  'ERQ_supp', 'ERQ suppression'), ncol = 2, byrow = T))
names(ERsucc_vars) = c('varnames', 'varlabels')

ERsucc_neg_vars = as.data.frame(matrix(c(
  'ERsucc_neg_valence', 'Valence',
  'ERsucc_neg_arousal', 'Arousal',
  'ERsucc_neg_corru', 'Corrugator',
  'ERsucc_neg_hp', 'Heart period',
  'ERsucc_neg_scr', 'SCR',
  'ERQ_reap', 'ERQ reappraisel',
  'ERQ_supp', 'ERQ suppression'), ncol = 2, byrow = T))
names(ERsucc_neg_vars) = c('varnames', 'varlabels')

# calculate correlations (ignore 'tie' warning)
ERsucc = makecorr(df = df, varnames = ERsucc_vars$varnames, varlabels = ERsucc_vars$varlabels, type = 'spearman')
ERsucc_neg = makecorr(df = df, varnames = ERsucc_neg_vars$varnames, varlabels = ERsucc_neg_vars$varlabels, type = 'spearman')

# draw ggplot as png
png(width = 4.61, height = 2.57, units = "in", res = 600, filename = 'code/figures/corr_regulate.png'); ERsucc$ggplot; dev.off()
png(width = 4.61, height = 2.57, units = "in", res = 600, filename = 'code/figures/corr_regulate_neg.png'); ERsucc_neg$ggplot; dev.off()

# draw plotly as interactive html
# change height and width of plotly like this: results$plotly = results$plotly %>% layout(height = 800, width = 1200)
saveWidget(results$plotly, 'code/figures/corr_regulate.html', selfcontained = TRUE); system('rm -rf code/figures/corr_regulate_files')
saveWidget(results$plotly, 'code/figures/corr_regulate_neg.html', selfcontained = TRUE); system('rm -rf code/figures/corr_regulate_neg_files')

# --------------------------------------------------------------------------
# --- Correlations ER success & ER success (negative) x inhibition (IES) ---
# --------------------------------------------------------------------------

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
  
# calculate correlations (ignore 'tie' warning)
results = makecorr(df = df, varnames = vars$varnames, varlabels = vars$varlabels, colvars = colvars, type = 'spearman')

# draw ggplot as png and plotly as interactive html
png(width = 5.27, height = 4.09, units = "in", res = 600, filename = 'code/figures/corr_regulate_inhibit_ies.png'); results$ggplot; dev.off()

# draw plotly as interactive html
results$plotly = results$plotly %>% layout(height = 527, width = 475)
saveWidget(results$plotly, 'code/figures/corr_regulate_inhibit_ies.html', selfcontained = TRUE); system('rm -rf code/figures/corr_regulate_inhibit_ies_files')

# calculate FDR
FDR = p.adjust(as.vector(unlist(results$pval[2:ncol(results$pval)])), method = 'BH')
FDR = as.data.frame(matrix(FDR, nrow = nrow(results$pval), ncol = ncol(results$pval)-1, byrow = F))
FDR$id = results$rho$id
FDR = FDR[,c(ncol(FDR),1:(ncol(FDR)-1))]
names(FDR) = names(results$rho)
results$FDR = FDR

# create output data frame and get rho, p, and FDR
output = as.data.frame(matrix(NA, nrow = nrow(results$rho), ncol = length(colvars)*3+1))
colnames(output) = c('id', apply(expand.grid( c('rho', 'p', 'FDR'),colvars)[c(2,1)], 1, paste, collapse="."))
output$id = results$rho$id

output[seq(2,ncol(output)-2,3)] = results$rho[,-1]
output[seq(3,ncol(output)-1,3)] = results$pval[,-1]
output[seq(4,ncol(output),3)] = results$FDR[,-1]
    
# write.table
write.table(output, 'code/tables/corr_regulate_inhibit_ies.txt', sep = '\t', row.names = F, quote = F)

# -------------------------------------------------------------------------
# --- Correlations ER success & ER success (negative) x inhibition (RT) ---
# -------------------------------------------------------------------------

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
  'Inhibit_antisaccade', 'Antisaccade',
  'Inhibit_stopsignal', 'Stop-signal',
  'Inhibit_stroop', 'Stroop',
  'Inhibit_flanker', 'Flanker',
  'Inhibit_shapematching', 'Shape-matching',
  'Inhibit_wordnaming', 'Word-naming'), ncol = 2, byrow = T))
names(vars) = c('varnames', 'varlabels')
colvars =  c('Inhibit_antisaccade', 'Inhibit_stopsignal', 'Inhibit_stroop', 'Inhibit_flanker', 'Inhibit_shapematching', 'Inhibit_wordnaming')

# calculate correlations (ignore 'tie' warning)
results = makecorr(df = df, varnames = vars$varnames, varlabels = vars$varlabels, colvars = colvars, type = 'spearman')

# draw ggplot as png and plotly as interactive html
png(width = 5.27, height = 4.09, units = "in", res = 600, filename = 'code/figures/corr_regulate_inhibit_rt.png'); results$ggplot; dev.off()

# draw plotly as interactive html
results$plotly = results$plotly %>% layout(height = 527, width = 475)
saveWidget(results$plotly, 'code/figures/corr_regulate_inhibit_rt.html', selfcontained = TRUE); system('rm -rf code/figures/corr_regulate_inhibit_rt_files')

# calculate FDR
FDR = p.adjust(as.vector(unlist(results$pval[2:ncol(results$pval)])), method = 'BH')
FDR = as.data.frame(matrix(FDR, nrow = nrow(results$pval), ncol = ncol(results$pval)-1, byrow = F))
FDR$id = results$rho$id
FDR = FDR[,c(ncol(FDR),1:(ncol(FDR)-1))]
names(FDR) = names(results$rho)
results$FDR = FDR

# create output data frame and get rho, p, and FDR
output = as.data.frame(matrix(NA, nrow = nrow(results$rho), ncol = length(colvars)*3+1))
colnames(output) = c('id', apply(expand.grid( c('rho', 'p', 'FDR'),colvars)[c(2,1)], 1, paste, collapse="."))
output$id = results$rho$id

output[seq(2,ncol(output)-2,3)] = results$rho[,-1]
output[seq(3,ncol(output)-1,3)] = results$pval[,-1]
output[seq(4,ncol(output),3)] = results$FDR[,-1]

# write.table
write.table(output, 'code/tables/corr_regulate_inhibit_rt.txt', sep = '\t', row.names = F, quote = F)

