*&---------------------------------------------------------------------*
*& Report Z_HR_SAMPLE_DATA
*& Insert 1 employee - ALL values read from existing config tables
*& NON-PRODUCTION USE ONLY - System: GCD
*&---------------------------------------------------------------------*
REPORT z_hr_sample_data.

PARAMETERS: p_pernr TYPE persno DEFAULT '90000002',
            p_mode  TYPE c LENGTH 1 DEFAULT 'I'.
* p_mode: I = Insert, D = Delete

DATA: lv_begda TYPE begda VALUE '20250101',
      lv_endda TYPE endda VALUE '99991231'.

*--- Config values read from existing tables ---
DATA: BEGIN OF gs_cfg,
        bukrs  TYPE bukrs,        "T001: Company code
        waers  TYPE waers,        "T001: Currency
        werks  TYPE persa,        "T500P: Personnel area
        molga  TYPE molga,        "T500P: Country grouping
        btrtl  TYPE btrtl,        "T001P: Personnel subarea
        persg  TYPE persg,        "T503: Employee group
        persk  TYPE persk,        "T503: Employee subgroup
        kostl  TYPE kostl,        "CSKS: Cost center
        abkrs  TYPE abkrs,        "T549A: Payroll area
        schkz  TYPE pa0007-schkz,  "T508A: Work schedule rule
        trfar  TYPE trfar,        "T510: Pay scale type
        trfgb  TYPE trfgb,        "T510: Pay scale area
        trfgr  TYPE trfgr,        "T510: Pay scale group
        trfst  TYPE trfst,        "T510: Pay scale level
        lgart1 TYPE lgart,        "T512T: Wage type (basic)
        lgart2 TYPE lgart,        "T512T: Wage type (recurring/HRA)
        lgart3 TYPE lgart,        "T512T: Wage type (bonus)
        bankl  TYPE bankk,        "BNKA: Bank key
        banks  TYPE banks,        "BNKA: Bank country
        awart  TYPE awart,        "T554S: Absence type
        atart  TYPE awart,        "T554S: Attendance type
        ktart  TYPE ktart,        "T556B: Quota type
      END OF gs_cfg.

START-OF-SELECTION.

  IF p_mode = 'D'.
    PERFORM delete_all USING p_pernr.
    RETURN.
  ENDIF.

*=== Step 1: Read ALL config data =====================================
  PERFORM read_config.

  IF gs_cfg-bukrs IS INITIAL.
    WRITE: / 'ERROR: No company code found in T001. Cannot proceed.'.
    RETURN.
  ENDIF.

  PERFORM print_config.

*=== Step 2: Insert employee data =====================================
  PERFORM insert_all USING p_pernr lv_begda lv_endda.

*&---------------------------------------------------------------------*
*& Form READ_CONFIG
*&---------------------------------------------------------------------*
FORM read_config.

* T001: Company Code + Currency
  SELECT SINGLE bukrs waers FROM t001
    INTO (gs_cfg-bukrs, gs_cfg-waers).
  IF sy-subrc <> 0.
    WRITE: / 'WARNING: T001 is empty'.
  ENDIF.

* T500P: Personnel Area + Country grouping
  SELECT SINGLE persa molga FROM t500p
    INTO (gs_cfg-werks, gs_cfg-molga)
    WHERE molga <> ''.
  IF sy-subrc <> 0.
    SELECT SINGLE persa molga FROM t500p
      INTO (gs_cfg-werks, gs_cfg-molga).
  ENDIF.

* T001P: Personnel Subarea
  SELECT SINGLE btrtl FROM t001p INTO gs_cfg-btrtl
    WHERE werks = gs_cfg-werks.
  IF sy-subrc <> 0.
    SELECT SINGLE btrtl FROM t001p INTO gs_cfg-btrtl.
  ENDIF.

* T503: Employee Group + Subgroup
  SELECT SINGLE persg persk FROM t503
    INTO (gs_cfg-persg, gs_cfg-persk).

* CSKS: Cost Center
  SELECT SINGLE kostl FROM csks INTO gs_cfg-kostl
    WHERE bukrs = gs_cfg-bukrs.
  IF sy-subrc <> 0.
    SELECT SINGLE kostl FROM csks INTO gs_cfg-kostl.
  ENDIF.

* T549A: Payroll Area
  SELECT SINGLE abkrs FROM t549a INTO gs_cfg-abkrs.

* T508A: Work Schedule Rule
  SELECT SINGLE schkz FROM t508a INTO gs_cfg-schkz.

* T510: Pay Scale Type/Area/Group/Level
  SELECT SINGLE trfar trfgb trfgr trfst FROM t510
    INTO (gs_cfg-trfar, gs_cfg-trfgb, gs_cfg-trfgr, gs_cfg-trfst).

