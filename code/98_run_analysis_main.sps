* Encoding: UTF-8.

* Set working directory.
cd '/users/philippe/desktop/projects/emotion'.

* get dataset.
GET FILE='code/derivatives/main.sav'.
DATASET NAME main.
DATASET ACTIVATE main.
EXECUTE.

********************************************descriptive statistics**********************************************
*age and sex (N=190).
FREQUENCIES VARIABLES=age sex 
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN 
  /ORDER=ANALYSIS.

*age and sex (N=189).
USE ALL.
COMPUTE filter_$=(id ~= "T_102").
VARIABLE LABELS filter_$ 'id ~= "T_102" (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

FREQUENCIES VARIABLES=age sex 
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN 
  /ORDER=ANALYSIS.



*KS-tests and shapiro wilk-tests

*ER: all p <.20 / <.05. 
*einfache Differenz.
EXAMINE VARIABLES=ERsucc_neg_valence ERsucc_neg_arousal ERsucc_neg_corru ERsucc_neg_hp ERsucc_neg_scr
  /PLOT BOXPLOT STEMLEAF NPPLOT 
  /COMPARE GROUPS 
  /MESTIMATORS HUBER(1.339) ANDREW(1.34) HAMPEL(1.7,3.4,8.5) TUKEY(4.685) 
  /PERCENTILES(5,10,25,50,75,90,95) HAVERAGE 
  /STATISTICS DESCRIPTIVES EXTREME 
  /CINTERVAL 95 
  /MISSING PAIRWISE 
  /NOTOTAL.

*doppelte Differenz.
EXAMINE VARIABLES=ERsucc_valence ERsucc_arousal ERsucc_corru ERsucc_hp ERsucc_neg_scr
  /PLOT BOXPLOT STEMLEAF NPPLOT 
  /COMPARE GROUPS 
  /MESTIMATORS HUBER(1.339) ANDREW(1.34) HAMPEL(1.7,3.4,8.5) TUKEY(4.685) 
  /PERCENTILES(5,10,25,50,75,90,95) HAVERAGE 
  /STATISTICS DESCRIPTIVES EXTREME 
  /CINTERVAL 95 
  /MISSING PAIRWISE 
  /NOTOTAL.

*negative permit.
EXAMINE VARIABLES=ER_valence_neg_permit ER_arousal_neg_permit Corru_neg_permit HP_neg_permit SCR_neg_permit 
  /PLOT BOXPLOT STEMLEAF NPPLOT 
  /COMPARE GROUPS 
  /MESTIMATORS HUBER(1.339) ANDREW(1.34) HAMPEL(1.7,3.4,8.5) TUKEY(4.685) 
  /PERCENTILES(5,10,25,50,75,90,95) HAVERAGE 
  /STATISTICS DESCRIPTIVES EXTREME 
  /CINTERVAL 95 
  /MISSING PAIRWISE 
  /NOTOTAL.

*negative distancing.
EXAMINE VARIABLES=ER_valence_neg_distancing ER_arousal_neg_distancing Corru_neg_distancing HP_neg_distancing SCR_neg_distancing 
  /PLOT BOXPLOT STEMLEAF NPPLOT 
  /COMPARE GROUPS 
  /MESTIMATORS HUBER(1.339) ANDREW(1.34) HAMPEL(1.7,3.4,8.5) TUKEY(4.685) 
  /PERCENTILES(5,10,25,50,75,90,95) HAVERAGE 
  /STATISTICS DESCRIPTIVES EXTREME 
  /CINTERVAL 95 
  /MISSING PAIRWISE 
  /NOTOTAL.

*neutral permit.
EXAMINE VARIABLES=ER_valence_neu_permit ER_arousal_neu_permit Corru_neu_permit HP_neu_permit SCR_neu_permit 
  /PLOT BOXPLOT STEMLEAF NPPLOT 
  /COMPARE GROUPS 
  /MESTIMATORS HUBER(1.339) ANDREW(1.34) HAMPEL(1.7,3.4,8.5) TUKEY(4.685) 
  /PERCENTILES(5,10,25,50,75,90,95) HAVERAGE 
  /STATISTICS DESCRIPTIVES EXTREME 
  /CINTERVAL 95 
  /MISSING PAIRWISE 
  /NOTOTAL.

*neutral distancing.
EXAMINE VARIABLES=ER_valence_neu_distancing ER_arousal_neu_distancing Corru_neu_distancing HP_neu_distancing SCR_neu_distancing 
  /PLOT BOXPLOT STEMLEAF NPPLOT 
  /COMPARE GROUPS 
  /MESTIMATORS HUBER(1.339) ANDREW(1.34) HAMPEL(1.7,3.4,8.5) TUKEY(4.685) 
  /PERCENTILES(5,10,25,50,75,90,95) HAVERAGE 
  /STATISTICS DESCRIPTIVES EXTREME 
  /CINTERVAL 95 
  /MISSING PAIRWISE 
  /NOTOTAL.

