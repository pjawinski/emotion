* Encoding: UTF-8.

* ==============================
* === Create analyis dataset ===
* ==============================.

* Set working directory.
cd '/Users/philippe/Desktop/projects/emotion'.

* -----------------------
* --- Get age and sex ---
* -----------------------.

* load data.
GET DATA
  /TYPE=XLS
  /FILE='data/survey_cognition/id.xls'
  /SHEET=name 'sheet1'
  /CELLRANGE=FULL
  /READNAMES=ON.
EXECUTE.
DATASET NAME main WINDOW=FRONT.

* recode and rename variables.
RECODE Geschlecht ('1 (männlich)' = 0) ('2' = 1) into sex.
FORMATS  sex(F8.0).
VALUE LABELS sex
  0 'male'
  1 'female'.
EXECUTE.

RENAME VARIABLE (Alter Vp = age VPN ).
EXECUTE.

* keep variables of interest.
MATCH FILES
FILE = * /
KEEP = VPN sex age.
SELECT IF (NOT(VPN EQ "")).
EXECUTE.

* ---------------------------------------
* --- Get arousal and valence ratings ---
* ---------------------------------------.

* load data.
GET FILE='data/regulation/ER_Helper/ERHelper_Zusammenfassung_V1.sav'.
DATASET NAME ERratings.
DATASET ACTIVATE ERratings.

* rename variables.
RENAME VARIABLE (ER_Valenz_neutral ER_Valenz_negativ ER_Valenz_zulassen ER_Valenz_distanzieren 
    ER_Valenz_neutral_zulassen ER_Valenz_neutral_distanzieren ER_Valenz_negativ_zulassen ER_Valenz_negativ_distanzieren 
    ER_Arousal_neutral ER_Arousal_negativ ER_Arousal_zulassen ER_Arousal_distanzieren 
    ER_Arousal_neutral_zulassen ER_Arousal_neutral_distanzieren ER_Arousal_negativ_zulassen ER_Arousal_negativ_distanzieren =
    ER_valence_neu ER_valence_neg ER_valence_permit ER_valence_distancing
    ER_valence_neu_permit ER_valence_neu_distancing ER_valence_neg_permit ER_valence_neg_distancing
    ER_arousal_neu ER_arousal_neg ER_arousal_permit ER_arousal_distancing
    ER_arousal_neu_permit ER_arousal_neu_distancing ER_arousal_neg_permit ER_arousal_neg_distancing).
EXECUTE.

* keep variables of interest.
MATCH FILES
FILE = * /
KEEP = VPN ER_Filename ER_FileDateTime ER_FileDate ER_FileTime ER_Ratings
    ER_valence_neu ER_valence_neg ER_valence_permit ER_valence_distancing
    ER_valence_neu_permit ER_valence_neu_distancing ER_valence_neg_permit ER_valence_neg_distancing
    ER_arousal_neu ER_arousal_neg ER_arousal_permit ER_arousal_distancing
    ER_arousal_neu_permit ER_arousal_neu_distancing ER_arousal_neg_permit ER_arousal_neg_distancing.
SELECT IF (NOT(VPN EQ "")).
EXECUTE.

* convert to affect grid scale (scores ranging between -4 and +4).
COMPUTE ER_valence_neu = ER_valence_neu - 5.
COMPUTE ER_valence_neg = ER_valence_neg - 5.
COMPUTE ER_valence_permit = ER_valence_permit - 5.
COMPUTE ER_valence_distancing = ER_valence_distancing - 5.
COMPUTE ER_valence_neu_permit = ER_valence_neu_permit - 5.
COMPUTE ER_valence_neu_distancing = ER_valence_neu_distancing - 5.
COMPUTE ER_valence_neg_permit = ER_valence_neg_permit - 5.
COMPUTE ER_valence_neg_distancing = ER_valence_neg_distancing - 5.

COMPUTE ER_arousal_neu = ER_arousal_neu - 5.
COMPUTE ER_arousal_neg = ER_arousal_neg - 5.
COMPUTE ER_arousal_permit = ER_arousal_permit - 5.
COMPUTE ER_arousal_distancing = ER_arousal_distancing - 5.
COMPUTE ER_arousal_neu_permit = ER_arousal_neu_permit - 5.
COMPUTE ER_arousal_neu_distancing = ER_arousal_neu_distancing - 5.
COMPUTE ER_arousal_neg_permit = ER_arousal_neg_permit - 5.
COMPUTE ER_arousal_neg_distancing = ER_arousal_neg_distancing - 5.
EXECUTE. 

