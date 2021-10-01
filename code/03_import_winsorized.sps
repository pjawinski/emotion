* Encoding: UTF-8.

* ==============================
* === Create analyis dataset ===
* ==============================.

* Set working directory.
cd '/Users/philippe/Desktop/projects/emotion'.

* ---------------------------------------
* --- convert winsorized data to spss format ---
* ----------------------------------------.

* load data (longlist).
PRESERVE.
SET DECIMAL DOT.

GET DATA /TYPE=TXT
 /FILE="code/derivatives/main_winsor_longlist.txt"
 /ENCODING='UTF8'
 /DELCASE=LINE
 /DELIMITERS="\t"
 /ARRANGEMENT=DELIMITED
 /FIRSTCASE=2
 /DATATYPEMIN PERCENTAGE=100.0
 /VARIABLES=
 id A15
 sex F10.0
 age F10.0
 ER_Filename A20
 ER_FileDateTime A20
 ER_FileDate A20
 ER_FileTime A20
 ER_Ratings F16.2
 ER_valence_neu F16.2
 ER_valence_neg F16.2
 ER_valence_permit F16.2
 ER_valence_distancing F16.2
 ER_valence_neu_permit F16.2
 ER_valence_neu_distancing F16.2
 ER_valence_neg_permit F16.2
 ER_valence_neg_distancing F16.2
 ER_arousal_neu F16.2
 ER_arousal_neg F16.2
 ER_arousal_permit F16.2
 ER_arousal_distancing F16.2
 ER_arousal_neu_permit F16.2
 ER_arousal_neu_distancing F16.2
 ER_arousal_neg_permit F16.2
 ER_arousal_neg_distancing F16.2
 Corru_VPN A15
 Corru_Filename A20
 Corru_FileDateTime A20
 Corru_FileDate A20
 Corru_FileTime A20
 Corru_Trials F16.2
 Corru_neu F16.2
 Corru_neg F16.2
 Corru_permit F16.2
 Corru_distancing F16.2
 Corru_neu_permit F16.2
 Corru_neu_distancing F16.2
 Corru_neg_permit F16.2
 Corru_neg_distancing F16.2
 HP_VPN A15
 HP_Filename A20
 HP_N_Trials F16.2
 HP_neu F16.2
 HP_neg F16.2
 HP_permit F16.2
 HP_distancing F16.2
 HP_neu_permit F16.2
 HP_neu_distancing F16.2
 HP_neg_permit F16.2
 HP_neg_distancing F16.2
 SCR_neu F16.2
 SCR_neg F16.2
 SCR_permit F16.2
 SCR_distancing F16.2
 SCR_neu_permit F16.2
 SCR_neu_distancing F16.2
 SCR_neg_permit F16.2
 SCR_neg_distancing F16.2
 ERQ_reap F16.2
 ERQ_supp F16.2
 Inhibit_stroop F16.2
 Inhibit_antisaccade F16.2
 Inhibit_flanker F16.2
 Inhibit_shapematching F16.2
 Inhibit_wordnaming F16.2
 Inhibit_stopsignal F16.2
 Inhibit_ies_stroop F16.2
 Inhibit_ies_antisaccade F16.2
 Inhibit_ies_flanker F16.2
 Inhibit_ies_shapematching F16.2
 Inhibit_ies_wordnaming F16.2
 Inhibit_ies_latent F16.2
 ERsucc_arousal F16.2
 ERsucc_valence F16.2
 ERsucc_corru F16.2
 ERsucc_hp F16.2
 ERsucc_scr F16.2
 ERsucc_neg_arousal F16.2
 ERsucc_neg_valence F16.2
 ERsucc_neg_corru F16.2
 ERsucc_neg_hp F16.2
 ERsucc_neg_scr F16.2
 ERsucc_neu_arousal F16.2
 ERsucc_neu_valence F16.2
 ERsucc_neu_corru F16.2
 ERsucc_neu_hp F16.2
 ERsucc_neu_scr F16.2
 Wins_ER_arousal_neu F16.2
 Wins_ER_arousal_neg F16.2
 Wins_ER_arousal_permit F16.2
 Wins_ER_arousal_distancing F16.2
 Wins_ER_arousal_neu_permit F16.2
 Wins_ER_arousal_neu_distancing F16.2
 Wins_ER_arousal_neg_permit F16.2
 Wins_ER_arousal_neg_distancing F16.2
 Wins_ER_valence_neu F16.2
 Wins_ER_valence_neg F16.2
 Wins_ER_valence_permit F16.2
 Wins_ER_valence_distancing F16.2
 Wins_ER_valence_neu_permit F16.2
 Wins_ER_valence_neu_distancing F16.2
 Wins_ER_valence_neg_permit F16.2
 Wins_ER_valence_neg_distancing F16.2
 Wins_Corru_neu F16.2
 Wins_Corru_neg F16.2
 Wins_Corru_permit F16.2
 Wins_Corru_distancing F16.2
 Wins_Corru_neu_permit F16.2
 Wins_Corru_neu_distancing F16.2
 Wins_Corru_neg_permit F16.2
 Wins_Corru_neg_distancing F16.2
 Wins_HP_neu F16.2
 Wins_HP_neg F16.2
 Wins_HP_permit F16.2
 Wins_HP_distancing F16.2
 Wins_HP_neu_permit F16.2
 Wins_HP_neu_distancing F16.2
 Wins_HP_neg_permit F16.2
 Wins_HP_neg_distancing F16.2
 Wins_SCR_neu F16.2
 Wins_SCR_neg F16.2
 Wins_SCR_permit F16.2
 Wins_SCR_distancing F16.2
 Wins_SCR_neu_permit F16.2
 Wins_SCR_neu_distancing F16.2
 Wins_SCR_neg_permit F16.2
 Wins_SCR_neg_distancing F16.2
 Wins_ERsucc_valence F16.2
 Wins_ERsucc_arousal F16.2
 Wins_ERsucc_corru F16.2
 Wins_ERsucc_hp F16.2
 Wins_ERsucc_scr F16.2
 Wins_ERsucc_neg_valence F16.2
 Wins_ERsucc_neg_arousal F16.2
 Wins_ERsucc_neg_corru F16.2
 Wins_ERsucc_neg_hp F16.2
 Wins_ERsucc_neg_scr F16.2
 Wins_ERsucc_neu_valence F16.2
 Wins_ERsucc_neu_arousal F16.2
 Wins_ERsucc_neu_corru F16.2
 Wins_ERsucc_neu_hp F16.2
 Wins_ERsucc_neu_scr F16.2
 /MAP.