* T512T: Wage Types (pick first 3 distinct)
  SELECT lgart FROM t512t INTO gs_cfg-lgart1
    UP TO 1 ROWS WHERE sprsl = sy-langu.
  ENDSELECT.
  IF gs_cfg-lgart1 IS INITIAL.
    SELECT lgart FROM t512t INTO gs_cfg-lgart1 UP TO 1 ROWS.
    ENDSELECT.
  ENDIF.
  SELECT lgart FROM t512t INTO gs_cfg-lgart2
    UP TO 1 ROWS WHERE sprsl = sy-langu AND lgart > gs_cfg-lgart1.
  ENDSELECT.
  SELECT lgart FROM t512t INTO gs_cfg-lgart3
    UP TO 1 ROWS WHERE sprsl = sy-langu AND lgart > gs_cfg-lgart2.
  ENDSELECT.

* BNKA: Bank Key
  SELECT SINGLE bankl banks FROM bnka
    INTO (gs_cfg-bankl, gs_cfg-banks).

* T554S: Absence Type
  SELECT SINGLE awart FROM t554s INTO gs_cfg-awart.

* T554S: Attendance Type (subtype for PA2002)
  SELECT SINGLE awart FROM t554s INTO gs_cfg-atart
    WHERE awart <> gs_cfg-awart.

* T556B: Absence Quota Type
  SELECT SINGLE ktart FROM t556b INTO gs_cfg-ktart.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form PRINT_CONFIG
*&---------------------------------------------------------------------*
FORM print_config.
  WRITE: / '=== Config Data from Existing Tables ==='.
  WRITE: / 'T001    Company Code:', gs_cfg-bukrs,
           ' Currency:', gs_cfg-waers.
  WRITE: / 'T500P   Personnel Area:', gs_cfg-werks,
           ' Country:', gs_cfg-molga.
  WRITE: / 'T001P   Pers. Subarea:', gs_cfg-btrtl.
  WRITE: / 'T503    Emp Group:', gs_cfg-persg,
           ' Subgroup:', gs_cfg-persk.
  WRITE: / 'CSKS    Cost Center:', gs_cfg-kostl.
  WRITE: / 'T549A   Payroll Area:', gs_cfg-abkrs.
  WRITE: / 'T508A   Work Schedule:', gs_cfg-schkz.
  WRITE: / 'T510    Pay Scale:', gs_cfg-trfar, '/', gs_cfg-trfgb,
           '/', gs_cfg-trfgr, '/', gs_cfg-trfst.
  WRITE: / 'T512T   Wage Types:', gs_cfg-lgart1, '/', gs_cfg-lgart2,
           '/', gs_cfg-lgart3.
  WRITE: / 'BNKA    Bank Key:', gs_cfg-bankl,
           ' Country:', gs_cfg-banks.
  WRITE: / 'T554S   Absence Type:', gs_cfg-awart,
           ' Attend:', gs_cfg-atart.
  WRITE: / 'T556B   Quota Type:', gs_cfg-ktart.
  WRITE: / ''.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form INSERT_ALL
*&---------------------------------------------------------------------*
FORM insert_all USING iv_pernr TYPE persno
                      iv_begda TYPE begda
                      iv_endda TYPE endda.

  DATA: ls_pa0000  TYPE pa0000,
        ls_pa0001  TYPE pa0001,
        ls_pa0002  TYPE pa0002,
        ls_pa0003  TYPE pa0003,
        ls_pa0006  TYPE pa0006,
        ls_pa0007  TYPE pa0007,
        ls_pa0008  TYPE pa0008,
        ls_pa0009  TYPE pa0009,
        ls_pa0014  TYPE pa0014,
        ls_pa0015  TYPE pa0015,
        ls_pa0021  TYPE pa0021,
        ls_pa0032  TYPE pa0032,
        ls_pa0105  TYPE pa0105,
        ls_pa0167  TYPE pa0167,
        ls_pa0171  TYPE pa0171,
        ls_pa2001  TYPE pa2001,
        ls_pa2002  TYPE pa2002,
        ls_pa2006  TYPE pa2006,
        ls_hrp1000 TYPE hrp1000,
        ls_hrp1001 TYPE hrp1001.

  WRITE: / '=== Inserting Employee Data ==='.

*=== PA0000: Actions ===================================================
  CLEAR ls_pa0000.
  ls_pa0000-mandt  = sy-mandt.
  ls_pa0000-pernr  = iv_pernr.
  ls_pa0000-endda  = iv_endda.
  ls_pa0000-begda  = iv_begda.
  ls_pa0000-seqnr  = '000'.
  ls_pa0000-massn  = '01'.
  ls_pa0000-massg  = '01'.
  ls_pa0000-stat2  = '3'.
  ls_pa0000-stat1  = '1'.
  MODIFY pa0000 FROM ls_pa0000.
  WRITE: / 'PA0000 (Actions):', sy-subrc.