*inhibitory control tasks.
EXAMINE VARIABLES=Inhibit_ies_stroop Inhibit_ies_antisaccade Inhibit_ies_flanker Inhibit_ies_shapematching Inhibit_ies_wordnaming Inhibit_stopsignal
  /PLOT BOXPLOT STEMLEAF NPPLOT 
  /COMPARE GROUPS 
  /MESTIMATORS HUBER(1.339) ANDREW(1.34) HAMPEL(1.7,3.4,8.5) TUKEY(4.685) 
  /PERCENTILES(5,10,25,50,75,90,95) HAVERAGE 
  /STATISTICS DESCRIPTIVES EXTREME 
  /CINTERVAL 95 
  /MISSING PAIRWISE 
  /NOTOTAL.

********************************************Friedman ANOVAs*********************************************

*USE ALL.
*COMPUTE filter_$=(id ~= "T_102").
*VARIABLE LABELS filter_$ 'id ~= "T_102") (FILTER)'.
*VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
*FORMATS filter_$ (f1.0).
*FILTER BY filter_$.
*EXECUTE.

* arousal.
NPAR TESTS 
  /FRIEDMAN=ER_arousal_neg ER_arousal_neu 
  /KENDALL=ER_arousal_neg ER_arousal_neu 
  /STATISTICS DESCRIPTIVES 
  /MISSING LISTWISE.

NPAR TESTS 
  /FRIEDMAN=ER_arousal_permit ER_arousal_distancing 
  /KENDALL=ER_arousal_permit ER_arousal_distancing 
 /STATISTICS DESCRIPTIVES 
  /MISSING LISTWISE.

NPAR TESTS 
  /FRIEDMAN=ERsucc_neg_arousal ERsucc_neu_arousal 
  /KENDALL=ERsucc_neg_arousal ERsucc_neu_arousal 
  /STATISTICS DESCRIPTIVES QUARTILES 
  /MISSING LISTWISE.

NPAR TESTS 
  /FRIEDMAN=ER_Arousal_neg_permit ER_Arousal_neg_distancing
  /KENDALL ER_Arousal_neg_permit ER_Arousal_neg_distancing
 /STATISTICS DESCRIPTIVES 
  /MISSING LISTWISE.

* valence.
NPAR TESTS 
  /FRIEDMAN=ER_valence_neg ER_valence_neu 
  /KENDALL=ER_valence_neg ER_valence_neu 
  /STATISTICS DESCRIPTIVES 
  /MISSING LISTWISE.

NPAR TESTS 
  /FRIEDMAN=ER_valence_permit ER_valence_distancing 
  /KENDALL=ER_valence_permit ER_valence_distancing 
 /STATISTICS DESCRIPTIVES 
  /MISSING LISTWISE.

NPAR TESTS 
  /FRIEDMAN=ERsucc_neg_valence ERsucc_neu_valence 
  /KENDALL=ERsucc_neg_valence ERsucc_neu_valence 
  /STATISTICS DESCRIPTIVES QUARTILES 
  /MISSING LISTWISE.

NPAR TESTS 
  /FRIEDMAN=ER_valence_neg_permit ER_valence_neg_distancing
  /KENDALL ER_valence_neg_permit ER_valence_neg_distancing
 /STATISTICS DESCRIPTIVES 
  /MISSING LISTWISE.

* corrugator.
NPAR TESTS 
  /FRIEDMAN=Corru_neg Corru_neu 
  /KENDALL=Corru_neg Corru_neu 
  /STATISTICS DESCRIPTIVES 
  /MISSING LISTWISE.

NPAR TESTS 
  /FRIEDMAN=Corru_permit Corru_distancing 
  /KENDALL=Corru_permit Corru_distancing 
 /STATISTICS DESCRIPTIVES 
  /MISSING LISTWISE.

NPAR TESTS 
  /FRIEDMAN=ERsucc_neg_corru ERsucc_neu_corru 
  /KENDALL=ERsucc_neg_corru ERsucc_neu_corru 
  /STATISTICS DESCRIPTIVES QUARTILES 
  /MISSING LISTWISE.

NPAR TESTS 
  /FRIEDMAN=Corru_neg_permit Corru_neg_distancing
  /KENDALL Corru_neg_permit Corru_neg_distancing
 /STATISTICS DESCRIPTIVES 
  /MISSING LISTWISE.

* Heart period.
NPAR TESTS 
  /FRIEDMAN=HP_neg HP_neu
  /KENDALL=HP_neg HP_neu
  /STATISTICS DESCRIPTIVES QUARTILES 
  /MISSING LISTWISE.