* merge with main dataset.
ALTER TYPE VPN (A15).
SORT CASES BY VPN.
DATASET ACTIVATE main.
ALTER TYPE VPN (A15).
SORT CASES BY VPN.
MATCH FILES /FILE=*
  /FILE='ERratings'
  /BY VPN.
EXECUTE.

* close dataset.
DATASET CLOSE ERratings.

* ---------------------------
* --- Get corrugator data ---
* ---------------------------.

* load data.
GET FILE='data/regulation/Corr_Helper/Corr_Zusammenfassung_V1.sav'.
DATASET NAME Corrugator.
DATASET ACTIVATE Corrugator.

* rename variables.
RENAME VARIABLE (Corru_Bilateral_MeanArea_neutral Corru_Bilateral_MeanArea_negativ Corru_Bilateral_MeanArea_zulassen Corru_Bilateral_MeanArea_distanzieren
    Corru_Bilateral_MeanArea_neutral_zulassen Corru_Bilateral_MeanArea_neutral_distanzieren Corru_Bilateral_MeanArea_negativ_zulassen Corru_Bilateral_MeanArea_negativ_distanzieren =
    Corru_neu Corru_neg Corru_permit Corru_distancing
    Corru_neu_permit Corru_neu_distancing Corru_neg_permit Corru_neg_distancing).
EXECUTE.

* keep variables of interest.
MATCH FILES
FILE = * /
KEEP = VPN Corru_VPN Corru_Filename Corru_FileDateTime Corru_FileDate Corru_FileTime Corru_Trials
    Corru_neu Corru_neg Corru_permit Corru_distancing
    Corru_neu_permit Corru_neu_distancing Corru_neg_permit Corru_neg_distancing.
SELECT IF (NOT(VPN EQ "")).
EXECUTE.

* convert to mV.
COMPUTE Corru_neu = Corru_neu/1000.
COMPUTE Corru_neg = Corru_neg/1000.
COMPUTE Corru_permit = Corru_permit/1000.
COMPUTE Corru_distancing = Corru_distancing/1000.
COMPUTE Corru_neu_permit = Corru_neu_permit/1000.
COMPUTE Corru_neu_distancing = Corru_neu_distancing/1000.
COMPUTE Corru_neg_permit = Corru_neg_permit/1000.
COMPUTE Corru_neg_distancing = Corru_neg_distancing/1000.
EXECUTE.

* merge with main dataset.
ALTER TYPE VPN (A15).
SORT CASES BY VPN.
DATASET ACTIVATE main.
ALTER TYPE VPN (A15).
SORT CASES BY VPN.
MATCH FILES /FILE=*
  /FILE='Corrugator'
  /BY VPN.
EXECUTE.

* close dataset.
DATASET CLOSE Corrugator.

* -----------------------------
* --- Get heart period data ---
* -----------------------------.

* load data.
GET FILE='data/regulation/ECG_Helper/EKG Zusammenfassung.sav'.
DATASET NAME HP.
DATASET ACTIVATE HP.

* calculate baseline-corrected variables of interest.
COMPUTE HP_neu_permit = HP_neu_zul_Trial - HP_neu_zul_Baseline.
COMPUTE HP_neu_distancing = HP_neu_dist_Trial - HP_neu_dist_Baseline.
COMPUTE HP_neg_permit = HP_neg_zul_Trial - HP_neg_zul_Baseline.
COMPUTE HP_neg_distancing = HP_neg_dist_Trial - HP_neg_dist_Baseline.
COMPUTE HP_neu = MEAN(HP_neu_permit,HP_neu_distancing).
COMPUTE HP_neg = MEAN(HP_neg_permit,HP_neg_distancing).
COMPUTE HP_permit = MEAN(HP_neg_permit,HP_neu_permit).
COMPUTE HP_distancing = MEAN(HP_neg_distancing,HP_neu_distancing).
EXECUTE.