*=== PA0001: Org Assignment ============================================
  CLEAR ls_pa0001.
  ls_pa0001-mandt  = sy-mandt.
  ls_pa0001-pernr  = iv_pernr.
  ls_pa0001-endda  = iv_endda.
  ls_pa0001-begda  = iv_begda.
  ls_pa0001-seqnr  = '000'.
  ls_pa0001-bukrs  = gs_cfg-bukrs.     "From T001
  ls_pa0001-werks  = gs_cfg-werks.     "From T500P
  ls_pa0001-btrtl  = gs_cfg-btrtl.     "From T001P
  ls_pa0001-persg  = gs_cfg-persg.     "From T503
  ls_pa0001-persk  = gs_cfg-persk.     "From T503
  ls_pa0001-orgeh  = '50000000'.       "Org unit -> HRP1000 O
  ls_pa0001-plans  = '50000001'.       "Position -> HRP1000 S
  ls_pa0001-stell  = '50000002'.       "Job      -> HRP1000 C
  ls_pa0001-kostl  = gs_cfg-kostl.     "From CSKS
  ls_pa0001-abkrs  = gs_cfg-abkrs.     "From T549A
  MODIFY pa0001 FROM ls_pa0001.
  WRITE: / 'PA0001 (Org Assignment):', sy-subrc.

*=== PA0002: Personal Data =============================================
  CLEAR ls_pa0002.
  ls_pa0002-mandt  = sy-mandt.
  ls_pa0002-pernr  = iv_pernr.
  ls_pa0002-endda  = iv_endda.
  ls_pa0002-begda  = iv_begda.
  ls_pa0002-seqnr  = '000'.
  ls_pa0002-nachn  = 'Kumar'.
  ls_pa0002-vorna  = 'Ravi'.
  ls_pa0002-rufnm  = 'Ravi'.
  ls_pa0002-gesch  = '1'.
  ls_pa0002-gbdat  = '19900115'.
  ls_pa0002-sprsl  = 'E'.
  ls_pa0002-natio  = gs_cfg-molga.     "From T500P country grouping
  ls_pa0002-gbort  = 'Hyderabad'.
  MODIFY pa0002 FROM ls_pa0002.
  WRITE: / 'PA0002 (Personal Data):', sy-subrc.

*=== PA0003: Payroll Status ============================================
  CLEAR ls_pa0003.
  ls_pa0003-mandt  = sy-mandt.
  ls_pa0003-pernr  = iv_pernr.
  ls_pa0003-endda  = iv_endda.
  ls_pa0003-begda  = iv_begda.
  ls_pa0003-seqnr  = '000'.
  ls_pa0003-uname  = sy-uname.
  ls_pa0003-aedtm  = sy-datum.
  ls_pa0003-viekn  = '10'.
  MODIFY pa0003 FROM ls_pa0003.
  WRITE: / 'PA0003 (Payroll Status):', sy-subrc.

*=== PA0006: Permanent Address =========================================
  CLEAR ls_pa0006.
  ls_pa0006-mandt  = sy-mandt.
  ls_pa0006-pernr  = iv_pernr.
  ls_pa0006-subty  = '1'.
  ls_pa0006-endda  = iv_endda.
  ls_pa0006-begda  = iv_begda.
  ls_pa0006-seqnr  = '000'.
  ls_pa0006-anssa  = '1'.
  ls_pa0006-stras  = '123 MG Road'.
  ls_pa0006-ort01  = 'Hyderabad'.
  ls_pa0006-pstlz  = '500001'.
  ls_pa0006-land1  = gs_cfg-banks.     "From BNKA country
  ls_pa0006-state  = '36'.
  MODIFY pa0006 FROM ls_pa0006.
  WRITE: / 'PA0006 (Address):', sy-subrc.

*=== PA0007: Planned Working Time ======================================
  CLEAR ls_pa0007.
  ls_pa0007-mandt  = sy-mandt.
  ls_pa0007-pernr  = iv_pernr.
  ls_pa0007-endda  = iv_endda.
  ls_pa0007-begda  = iv_begda.
  ls_pa0007-seqnr  = '000'.
  ls_pa0007-schkz  = gs_cfg-schkz.    "From T508A
  ls_pa0007-empct  = '100'.
  ls_pa0007-wkwdy  = '5'.
  ls_pa0007-arbst  = '08.00'.
  MODIFY pa0007 FROM ls_pa0007.
  WRITE: / 'PA0007 (Working Time):', sy-subrc.

*=== PA0008: Basic Pay =================================================
  CLEAR ls_pa0008.
  ls_pa0008-mandt  = sy-mandt.
  ls_pa0008-pernr  = iv_pernr.
  ls_pa0008-endda  = iv_endda.
  ls_pa0008-begda  = iv_begda.
  ls_pa0008-seqnr  = '000'.
  ls_pa0008-trfar  = gs_cfg-trfar.    "From T510
  ls_pa0008-trfgb  = gs_cfg-trfgb.    "From T510
  ls_pa0008-trfgr  = gs_cfg-trfgr.    "From T510
  ls_pa0008-trfst  = gs_cfg-trfst.    "From T510
  ls_pa0008-ansal  = '1200000'.
  ls_pa0008-bet01  = '100000'.
  ls_pa0008-lga01  = gs_cfg-lgart1.   "From T512T
  MODIFY pa0008 FROM ls_pa0008.
  WRITE: / 'PA0008 (Basic Pay):', sy-subrc.