NPAR TESTS 
  /FRIEDMAN=HP_permit HP_distancing
  /KENDALL=HP_permit HP_distancing
  /STATISTICS DESCRIPTIVES QUARTILES 
  /MISSING LISTWISE.

NPAR TESTS 
  /FRIEDMAN=ERsucc_neu_hp ERsucc_neg_hp
  /KENDALL=ERsucc_neu_hp ERsucc_neg_hp 
  /STATISTICS DESCRIPTIVES QUARTILES 
  /MISSING LISTWISE.

NPAR TESTS 
  /FRIEDMAN=HP_neg_permit HP_neg_distancing 
  /KENDALL=HP_neg_permit HP_neg_distancing
  /STATISTICS DESCRIPTIVES QUARTILES 
  /MISSING LISTWISE.

* skin conductance response
NPAR TESTS 
  /FRIEDMAN=SCR_neg SCR_neu 
  /KENDALL=SCR_neg SCR_neu 
  /STATISTICS DESCRIPTIVES 
  /MISSING LISTWISE.

NPAR TESTS 
  /FRIEDMAN=SCR_permit SCR_distancing 
  /KENDALL=SCR_permit SCR_distancing 
 /STATISTICS DESCRIPTIVES 
  /MISSING LISTWISE.

NPAR TESTS 
  /FRIEDMAN=ERsucc_neg_scr ERsucc_neu_scr 
  /KENDALL=ERsucc_neg_scr ERsucc_neu_scr 
  /STATISTICS DESCRIPTIVES QUARTILES 
  /MISSING LISTWISE.

NPAR TESTS 
  /FRIEDMAN=SCR_neg_permit SCR_neg_distancing
  /KENDALL SCR_neg_permit SCR_neg_distancing
 /STATISTICS DESCRIPTIVES 
  /MISSING LISTWISE.


********************************************n rm-ANOVA for comparison*********************************************

* arousal.
GLM ER_arousal_neg_permit ER_arousal_neg_distancing ER_arousal_neu_permit ER_arousal_neu_distancing
  /WSFACTOR=negative_vs_neutral 2 Polynomial permit_vs_distancing 2 Polynomial 
  /METHOD=SSTYPE(3)
  /PLOT=PROFILE(negative_vs_neutral*permit_vs_distancing) TYPE=LINE ERRORBAR=NO MEANREFERENCE=NO 
    YAXIS=AUTO
  /PRINT=DESCRIPTIVE ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=negative_vs_neutral permit_vs_distancing negative_vs_neutral*permit_vs_distancing.

GLM ER_arousal_neg_permit ER_arousal_neg_distancing
  /WSFACTOR=permit_vs_distancing 2 Polynomial 
  /METHOD=SSTYPE(3)
  /PLOT=PROFILE(permit_vs_distancing) TYPE=LINE ERRORBAR=NO MEANREFERENCE=NO 
    YAXIS=AUTO
  /PRINT=DESCRIPTIVE ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=permit_vs_distancing.

* valence.
GLM ER_valence_neg_permit ER_valence_neg_distancing ER_valence_neu_permit ER_valence_neu_distancing
  /WSFACTOR=negative_vs_neutral 2 Polynomial permit_vs_distancing 2 Polynomial 
  /METHOD=SSTYPE(3)
  /PLOT=PROFILE(negative_vs_neutral*permit_vs_distancing) TYPE=LINE ERRORBAR=NO MEANREFERENCE=NO 
    YAXIS=AUTO
  /PRINT=DESCRIPTIVE ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=negative_vs_neutral permit_vs_distancing negative_vs_neutral*permit_vs_distancing.

GLM ER_valence_neg_permit ER_valence_neg_distancing
  /WSFACTOR=permit_vs_distancing 2 Polynomial 
  /METHOD=SSTYPE(3)
  /PLOT=PROFILE(permit_vs_distancing) TYPE=LINE ERRORBAR=NO MEANREFERENCE=NO 
    YAXIS=AUTO
  /PRINT=DESCRIPTIVE ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=permit_vs_distancing.

* corrugator.
GLM Corru_neg_permit Corru_neg_distancing Corru_neu_permit Corru_neu_distancing
  /WSFACTOR=negative_vs_neutral 2 Polynomial permit_vs_distancing 2 Polynomial 
  /METHOD=SSTYPE(3)
  /PLOT=PROFILE(negative_vs_neutral*permit_vs_distancing) TYPE=LINE ERRORBAR=NO MEANREFERENCE=NO 
    YAXIS=AUTO
  /PRINT=DESCRIPTIVE ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=negative_vs_neutral permit_vs_distancing negative_vs_neutral*permit_vs_distancing.