* keep variables of interest.
MATCH FILES
FILE = * /
KEEP = VPN HP_VPN HP_Filename HP_N_Trials
    HP_neu HP_neg HP_permit HP_distancing
    HP_neu_permit HP_neu_distancing HP_neg_permit HP_neg_distancing.
SELECT IF (NOT(VPN EQ "")).
SELECT IF (NOT(VPN EQ "T_146_1")).
SELECT IF (NOT(VPN EQ "T_146_2")).
EXECUTE.

* merge with main dataset.
ALTER TYPE VPN (A15).
SORT CASES BY VPN.
DATASET ACTIVATE main.
ALTER TYPE VPN (A15).
SORT CASES BY VPN.
MATCH FILES /FILE=*
  /FILE='HP'
  /BY VPN.
EXECUTE.

* close dataset.
DATASET CLOSE HP.

* ------------------------------------------
* --- Get skin conductance response data ---
* ------------------------------------------.

* load data.
PRESERVE.
SET DECIMAL DOT.

GET DATA  /TYPE=TXT
  /FILE="data/regulation/scl_scr/scr_dcm.txt"
  /ENCODING='UTF8'
  /DELCASE=LINE
  /DELIMITERS="\t"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /VARIABLES=
  VPN A15
  SCR_neu_permit F10.2
  SCR_neu_distancing F10.2
  SCR_neg_permit F10.2
  SCR_neg_distancing F10.2
  /MAP.
RESTORE.

DATASET NAME SCR.
DATASET ACTIVATE SCR.

* calculate missing variables of interest.
COMPUTE SCR_neu = MEAN(SCR_neu_permit,SCR_neu_distancing).
COMPUTE SCR_neg = MEAN(SCR_neg_permit,SCR_neg_distancing).
COMPUTE SCR_permit = MEAN(SCR_neu_permit,SCR_neg_permit).
COMPUTE SCR_distancing = MEAN(SCR_neu_distancing,SCR_neg_distancing).
EXECUTE.

* keep variables of interest.
MATCH FILES
FILE = * /
KEEP = VPN
    SCR_neu SCR_neg SCR_permit SCR_distancing
    SCR_neu_permit SCR_neu_distancing SCR_neg_permit SCR_neg_distancing.
SELECT IF (NOT(VPN EQ "")).
EXECUTE.

* merge with main dataset.
ALTER TYPE VPN (A15).
SORT CASES BY VPN.
DATASET ACTIVATE main.
ALTER TYPE VPN (A15).
SORT CASES BY VPN.
MATCH FILES /FILE=*
  /FILE='SCR'
  /BY VPN.
EXECUTE.

* close dataset.
DATASET CLOSE SCR.

* ---------------------------
* --- Get ERQ data ---
* ---------------------------.

* load data.
GET FILE='data/survey_cognition/Lime_Umfrage_ERQ.sav'.
DATASET NAME erq.
DATASET ACTIVATE erq.

* rename variables.
RENAME VARIABLE (VP ERQ_REAP_sum ERQ_SUPP_sum = VPN ERQ_reap ERQ_supp).
EXECUTE.
    
* keep variables of interest.
MATCH FILES
FILE = * /
KEEP = VPN ERQ_reap ERQ_supp.
EXECUTE.

SELECT IF (NOT(VPN EQ "")).
EXECUTE.

* merge with main dataset.
ALTER TYPE VPN (A15).
SORT CASES BY VPN.
DATASET ACTIVATE main.
ALTER TYPE VPN (A15).
SORT CASES BY VPN.
MATCH FILES /FILE=*
  /FILE='erq'
  /BY VPN.
EXECUTE.

* close dataset.
DATASET CLOSE erq.

* ---------------------------
* --- Get inhibition data ---
* ---------------------------.

* load data.
GET FILE='data/survey_cognition/inhibition.sav'.
DATASET NAME inhibition.
DATASET ACTIVATE inhibition.

* rename variables.
RENAME VARIABLE (STROOP_EFFEKT AS_FALSCH_EFFEKT FLANKER_EFFEKT SHAPEHELPER_EFFEKT WORDNAMING_EFFEKT_2_200_200 SSRT_FM_V3_mean
    STR_IES_EFFEKT AS_IES FL_IES_EFFEKT SH_IES_EFFEKT WN_IES_EFFEKT ResponseDistractorInhibition_IES_4tasks =
    Inhibit_stroop Inhibit_antisaccade Inhibit_flanker Inhibit_shapematching Inhibit_wordnaming Inhibit_stopsignal
    Inhibit_ies_stroop Inhibit_ies_antisaccade Inhibit_ies_flanker Inhibit_ies_shapematching Inhibit_ies_wordnaming Inhibit_ies_latent).