*=== PA0009: Bank Details ==============================================
  CLEAR ls_pa0009.
  ls_pa0009-mandt  = sy-mandt.
  ls_pa0009-pernr  = iv_pernr.
  ls_pa0009-subty  = '0'.
  ls_pa0009-endda  = iv_endda.
  ls_pa0009-begda  = iv_begda.
  ls_pa0009-seqnr  = '000'.
  ls_pa0009-banks  = gs_cfg-banks.     "From BNKA
  ls_pa0009-bankl  = gs_cfg-bankl.     "From BNKA
  ls_pa0009-bankn  = '1234567890'.
  ls_pa0009-bkont  = '01'.
  ls_pa0009-zlsch  = 'T'.
  ls_pa0009-waers = gs_cfg-waers.   "From T001
  MODIFY pa0009 FROM ls_pa0009.
  WRITE: / 'PA0009 (Bank Details):', sy-subrc.

*=== PA0014: Recurring Payments ========================================
  CLEAR ls_pa0014.
  ls_pa0014-mandt  = sy-mandt.
  ls_pa0014-pernr  = iv_pernr.
  ls_pa0014-subty  = gs_cfg-lgart2.   "From T512T (2nd wage type)
  ls_pa0014-endda  = iv_endda.
  ls_pa0014-begda  = iv_begda.
  ls_pa0014-seqnr  = '000'.
  ls_pa0014-betrg  = '20000'.
  ls_pa0014-waers = gs_cfg-waers.   "From T001
  MODIFY pa0014 FROM ls_pa0014.
  WRITE: / 'PA0014 (Recurring Pay):', sy-subrc.

*=== PA0015: Additional Payments (Bonus) ===============================
  CLEAR ls_pa0015.
  ls_pa0015-mandt  = sy-mandt.
  ls_pa0015-pernr  = iv_pernr.
  ls_pa0015-subty  = gs_cfg-lgart3.   "From T512T (3rd wage type)
  ls_pa0015-endda  = '20250331'.
  ls_pa0015-begda  = '20250301'.
  ls_pa0015-seqnr  = '000'.
  ls_pa0015-betrg  = '50000'.
  ls_pa0015-waers = gs_cfg-waers.   "From T001
  MODIFY pa0015 FROM ls_pa0015.
  WRITE: / 'PA0015 (Additional Pay):', sy-subrc.

*=== PA0021: Family Members (Spouse) ===================================
  CLEAR ls_pa0021.
  ls_pa0021-mandt  = sy-mandt.
  ls_pa0021-pernr  = iv_pernr.
  ls_pa0021-subty  = '1'.
  ls_pa0021-endda  = iv_endda.
  ls_pa0021-begda  = iv_begda.
  ls_pa0021-seqnr  = '000'.
  ls_pa0021-fanam  = 'Kumar'.
  ls_pa0021-fgbdt  = '19920520'.
  ls_pa0021-favor  = 'Priya'.
  MODIFY pa0021 FROM ls_pa0021.
  WRITE: / 'PA0021 (Family - Spouse):', sy-subrc.

*=== PA0032: Internal Control ==========================================
  CLEAR ls_pa0032.
  ls_pa0032-mandt  = sy-mandt.
  ls_pa0032-pernr  = iv_pernr.
  ls_pa0032-endda  = iv_endda.
  ls_pa0032-begda  = iv_begda.
  ls_pa0032-seqnr  = '000'.
  ls_pa0032-pnalt  = '000000000001'.
  ls_pa0032-wausw  = gs_cfg-bukrs.     "Company ID from T001
  ls_pa0032-pkwrg  = '1'.
  ls_pa0032-pkwwr  = '500000'.
  ls_pa0032-kfzkz  = 'TS09AB1234'.
  ls_pa0032-waers  = gs_cfg-waers.     "From T001
  ls_pa0032-anlnr  = 'AST00001'.
  ls_pa0032-gebnr  = 'B001'.
  ls_pa0032-zimnr  = 'R101'.
  ls_pa0032-tel01  = '12345'.
  MODIFY pa0032 FROM ls_pa0032.
  WRITE: / 'PA0032 (Internal Control):', sy-subrc.