GLM Corru_neg_permit Corru_neg_distancing
  /WSFACTOR=permit_vs_distancing 2 Polynomial 
  /METHOD=SSTYPE(3)
  /PLOT=PROFILE(permit_vs_distancing) TYPE=LINE ERRORBAR=NO MEANREFERENCE=NO 
    YAXIS=AUTO
  /PRINT=DESCRIPTIVE ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=permit_vs_distancing.

* heart period.
GLM HP_neg_permit HP_neg_distancing HP_neu_permit HP_neu_distancing
  /WSFACTOR=negative_vs_neutral 2 Polynomial permit_vs_distancing 2 Polynomial 
  /METHOD=SSTYPE(3)
  /PLOT=PROFILE(negative_vs_neutral*permit_vs_distancing) TYPE=LINE ERRORBAR=NO MEANREFERENCE=NO 
    YAXIS=AUTO
  /PRINT=DESCRIPTIVE ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=negative_vs_neutral permit_vs_distancing negative_vs_neutral*permit_vs_distancing.

GLM HP_neg_permit HP_neg_distancing
  /WSFACTOR=permit_vs_distancing 2 Polynomial 
  /METHOD=SSTYPE(3)
  /PLOT=PROFILE(permit_vs_distancing) TYPE=LINE ERRORBAR=NO MEANREFERENCE=NO 
    YAXIS=AUTO
  /PRINT=DESCRIPTIVE ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=permit_vs_distancing.

* skin conductance.
GLM SCR_neg_permit SCR_neg_distancing SCR_neu_permit SCR_neu_distancing
  /WSFACTOR=negative_vs_neutral 2 Polynomial permit_vs_distancing 2 Polynomial 
  /METHOD=SSTYPE(3)
  /PLOT=PROFILE(negative_vs_neutral*permit_vs_distancing) TYPE=LINE ERRORBAR=NO MEANREFERENCE=NO 
    YAXIS=AUTO
  /PRINT=DESCRIPTIVE ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=negative_vs_neutral permit_vs_distancing negative_vs_neutral*permit_vs_distancing.

GLM SCR_neg_permit SCR_neg_distancing
  /WSFACTOR=permit_vs_distancing 2 Polynomial 
  /METHOD=SSTYPE(3)
  /PLOT=PROFILE(permit_vs_distancing) TYPE=LINE ERRORBAR=NO MEANREFERENCE=NO 
    YAXIS=AUTO
  /PRINT=DESCRIPTIVE ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=permit_vs_distancing.


********************************************Table 2: correlations among emotion regulation measures**********************************************

* Emotion regulation success, negative trials only.
NONPAR CORR 
/VARIABLES=ERsucc_neg_valence ERsucc_neg_arousal ERsucc_neg_corru ERsucc_neg_hp ERsucc_neg_scr ERQ_reap ERQ_supp
  /PRINT=SPEARMAN TWOTAIL NOSIG 
  /MISSING=PAIRWISE.

* Emotion regulation success, negative vs. neutral trials.
NONPAR CORR 
  /VARIABLES=ERsucc_valence ERsucc_arousal ERsucc_corru ERsucc_hp ERsucc_scr ERQ_reap ERQ_supp
  /PRINT=SPEARMAN TWOTAIL NOSIG 
  /MISSING=PAIRWISE.

********************************************Correlations among inhibitory control measures**********************************************

NONPAR CORR 
  /VARIABLES=Inhibit_ies_stroop Inhibit_ies_antisaccade Inhibit_stopsignal Inhibit_ies_flanker Inhibit_ies_shapematching Inhibit_ies_wordnaming Inhibit_ies_latent
  /PRINT=SPEARMAN TWOTAIL NOSIG 
  /MISSING=PAIRWISE.


********************************************Table 3: correlations between inhibitory control and emotion regulation measures**********************************************

* Emotion regulation success, negative trials only.
NONPAR CORR 
  /VARIABLES=ERsucc_neg_valence ERsucc_neg_arousal ERsucc_neg_corru ERsucc_neg_scr ERsucc_neg_hp
    WITH Inhibit_ies_antisaccade Inhibit_stopsignal Inhibit_ies_stroop Inhibit_ies_flanker Inhibit_ies_shapematching Inhibit_ies_wordnaming Inhibit_ies_latent
  /PRINT=SPEARMAN TWOTAIL NOSIG 
  /MISSING=PAIRWISE.

* Emotion regulation success, negative vs. neutral trials.
NONPAR CORR 
  /VARIABLES=ERsucc_valence ERsucc_arousal ERsucc_corru ERsucc_scr ERsucc_hp ERQ_Reap ERQ_Supp
    WITH Inhibit_ies_antisaccade Inhibit_stopsignal Inhibit_ies_stroop Inhibit_ies_flanker Inhibit_ies_shapematching Inhibit_ies_wordnaming Inhibit_ies_latent
  /PRINT=SPEARMAN TWOTAIL NOSIG 
  /MISSING=PAIRWISE.