RESTORE.

CACHE.
EXECUTE.
DATASET NAME main_winsor_longlist WINDOW=FRONT.

* save dataset as .sav file.
SAVE OUTFILE='code/derivatives/main_winsor_longlist.sav'.

* =======================
* === load data main_winsor.txt ===
* =======================.

* load data.
PRESERVE.
SET DECIMAL DOT.

GET DATA  /TYPE=TXT
  /FILE="code/derivatives/main_winsor.txt"
  /ENCODING='UTF8'
  /DELCASE=LINE
  /DELIMITERS="\t"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  id A15
  sex F10.0
  age F10.0
  ER_Filename A20
  ER_FileDateTime A20
  ER_FileDate A20
  ER_FileTime A20
  ER_Ratings F16.2
  ER_valence_neu F16.2
  ER_valence_neg F16.2
  ER_valence_permit F16.2
  ER_valence_distancing F16.2
  ER_valence_neu_permit F16.2
  ER_valence_neu_distancing F16.2
  ER_valence_neg_permit F16.2
  ER_valence_neg_distancing F16.2
  ER_arousal_neu F16.2
  ER_arousal_neg F16.2
  ER_arousal_permit F16.2
  ER_arousal_distancing F16.2
  ER_arousal_neu_permit F16.2
  ER_arousal_neu_distancing F16.2
  ER_arousal_neg_permit F16.2
  ER_arousal_neg_distancing F16.2
  Corru_VPN A15
  Corru_Filename A20
  Corru_FileDateTime A20
  Corru_FileDate A20
  Corru_FileTime A20
  Corru_Trials F16.2
  Corru_neu F16.2
  Corru_neg F16.2
  Corru_permit F16.2
  Corru_distancing F16.2
  Corru_neu_permit F16.2
  Corru_neu_distancing F16.2
  Corru_neg_permit F16.2
  Corru_neg_distancing F16.2
  HP_VPN A15
  HP_Filename A20
  HP_N_Trials F16.2
  HP_neu F16.2
  HP_neg F16.2
  HP_permit F16.2
  HP_distancing F16.2
  HP_neu_permit F16.2
  HP_neu_distancing F16.2
  HP_neg_permit F16.2
  HP_neg_distancing F16.2
  SCR_neu F16.2
  SCR_neg F16.2
  SCR_permit F16.2
  SCR_distancing F16.2
  SCR_neu_permit F16.2
  SCR_neu_distancing F16.2
  SCR_neg_permit F16.2
  SCR_neg_distancing F16.2
  ERQ_reap F16.2
  ERQ_supp F16.2
  Inhibit_stroop F16.2
  Inhibit_antisaccade F16.2
  Inhibit_flanker F16.2
  Inhibit_shapematching F16.2
  Inhibit_wordnaming F16.2
  Inhibit_stopsignal F16.2
  Inhibit_ies_stroop F16.2
  Inhibit_ies_antisaccade F16.2
  Inhibit_ies_flanker F16.2
  Inhibit_ies_shapematching F16.2
  Inhibit_ies_wordnaming F16.2
  Inhibit_ies_latent F16.2
  ERsucc_arousal F16.2
  ERsucc_valence F16.2
  ERsucc_corru F16.2
  ERsucc_hp F16.2
  ERsucc_scr F16.2
  ERsucc_neg_arousal F16.2
  ERsucc_neg_valence F16.2
  ERsucc_neg_corru F16.2
  ERsucc_neg_hp F16.2
  ERsucc_neg_scr F16.2
  ERsucc_neu_arousal F16.2
  ERsucc_neu_valence F16.2
  ERsucc_neu_corru F16.2
  ERsucc_neu_hp F16.2
  ERsucc_neu_scr F16.2
  /MAP.
RESTORE.

CACHE.
EXECUTE.
DATASET NAME main_winsor WINDOW=FRONT.

* save dataset as .sav file.
SAVE OUTFILE='code/derivatives/main_winsor.sav'.