*=== PA0105: Email (subtype 0010) ======================================
  CLEAR ls_pa0105.
  ls_pa0105-mandt  = sy-mandt.
  ls_pa0105-pernr  = iv_pernr.
  ls_pa0105-subty  = '0010'.
  ls_pa0105-endda  = iv_endda.
  ls_pa0105-begda  = iv_begda.
  ls_pa0105-seqnr  = '000'.
  ls_pa0105-usrid  = 'RKUMAR'.
  ls_pa0105-usrid_long = 'ravi.kumar@test.com'.
  MODIFY pa0105 FROM ls_pa0105.
  WRITE: / 'PA0105 (Email):', sy-subrc.

*=== PA0105: SAP User (subtype 0001) ===================================
  CLEAR ls_pa0105.
  ls_pa0105-mandt  = sy-mandt.
  ls_pa0105-pernr  = iv_pernr.
  ls_pa0105-subty  = '0001'.
  ls_pa0105-endda  = iv_endda.
  ls_pa0105-begda  = iv_begda.
  ls_pa0105-seqnr  = '000'.
  ls_pa0105-usrid  = 'RKUMAR'.
  MODIFY pa0105 FROM ls_pa0105.
  WRITE: / 'PA0105 (SAP User):', sy-subrc.

*=== PA0167: Health Plan ===============================================
  CLEAR ls_pa0167.
  ls_pa0167-mandt  = sy-mandt.
  ls_pa0167-pernr  = iv_pernr.
  ls_pa0167-subty  = '0001'.
  ls_pa0167-endda  = iv_endda.
  ls_pa0167-begda  = iv_begda.
  ls_pa0167-seqnr  = '000'.
  MODIFY pa0167 FROM ls_pa0167.
  WRITE: / 'PA0167 (Health Plan):', sy-subrc.

*=== PA0171: General Benefits ==========================================
  CLEAR ls_pa0171.
  ls_pa0171-mandt  = sy-mandt.
  ls_pa0171-pernr  = iv_pernr.
  ls_pa0171-subty  = '0001'.
  ls_pa0171-endda  = iv_endda.
  ls_pa0171-begda  = iv_begda.
  ls_pa0171-seqnr  = '000'.
  MODIFY pa0171 FROM ls_pa0171.
  WRITE: / 'PA0171 (General Benefits):', sy-subrc.

*=== PA2001: Absence / Leave ==========================================
  CLEAR ls_pa2001.
  ls_pa2001-mandt  = sy-mandt.
  ls_pa2001-pernr  = iv_pernr.
  ls_pa2001-subty  = gs_cfg-awart.     "From T554S
  ls_pa2001-endda  = '20250115'.
  ls_pa2001-begda  = '20250113'.
  ls_pa2001-seqnr  = '000'.
  MODIFY pa2001 FROM ls_pa2001.
  WRITE: / 'PA2001 (Leave Record):', sy-subrc.

*=== PA2002: Attendance ================================================
  CLEAR ls_pa2002.
  ls_pa2002-mandt  = sy-mandt.
  ls_pa2002-pernr  = iv_pernr.
  ls_pa2002-subty  = gs_cfg-atart.  "From T554S (2nd type)
  ls_pa2002-endda  = '20250120'.
  ls_pa2002-begda  = '20250120'.
  ls_pa2002-seqnr  = '000'.
  MODIFY pa2002 FROM ls_pa2002.
  WRITE: / 'PA2002 (Attendance):', sy-subrc.

*=== PA2006: Absence Quotas (Leave Balance) ============================
  CLEAR ls_pa2006.
  ls_pa2006-mandt  = sy-mandt.
  ls_pa2006-pernr  = iv_pernr.
  ls_pa2006-subty  = gs_cfg-ktart.     "From T556B
  ls_pa2006-endda  = '20251231'.
  ls_pa2006-begda  = '20250101'.
  ls_pa2006-seqnr  = '000'.
  ls_pa2006-anzhl  = '24.00'.
  MODIFY pa2006 FROM ls_pa2006.
  WRITE: / 'PA2006 (Leave Quota):', sy-subrc.

  WRITE: / ''.
  WRITE: / '=== OM Data ==='.

*=== HRP1000: Org Unit (O 50000000) ===================================
  CLEAR ls_hrp1000.
  ls_hrp1000-mandt  = sy-mandt.
  ls_hrp1000-plvar  = '01'.
  ls_hrp1000-otype  = 'O'.
  ls_hrp1000-objid  = '50000000'.
  ls_hrp1000-istat  = '1'.
  ls_hrp1000-begda  = iv_begda.
  ls_hrp1000-endda  = iv_endda.
  ls_hrp1000-langu  = sy-langu.
  ls_hrp1000-stext  = 'IT Department'.
  ls_hrp1000-short  = 'IT Dept'.
  MODIFY hrp1000 FROM ls_hrp1000.
  WRITE: / 'HRP1000 (Org Unit O 50000000):', sy-subrc.