* keep variables of interest.
MATCH FILES
FILE = * /
KEEP = VPN
    Inhibit_stroop Inhibit_antisaccade Inhibit_flanker Inhibit_shapematching Inhibit_wordnaming Inhibit_stopsignal
    Inhibit_ies_stroop Inhibit_ies_antisaccade Inhibit_ies_flanker Inhibit_ies_shapematching Inhibit_ies_wordnaming Inhibit_ies_latent.
EXECUTE.

SELECT IF (NOT(VPN EQ "")).
EXECUTE.

* merge with main dataset.
ALTER TYPE VPN (A15).
SORT CASES BY VPN.
DATASET ACTIVATE main.
ALTER TYPE VPN (A15).
SORT CASES BY VPN.
MATCH FILES /FILE=*
  /FILE='inhibition'
  /BY VPN.
EXECUTE.

* close dataset.
DATASET CLOSE inhibition.

* ------------------------------------------------------
* --- Calculate emotion regulation success variables ---
* ------------------------------------------------------.

* remove cases without inhibition data.
DATASET ACTIVATE main.
SELECT IF (NOT(SYSMIS(Inhibit_ies_latent))).
EXECUTE.

* calculate ERsucc.
COMPUTE ERsucc_arousal = (ER_Arousal_neg_permit - ER_Arousal_neg_distancing) - (ER_Arousal_neu_permit - ER_Arousal_neu_distancing). 
COMPUTE ERsucc_valence = (ER_valence_neg_permit - ER_valence_neg_distancing) - (ER_valence_neu_permit - ER_valence_neu_distancing). 
COMPUTE ERsucc_corru = (Corru_neg_permit - Corru_neg_distancing) - (Corru_neu_permit - Corru_neu_distancing). 
COMPUTE ERsucc_hp = (HP_neg_permit - HP_neg_distancing) - (HP_neu_permit - HP_neu_distancing). 
COMPUTE ERsucc_scr = (SCR_neg_permit - SCR_neg_distancing) - (SCR_neu_permit - SCR_neu_distancing). 
EXECUTE.

* calculate ERsucc using negative trials only.
COMPUTE ERsucc_neg_arousal = ER_arousal_neg_permit - ER_arousal_neg_distancing. 
COMPUTE ERsucc_neg_valence = ER_valence_neg_permit - ER_valence_neg_distancing. 
COMPUTE ERsucc_neg_corru = Corru_neg_permit - Corru_neg_distancing. 
COMPUTE ERsucc_neg_hp = HP_neg_permit - HP_neg_distancing. 
COMPUTE ERsucc_neg_scr = SCR_neg_permit - SCR_neg_distancing. 
EXECUTE.

* calculate ERsucc using neutral trials only.
COMPUTE ERsucc_neu_arousal = ER_arousal_neu_permit - ER_arousal_neu_distancing. 
COMPUTE ERsucc_neu_valence = ER_valence_neu_permit - ER_valence_neu_distancing. 
COMPUTE ERsucc_neu_corru = Corru_neu_permit - Corru_neu_distancing. 
COMPUTE ERsucc_neu_hp = HP_neu_permit - HP_neu_distancing. 
COMPUTE ERsucc_neu_scr = SCR_neu_permit - SCR_neu_distancing. 
EXECUTE.

* ----------------------------------------
* --- Save and export analysis dataset ---
* ----------------------------------------.

* rename VPN to id.
RENAME VARIABLES (VPN = id).

* save dataset as .sav file.
SAVE OUTFILE='code/derivatives/main.sav'.

* save dataset as tab-delimited.txt file.
GET FILE='code/derivatives/main.sav'.
DATASET NAME main.
DATASET ACTIVATE main.
EXECUTE.

SAVE TRANSLATE OUT = 'code/derivatives/main.txt'
   / TYPE=TAB
   / FIELDNAMES
   / REPLACE
   / MAP. 
