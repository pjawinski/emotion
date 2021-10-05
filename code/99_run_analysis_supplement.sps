* Encoding: UTF-8.


* Supplement: correlations with standard reaction time scores for inhibitory control tasks

* einfache Differenz (ERsucc). 
NONPAR CORR 
  /VARIABLES=ERsucc_neg_valence ERsucc_neg_arousal ERsucc_neg_corru ERsucc_neg_scr ERsucc_neg_hp
    WITH Inhibit_antisaccade Inhibit_stopsignal Inhibit_stroop Inhibit_flanker Inhibit_shapematching Inhibit_wordnaming
  /PRINT=SPEARMAN TWOTAIL NOSIG 
  /MISSING=PAIRWISE.

* doppelte Differenz (ERsucc-2).
NONPAR CORR 
  /VARIABLES=ERsucc_valence ERsucc_arousal ERsucc_corru ERsucc_scr ERsucc_hp
    WITH Inhibit_antisaccade Inhibit_stopsignal Inhibit_stroop Inhibit_flanker Inhibit_shapematching Inhibit_wordnaming
  /PRINT=SPEARMAN TWOTAIL NOSIG 
  /MISSING=PAIRWISE.

* ERQ.
NONPAR CORR 
  /VARIABLES=ERQ_reap ERQ_supp
    WITH Inhibit_antisaccade Inhibit_stopsignal Inhibit_stroop Inhibit_flanker Inhibit_shapematching Inhibit_wordnaming
  /PRINT=SPEARMAN TWOTAIL NOSIG 
  /MISSING=PAIRWISE.

* negative permit.
NONPAR CORR 
  /VARIABLES=ER_valence_neg_permit ER_arousal_neg_permit Corru_neg_permit SCR_neg_permit HP_neg_permit
    WITH Inhibit_antisaccade Inhibit_stopsignal Inhibit_stroop Inhibit_flanker Inhibit_shapematching Inhibit_wordnaming
  /PRINT=SPEARMAN TWOTAIL NOSIG 
  /MISSING=PAIRWISE.

*negative distancing. 
NONPAR CORR 
  /VARIABLES=ER_valence_neg_distancing ER_arousal_neg_distancing Corru_neg_distancing SCR_neg_distancing HP_neg_distancing
    WITH Inhibit_antisaccade Inhibit_stopsignal Inhibit_stroop Inhibit_flanker Inhibit_shapematching Inhibit_wordnaming
  /PRINT=SPEARMAN TWOTAIL NOSIG 
  /MISSING=PAIRWISE.

* neutral permit.
NONPAR CORR 
  /VARIABLES=ER_valence_neu_permit ER_arousal_neu_permit Corru_neu_permit SCR_neu_permit HP_neu_permit
    WITH Inhibit_antisaccade Inhibit_stopsignal Inhibit_stroop Inhibit_flanker Inhibit_shapematching Inhibit_wordnaming
  /PRINT=SPEARMAN TWOTAIL NOSIG 
  /MISSING=PAIRWISE.

*neutral distancing. 
NONPAR CORR 
  /VARIABLES=ER_valence_neu_distancing ER_arousal_neu_distancing Corru_neu_distancing SCR_neu_distancing HP_neu_distancing
    WITH Inhibit_antisaccade Inhibit_stopsignal Inhibit_stroop Inhibit_flanker Inhibit_shapematching Inhibit_wordnaming
  /PRINT=SPEARMAN TWOTAIL NOSIG 
  /MISSING=PAIRWISE.