*=== HRP1000: Employee Position (S 50000001) ===========================
  CLEAR ls_hrp1000.
  ls_hrp1000-mandt  = sy-mandt.
  ls_hrp1000-plvar  = '01'.
  ls_hrp1000-otype  = 'S'.
  ls_hrp1000-objid  = '50000001'.
  ls_hrp1000-istat  = '1'.
  ls_hrp1000-begda  = iv_begda.
  ls_hrp1000-endda  = iv_endda.
  ls_hrp1000-langu  = sy-langu.
  ls_hrp1000-stext  = 'SAP Developer'.
  ls_hrp1000-short  = 'SAP Dev'.
  MODIFY hrp1000 FROM ls_hrp1000.
  WRITE: / 'HRP1000 (Position S 50000001):', sy-subrc.

*=== HRP1000: Job (C 50000002) =========================================
  CLEAR ls_hrp1000.
  ls_hrp1000-mandt  = sy-mandt.
  ls_hrp1000-plvar  = '01'.
  ls_hrp1000-otype  = 'C'.
  ls_hrp1000-objid  = '50000002'.
  ls_hrp1000-istat  = '1'.
  ls_hrp1000-begda  = iv_begda.
  ls_hrp1000-endda  = iv_endda.
  ls_hrp1000-langu  = sy-langu.
  ls_hrp1000-stext  = 'Software Developer'.
  ls_hrp1000-short  = 'SW Dev'.
  MODIFY hrp1000 FROM ls_hrp1000.
  WRITE: / 'HRP1000 (Job C 50000002):', sy-subrc.

*=== HRP1000: Manager Position (S 50000099) ============================
  CLEAR ls_hrp1000.
  ls_hrp1000-mandt  = sy-mandt.
  ls_hrp1000-plvar  = '01'.
  ls_hrp1000-otype  = 'S'.
  ls_hrp1000-objid  = '50000099'.
  ls_hrp1000-istat  = '1'.
  ls_hrp1000-begda  = iv_begda.
  ls_hrp1000-endda  = iv_endda.
  ls_hrp1000-langu  = sy-langu.
  ls_hrp1000-stext  = 'IT Manager'.
  ls_hrp1000-short  = 'IT Mgr'.
  MODIFY hrp1000 FROM ls_hrp1000.
  WRITE: / 'HRP1000 (Manager Position S 50000099):', sy-subrc.

*=== HRP1000: Manager Job (C 50000003) =================================
  CLEAR ls_hrp1000.
  ls_hrp1000-mandt  = sy-mandt.
  ls_hrp1000-plvar  = '01'.
  ls_hrp1000-otype  = 'C'.
  ls_hrp1000-objid  = '50000003'.
  ls_hrp1000-istat  = '1'.
  ls_hrp1000-begda  = iv_begda.
  ls_hrp1000-endda  = iv_endda.
  ls_hrp1000-langu  = sy-langu.
  ls_hrp1000-stext  = 'IT Manager Job'.
  ls_hrp1000-short  = 'IT Mgr J'.
  MODIFY hrp1000 FROM ls_hrp1000.
  WRITE: / 'HRP1000 (Manager Job C 50000003):', sy-subrc.

  WRITE: / ''.
  WRITE: / '=== OM Relationships ==='.

*=== S 50000001 belongs to O 50000000 (A003) ===========================
  CLEAR ls_hrp1001.
  ls_hrp1001-mandt = sy-mandt. ls_hrp1001-plvar = '01'.
  ls_hrp1001-otype = 'S'. ls_hrp1001-objid = '50000001'.
  ls_hrp1001-rsign = 'A'. ls_hrp1001-relat = '003'.
  ls_hrp1001-istat = '1'.
  ls_hrp1001-begda = iv_begda. ls_hrp1001-endda = iv_endda.
  ls_hrp1001-sclas = 'O'. ls_hrp1001-sobid = '50000000'.
  MODIFY hrp1001 FROM ls_hrp1001.
  WRITE: / 'HRP1001 (S->O belongs to A003):', sy-subrc.

*=== O 50000000 incorporates S 50000001 (B003) =========================
  CLEAR ls_hrp1001.
  ls_hrp1001-mandt = sy-mandt. ls_hrp1001-plvar = '01'.
  ls_hrp1001-otype = 'O'. ls_hrp1001-objid = '50000000'.
  ls_hrp1001-rsign = 'B'. ls_hrp1001-relat = '003'.
  ls_hrp1001-istat = '1'.
  ls_hrp1001-begda = iv_begda. ls_hrp1001-endda = iv_endda.
  ls_hrp1001-sclas = 'S'. ls_hrp1001-sobid = '50000001'.
  MODIFY hrp1001 FROM ls_hrp1001.
  WRITE: / 'HRP1001 (O->S incorporates B003):', sy-subrc.

*=== S 50000001 describes C 50000002 (A007) ============================
  CLEAR ls_hrp1001.
  ls_hrp1001-mandt = sy-mandt. ls_hrp1001-plvar = '01'.
  ls_hrp1001-otype = 'S'. ls_hrp1001-objid = '50000001'.
  ls_hrp1001-rsign = 'A'. ls_hrp1001-relat = '007'.
  ls_hrp1001-istat = '1'.
  ls_hrp1001-begda = iv_begda. ls_hrp1001-endda = iv_endda.
  ls_hrp1001-sclas = 'C'. ls_hrp1001-sobid = '50000002'.
  MODIFY hrp1001 FROM ls_hrp1001.
  WRITE: / 'HRP1001 (S->C describes A007):', sy-subrc.

*=== S 50000001 held by P (A008) =======================================
  CLEAR ls_hrp1001.
  ls_hrp1001-mandt = sy-mandt. ls_hrp1001-plvar = '01'.
  ls_hrp1001-otype = 'S'. ls_hrp1001-objid = '50000001'.
  ls_hrp1001-rsign = 'A'. ls_hrp1001-relat = '008'.
  ls_hrp1001-istat = '1'.
  ls_hrp1001-begda = iv_begda. ls_hrp1001-endda = iv_endda.
  ls_hrp1001-sclas = 'P'. ls_hrp1001-sobid = iv_pernr.
  MODIFY hrp1001 FROM ls_hrp1001.
  WRITE: / 'HRP1001 (S->P holder A008):', sy-subrc.

*=== P holds S 50000001 (B008) =========================================
  CLEAR ls_hrp1001.
  ls_hrp1001-mandt = sy-mandt. ls_hrp1001-plvar = '01'.
  ls_hrp1001-otype = 'P'. ls_hrp1001-objid = iv_pernr.
  ls_hrp1001-rsign = 'B'. ls_hrp1001-relat = '008'.
  ls_hrp1001-istat = '1'.
  ls_hrp1001-begda = iv_begda. ls_hrp1001-endda = iv_endda.
  ls_hrp1001-sclas = 'S'. ls_hrp1001-sobid = '50000001'.
  MODIFY hrp1001 FROM ls_hrp1001.
  WRITE: / 'HRP1001 (P->S holds B008):', sy-subrc.

*=== O has chief S 50000099 (A012) =====================================
  CLEAR ls_hrp1001.
  ls_hrp1001-mandt = sy-mandt. ls_hrp1001-plvar = '01'.
  ls_hrp1001-otype = 'O'. ls_hrp1001-objid = '50000000'.
  ls_hrp1001-rsign = 'A'. ls_hrp1001-relat = '012'.
  ls_hrp1001-istat = '1'.
  ls_hrp1001-begda = iv_begda. ls_hrp1001-endda = iv_endda.
  ls_hrp1001-sclas = 'S'. ls_hrp1001-sobid = '50000099'.
  MODIFY hrp1001 FROM ls_hrp1001.
  WRITE: / 'HRP1001 (O->S chief A012):', sy-subrc.

*=== S 50000099 is chief of O (B012) ===================================
  CLEAR ls_hrp1001.
  ls_hrp1001-mandt = sy-mandt. ls_hrp1001-plvar = '01'.
  ls_hrp1001-otype = 'S'. ls_hrp1001-objid = '50000099'.
  ls_hrp1001-rsign = 'B'. ls_hrp1001-relat = '012'.
  ls_hrp1001-istat = '1'.
  ls_hrp1001-begda = iv_begda. ls_hrp1001-endda = iv_endda.
  ls_hrp1001-sclas = 'O'. ls_hrp1001-sobid = '50000000'.
  MODIFY hrp1001 FROM ls_hrp1001.
  WRITE: / 'HRP1001 (S->O chief B012):', sy-subrc.

*=== Manager S 50000099 belongs to O (A003) ============================
  CLEAR ls_hrp1001.
  ls_hrp1001-mandt = sy-mandt. ls_hrp1001-plvar = '01'.
  ls_hrp1001-otype = 'S'. ls_hrp1001-objid = '50000099'.
  ls_hrp1001-rsign = 'A'. ls_hrp1001-relat = '003'.
  ls_hrp1001-istat = '1'.
  ls_hrp1001-begda = iv_begda. ls_hrp1001-endda = iv_endda.
  ls_hrp1001-sclas = 'O'. ls_hrp1001-sobid = '50000000'.
  MODIFY hrp1001 FROM ls_hrp1001.
  WRITE: / 'HRP1001 (Mgr S->O belongs A003):', sy-subrc.

*=== O incorporates Manager S 50000099 (B003) ==========================
  CLEAR ls_hrp1001.
  ls_hrp1001-mandt = sy-mandt. ls_hrp1001-plvar = '01'.
  ls_hrp1001-otype = 'O'. ls_hrp1001-objid = '50000000'.
  ls_hrp1001-rsign = 'B'. ls_hrp1001-relat = '003'.
  ls_hrp1001-istat = '1'.
  ls_hrp1001-begda = iv_begda. ls_hrp1001-endda = iv_endda.
  ls_hrp1001-sclas = 'S'. ls_hrp1001-sobid = '50000099'.
  MODIFY hrp1001 FROM ls_hrp1001.
  WRITE: / 'HRP1001 (O->Mgr S incorp B003):', sy-subrc.

*=== Manager S 50000099 describes C 50000003 (A007) ====================
  CLEAR ls_hrp1001.
  ls_hrp1001-mandt = sy-mandt. ls_hrp1001-plvar = '01'.
  ls_hrp1001-otype = 'S'. ls_hrp1001-objid = '50000099'.
  ls_hrp1001-rsign = 'A'. ls_hrp1001-relat = '007'.
  ls_hrp1001-istat = '1'.
  ls_hrp1001-begda = iv_begda. ls_hrp1001-endda = iv_endda.
  ls_hrp1001-sclas = 'C'. ls_hrp1001-sobid = '50000003'.
  MODIFY hrp1001 FROM ls_hrp1001.
  WRITE: / 'HRP1001 (Mgr S->C describes A007):', sy-subrc.

  COMMIT WORK AND WAIT.

  WRITE: / ''.
  WRITE: / '=== Summary ==='.
  WRITE: / 'Employee:', iv_pernr, '- Ravi Kumar'.
  WRITE: / 'ALL values from config tables (no hardcoded keys)'.
  WRITE: / ''.
  WRITE: / 'PA: 0000,0001,0002,0003,0006,0007,0008,0009,'.
  WRITE: / '    0014,0015,0021,0032,0105,0167,0171'.
  WRITE: / 'Time: PA2001, PA2002, PA2006'.
  WRITE: / 'OM: O(50000000), S(50000001), C(50000002),'.
  WRITE: / '    Mgr S(50000099), Mgr C(50000003)'.
  WRITE: / 'Rels: A/B003, A007, A/B008, A/B012'.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form DELETE_ALL
*&---------------------------------------------------------------------*
FORM delete_all USING iv_pernr TYPE persno.

  WRITE: / '=== Deleting Employee Data ==='.

  DELETE FROM pa0000 WHERE pernr = iv_pernr.
  WRITE: / 'PA0000 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0001 WHERE pernr = iv_pernr.
  WRITE: / 'PA0001 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0002 WHERE pernr = iv_pernr.
  WRITE: / 'PA0002 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0003 WHERE pernr = iv_pernr.
  WRITE: / 'PA0003 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0006 WHERE pernr = iv_pernr.
  WRITE: / 'PA0006 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0007 WHERE pernr = iv_pernr.
  WRITE: / 'PA0007 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0008 WHERE pernr = iv_pernr.
  WRITE: / 'PA0008 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0009 WHERE pernr = iv_pernr.
  WRITE: / 'PA0009 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0014 WHERE pernr = iv_pernr.
  WRITE: / 'PA0014 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0015 WHERE pernr = iv_pernr.
  WRITE: / 'PA0015 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0021 WHERE pernr = iv_pernr.
  WRITE: / 'PA0021 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0032 WHERE pernr = iv_pernr.
  WRITE: / 'PA0032 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0105 WHERE pernr = iv_pernr.
  WRITE: / 'PA0105 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0167 WHERE pernr = iv_pernr.
  WRITE: / 'PA0167 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0171 WHERE pernr = iv_pernr.
  WRITE: / 'PA0171 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa2001 WHERE pernr = iv_pernr.
  WRITE: / 'PA2001 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa2002 WHERE pernr = iv_pernr.
  WRITE: / 'PA2002 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa2006 WHERE pernr = iv_pernr.
  WRITE: / 'PA2006 deleted:', sy-dbcnt, 'rows'.

  WRITE: / ''.
  WRITE: / '=== Deleting OM Data ==='.

  DELETE FROM hrp1000 WHERE otype = 'O' AND objid = '50000000'.
  DELETE FROM hrp1000 WHERE otype = 'S' AND objid = '50000001'.
  DELETE FROM hrp1000 WHERE otype = 'C' AND objid = '50000002'.
  DELETE FROM hrp1000 WHERE otype = 'S' AND objid = '50000099'.
  DELETE FROM hrp1000 WHERE otype = 'C' AND objid = '50000003'.
  WRITE: / 'HRP1000 deleted (O, S, C, Mgr S, Mgr C)'.

  DELETE FROM hrp1001 WHERE otype = 'O' AND objid = '50000000'.
  DELETE FROM hrp1001 WHERE otype = 'S' AND objid = '50000001'.
  DELETE FROM hrp1001 WHERE otype = 'S' AND objid = '50000099'.
  DELETE FROM hrp1001 WHERE otype = 'P' AND objid = iv_pernr.
  WRITE: / 'HRP1001 deleted (all relationships)'.

  COMMIT WORK AND WAIT.
  WRITE: / ''.
  WRITE: / 'All data deleted for employee', iv_pernr.

ENDFORM.
